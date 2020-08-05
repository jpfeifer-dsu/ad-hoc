WITH
      cte_HSCE_2019 AS (
     -- USHE YEAR 2020
         SELECT DISTINCT
             'Fall 2019' AS Term_Desc,
             spriden_pidm AS PIDM,
             spriden_id AS Banner_ID,
             spriden_last_name AS Last_Name,
             spriden_first_name AS First_Name,
             'Transfer' AS Credit_Type,
             shrtrce_credit_hours AS Att_Cr,
             cw_dsu_bucket AS GE_Bucket,
             shrtrce_subj_code AS Subject,
             shrtrce_crse_numb AS Course_Nbr,
             CASE
                WHEN shrtrce_subj_code = 'EL'
                    THEN 'EL ' || to_char(lpad(shrtrce_crse_numb, 4, '0')) || ' - Various'
                ELSE shrtrce_crse_title
                END AS Course_Title
          FROM spriden
           LEFT JOIN sorhsch ON sorhsch.ROWID = dsc.f_get_sorhsch_rowid(spriden_pidm),
               stvterm,
               spbpers,
               students_201943,
               shrtrce LEFT JOIN cw_ge_buckets_all ON shrtrce_subj_code = cw_subj_code AND shrtrce_crse_numb = cw_crse_numb
          WHERE shrtrce_pidm = pidm
            AND spbpers_pidm = spriden_pidm
            AND spriden_pidm = shrtrce_pidm
            AND stvterm_code = shrtrce_term_code_eff
            AND shrtrce_term_code_eff <= '201940'
            AND shrtrce_crse_numb != '0000'
            AND spriden_change_ind IS NULL
            AND s_entry_action LIKE 'F%'
            AND (
                      sorhsch_graduation_date
                      > stvterm_start_date
                  OR
                      shrtrce_grde_code = 'P'
                  OR
                      (
                              sorhsch_graduation_date IS NULL
                              AND
                              f_calculate_age(stvterm_start_date
                                  , spbpers_birth_date
                                  , spbpers_dead_date)
                                  < 18
                          )
              )

          UNION

          SELECT DISTINCT
                'Fall 2019'                                        AS Term_Desc,
                 spriden_pidm                                      AS PIDM,
                 nvl(scbcrse_credit_hr_low, scbcrse_credit_hr_high) AS Att_Cr,
                 cw_dsu_bucket                                      AS GE_Bucket,
                 scbcrse_subj_code                                  AS Subject,
                 scbcrse_crse_numb                                  AS Course_Nbr
          FROM sfrstcr,
               dsc.dsc_swvgrde,
               spriden,
               scbcrse c1,
               ssbsect
                   LEFT JOIN cw_ge_buckets_all
                             ON ssbsect_subj_code = cw_subj_code AND ssbsect_crse_numb = cw_crse_numb
          WHERE sfrstcr_crn = ssbsect_crn
            AND swvgrde_crn = ssbsect_crn
            AND spriden_pidm = sfrstcr_pidm
            AND swvgrde_pidm = sfrstcr_pidm
            AND sfrstcr_term_code = ssbsect_term_code
            AND swvgrde_term_code = sfrstcr_term_code
            AND ssbsect_subj_code = scbcrse_subj_code
            AND ssbsect_crse_numb = scbcrse_crse_numb
            AND ssbsect_term_code <= '201940'
            AND ssbsect_subj_code != 'CED'
            AND f_calc_entry_action(sfrstcr_pidm, sfrstcr_term_code) = 'HS' --IN ('FF','FH')
            AND sfrstcr_rsts_code IN (SELECT stvrsts_code FROM stvrsts WHERE stvrsts_incl_sect_enrl = 'Y')
            AND spriden_change_ind IS NULL
            AND scbcrse_eff_term =
                (
                    SELECT MAX(c2.scbcrse_eff_term)
                    FROM scbcrse c2
                    WHERE c2.scbcrse_subj_code = ssbsect_subj_code
                      AND c2.scbcrse_crse_numb = ssbsect_crse_numb
                      AND c2.scbcrse_eff_term <= ssbsect_term_code
                )
            AND EXISTS
              (
                  SELECT 'Y'
                  FROM bailey.students03@dscir
                  WHERE dsc_pidm = sfrstcr_pidm
                    AND dsc_term_code = '201943'
                    AND s_entry_action LIKE 'F%'
              )
),

cte_HSCE_2018 AS (
         --USHE YEAR 2019
         SELECT DISTINCT
             'Fall 2018' AS Term_Desc,
             spriden_pidm AS PIDM,
             shrtrce_credit_hours AS Att_Cr,
             cw_dsu_bucket AS GE_Bucket,
             shrtrce_subj_code AS Subject,
             shrtrce_crse_numb AS Course_Nbr
         FROM spriden
                  LEFT JOIN sorhsch ON sorhsch.ROWID = dsc.f_get_sorhsch_rowid(spriden_pidm),
              stvterm,
              spbpers,
              students_201843,
              shrtrce
                  LEFT JOIN cw_ge_buckets_all ON shrtrce_subj_code = cw_subj_code AND shrtrce_crse_numb = cw_crse_numb
         WHERE shrtrce_pidm = pidm
           AND spbpers_pidm = spriden_pidm
           AND spriden_pidm = shrtrce_pidm
           AND stvterm_code = shrtrce_term_code_eff
           AND shrtrce_term_code_eff <= '201840'
           AND shrtrce_crse_numb != '0000'
           AND spriden_change_ind IS NULL
           AND s_entry_action LIKE 'F%'
           AND (
                     sorhsch_graduation_date
                     > stvterm_start_date
                 OR
                     shrtrce_grde_code = 'P'
                 OR
                     (
                             sorhsch_graduation_date IS NULL
                             AND
                             f_calculate_age(stvterm_start_date
                                 , spbpers_birth_date
                                 , spbpers_dead_date)
                                 < 18
                         )
             )

          UNION

          SELECT DISTINCT
                'Fall 2018' AS Term_Desc,
                spriden_pidm AS PIDM,
                nvl(scbcrse_credit_hr_low, scbcrse_credit_hr_high) AS Att_Cr,
                cw_dsu_bucket                                      AS GE_Bucket,
                scbcrse_subj_code                                  AS Subject,
                scbcrse_crse_numb                                  AS Course_Nbr
          FROM sfrstcr,
               dsc.dsc_swvgrde,
               spriden,
               scbcrse c1,
               ssbsect
                   LEFT JOIN cw_ge_buckets_all
                             ON ssbsect_subj_code = cw_subj_code AND ssbsect_crse_numb = cw_crse_numb
          WHERE sfrstcr_crn = ssbsect_crn
            AND swvgrde_crn = ssbsect_crn
            AND spriden_pidm = sfrstcr_pidm
            AND swvgrde_pidm = sfrstcr_pidm
            AND sfrstcr_term_code = ssbsect_term_code
            AND swvgrde_term_code = sfrstcr_term_code
            AND ssbsect_subj_code = scbcrse_subj_code
            AND ssbsect_crse_numb = scbcrse_crse_numb
            AND ssbsect_term_code <= '201840'
            AND ssbsect_subj_code != 'CED'
            AND f_calc_entry_action(sfrstcr_pidm, sfrstcr_term_code) = 'HS' --IN ('FF','FH')
            AND sfrstcr_rsts_code IN (SELECT stvrsts_code FROM stvrsts WHERE stvrsts_incl_sect_enrl = 'Y')
            AND spriden_change_ind IS NULL
            AND scbcrse_eff_term =
                (
                    SELECT MAX(c2.scbcrse_eff_term)
                    FROM scbcrse c2
                    WHERE c2.scbcrse_subj_code = ssbsect_subj_code
                      AND c2.scbcrse_crse_numb = ssbsect_crse_numb
                      AND c2.scbcrse_eff_term <= ssbsect_term_code
                )
            AND EXISTS
              (
                  SELECT 'Y'
                  FROM bailey.students03@dscir
                  WHERE dsc_pidm = sfrstcr_pidm
                    AND dsc_term_code = '201843'
                    AND s_entry_action LIKE 'F%'
              )
),

      cte_HSCE_2017 AS (
      --USHE YEAR 2018
          SELECT DISTINCT
             'Fall 2017' AS Term_Desc,
             spriden_pidm AS PIDM,
             shrtrce_credit_hours AS Att_Cr,
             cw_dsu_bucket AS GE_Bucket,
             shrtrce_subj_code AS Subject,
             shrtrce_crse_numb AS Course_Nbr
          FROM spriden
           LEFT JOIN sorhsch ON sorhsch.ROWID = dsc.f_get_sorhsch_rowid(spriden_pidm),
               stvterm,
               spbpers,
               students_201743,
               shrtrce LEFT JOIN cw_ge_buckets_all ON shrtrce_subj_code = cw_subj_code AND shrtrce_crse_numb = cw_crse_numb
          WHERE shrtrce_pidm = pidm
            AND spbpers_pidm = spriden_pidm
            AND spriden_pidm = shrtrce_pidm
            AND stvterm_code = shrtrce_term_code_eff
            AND shrtrce_term_code_eff <= '201740'
            AND shrtrce_crse_numb != '0000'
            AND spriden_change_ind IS NULL
            AND s_entry_action LIKE 'F%'
            AND (
                      sorhsch_graduation_date
                      > stvterm_start_date
                  OR
                      shrtrce_grde_code = 'P'
                  OR
                      (
                              sorhsch_graduation_date IS NULL
                              AND
                              f_calculate_age(stvterm_start_date
                                  , spbpers_birth_date
                                  , spbpers_dead_date)
                                  < 18
                          )
              )

          UNION

          SELECT DISTINCT
                'Fall 2017' AS Term_Desc,
                spriden_pidm AS PIDM,
                nvl(scbcrse_credit_hr_low, scbcrse_credit_hr_high) AS Att_Cr,
                cw_dsu_bucket AS GE_Bucket,
                scbcrse_subj_code AS Subject,
                scbcrse_crse_numb AS Course_Nbr
          FROM sfrstcr,
               dsc.dsc_swvgrde,
               spriden,
               scbcrse c1,
               ssbsect LEFT JOIN cw_ge_buckets_all ON ssbsect_subj_code = cw_subj_code AND ssbsect_crse_numb = cw_crse_numb
          WHERE sfrstcr_crn = ssbsect_crn
            AND swvgrde_crn = ssbsect_crn
            AND spriden_pidm = sfrstcr_pidm
            AND swvgrde_pidm = sfrstcr_pidm
            AND sfrstcr_term_code = ssbsect_term_code
            AND swvgrde_term_code = sfrstcr_term_code
            AND ssbsect_subj_code = scbcrse_subj_code
            AND ssbsect_crse_numb = scbcrse_crse_numb
            AND ssbsect_term_code <= '201740'
            AND ssbsect_subj_code != 'CED'
            AND f_calc_entry_action(sfrstcr_pidm, sfrstcr_term_code) = 'HS' --IN ('FF','FH')
            AND sfrstcr_rsts_code IN (SELECT stvrsts_code FROM stvrsts WHERE stvrsts_incl_sect_enrl = 'Y')
            AND spriden_change_ind IS NULL
            AND scbcrse_eff_term =
                (
                    SELECT MAX(c2.scbcrse_eff_term)
                    FROM scbcrse c2
                    WHERE c2.scbcrse_subj_code = ssbsect_subj_code
                      AND c2.scbcrse_crse_numb = ssbsect_crse_numb
                      AND c2.scbcrse_eff_term <= ssbsect_term_code
                )
            AND EXISTS
              (
                  SELECT 'Y'
                  FROM bailey.students03@dscir
                  WHERE dsc_pidm = sfrstcr_pidm
                    AND dsc_term_code = '201743'
                    AND s_entry_action LIKE 'F%'
              )
      )
--Main Query
SELECT
        DSC_PIDM,
        d.S_YEAR,
        h1.PIDM AS Earned_HSCE_2020,
        h2.PIDM AS Earned_HSCE_2019,
        h3.PIDM AS Earned_HSCE_2018,
        CASE WHEN COALESCE(h1.PIDM, h2.PIDM, h3.PIDM) IS NULL THEN 'No' ELSE 'Yes' END,
        COALESCE(h1.Att_Cr, h2.Att_Cr, h3.Att_Cr) AS Att_Cr,
        COALESCE(h1.GE_Bucket, h2.GE_Bucket, h3.GE_Bucket) AS GE_Bucket,
        COALESCE(h1.Subject, h2.Subject, h3.Subject) AS Subject,
        COALESCE(h1.Course_Nbr, h2.Course_Nbr, h3.Course_Nbr) AS Course_Nbr
FROM BAILEY.STUDENTS03@DSCIR d
LEFT JOIN cte_HSCE_2019 h1 ON h1.PIDM = d.DSC_PIDM
    AND d.S_YEAR = '2020'
LEFT JOIN cte_HSCE_2018 h2 on h2.PIDM = d.DSC_PIDM
    AND d.S_YEAR = '2019'
LEFT JOIN cte_HSCE_2017 h3 on h3.PIDM = d.DSC_PIDM
     AND d.S_YEAR = '2018'
WHERE d.S_YEAR IN ('2020', '2019', '2018')
    AND S_TERM = '2'
    AND S_EXTRACT = '3'
    AND S_ENTRY_ACTION IN ('FF', 'FH');
