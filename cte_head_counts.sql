/*
 Major / Program Counts
 */
SELECT DISTINCT
       s_curr_cip,
       cur_prgm1,
       cur_degc1,
       cur_majr1,
       conc1
  FROM students03 a
 WHERE dsc_term_code IN ('20193E', '20194E', '20202E')
   --AND cur_majr1 = 'VTEC'
   AND s_curr_cip = '521401'
   --    AND s_curr_cip in ('510810',
   -- '520201',
   -- '430116',
   -- '131210',
   -- '521401',
   -- '510810',
   -- '520201',
   -- '521401',
   -- '520201',
   -- '470000',
   -- '141901',
   -- '510911',
   -- '513902',
   -- '513902',
   -- '520299',
   -- '510810',
   -- '511009',
   -- '510806',
   -- '140102',
   -- '510908',
   -- '520201',
   -- '090402',
   -- '510909',
   -- '110801'
   -- )
 ORDER BY 1;

/*
 Course Counts
 */

SELECT
       COUNT(DISTINCT dsc_pidm) AS student_count,
       '2019-20' AS academic_year
  FROM student_courses
 WHERE dsc_term_code IN ('20193E', '20194E', '20202E')
   AND (sc_crs_sbj = 'ACCT' AND sc_crs_num IN ('1010', '2010', '2020')
           OR sc_crs_sbj = 'BUS' AND sc_crs_num IN ('1010', '1020', '1030', '1050', '1370', '2000')
           OR sc_crs_sbj = 'CIS' AND sc_crs_num IN ('1140', '1150', '1200', '2010', '2400', '2450')
           OR sc_crs_sbj = 'CJ' AND sc_crs_num IN ('1001', '1010', '1070', '1080', '1090', '1300', '1330', '1340', '1390', '1900', '2020', '2330', '2350', '2360', '2500', '2700', '2990', '2991', '3900', '3950', '4700', '4750')
           OR sc_crs_sbj = 'COMP' AND sc_crs_num IN  ('1435', '1700')
           OR sc_crs_sbj = 'COOP' AND sc_crs_num IN  ('1800R')
           OR sc_crs_sbj = 'CS' AND sc_crs_num IN  ('1400', '1410')
           OR sc_crs_sbj = 'DES' AND sc_crs_num IN  ('1300', '2100','2300', '2500','2600','2710')
           OR sc_crs_sbj = 'EDUC' AND sc_crs_num IN  ('1010', '2010', '2400')
           OR sc_crs_sbj = 'EMS' AND sc_crs_num IN  ('1110', '1120','1140','1145','1200','2200','2300','2400','2500','2600')
           OR sc_crs_sbj = 'ENGR' AND sc_crs_num IN  ('1050','2010','2030')
           OR sc_crs_sbj = 'FSHD' AND sc_crs_num IN  ('1020', '1500','2120','2180','2400','2500','2600','2610','2620','2630','2880')
           OR sc_crs_sbj = 'FIN' AND sc_crs_num IN  ('1750')
           OR sc_crs_sbj = 'HLOC' AND sc_crs_num IN  ('1000', '1010', '1050','1060', '2990')
           OR sc_crs_sbj = 'MAN' AND sc_crs_num IN  ('1010','1020', '2010','2020')
           OR sc_crs_sbj = 'MECH' AND sc_crs_num IN  ('1000','1005','1100','1150','1200','1205','2010','2160', '2030','2210','2215','2250','2255')
           OR sc_crs_sbj = 'MDIA' AND sc_crs_num IN  ('1130','1380','1385','1500','2010','2300','2370R','2460')
           OR sc_crs_sbj = 'MGMT' AND sc_crs_num IN  ('1650','2600','2620','2640','2990R','3400')
           OR sc_crs_sbj = 'MKTG' AND sc_crs_num IN  ('1510','1530R','1540R','2520','2540','2550', '3010','3500')
           OR sc_crs_sbj = 'NURS' AND sc_crs_num IN  ('1005','1007','2000,','2001','2005','2400','2401','2450','2500','2501','2530','2600','2700','2701','2750')
           OR sc_crs_sbj = 'OPER' AND sc_crs_num IN  ('1010','1020','2010','2020','2070','2080')
           OR sc_crs_sbj = 'PEHR' AND sc_crs_num = '1543'
           OR sc_crs_sbj = 'PHLB' AND sc_crs_num = '1000'
           OR sc_crs_sbj = 'PTA' AND sc_crs_num IN  ('1010','2000','2010','2011','2110','2111','2200','2201','2210','2211','2300','2301','2400','2410','2411','2520','2521','2530','2605','2705','2805')
           OR sc_crs_sbj = 'RADT' AND sc_crs_num IN  ('1010','1020','1030','1040','1050','1120','1140','1230','1240','1250','2030','2040','3020','3150','3240','3260')
           OR sc_crs_sbj = 'RESP' AND sc_crs_num IN  ('1010','2020','2030','2040','2041','2050','2060','2065','2070','2071','2100','2200','2300','2301','2310','2400','3005','3020','3021','3100','3150')
           OR sc_crs_sbj = 'SURG' AND sc_crs_num IN  ('1000','1021','1050','1055','1060','2010','2050','2055','2060','2070')
           OR sc_crs_sbj = 'WEB' AND sc_crs_num IN  ('1400','3000','3100')
      )
 ORDER BY 1, 2;

SELECT *
  FROM stvmajr@proddb
 WHERE stvmajr_desc LIKE 'Soc%'
 ORDER BY 2;

SELECT DISTINCT
       majr_code,
       a.*
  FROM dsc_programs_all a
 WHERE cipc_code = '110801'
   AND acyr_code = '1920';