SELECT dsc_pidm,
       s_first,
       s_last,
       s_ethnic,
       CASE
          WHEN s_ethnic = 'W' THEN 'White'
          WHEN s_ethnic = 'B' THEN 'Black American'
          WHEN s_ethnic = 'H' THEN 'Hispanic'
          WHEN s_ethnic = 'P' THEN 'Hawaiian/Pacific Islander'
          WHEN s_ethnic = 'A' THEN 'Asian'
          WHEN s_ethnic = 'I' THEN 'American Indian'
          WHEN s_ethnic = 'U' THEN 'Unspecified'
          WHEN s_ethnic = '2' THEN '2 or more'
          WHEN s_ethnic = 'N' THEN 'Non-Resident Alien'
          END AS ethnicity_desc,
       s_gender,
       CASE
          WHEN s_gender = 'M' THEN 'Male'
          WHEN s_gender = 'F' THEN 'Female'
          ELSE 'Not Specified'
          END AS gender_desc,
       s_pell,
       CASE
          WHEN s_pell IS NOT NULL THEN 'Low Income'
          END AS low_income_ind,
       s_age,
       CASE
          WHEN s_age >= 25 THEN 'Non-Traditional Student'
          ELSE 'Traditional Student'
          END AS traditional_student_ind,
       s_regent_res,
       CASE
          WHEN s_regent_res IN ('A', 'M', 'R') THEN 'Resident'
          WHEN s_regent_res IN ('G', 'N') THEN 'Non-Resident'
          END AS residency_desc,
       COALESCE(a.first_gen_ind, 'N'),
       b.hsgpact_hsgpact AS index_score,
       CASE
          WHEN hsgpact_hsgpact < 45 THEN 'Low Index Score'
          ELSE 'Missing Data'
          END AS low_index_score_ind,
       a.s_entry_action,
       CASE
          WHEN s_entry_action = 'TU' THEN 'Transfer'
          WHEN s_entry_action = 'HS' THEN 'High School Student'
          WHEN s_entry_action IN ('FH', 'FF') THEN 'First Time Student'
          WHEN s_entry_action = 'CS' THEN 'Continuing Student'
          WHEN s_entry_action = 'RS' THEN 'Returning Student'
          WHEN s_entry_action = 'NM' THEN 'Non-Matriculated'
          WHEN s_entry_action LIKE '%G' THEN 'Graduate'
          ELSE 'Unknown'
          END AS entry_action_desc,
       a.dsc_term_code
  FROM bailey.students03 a
       LEFT JOIN dsc.hsgpact@prod b
                 ON a.dsc_pidm = b.hsgpact_pidm
 WHERE dsc_term_code IN ('201943', '201543');