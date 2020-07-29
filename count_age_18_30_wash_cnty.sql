SELECT metric,
       counts
  FROM (SELECT 'total_students_18_30' AS metric,
               COUNT(DISTINCT dsc_pidm) AS counts,
               1 AS custom_order
          FROM enroll.students03
         WHERE s_age BETWEEN 18 AND 30
           AND dsc_term_code = :term

         UNION

        SELECT 'total_students' AS metric,
               COUNT(DISTINCT dsc_pidm) AS counts,
               2 AS custom_order
          FROM enroll.students03
         WHERE dsc_term_code = :term

         UNION

        SELECT DISTINCT
               'total_students_18_30_pct',
               (ROUND((SELECT COUNT(DISTINCT dsc_pidm)
                         FROM enroll.students03
                        WHERE s_age BETWEEN 18 AND 30
                          AND dsc_term_code = :term) / (SELECT COUNT(DISTINCT dsc_pidm)
                                                          FROM enroll.students03
                                                         WHERE dsc_term_code = :term), 4) * 100) AS metric,
               3 AS custom_order
          FROM dual

         UNION

        SELECT 'total_students_18_30_wash_cnty' AS metric,
               COUNT(DISTINCT dsc_pidm) AS counts,
               4 AS custom_order
          FROM enroll.students03
         WHERE dsc_term_code = :term
           AND s_age BETWEEN 18 AND 30
           AND s_county_origin = 'UT053'

         UNION

        SELECT 'total_students_18_30_other_cnty' AS metric,
               COUNT(DISTINCT dsc_pidm) AS counts,
               5 AS custom_order
          FROM enroll.students03
         WHERE dsc_term_code = :term
           AND s_age BETWEEN 18 AND 30
           AND s_county_origin != 'UT053'

         UNION

        SELECT 'total_students_18_30_wash_cnty_pct' AS metric,
               ROUND((SELECT COUNT(DISTINCT dsc_pidm)
                        FROM enroll.students03
                       WHERE dsc_term_code = :term
                         AND s_age BETWEEN 18 AND 30
                         AND s_county_origin = 'UT053') / (SELECT COUNT(DISTINCT dsc_pidm)
                                                             FROM enroll.students03
                                                            WHERE dsc_term_code = :term
                                                              AND s_age BETWEEN 18 AND 30
                                                              AND s_county_origin != 'UT053'), 4) * 100 AS counts,
               6 AS custom_order
          FROM dual)
 ORDER BY custom_order;

