/*
   -- All
   WITH ORDERED AS 
   (          
    SELECT DISTINCT 
           scrfees1.scrfees_eff_term    AS "Term Effective", 
           scbcrse1.scbcrse_subj_code   AS "Course Subject", 
           scbcrse1.scbcrse_crse_numb   AS "Course Number", 
           scbcrse1.scbcrse_title       AS "Course Title",
           scrfees1.scrfees_fee_amount  AS "Term Fee Amount",
           scrfees1.scrfees_detl_code   AS "DETL Code", 
           scbcrse1.scbcrse_coll_code   AS "COLL Code",
           tbracct1.tbracct_b_acci_code AS "ACCI Code",
           scbsupp1.scbsupp_tops_code   AS "TOPS Code",
           row_number() OVER 
           (
             PARTITION BY scbcrse_subj_code, 
                          scbcrse_crse_numb
             ORDER BY scbcrse_subj_code, 
                      scbcrse_crse_numb, 
                      scrfees_eff_term DESC
           ) AS rn
    FROM   scrfees scrfees1
           JOIN scbcrky scbcrky1 ON (scrfees1.scrfees_subj_code||'-'||scrfees1.scrfees_crse_numb = scbcrky1.scbcrky_subj_code||'-'||scbcrky1.scbcrky_crse_numb)
           JOIN scbcrse scbcrse1 ON (scrfees1.scrfees_subj_code||'-'||scrfees1.scrfees_crse_numb = scbcrse1.scbcrse_subj_code||'-'||scbcrse1.scbcrse_crse_numb)
           JOIN scbsupp scbsupp1 ON (scrfees1.scrfees_subj_code||'-'||scrfees1.scrfees_crse_numb = scbsupp1.scbsupp_subj_code||'-'||scbsupp1.scbsupp_crse_numb)
           JOIN tbracct tbracct1 ON  scrfees1.scrfees_detl_code = tbracct1.tbracct_detail_code
    WHERE  scbcrky1.scbcrky_term_code_end = '999999'
    AND    scbcrse1.scbcrse_eff_term = scksels.f_get_scbcrse_max_term_code(scrfees1.scrfees_subj_code,scrfees1.scrfees_crse_numb,'201820')
    AND    scrfees1.scrfees_eff_term = 
           (
             SELECT max(scrfees2.scrfees_eff_term)
             FROM   scrfees scrfees2
                    JOIN scbcrky scbcrky2 ON (scrfees2.scrfees_subj_code||'-'||scrfees2.scrfees_crse_numb = scbcrky2.scbcrky_subj_code||'-'||scbcrky2.scbcrky_crse_numb)
                    JOIN scbcrse scbcrse2 ON (scrfees2.scrfees_subj_code||'-'||scrfees2.scrfees_crse_numb = scbcrse2.scbcrse_subj_code||'-'||scbcrse2.scbcrse_crse_numb)
                    JOIN scbsupp scbsupp2 ON (scrfees2.scrfees_subj_code||'-'||scrfees2.scrfees_crse_numb = scbsupp2.scbsupp_subj_code||'-'||scbsupp2.scbsupp_crse_numb)
                    JOIN tbracct tbracct2 ON  scrfees2.scrfees_detl_code = tbracct2.tbracct_detail_code
             WHERE  scbcrky2.scbcrky_term_code_end = '999999'
             AND    scbcrse2.scbcrse_eff_term      = scksels.f_get_scbcrse_max_term_code(scrfees1.scrfees_subj_code,scrfees1.scrfees_crse_numb,'201820')
             AND    scbcrse1.scbcrse_subj_code     = scbcrse2.scbcrse_subj_code
             AND    scbcrse1.scbcrse_crse_numb     = scbcrse2.scbcrse_crse_numb
             AND    scrfees1.scrfees_detl_code     = scrfees2.scrfees_detl_code
             AND    tbracct1.tbracct_b_acci_code   = 
                    (
                      SELECT max(tbracct3.tbracct_b_acci_code)
                      FROM   scrfees scrfees3
                             JOIN scbcrky scbcrky3 ON (scrfees3.scrfees_subj_code||'-'||scrfees3.scrfees_crse_numb = scbcrky3.scbcrky_subj_code||'-'||scbcrky3.scbcrky_crse_numb)
                             JOIN scbcrse scbcrse3 ON (scrfees3.scrfees_subj_code||'-'||scrfees3.scrfees_crse_numb = scbcrse3.scbcrse_subj_code||'-'||scbcrse3.scbcrse_crse_numb)
                             JOIN scbsupp scbsupp3 ON (scrfees3.scrfees_subj_code||'-'||scrfees3.scrfees_crse_numb = scbsupp3.scbsupp_subj_code||'-'||scbsupp3.scbsupp_crse_numb)
                             JOIN tbracct tbracct3 ON  scrfees3.scrfees_detl_code = tbracct3.tbracct_detail_code
                      WHERE  scbcrky3.scbcrky_term_code_end = '999999'
                      AND    scbcrse3.scbcrse_eff_term      = scksels.f_get_scbcrse_max_term_code(scrfees1.scrfees_subj_code,scrfees1.scrfees_crse_numb,'201820')
                      AND    scbcrse2.scbcrse_subj_code     = scbcrse3.scbcrse_subj_code
                      AND    scbcrse2.scbcrse_crse_numb     = scbcrse3.scbcrse_crse_numb
                      AND    scrfees2.scrfees_detl_code     = scrfees3.scrfees_detl_code
                      AND    scbcrky2.scbcrky_term_code_end = scbcrky3.scbcrky_term_code_end
                      GROUP  BY scbcrse3.scbcrse_subj_code, scbcrse3.scbcrse_crse_numb, scrfees3.scrfees_detl_code
                    )
             GROUP  BY scbcrse2.scbcrse_subj_code, scbcrse2.scbcrse_crse_numb, scrfees2.scrfees_detl_code
           )
    GROUP  BY scbcrse1.scbcrse_subj_code, scbcrse1.scbcrse_crse_numb,   scrfees1.scrfees_detl_code,
              scbcrse1.scbcrse_title,     scrfees1.scrfees_fee_amount,  scbsupp1.scbsupp_tops_code, 
              scbcrse1.scbcrse_coll_code, tbracct1.tbracct_b_acci_code, scrfees1.scrfees_eff_term
    ORDER  BY scbcrse1.scbcrse_subj_code, scbcrse1.scbcrse_crse_numb, 
              scrfees1.scrfees_detl_code, scbsupp1.scbsupp_tops_code ASC
   )
   -- pull data from temp table
   SELECT -- "Term Effective", 
           "Course Subject", 
           "Course Number", 
           "Course Title",
          -- "Term Fee Amount",
           "DETL Code", 
           "COLL Code",
           "ACCI Code",
           "TOPS Code"
   FROM   ORDERED 
   WHERE  rn = 1; -- choose only the first record of each set of duplicates by pidm
 */
 ------------------------------------------------------------------------------------------------------------

   -- Term
   WITH ORDERED AS 
   (          
SELECT DISTINCT
           scrfees1.scrfees_eff_term    AS "Term Effective",
           scbcrse1.scbcrse_subj_code   AS "Course Subject",
           scbcrse1.scbcrse_crse_numb   AS "Course Number",
           scbcrse1.scbcrse_title       AS "Course Title",
           scrfees1.scrfees_fee_amount  AS "Term Fee Amount",
           scrfees1.scrfees_detl_code   AS "DETL Code",
           scbcrse1.scbcrse_coll_code   AS "COLL Code",
           tbracct1.tbracct_b_acci_code AS "ACCI Code",
           scbsupp1.scbsupp_tops_code   AS "TOPS Code",
           row_number() OVER
           (
             PARTITION BY scbcrse_subj_code,
                          scbcrse_crse_numb
             ORDER BY scbcrse_subj_code,
                      scbcrse_crse_numb,
                      scrfees_eff_term DESC
           ) AS rn
    FROM   scrfees scrfees1
           LEFT JOIN scbcrse scbcrse1 ON (scrfees1.scrfees_subj_code||'-'||scrfees1.scrfees_crse_numb = scbcrse1.scbcrse_subj_code||'-'||scbcrse1.scbcrse_crse_numb)
           LEFT JOIN scbsupp scbsupp1 ON (scrfees1.scrfees_subj_code||'-'||scrfees1.scrfees_crse_numb = scbsupp1.scbsupp_subj_code||'-'||scbsupp1.scbsupp_crse_numb)
           LEFT JOIN tbracct tbracct1 ON  scrfees1.scrfees_detl_code = tbracct1.tbracct_detail_code
           INNER JOIN scbcrky ON scbcrky_subj_code = scbcrse1.scbcrse_subj_code AND scbcrky_crse_numb = scbcrse1.scbcrse_crse_numb AND scbcrky_term_code_end = '999999'
    WHERE  scrfees1.scrfees_eff_term <= '202040'
    AND    scbcrse1.scbcrse_eff_term  = scksels.f_get_scbcrse_max_term_code(scrfees1.scrfees_subj_code,scrfees1.scrfees_crse_numb,'202040')
    AND    scrfees1.scrfees_eff_term  = 
           (
             SELECT max(scrfees2.scrfees_eff_term)
             FROM   scrfees scrfees2
                    LEFT JOIN scbcrse scbcrse2 ON (scrfees2.scrfees_subj_code||'-'||scrfees2.scrfees_crse_numb = scbcrse2.scbcrse_subj_code||'-'||scbcrse2.scbcrse_crse_numb)
                    LEFT JOIN scbsupp scbsupp2 ON (scrfees2.scrfees_subj_code||'-'||scrfees2.scrfees_crse_numb = scbsupp2.scbsupp_subj_code||'-'||scbsupp2.scbsupp_crse_numb)
                    LEFT JOIN tbracct tbracct2 ON  scrfees2.scrfees_detl_code = tbracct2.tbracct_detail_code
                    INNER JOIN scbcrky ON scbcrky_subj_code = scbcrse2.scbcrse_subj_code AND scbcrky_crse_numb = scbcrse2.scbcrse_crse_numb AND scbcrky_term_code_end = '999999'
             WHERE  scrfees2.scrfees_eff_term     <= '202040'
             AND    scbcrse2.scbcrse_eff_term      = scksels.f_get_scbcrse_max_term_code(scrfees1.scrfees_subj_code,scrfees1.scrfees_crse_numb,'202040')
             AND    scbcrse1.scbcrse_subj_code     = scbcrse2.scbcrse_subj_code
             AND    scbcrse1.scbcrse_crse_numb     = scbcrse2.scbcrse_crse_numb
             AND    scrfees1.scrfees_detl_code     = scrfees2.scrfees_detl_code
             AND    tbracct1.tbracct_b_acci_code   = 
                    (
                      SELECT max(tbracct3.tbracct_b_acci_code)
                      FROM   scrfees scrfees3
                             LEFT JOIN scbcrse scbcrse3 ON (scrfees3.scrfees_subj_code||'-'||scrfees3.scrfees_crse_numb = scbcrse3.scbcrse_subj_code||'-'||scbcrse3.scbcrse_crse_numb)
                             LEFT JOIN scbsupp scbsupp3 ON (scrfees3.scrfees_subj_code||'-'||scrfees3.scrfees_crse_numb = scbsupp3.scbsupp_subj_code||'-'||scbsupp3.scbsupp_crse_numb)
                             LEFT JOIN tbracct tbracct3 ON  scrfees3.scrfees_detl_code = tbracct3.tbracct_detail_code
                             INNER JOIN scbcrky ON scbcrky_subj_code = scbcrse3.scbcrse_subj_code AND scbcrky_crse_numb = scbcrse3.scbcrse_crse_numb AND scbcrky_term_code_end = '999999'
                      WHERE  scrfees3.scrfees_eff_term     <= '202040'
                      AND    scbcrse3.scbcrse_eff_term      = scksels.f_get_scbcrse_max_term_code(scrfees1.scrfees_subj_code,scrfees1.scrfees_crse_numb,'202040')
                      AND    scbcrse2.scbcrse_subj_code     = scbcrse3.scbcrse_subj_code
                      AND    scbcrse2.scbcrse_crse_numb     = scbcrse3.scbcrse_crse_numb
                      AND    scrfees2.scrfees_detl_code     = scrfees3.scrfees_detl_code
                      GROUP  BY scbcrse3.scbcrse_subj_code, scbcrse3.scbcrse_crse_numb, scrfees3.scrfees_detl_code
                    )
             GROUP  BY scbcrse2.scbcrse_subj_code, scbcrse2.scbcrse_crse_numb, scrfees2.scrfees_detl_code
           )
    GROUP  BY scbcrse1.scbcrse_subj_code, scbcrse1.scbcrse_crse_numb,   scrfees1.scrfees_detl_code,
              scbcrse1.scbcrse_title,     scrfees1.scrfees_fee_amount,  scbsupp1.scbsupp_tops_code, 
              scbcrse1.scbcrse_coll_code, tbracct1.tbracct_b_acci_code, scrfees1.scrfees_eff_term
    ORDER  BY scbcrse1.scbcrse_subj_code, scbcrse1.scbcrse_crse_numb, 
              scrfees1.scrfees_detl_code, scbsupp1.scbsupp_tops_code ASC
   )
   -- pull data from temp table
   SELECT  "Term Effective", 
           "Course Subject", 
           "Course Number", 
           "Course Title",
           "Term Fee Amount",
           "DETL Code", 
           "COLL Code",
           "ACCI Code",
           "TOPS Code"
   FROM   ORDERED 
   WHERE  rn = 1; -- choose only the first record of each set of duplicates by pidm

 ----------------------------------------------------------------------------------------------------     
 
 
-- end of file