SELECT count(sgrchrt_pidm),
       sgrchrt_term_code_eff,
       sgrchrt_chrt_code,
       sgrchrt_activity_date
  FROM (SELECT dsc_pidm AS sgrchrt_pidm,
               substr(dsc_term_code, 0, 5) || '0' AS sgrchrt_term_code_eff,
               CASE
                  --200943
                  WHEN dsc_term_code = '200943' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB200940'
                  WHEN dsc_term_code = '200943' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB200940'
                  WHEN dsc_term_code = '200943' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO200940'
                  WHEN dsc_term_code = '200943' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO200940'
                  --201043
                  WHEN dsc_term_code = '201043' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201040'
                  WHEN dsc_term_code = '201043' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201040'
                  WHEN dsc_term_code = '201043' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201040'
                  WHEN dsc_term_code = '201043' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201040'
                  --201143
                  WHEN dsc_term_code = '201143' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201140'
                  WHEN dsc_term_code = '201143' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201140'
                  WHEN dsc_term_code = '201143' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201140'
                  WHEN dsc_term_code = '201143' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201140'
                  --201243
                  WHEN dsc_term_code = '201243' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201240'
                  WHEN dsc_term_code = '201243' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201240'
                  WHEN dsc_term_code = '201243' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201240'
                  WHEN dsc_term_code = '201243' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201240'
                  --201343
                  WHEN dsc_term_code = '201343' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201340'
                  WHEN dsc_term_code = '201343' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201340'
                  WHEN dsc_term_code = '201343' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201340'
                  WHEN dsc_term_code = '201343' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201340'
                  --201443
                  WHEN dsc_term_code = '201443' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201440'
                  WHEN dsc_term_code = '201443' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201440'
                  WHEN dsc_term_code = '201443' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201440'
                  WHEN dsc_term_code = '201443' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201440'
                  --201543
                  WHEN dsc_term_code = '201543' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201540'
                  WHEN dsc_term_code = '201543' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201540'
                  WHEN dsc_term_code = '201543' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201540'
                  WHEN dsc_term_code = '201543' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201540'
                  --201643
                  WHEN dsc_term_code = '201643' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201640'
                  WHEN dsc_term_code = '201643' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201640'
                  WHEN dsc_term_code = '201643' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201640'
                  WHEN dsc_term_code = '201643' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201640'
                  --201743
                  WHEN dsc_term_code = '201743' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201740'
                  WHEN dsc_term_code = '201743' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201740'
                  WHEN dsc_term_code = '201743' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201740'
                  WHEN dsc_term_code = '201743' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201740'
                  --201843
                  WHEN dsc_term_code = '201843' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201840'
                  WHEN dsc_term_code = '201843' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201840'
                  WHEN dsc_term_code = '201843' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201840'
                  WHEN dsc_term_code = '201843' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201840'
                  --201943
                  WHEN dsc_term_code = '201943' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201940'
                  WHEN dsc_term_code = '201943' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201940'
                  WHEN dsc_term_code = '201943' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201940'
                  WHEN dsc_term_code = '201943' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201940'
                  END AS sgrchrt_chrt_code,
               sysdate AS sgrchrt_activity_date
          FROM students03 s1
         WHERE dsc_term_code IN ('200943', '201043', '201143', '201243', '201343', '201443', '201543', '201643', '201743', '201843', '201943')
           AND s_pt_ft IN ('F', 'P')
           AND (s_entry_action IN ('FF', 'FH') OR (EXISTS(SELECT 'Y'
                                                            FROM students03 s2
                                                           WHERE s2.dsc_pidm = s1.dsc_pidm
                                                             AND s2.dsc_term_code = substr(s1.dsc_term_code, 1, 4) || '3E' -- The Summer previous to that Fall.
                                                             AND s2.s_entry_action IN ('FF', 'FH', 'HS') -- If they were HS in Summer, and FH the next Fall, I assume they should have been labeled FH.
                                                      ) AND (s_entry_action = 'CS')))
         UNION

/*
FALL
Transfers, FT, PT, BS, OT
Cohort FTFB200940, FTPB200940, FTFO200940, FTPO200940
Count 322
*/
        SELECT dsc_pidm AS sgrchrt_pidm,
               substr(dsc_term_code, 0, 5) || '0' AS sgrchrt_term_code_eff,
               CASE
                  --200943
                  WHEN dsc_term_code = '200943' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB200940'
                  WHEN dsc_term_code = '200943' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB200940'
                  WHEN dsc_term_code = '200943' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO200940'
                  WHEN dsc_term_code = '200943' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO200940'
                   --201043
                  WHEN dsc_term_code = '201043' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201040'
                  WHEN dsc_term_code = '201043' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201040'
                  WHEN dsc_term_code = '201043' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201040'
                  WHEN dsc_term_code = '201043' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201040'
                  --201143
                  WHEN dsc_term_code = '201143' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201140'
                  WHEN dsc_term_code = '201143' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201140'
                  WHEN dsc_term_code = '201143' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201140'
                  WHEN dsc_term_code = '201143' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201140'
                  --201243
                  WHEN dsc_term_code = '201243' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201240'
                  WHEN dsc_term_code = '201243' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201240'
                  WHEN dsc_term_code = '201243' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201240'
                  WHEN dsc_term_code = '201243' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201240'
                  --201343
                  WHEN dsc_term_code = '201343' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201340'
                  WHEN dsc_term_code = '201343' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201340'
                  WHEN dsc_term_code = '201343' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201340'
                  WHEN dsc_term_code = '201343' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201340'
                  --201443
                  WHEN dsc_term_code = '201443' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201440'
                  WHEN dsc_term_code = '201443' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201440'
                  WHEN dsc_term_code = '201443' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201440'
                  WHEN dsc_term_code = '201443' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201440'
                  --201543
                  WHEN dsc_term_code = '201543' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201540'
                  WHEN dsc_term_code = '201543' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201540'
                  WHEN dsc_term_code = '201543' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201540'
                  WHEN dsc_term_code = '201543' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201540'
                  --201643
                  WHEN dsc_term_code = '201643' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201640'
                  WHEN dsc_term_code = '201643' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201640'
                  WHEN dsc_term_code = '201643' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201640'
                  WHEN dsc_term_code = '201643' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201640'
                  --201743
                  WHEN dsc_term_code = '201743' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201740'
                  WHEN dsc_term_code = '201743' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201740'
                  WHEN dsc_term_code = '201743' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201740'
                  WHEN dsc_term_code = '201743' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201740'
                  --201843
                  WHEN dsc_term_code = '201843' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201840'
                  WHEN dsc_term_code = '201843' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201840'
                  WHEN dsc_term_code = '201843' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201840'
                  WHEN dsc_term_code = '201843' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201840'
                  --201943
                  WHEN dsc_term_code = '201943' and s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201940'
                  WHEN dsc_term_code = '201943' and s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201940'
                  WHEN dsc_term_code = '201943' and s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201940'
                  WHEN dsc_term_code = '201943' and s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201940'
                  END AS sgrchrt_chrt_code,
               sysdate AS sgrchrt_activity_date
          FROM students03 s1
         WHERE dsc_term_code IN ('200943', '201043', '201143', '201243', '201343', '201443', '201543', '201643', '201743', '201843', '201943')
           AND s_pt_ft IN ('F', 'P')
           AND (s_entry_action = 'TU' OR (EXISTS(SELECT 'Y'
                                                   FROM students03 s2
                                                  WHERE s2.dsc_pidm = s1.dsc_pidm
                                                    AND s2.dsc_term_code = substr(s1.dsc_term_code, 1, 4) || '3E' -- The Summer previous to that Fall.
                                                    AND s2.s_entry_action = 'TU' -- If they were TU in Summer, and something else the next Fall, I assume they should have been labeled TU.
                                             ) AND (s_entry_action != 'HS')))

     UNION

/*
SPRING
1st Time, Transfer, FT, PT, BS, OT
Cohort FTFB200940, FTPB200940, FTFO200940, FTPO200940
Count 322
 */
--Cohort FTFB201020 - 1st Time,FT,BS,Fresh
  SELECT dsc_pidm AS sgrchrt_pidm,
               substr(dsc_term_code, 0, 5) || '0' AS sgrchrt_term_code_eff,
               CASE
                  --201023
                  WHEN dsc_term_code = '201023' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFB201020'
                  WHEN dsc_term_code = '201023' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFO201020'
                  WHEN dsc_term_code = '201023' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPB201020'
                  WHEN dsc_term_code = '201023' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPO201020'
                  WHEN dsc_term_code = '201023' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action =  'TU' THEN 'TUFB201020'
                  WHEN dsc_term_code = '201023' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action =  'TU' THEN 'TUFO201020'
                  WHEN dsc_term_code = '201023' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action =  'TU' THEN 'TUPB201020'
                  WHEN dsc_term_code = '201023' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action =  'TU' THEN 'TUPO201020'
                  --201123
                  WHEN dsc_term_code = '201123' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFB201120'
                  WHEN dsc_term_code = '201123' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFO201120'
                  WHEN dsc_term_code = '201123' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPB201120'
                  WHEN dsc_term_code = '201123' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPO201120'
                  WHEN dsc_term_code = '201123' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action =  'TU' THEN 'TUFB201120'
                  WHEN dsc_term_code = '201123' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action =  'TU' THEN 'TUFO201120'
                  WHEN dsc_term_code = '201123' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action =  'TU' THEN 'TUPB201120'
                  WHEN dsc_term_code = '201123' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action =  'TU' THEN 'TUPO201120'
                  --201223
                  WHEN dsc_term_code = '201223' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFB201220'
                  WHEN dsc_term_code = '201223' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFO201220'
                  WHEN dsc_term_code = '201223' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPB201220'
                  WHEN dsc_term_code = '201223' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPO201220'
                  WHEN dsc_term_code = '201223' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action =  'TU' THEN 'TUFB201220'
                  WHEN dsc_term_code = '201223' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action =  'TU' THEN 'TUFO201220'
                  WHEN dsc_term_code = '201223' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action =  'TU' THEN 'TUPB201220'
                  WHEN dsc_term_code = '201223' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action =  'TU' THEN 'TUPO201220'
                  --201323
                  WHEN dsc_term_code = '201323' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFB201320'
                  WHEN dsc_term_code = '201323' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFO201320'
                  WHEN dsc_term_code = '201323' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPB201320'
                  WHEN dsc_term_code = '201323' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPO201320'
                  WHEN dsc_term_code = '201323' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action =  'TU' THEN 'TUFB201320'
                  WHEN dsc_term_code = '201323' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action =  'TU' THEN 'TUFO201320'
                  WHEN dsc_term_code = '201323' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action =  'TU' THEN 'TUPB201320'
                  WHEN dsc_term_code = '201323' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action =  'TU' THEN 'TUPO201320'
                  --201423
                  WHEN dsc_term_code = '201423' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFB201420'
                  WHEN dsc_term_code = '201423' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFO201420'
                  WHEN dsc_term_code = '201423' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPB201420'
                  WHEN dsc_term_code = '201423' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPO201420'
                  WHEN dsc_term_code = '201423' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUFB201420'
                  WHEN dsc_term_code = '201423' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUFO201420'
                  WHEN dsc_term_code = '201423' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUPB201420'
                  WHEN dsc_term_code = '201423' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUPO201420'
                  --201523
                  WHEN dsc_term_code = '201523' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFB201520'
                  WHEN dsc_term_code = '201523' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFO201520'
                  WHEN dsc_term_code = '201523' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPB201520'
                  WHEN dsc_term_code = '201523' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPO201520'
                  WHEN dsc_term_code = '201523' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUFB201520'
                  WHEN dsc_term_code = '201523' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUFO201520'
                  WHEN dsc_term_code = '201523' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUPB201520'
                  WHEN dsc_term_code = '201523' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUPO201520'
                  --201623
                  WHEN dsc_term_code = '201623' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFB201620'
                  WHEN dsc_term_code = '201623' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFO201620'
                  WHEN dsc_term_code = '201623' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPB201620'
                  WHEN dsc_term_code = '201623' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPO201620'
                  WHEN dsc_term_code = '201623' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUFB201620'
                  WHEN dsc_term_code = '201623' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUFO201620'
                  WHEN dsc_term_code = '201623' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUPB201620'
                  WHEN dsc_term_code = '201623' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUPO201620'
                  --201723
                  WHEN dsc_term_code = '201723' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFB201720'
                  WHEN dsc_term_code = '201723' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFO201720'
                  WHEN dsc_term_code = '201723' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPB201720'
                  WHEN dsc_term_code = '201723' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPO201720'
                  WHEN dsc_term_code = '201723' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUFB201720'
                  WHEN dsc_term_code = '201723' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUFO201720'
                  WHEN dsc_term_code = '201723' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUPB201720'
                  WHEN dsc_term_code = '201723' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUPO201720'
                  --201823
                  WHEN dsc_term_code = '201823' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFB201820'
                  WHEN dsc_term_code = '201823' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFO201820'
                  WHEN dsc_term_code = '201823' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPB201820'
                  WHEN dsc_term_code = '201823' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPO201820'
                  WHEN dsc_term_code = '201823' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUFB201820'
                  WHEN dsc_term_code = '201823' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUFO201820'
                  WHEN dsc_term_code = '201823' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUPB201820'
                  WHEN dsc_term_code = '201823' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUPO201820'
                  --201923
                  WHEN dsc_term_code = '201923' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFB201920'
                  WHEN dsc_term_code = '201923' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFO201920'
                  WHEN dsc_term_code = '201923' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPB201920'
                  WHEN dsc_term_code = '201923' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPO201920'
                  WHEN dsc_term_code = '201923' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUFB201920'
                  WHEN dsc_term_code = '201923' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUFO201920'
                  WHEN dsc_term_code = '201923' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUPB201920'
                  WHEN dsc_term_code = '201923' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUPO201920'
                  END AS sgrchrt_chrt_code,
               sysdate AS sgrchrt_activity_date
    FROM enroll.students03
   WHERE dsc_term_code IN ('201023', '201123', '201223', '201323', '201423','201523', '201623', '201723', '201823', '201923')
     AND s_entry_action IN ('FF', 'FH', 'TU')
     AND s_pt_ft IN ('F', 'P')
     )
 GROUP BY sgrchrt_term_code_eff,
          sgrchrt_chrt_code, sgrchrt_activity_date
 ORDER BY sgrchrt_term_code_eff desc, sgrchrt_chrt_code;

