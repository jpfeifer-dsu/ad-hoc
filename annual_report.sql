/******************************************************************
  Page 4 of Annual Review by
  Degree Programs, Major Headcounts
******************************************************************/
/*
 Actual headcount by major for Fall 2019
 */
  WITH major_headcount AS (SELECT CAST(COUNT(a.cur_majr1) AS VARCHAR(10)) AS actual_headcount,
                                  b.prgm_code,
                                  b.majr_code,
                                  b.majr_desc,
                                  b.dept_code
                             FROM students03 a
                        LEFT JOIN cw_programs b
                               ON b.prgm_code = a.cur_prgm1
                            WHERE a.dsc_term_code = '201943'
                              AND b.acyr_code = '1920'
                         GROUP BY b.prgm_code,
                                  b.majr_code,
                                  b.majr_desc,
                                  b.dept_code
),

/*
Average headcount by major for Fall 2016, 2017, & 2018 (calculate)
 */
     major_avg AS (SELECT CAST(ROUND(COUNT(a.cur_majr1) / 3, 2) AS VARCHAR(10)) AS avg_headcount_by_major,
                          b.prgm_code,
                          b.majr_code,
                          b.majr_desc,
                          b.dept_code
                     FROM students03 a
                LEFT JOIN cw_programs b
                       ON b.prgm_code = a.cur_prgm1
                    WHERE a.dsc_term_code IN ('201943', '201843', '201743')
                      AND b.acyr_code = '1920'
                 GROUP BY b.prgm_code,
                          b.majr_code,
                          b.majr_desc,
                          b.dept_code
                   HAVING COUNT(DISTINCT a.dsc_term_code) = 3
),

/*
Actual number of degrees conferred this academic year for 2019-2020
 */
       degrees_conferred AS (SELECT CAST(COUNT(a.dxgrad_degc_code) AS VARCHAR(10)) AS degrees_awrd_2019_20,
                                    b.prgm_code,
                                    b.majr_code,
                                    b.majr_desc,
                                    b.dept_code
                               FROM dxgrad_all a
                          LEFT JOIN cw_programs b
                                 ON b.prgm_code = a.dxgrad_dgmr_prgm
                              WHERE a.dxgrad_acyr = '1920'
                                AND b.acyr_code = '1920'
                              GROUP BY b.prgm_code,
                                       b.majr_code,
                                       b.majr_desc,
                                       b.dept_code
),

/*
Average number of degrees conferred for previous 3 years (calculate)
 */
       degrees_conferred_avg
          AS (SELECT CAST(ROUND(COUNT(a.dxgrad_degc_code) / 3, 2) AS VARCHAR(10)) AS avg_degrees_prev_3_yrs,
                     b.prgm_code,
                     b.majr_code,
                     b.majr_desc,
                     b.dept_code
                FROM dxgrad_all a
           LEFT JOIN cw_programs b
                  ON b.prgm_code = a.dxgrad_dgmr_prgm
               WHERE a.dxgrad_acyr IN ('1920', '1819', '1718')
                 AND b.acyr_code = '1920'
            GROUP BY b.prgm_code,
                     b.majr_code,
                     b.majr_desc,
                     b.dept_code
              HAVING COUNT(DISTINCT dxgrad_acyr) = 3
),

/*
Change from previous year 2018-19 (calculate)
 */
       degree_1819 AS (SELECT CAST(COUNT(a.dxgrad_degc_code) AS VARCHAR(10)) AS degrees_conferred_1819,
                              b.prgm_code,
                              b.majr_code,
                              b.dept_code
                         FROM dxgrad_all a
                    LEFT JOIN cw_programs b
                           ON b.prgm_code = a.dxgrad_dgmr_prgm
                        WHERE a.dxgrad_acyr = '1819'
                          AND b.acyr_code = '1920'
                        GROUP BY b.prgm_code,
                                 b.majr_code,
                                 b.dept_code),

       degrees_conferred_changed AS (SELECT COUNT(a.dxgrad_degc_code) AS degree_count_1920,
                                            c.degrees_conferred_1819,
                                            CAST(COUNT(a.dxgrad_degc_code) - c.degrees_conferred_1819 AS CHAR(10)) AS change_prev_yr,
                                            b.prgm_code,
                                            b.majr_code,
                                            b.majr_desc,
                                            b.dept_code
                                       FROM dxgrad_all a
                                  LEFT JOIN cw_programs b
                                         ON b.prgm_code = a.dxgrad_dgmr_prgm
                                  LEFT JOIN degree_1819 c
                                         ON c.prgm_code = b.prgm_code AND
                                            c.dept_code = b.dept_code AND c.majr_code = b.majr_code
                                      WHERE a.dxgrad_acyr = '1920'
                                        AND b.acyr_code = '1920'
                                   GROUP BY b.prgm_code,
                                            b.majr_code,
                                            b.majr_desc,
                                            b.dept_code,
                                            c.degrees_conferred_1819
),

--Union All Programs, Majors, Department Codes, and Descriptions
       programs AS (SELECT prgm_code,
                               majr_code,
                               majr_desc,
                               dept_code
                          FROM major_headcount
                         UNION
                        SELECT prgm_code,
                               majr_code,
                               majr_desc,
                               dept_code
                          FROM major_avg
                         UNION
                        SELECT prgm_code,
                               majr_code,
                               majr_desc,
                               dept_code
                          FROM degrees_conferred
                         UNION
                        SELECT prgm_code,
                               majr_code,
                               majr_desc,
                               dept_code
                          FROM degrees_conferred_avg
                         UNION
                        SELECT prgm_code,
                               majr_code,
                               majr_desc,
                               dept_code
                          FROM degrees_conferred_changed)

--Final Query Normalized
   SELECT COALESCE(c.actual_headcount, 'N/A') AS "Actual headcount",
          COALESCE(d.avg_headcount_by_major, 'N/A') AS "AVG Headcount By Major",
          COALESCE(e.degrees_awrd_2019_20, 'N/A') AS "Degrees Awd 2019-20",
          COALESCE(f.avg_degrees_prev_3_yrs, 'N/A') AS "Avg Degrees Prev 3 yrs",
          COALESCE(e.change_prev_yr, 'N/A') AS "Change from Prev yr",
          a.prgm_code AS "Program",
          a.majr_code AS "Major Code",
          a.majr_desc AS "Major Desc",
          a.dept_code AS "Department Code",
          b.stvdept_desc AS "Department Desc"
     FROM programs a
LEFT JOIN stvdept b
       ON b.stvdept_code = a.dept_code
LEFT JOIN major_headcount c
       ON c.prgm_code = a.prgm_code AND c.dept_code = a.dept_code AND c.majr_code = a.majr_code
LEFT JOIN major_avg d
       ON d.prgm_code = a.prgm_code AND d.dept_code = a.dept_code AND d.majr_code = a.majr_code
LEFT JOIN degrees_conferred e
       ON e.prgm_code = a.prgm_code AND e.dept_code = a.dept_code AND e.majr_code = a.majr_code
LEFT JOIN degrees_conferred_avg f
       ON f.prgm_code = a.prgm_code AND f.dept_code = a.dept_code AND f.majr_code = a.majr_code
LEFT JOIN degrees_conferred_changed e
       ON e.prgm_code = a.prgm_code AND e.dept_code = a.dept_code AND e.majr_code = a.majr_code
 ORDER BY a.dept_code,
          a.majr_code,
          a.prgm_code;

/******************************************************************
  Page 9 of Annual Review
  Department & Program:
******************************************************************/

/*
Faculty Count for Dept Review
 */
  WITH perappt_max AS (SELECT perappt_pidm,
                              MAX(perappt_appt_eff_date) AS perappt_appt_eff_date
                         FROM perappt
                     GROUP BY perappt_pidm),
      employee AS (SELECT DISTINCT
                   CASE
                       WHEN f.pebempl_ecls_code IN ('F2', 'F9') AND e.perappt_tenure_code = 'T' THEN 'Full-Time Tenured'
                       WHEN f.pebempl_ecls_code IN ('F2', 'F9') AND e.perappt_tenure_code = 'O' THEN 'Full-Time Non-Tenured'
                       ELSE 'Part Time'
                       END AS fac_status,
                   a.c_instr_id,
                   f.pebempl_ecls_code,
                   e.perappt_tenure_code,
                   CAST(SUBSTR(a.dsc_term_code, 3, 2) || SUBSTR(a.dsc_term_code, 3, 2) + 1 AS VARCHAR2(4)) AS academic_year,
                   b.dept_code AS department_code,
                   g.stvdept_desc AS department_desc
              FROM courses@dscir a
         LEFT JOIN cw_subject b
                ON a.c_crs_subject = b.subj_code
         LEFT JOIN spriden c
                ON c.spriden_id = a.c_instr_id AND c.spriden_change_ind IS NULL
         LEFT JOIN perappt_max d
                ON d.perappt_pidm = c.spriden_pidm
         LEFT JOIN perappt e
                ON e.perappt_pidm = d.perappt_pidm AND
                   e.perappt_appt_eff_date = d.perappt_appt_eff_date
         LEFT JOIN pebempl f
                ON c.spriden_pidm = f.pebempl_pidm
         LEFT JOIN stvdept g
                ON g.stvdept_code = b.dept_code
             WHERE a.dsc_term_code IN ('201943', '201843', '201743', '201643', '201543')
),
       faculty AS (SELECT SUM(CASE
                                 WHEN a.fac_status = 'Full-Time Tenured' THEN 1
                                 END) AS full_time_tenured,
                          SUM(CASE
                                 WHEN a.fac_status = 'Full-Time Non-Tenured' THEN 1
                                 END) AS full_time_non_tenured,
                          SUM(CASE
                                 WHEN a.fac_status = 'Part Time' THEN 1
                                 END) AS part_time,
                          a.academic_year,
                          a.department_code,
                          a.department_desc
                     FROM employee a
                 GROUP BY a.academic_year,
                          a.department_code,
                          a.department_desc
),

/*
 Number of Graduates
 */
    graduates AS (SELECT COUNT(CASE
                                  WHEN a.dxgrad_degc_code LIKE 'C%' THEN 1
                                  END) AS certificates,
                         COUNT(CASE
                                  WHEN a.dxgrad_degc_code LIKE 'A%' THEN 1
                                  END) AS associates,
                         COUNT(CASE
                                  WHEN a.dxgrad_degc_code LIKE 'B%' THEN 1
                                  END) AS bachelors,
                         COUNT(CASE
                                  WHEN a.dxgrad_degc_code LIKE 'M%' THEN 1
                                  END) AS masters,
                         a.dxgrad_acyr AS academic_year,
                         b.dept_code AS department_code,
                         c.stvdept_desc AS department_desc
                    FROM dxgrad_all a
                         LEFT JOIN cw_programs b
                                   ON b.prgm_code = a.dxgrad_dgmr_prgm
                         LEFT JOIN stvdept c
                                   ON c.stvdept_code = b.dept_code
                   WHERE a.dxgrad_acyr >= '1516'
                     AND b.acyr_code = '1920'
                   GROUP BY a.dxgrad_acyr,
                            b.dept_code,
                            c.stvdept_desc
),

/*
 # of Declared Majors in Department
 */
       declared_majors AS (SELECT c.stvdept_desc AS department_desc,
                                  b.dept_code AS department_code,
                                  CAST(SUBSTR(dsc_term_code, 3, 2) || SUBSTR(dsc_term_code, 3, 2) + 1 AS VARCHAR2(4)) AS academic_year,
                                  COUNT(a.cur_majr1) AS declared_majors
                             FROM students03 a
                        LEFT JOIN cw_programs b
                               ON b.prgm_code = a.cur_prgm1
                        LEFT JOIN stvdept c
                               ON c.stvdept_code = b.dept_code
                            WHERE a.dsc_term_code IN ('201943', '201843', '201743', '201643', '201543')
                         GROUP BY c.stvdept_desc,
                                  b.dept_code,
                                  a.dsc_term_code
),

/*
 Department FTE
 Calculates UG FTE by Department
 */

       ug_fte AS (SELECT ROUND(SUM(a.sc_att_cr) / 150 + SUM(COALESCE(a.sc_contact_hrs, 0)) / 450, 2) AS ug_fte,
                         c.dept_code,
                         a.dsc_term_code
                    FROM bailey.student_courses@dscir a
               LEFT JOIN bailey.courses@dscir b
                      ON a.dsc_crn = b.dc_crn AND a.dsc_term_code = b.dsc_term_code
               LEFT JOIN cw_subject c
                      ON c.subj_code = a.sc_crs_sbj
                   WHERE a.dsc_term_code IN ('201943', '201843', '201743', '201643', '201543')
                     AND b.c_level != 'G'
                GROUP BY c.dept_code,
                         a.dsc_term_code
),

/*
 Calculates GRAD FTE by Department
 */
       g_fte AS (SELECT COALESCE(ROUND(SUM(a.sc_att_cr) / 100 + SUM(COALESCE(a.sc_contact_hrs, 0)) / 450, 2), 0) AS g_fte,
                        d.dept_code,
                        a.dsc_term_code
                   FROM bailey.student_courses@dscir a
              LEFT JOIN bailey.courses@dscir b
                     ON a.dsc_crn = b.dc_crn AND a.dsc_term_code = b.dsc_term_code
              LEFT JOIN cw_subject d
                     ON d.subj_code = a.sc_crs_sbj
                  WHERE a.dsc_term_code = b.dsc_term_code
                    AND a.dsc_term_code IN ('201943', '201843', '201743', '201643', '201543')
                    AND b.c_level = 'G'
               GROUP BY d.dept_code,
                        a.dsc_term_code
 ),

/*
Combines UG and GRAD FTE by Department
 */
       department_fte AS (SELECT c.dept_code AS department_code,
                                 c.dept_desc AS department_desc,
                                 CAST(SUBSTR(a.dsc_term_code, 3, 2) || SUBSTR(a.dsc_term_code, 3, 2) + 1 AS VARCHAR2(4)) AS academic_year,
                                 COALESCE(e.g_fte + d.ug_fte, d.ug_fte) AS fte
                            FROM bailey.student_courses@dscir a
                       LEFT JOIN bailey.courses@dscir b
                              ON b.dc_crn = a.dsc_crn AND b.dsc_term_code = a.dsc_term_code
                       LEFT JOIN cw_subject c
                              ON c.subj_code = a.sc_crs_sbj
                       LEFT JOIN ug_fte d
                              ON d.dsc_term_code = a.dsc_term_code AND d.dept_code = c.dept_code
                       LEFT JOIN g_fte e
                              ON e.dsc_term_code = a.dsc_term_code AND e.dept_code = c.dept_code
                           WHERE a.dsc_term_code IN ('201943', '201843', '201743', '201643', '201543')
                           GROUP BY c.dept_code,
                                    c.dept_desc,
                                    a.dsc_term_code,
                                    d.ug_fte,
                                    e.g_fte
),

/*
 Total Department SCH
 SCH = Enrollment (class Size) * credit Hours
 */
       department_sch AS (SELECT a.department_code,
                                     a.department_desc,
                                     a.academic_year,
                                     SUM(sch) AS sch
                                FROM (SELECT b1.dept_code AS department_code,
                                             b1.dept_desc AS department_desc,
                                             CAST(SUBSTR(a1.dsc_term_code, 3, 2) || SUBSTR(a1.dsc_term_code, 3, 2) + 1 AS VARCHAR2(4)) AS academic_year,
                                             SUM(DISTINCT (a1.c_min_credit / 10) * a1.c_class_size) AS sch
                                        FROM bailey.courses@dscir a1
                                   LEFT JOIN cw_subject b1
                                          ON b1.subj_code = a1.c_crs_subject
                                       WHERE a1.dsc_term_code IN ('201943', '201843', '201743', '201643', '201543')
                                    GROUP BY b1.dept_code,
                                             b1.dept_desc,
                                             CAST(SUBSTR(a1.dsc_term_code, 3, 2) || SUBSTR(a1.dsc_term_code, 3, 2) + 1 AS VARCHAR2(4)),
                                             a1.c_crs_subject,
                                             a1.c_crs_number,
                                             a1.c_crs_section,
                                             a1.dsc_term_code) a
                               GROUP BY a.department_code,
                                        a.department_desc,
                                        a.academic_year
),

--Union All Department Codes, Descriptions, and Academic Years
       acyr_dept AS (SELECT academic_year,
                            department_code,
                            department_desc
                       FROM faculty
                      UNION
                     SELECT academic_year,
                            department_code,
                            department_desc
                       FROM declared_majors
                      UNION
                     SELECT academic_year,
                            department_code,
                            department_desc
                       FROM graduates
                      UNION
                     SELECT academic_year,
                            department_code,
                            department_desc
                       FROM department_fte
                      UNION
                     SELECT academic_year,
                            department_code,
                            department_desc
                       FROM department_sch
)

/*
Final Query Normalized
calculated columns: total_faculty_fte, student_fte_per_total_faculty_fte
 */
      SELECT b.full_time_tenured,
             b.full_time_non_tenured,
             b.part_time,
             '' AS total_faculty_fte, --calculated column
             c.certificates,
             c.associates,
             c.bachelors,
             c.masters,
             d.declared_majors AS declared_majors,
             e.fte AS department_fte,
             f.sch AS department_sch,
             '' AS student_fte_per_total_faculty_fte, --calculated column
             a.academic_year,
             a.department_code,
             a.department_desc
        FROM acyr_dept a
   LEFT JOIN faculty b
          ON b.department_code = a.department_code AND b.academic_year = a.academic_year
   LEFT JOIN graduates c
          ON c.department_code = a.department_code AND c.academic_year = a.academic_year
   LEFT JOIN declared_majors d
          ON d.department_code = a.department_code AND d.academic_year = a.academic_year
   LEFT JOIN department_fte e
          ON e.department_code = a.department_code AND e.academic_year = a.academic_year
   LEFT JOIN department_sch f
          ON f.department_code = a.department_code AND f.academic_year = a.academic_year
    ORDER BY a.department_code,
             a.academic_year;
