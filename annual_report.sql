/******************************************************************
  Page 4 of Annual Review by
  Degree Programs, Major Headcounts
******************************************************************/
-- Actual headcount by major for Fall 2019
WITH CTE_Major_Headcount AS (
    SELECT
        CAST(COUNT(st.CUR_MAJR1) AS VARCHAR(10)) AS Actual_Headcount,
        p.PRGM_CODE,
        p.MAJR_CODE,
        p.MAJR_DESC,
        p.DEPT_CODE
    FROM STUDENTS03 st
        LEFT JOIN STVTERM t on t.STVTERM_CODE = st.BANNER_TERM
        LEFT JOIN CW_PROGRAMS p on p.PRGM_CODE = st.CUR_PRGM1
    WHERE
        DSC_TERM_CODE = '201943'
        AND p.ACYR_CODE = '1920'
    GROUP BY p.PRGM_CODE, p.MAJR_CODE, p.MAJR_DESC, p.DEPT_CODE
),

--Average headcount by major for Fall 2016, 2017, & 2018 (calculate)
CTE_Major_AVG AS (
    SELECT
        CAST(ROUND(COUNT(st.CUR_MAJR1) / 3,2) AS VARCHAR(10)) AVG_Headcount_By_Major,
        p.PRGM_CODE,
        p.MAJR_CODE,
        p.MAJR_DESC,
        p.DEPT_CODE
    FROM STUDENTS03 st
    LEFT JOIN CW_PROGRAMS p on p.PRGM_CODE = st.CUR_PRGM1
    WHERE
        DSC_TERM_CODE IN ('201943','201843','201743')
        AND p.ACYR_CODE = '1920'
    GROUP BY p.PRGM_CODE, p.MAJR_CODE, p.MAJR_DESC, p.DEPT_CODE
    HAVING COUNT(DISTINCT st.DSC_TERM_CODE) = 3
),

--Actual number of degrees conferred this academic year for 2019-2020
CTE_Degrees_Conferred AS (
    SELECT
        CAST(COUNT(DXGRAD_DEGC_CODE) AS VARCHAR(10)) AS Degrees_AWRD_2019_20,
        p.PRGM_CODE,
        p.MAJR_CODE,
        p.MAJR_DESC,
        p.DEPT_CODE
    FROM DXGRAD_ALL g
    LEFT JOIN CW_PROGRAMS p on p.PRGM_CODE = g.DXGRAD_DGMR_PRGM
    WHERE
          DXGRAD_ACYR = '1920'
          AND p.ACYR_CODE = '1920'
    GROUP BY p.PRGM_CODE, p.MAJR_CODE, p.MAJR_DESC, p.DEPT_CODE
),

--Average number of degrees conferred for previous 3 years (calculate)
CTE_Degrees_Conferred_AVG AS (
    SELECT
        CAST(ROUND(COUNT(DXGRAD_DEGC_CODE) / 3,2) AS VARCHAR(10)) AS Avg_Degrees_Prev_3_Yrs,
        p.PRGM_CODE,
        p.MAJR_CODE,
        p.MAJR_DESC,
        p.DEPT_CODE
    FROM DXGRAD_ALL g
    LEFT JOIN CW_PROGRAMS p on p.PRGM_CODE = g.DXGRAD_DGMR_PRGM
    LEFT JOIN STVDEPT d on d.STVDEPT_CODE = p.DEPT_CODE
    WHERE
        DXGRAD_ACYR IN ('1920','1819','1718')
        AND p.ACYR_CODE = '1920'
    GROUP BY p.PRGM_CODE, p.MAJR_CODE, p.MAJR_DESC, p.DEPT_CODE
    HAVING COUNT(DISTINCT DXGRAD_ACYR) = 3
),

-- Change from previous year 2018-19 (calculate)
CTE_DEGREE_1819 AS (
    SELECT
        CAST(COUNT(DXGRAD_DEGC_CODE) AS VARCHAR(10)) AS Degrees_Conferred_1819,
        p.PRGM_CODE,
        p.MAJR_CODE,
        p.DEPT_CODE
    FROM DXGRAD_ALL g
    LEFT JOIN CW_PROGRAMS p on p.PRGM_CODE = g.DXGRAD_DGMR_PRGM
    LEFT JOIN STVDEPT d on d.STVDEPT_CODE = p.DEPT_CODE
    WHERE
        DXGRAD_ACYR = '1819'
        AND p.ACYR_CODE = '1920'
    GROUP BY p.PRGM_CODE, p.MAJR_CODE, p.DEPT_CODE
),

CTE_Degrees_Conferred_Changed AS (
    SELECT
        COUNT(DXGRAD_DEGC_CODE) AS Degree_Count_1920,
        Degrees_Conferred_1819,
        CAST(COUNT(DXGRAD_DEGC_CODE) - Degrees_Conferred_1819 AS CHAR(10)) AS Change_Prev_Yr,
        p.PRGM_CODE,
        p.MAJR_CODE,
        p.MAJR_DESC,
        p.DEPT_CODE
    FROM DXGRAD_ALL g
    LEFT JOIN CW_PROGRAMS p on p.PRGM_CODE = g.DXGRAD_DGMR_PRGM
    LEFT JOIN CTE_DEGREE_1819 d2 on d2.PRGM_CODE = p.PRGM_CODE and d2.DEPT_CODE = p.DEPT_CODE AND d2.MAJR_CODE = p.MAJR_CODE
    WHERE
        DXGRAD_ACYR = '1920'
        AND p.ACYR_CODE = '1920'
    GROUP BY p.PRGM_CODE, p.MAJR_CODE, p.MAJR_DESC, p.DEPT_CODE, Degrees_Conferred_1819
),
--Union All Programs, Majors, Department Codes, and Descriptions
CTE_programs AS (
    SELECT PRGM_CODE, MAJR_CODE, MAJR_DESC, DEPT_CODE
    FROM CTE_Major_Headcount
    UNION
    SELECT PRGM_CODE, MAJR_CODE, MAJR_DESC, DEPT_CODE
    FROM CTE_Major_AVG
    UNION
    SELECT PRGM_CODE, MAJR_CODE, MAJR_DESC, DEPT_CODE
    FROM CTE_Degrees_Conferred
    UNION
    SELECT PRGM_CODE, MAJR_CODE, MAJR_DESC, DEPT_CODE
    FROM CTE_Degrees_Conferred_AVG
    UNION
    SELECT PRGM_CODE, MAJR_CODE, MAJR_DESC, DEPT_CODE
    FROM CTE_Degrees_Conferred_Changed
    )

--Final Query Normalized
SELECT
    NVL(m.Actual_Headcount, 'N/A') AS "Actual headcount",
    NVL(ma.AVG_Headcount_By_Major, 'N/A') AS "AVG Headcount By Major",
    NVL(dc.Degrees_AWRD_2019_20, 'N/A') AS "Degrees Awd 2019-20",
    NVL(dca.Avg_Degrees_Prev_3_Yrs, 'N/A') AS "Avg Degrees Prev 3 yrs",
    NVL(dcc.Change_Prev_Yr, 'N/A') AS "Change from Prev yr",
    p.PRGM_CODE AS "Program",
    p.MAJR_CODE AS "Major Code",
    p.MAJR_DESC AS "Major Desc",
    p.DEPT_CODE AS "Department Code",
    d.STVDEPT_DESC AS "Department Desc"
FROM CTE_programs p
LEFT JOIN STVDEPT d on d.STVDEPT_CODE = p.DEPT_CODE
LEFT JOIN CTE_Major_Headcount m on m.PRGM_CODE = p.PRGM_CODE
    AND m.DEPT_CODE = p.DEPT_CODE
    AND m.MAJR_CODE = p.MAJR_CODE
LEFT JOIN CTE_Major_AVG ma on ma.PRGM_CODE = p.PRGM_CODE
    AND ma.DEPT_CODE = p.DEPT_CODE
    AND ma.MAJR_CODE = p.MAJR_CODE
LEFT JOIN CTE_Degrees_Conferred dc on dc.PRGM_CODE = p.PRGM_CODE
    AND dc.DEPT_CODE = p.DEPT_CODE
    AND dc.MAJR_CODE = p.MAJR_CODE
LEFT JOIN CTE_Degrees_Conferred_AVG dca on dca.PRGM_CODE = p.PRGM_CODE
    AND dca.DEPT_CODE = p.DEPT_CODE
    AND dca.MAJR_CODE = p.MAJR_CODE
LEFT JOIN CTE_Degrees_Conferred_Changed dcc on dcc.PRGM_CODE = p.PRGM_CODE
    AND dcc.DEPT_CODE = p.DEPT_CODE
    AND dcc.MAJR_CODE = p.MAJR_CODE
ORDER BY p.DEPT_CODE, p.MAJR_CODE, p.PRGM_CODE;

/******************************************************************
  Page 9 of Annual Review
  Department & Program:
******************************************************************/

-- Page 9 of Annual Review
--Faculty Count for Dept Review
WITH CTE_Perappt_max AS (
    SELECT perappt_pidm,
           max(perappt_appt_eff_date) AS perappt_appt_eff_date
    FROM perappt
    GROUP BY perappt_pidm
),
CTE_employee AS (
    SELECT DISTINCT
        CASE
        WHEN e.PEBEMPL_ECLS_CODE IN ('F2', 'F9') AND d2.PERAPPT_TENURE_CODE = 'T'
            THEN 'Full-Time Tenured'
        WHEN e.PEBEMPL_ECLS_CODE IN ('F2', 'F9') AND d2.PERAPPT_TENURE_CODE = 'O'
            THEN 'Full-Time Non-Tenured'
            ELSE 'Part Time'
        END AS Fac_Status,
        a.C_INSTR_ID,
        e.PEBEMPL_ECLS_CODE,
        d2.PERAPPT_TENURE_CODE,
        CAST(SUBSTR(a.DSC_TERM_CODE, 3, 2) || SUBSTR(a.DSC_TERM_CODE, 3, 2) + 1 AS VARCHAR2(4)) AS academic_year,
        b.DEPT_CODE AS department_code,
        d.STVDEPT_DESC AS department_desc
    FROM COURSES@DSCIR a
    LEFT JOIN CW_SUBJECT b ON a.C_CRS_SUBJECT = b.SUBJ_CODE
    LEFT JOIN SPRIDEN c ON c.SPRIDEN_ID = a.C_INSTR_ID
        AND c.SPRIDEN_CHANGE_IND IS NULL
    LEFT JOIN CTE_PERAPPT_MAX d1 on d1.PERAPPT_PIDM = c.SPRIDEN_PIDM
    LEFT JOIN PERAPPT d2 ON d2.PERAPPT_PIDM = d1.PERAPPT_PIDM
        AND d2.PERAPPT_APPT_EFF_DATE = d1.PERAPPT_APPT_EFF_DATE
    LEFT JOIN PEBEMPL e ON c.SPRIDEN_PIDM = e.PEBEMPL_PIDM
    LEFT JOIN STVDEPT d on d.STVDEPT_CODE = b.DEPT_CODE
    WHERE a.DSC_TERM_CODE IN ('201943', '201843', '201743', '201643', '201543')
),
CTE_faculty AS (
    SELECT
        SUM(CASE WHEN Fac_Status = 'Full-Time Tenured' THEN 1 END) AS "Full-Time Tenured",
        SUM(CASE WHEN Fac_Status = 'Full-Time Non-Tenured' THEN 1 END) AS "Full-Time Non-Tenured",
        SUM(CASE WHEN Fac_Status = 'Part Time' THEN 1 END) AS "Part Time",
        academic_year,
        department_code,
        department_desc
    FROM cte_employee
    GROUP BY academic_year, department_code, department_desc
),

-- # of Graduates
CTE_graduates AS (
    SELECT
        COUNT(CASE WHEN DXGRAD_DEGC_CODE LIKE 'C%' THEN 1 END) AS "Certificates",
        COUNT(CASE WHEN DXGRAD_DEGC_CODE LIKE 'A%' THEN 1 END) AS "Associates",
        COUNT(CASE WHEN DXGRAD_DEGC_CODE LIKE 'B%' THEN 1 END) AS "Bachelors",
        COUNT(CASE WHEN DXGRAD_DEGC_CODE LIKE 'M%' THEN 1 END) AS "Masters",
        DXGRAD_ACYR AS academic_year,
        p.DEPT_CODE AS department_code,
        d.STVDEPT_DESC as department_desc
    FROM DXGRAD_ALL g
    LEFT JOIN CW_PROGRAMS p on p.PRGM_CODE = g.DXGRAD_DGMR_PRGM
    LEFT JOIN STVDEPT d on d.STVDEPT_CODE = p.DEPT_CODE
    WHERE DXGRAD_ACYR >= '1516'
    AND p.ACYR_CODE = '1920'
    GROUP BY DXGRAD_ACYR, p.DEPT_CODE, d.STVDEPT_DESC
),
-- # of Declared Majors in Department
CTE_declared_majors AS (
    SELECT
        d.STVDEPT_DESC AS department_desc,
        p.DEPT_CODE AS department_code,
        CAST(SUBSTR(DSC_TERM_CODE,3,2) || SUBSTR(DSC_TERM_CODE,3,2) + 1 AS VARCHAR2(4)) AS academic_year,
        COUNT(st.CUR_MAJR1) AS declared_majors
    FROM STUDENTS03 st
    LEFT JOIN CW_PROGRAMS p on p.PRGM_CODE = st.CUR_PRGM1
    LEFT JOIN STVDEPT d on d.STVDEPT_CODE = p.DEPT_CODE
    WHERE dsc_term_code IN ('201943', '201843', '201743', '201643', '201543')
    GROUP BY STVDEPT_DESC, DEPT_CODE, st.DSC_TERM_CODE
),

-- Department FTE
-- Calculates UG FTE by Department
CTE_ug_fte AS (
    SELECT round(sum(SC_ATT_CR) / 150 + sum(nvl(SC_CONTACT_HRS, 0)) / 450, 2) AS UG_FTE,
        e.DEPT_CODE,
        sc.DSC_TERM_CODE
    FROM bailey.student_courses@dscir sc
    LEFT JOIN bailey.courses@dscir c on sc.DSC_CRN = c.DC_CRN
        AND sc.DSC_TERM_CODE = c.DSC_TERM_CODE
    LEFT JOIN CW_SUBJECT e on e.SUBJ_CODE = sc.SC_CRS_SBJ
    WHERE sc.DSC_TERM_CODE IN ('201943', '201843', '201743', '201643', '201543')
        AND c.C_LEVEL != 'G'
    GROUP BY e.DEPT_CODE, sc.DSC_TERM_CODE
),

-- Calculates GRAD FTE by Department
CTE_g_fte AS (
    SELECT nvl(round(sum(SC_ATT_CR) / 100 + sum(nvl(SC_CONTACT_HRS, 0)) / 450, 2), 0) AS G_FTE,
        e.DEPT_CODE,
        sc.DSC_TERM_CODE
    FROM BAILEY.STUDENT_COURSES@DSCIR sc
    LEFT JOIN BAILEY.COURSES@DSCIR c on sc.DSC_CRN = c.DC_CRN
        AND sc.DSC_TERM_CODE = c.DSC_TERM_CODE
    LEFT JOIN CW_SUBJECT e on e.SUBJ_CODE = sc.SC_CRS_SBJ
    WHERE sc.DSC_TERM_CODE = c.DSC_TERM_CODE
    AND sc.DSC_TERM_CODE IN ('201943', '201843', '201743', '201643', '201543')
    AND C_LEVEL = 'G'
    GROUP BY e.DEPT_CODE, sc.DSC_TERM_CODE
 ),

--Combines UG and GRAD FTE by Department
CTE_department_fte AS (
    SELECT
        e.DEPT_CODE AS department_code,
        e.DEPT_DESC AS department_desc,
        CAST(SUBSTR(sc.DSC_TERM_CODE,3,2) || SUBSTR(sc.DSC_TERM_CODE,3,2) + 1 AS VARCHAR2(4)) AS academic_year,
        COALESCE(g.G_FTE + ug.UG_FTE, ug.UG_FTE) AS FTE
    FROM BAILEY.STUDENT_COURSES@DSCIR sc
    LEFT JOIN BAILEY.COURSES@DSCIR c ON SC.DSC_CRN = C.DC_CRN
        AND SC.DSC_TERM_CODE = C.DSC_TERM_CODE
    LEFT JOIN CW_SUBJECT e ON e.SUBJ_CODE = sc.SC_CRS_SBJ
    LEFT JOIN CTE_UG_FTE ug ON ug.dsc_term_code = sc.dsc_term_code
        AND ug.DEPT_CODE = e.DEPT_CODE
    LEFT JOIN CTE_G_FTE g ON g.dsc_term_code = sc.dsc_term_code
        AND g.DEPT_CODE =  e.DEPT_CODE
    WHERE sc.DSC_TERM_CODE IN ('201943', '201843', '201743', '201643', '201543')
    GROUP BY e.DEPT_CODE, e.DEPT_DESC, sc.DSC_TERM_CODE, ug.UG_FTE, g.G_FTE
),

-- Total Department SCH
-- SCH = Enrollment (class Size) * credit Hours
CTE_department_sch AS (
    SELECT a.department_code,
           a.department_desc,
           a.academic_year,
           SUM(sch) AS sch
      FROM (SELECT  b.dept_code AS department_code,
                    b.dept_desc AS department_desc,
                    CAST(SUBSTR(a1.dsc_term_code, 3, 2) || SUBSTR(a1.dsc_term_code, 3, 2) + 1 AS VARCHAR2(4)) AS academic_year,
                    SUM(DISTINCT (a1.c_min_credit / 10) * a1.c_class_size) AS sch
              FROM  bailey.courses@dscir a1
          LEFT JOIN cw_subject b
                 ON b.subj_code = a1.c_crs_subject
              WHERE a1.dsc_term_code IN ('201943', '201843', '201743', '201643', '201543')
           GROUP BY b.dept_code,
                    b.dept_desc,
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
CTE_acyr_dept AS (
SELECT academic_year, department_code, department_desc
FROM CTE_faculty
UNION
SELECT academic_year, department_code, department_desc
FROM CTE_declared_majors
UNION
SELECT academic_year, department_code, department_desc
FROM CTE_graduates
UNION
SELECT academic_year, department_code, department_desc
FROM CTE_department_fte
UNION
SELECT academic_year, department_code, department_desc
FROM CTE_department_sch
)

--Final Query Normalized
SELECT
    f."Full-Time Tenured",
    f."Full-Time Non-Tenured",
    f."Part Time",
    '' as "total faculty FTE", --calculated column
    g."Certificates",
    g."Associates",
    g."Bachelors",
    g."Masters",
    dm.declared_majors AS "Declared majors",
    fte.FTE as "department FTE",
    sch.SCH as "department SCH",
    '' as "Student FTE per total faculty FTE", --calculated column
    a.academic_year,
    a.department_code,
    a.department_desc
FROM CTE_acyr_dept a
LEFT JOIN CTE_FACULTY f on f.department_code = a.department_code
    AND f.academic_year = a.academic_year
LEFT JOIN CTE_Graduates g on g.department_code = a.department_code
    AND g.academic_year = a.academic_year
LEFT JOIN CTE_Declared_Majors dm on dm.department_code = a.department_code
    AND dm.academic_year = a.academic_year
LEFT JOIN CTE_Department_FTE fte on fte.department_code = a.department_code
    AND fte.academic_year = a.academic_year
LEFT JOIN CTE_Department_SCH sch on sch.department_code = a.department_code
    AND sch.academic_year = a.academic_year
ORDER BY a.department_code, a.academic_year;
