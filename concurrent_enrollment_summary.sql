WITH cte_HSCE_2019 AS (
    --Fall 2019
        SELECT
            'Fall 2019'                     AS Term_Desc,
            spriden_pidm                    AS PIDM
         FROM spriden
          LEFT JOIN sorhsch ON sorhsch.ROWID = dsc.f_get_sorhsch_rowid(spriden_pidm),
              stvterm,
              spbpers,
              students_201843,
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

         SELECT 'Fall 2019'                                        AS Term_Desc,
                spriden_pidm                                       AS PIDM
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
         SELECT 'Fall 2018' AS Term_Desc,
                spriden_pidm AS PIDM
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

         UNION ALL

         SELECT 'Fall 2018' AS Term_Desc,
                spriden_pidm AS PIDM
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
         SELECT
            'Fall 2017'                     AS Term_Desc,
            spriden_pidm                    AS PIDM
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

         UNION ALL

         SELECT 'Fall 2017'                                        AS Term_Desc,
                spriden_pidm                                       AS PIDM

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
SELECT DSC_PIDM,
    'Fall ' || S_YEAR AS TERM,
    COALESCE(h1.PIDM,h2.PIDM,h3.PIDM) AS Concurrent_Student,
    h1.PIDM,
    h2.PIDM,
    h3.PIDM
FROM BAILEY.STUDENTS03@DSCIR d
LEFT JOIN cte_HSCE_2019 h1 ON h1.PIDM = d.DSC_PIDM
    AND h1.TERM_DESC = 'Fall ' || S_YEAR
LEFT JOIN cte_HSCE_2018 h2 on h2.PIDM = d.DSC_PIDM
    AND h2.Term_Desc = 'Fall ' || S_YEAR
LEFT JOIN cte_HSCE_2017 h3 on h3.PIDM = d.DSC_PIDM
    AND h2.Term_Desc = 'Fall ' || S_YEAR
WHERE S_YEAR IN ('2017','2018','2019')
    AND S_TERM = '2'
    AND S_EXTRACT = '3'
    AND S_ENTRY_ACTION IN ('FF', 'FH');