with cte_hsce_2019 as (
    -- USHE YEAR 2020
    select distinct

           'Fall 2019' as term_desc,
           spriden_pidm as pidm,
           spriden_id as banner_id,
           spriden_last_name as last_name,
           spriden_first_name as first_name,
           'Transfer' as credit_type,
           shrtrce_credit_hours as att_cr,
           cw_dsu_bucket as ge_bucket,
           shrtrce_subj_code as subject,
           shrtrce_crse_numb as course_nbr,
           case
               when shrtrce_subj_code = 'EL' then 'EL ' || to_char(lpad(shrtrce_crse_numb, 4, '0')) || ' - Various'
               else shrtrce_crse_title
           end as course_title,
           replace(shrtrce_grde_code, 'T') as grade,
           case
               when shrtrce_grde_code not like '%D%' and shrtrce_grde_code not like '%F%' and
                    shrtrce_grde_code not like '%W%' and shrtrce_grde_code not like '%C-' then 1
               else 0
           end as passed_count,
           case
               when shrtrce_grde_code not like '%D%' and shrtrce_grde_code not like '%F%' and
                    shrtrce_grde_code not like '%W%' and shrtrce_grde_code not like '%C-' then shrtrce_credit_hours
               else 0
           end as earn_cr
    from spriden
         left join sorhsch on sorhsch.rowid = dsc.f_get_sorhsch_rowid(spriden_pidm),
         stvterm,
         spbpers,
         students_201943,
         shrtrce
         left join cw_ge_buckets_all on shrtrce_subj_code = cw_subj_code and shrtrce_crse_numb = cw_crse_numb
    where shrtrce_pidm = pidm
      and spbpers_pidm = spriden_pidm
      and spriden_pidm = shrtrce_pidm
      and stvterm_code = shrtrce_term_code_eff
      and shrtrce_term_code_eff <= '201940'
      and shrtrce_crse_numb != '0000'
      and spriden_change_ind is null
      and s_entry_action like 'F%'
      and (sorhsch_graduation_date > stvterm_start_date or shrtrce_grde_code = 'P' or
           (sorhsch_graduation_date is null and
            f_calculate_age(stvterm_start_date, spbpers_birth_date, spbpers_dead_date) < 18))

    union

    select distinct
           'Fall 2019' as term_desc,
           spriden_pidm as pidm,
           spriden_id as banner_id,
           spriden_last_name as last_name,
           spriden_first_name as first_name,
           'DSU HSCE' as credit_type,
           nvl(scbcrse_credit_hr_low, scbcrse_credit_hr_high) as att_cr,
           cw_dsu_bucket as ge_bucket,
           scbcrse_subj_code as subject,
           scbcrse_crse_numb as course_nbr,
           case
               when scbcrse_subj_code = 'EL' then 'EL ' || to_char(lpad(scbcrse_crse_numb, 4, '0')) || ' - Various'
               else scbcrse_title
           end as course_title,
           swvgrde_final_grade,
           case
               when swvgrde_final_grade not like '%D%' and swvgrde_final_grade not like '%F%' and
                    swvgrde_final_grade not like '%W%' and swvgrde_final_grade not like '%C-' then 1
               else 0
           end as grade,
           case
               when swvgrde_final_grade not like '%D%' and swvgrde_final_grade not like '%F%' and
                    swvgrde_final_grade not like '%W%' and swvgrde_final_grade not like '%C-' then swvgrde_earned_hours
               else 0
           end as earn_cr
    from sfrstcr,
         dsc.dsc_swvgrde,
         spriden,
         scbcrse c1,
         ssbsect
         left join cw_ge_buckets_all on ssbsect_subj_code = cw_subj_code and ssbsect_crse_numb = cw_crse_numb
    where sfrstcr_crn = ssbsect_crn
      and swvgrde_crn = ssbsect_crn
      and spriden_pidm = sfrstcr_pidm
      and swvgrde_pidm = sfrstcr_pidm
      and sfrstcr_term_code = ssbsect_term_code
      and swvgrde_term_code = sfrstcr_term_code
      and ssbsect_subj_code = scbcrse_subj_code
      and ssbsect_crse_numb = scbcrse_crse_numb
      and ssbsect_term_code <= '201940'
      and ssbsect_subj_code != 'CED'
      and f_calc_entry_action(sfrstcr_pidm, sfrstcr_term_code) = 'HS' --IN ('FF','FH')
      and sfrstcr_rsts_code in (select stvrsts_code from stvrsts where stvrsts_incl_sect_enrl = 'Y')
      and spriden_change_ind is null
      and scbcrse_eff_term = (select MAX(c2.scbcrse_eff_term)
                              from scbcrse c2
                              where c2.scbcrse_subj_code = ssbsect_subj_code
                                and c2.scbcrse_crse_numb = ssbsect_crse_numb
                                and c2.scbcrse_eff_term <= ssbsect_term_code)
      and EXISTS(select 'Y'
                 from bailey.students03@dscir
                 where dsc_pidm = sfrstcr_pidm
                   and dsc_term_code = '201943'
                   and s_entry_action like 'F%')),

     cte_hsce_2018 as (
         --USHE YEAR 2019
         select distinct
                'Fall 2019' as term_desc,
                spriden_pidm as pidm,
                spriden_id as banner_id,
                spriden_last_name as last_name,
                spriden_first_name as first_name,
                'Transfer' as credit_type,
                shrtrce_credit_hours as att_cr,
                cw_dsu_bucket as ge_bucket,
                shrtrce_subj_code as subject,
                shrtrce_crse_numb as course_nbr,
                case
                    when shrtrce_subj_code = 'EL' then 'EL ' || to_char(lpad(shrtrce_crse_numb, 4, '0')) || ' - Various'
                    else shrtrce_crse_title
                end as course_title,
                replace(shrtrce_grde_code, 'T') as grade,
                case
                    when shrtrce_grde_code not like '%D%' and shrtrce_grde_code not like '%F%' and
                         shrtrce_grde_code not like '%W%' and shrtrce_grde_code not like '%C-' then 1
                    else 0
                end as passed_count,
                case
                    when shrtrce_grde_code not like '%D%' and shrtrce_grde_code not like '%F%' and
                         shrtrce_grde_code not like '%W%' and shrtrce_grde_code not like '%C-' then shrtrce_credit_hours
                    else 0
                end as earn_cr
         from spriden
              left join sorhsch on sorhsch.rowid = dsc.f_get_sorhsch_rowid(spriden_pidm),
              stvterm,
              spbpers,
              students_201843,
              shrtrce
              left join cw_ge_buckets_all on shrtrce_subj_code = cw_subj_code and shrtrce_crse_numb = cw_crse_numb
         where shrtrce_pidm = pidm
           and spbpers_pidm = spriden_pidm
           and spriden_pidm = shrtrce_pidm
           and stvterm_code = shrtrce_term_code_eff
           and shrtrce_term_code_eff <= '201840'
           and shrtrce_crse_numb != '0000'
           and spriden_change_ind is null
           and s_entry_action like 'F%'
           and (sorhsch_graduation_date > stvterm_start_date or shrtrce_grde_code = 'P' or
                (sorhsch_graduation_date is null and
                 f_calculate_age(stvterm_start_date, spbpers_birth_date, spbpers_dead_date) < 18))

         union

         select distinct
                'Fall 2019' as term_desc,
                spriden_pidm as pidm,
                spriden_id as banner_id,
                spriden_last_name as last_name,
                spriden_first_name as first_name,
                'DSU HSCE' as credit_type,
                nvl(scbcrse_credit_hr_low, scbcrse_credit_hr_high) as att_cr,
                cw_dsu_bucket as ge_bucket,
                scbcrse_subj_code as subject,
                scbcrse_crse_numb as course_nbr,
                case
                    when scbcrse_subj_code = 'EL' then 'EL ' || to_char(lpad(scbcrse_crse_numb, 4, '0')) || ' - Various'
                    else scbcrse_title
                end as course_title,
                swvgrde_final_grade,
                case
                    when swvgrde_final_grade not like '%D%' and swvgrde_final_grade not like '%F%' and
                         swvgrde_final_grade not like '%W%' and swvgrde_final_grade not like '%C-' then 1
                    else 0
                end as grade,
                case
                    when swvgrde_final_grade not like '%D%' and swvgrde_final_grade not like '%F%' and
                         swvgrde_final_grade not like '%W%' and swvgrde_final_grade not like '%C-'
                        then swvgrde_earned_hours
                    else 0
                end as earn_cr
         from sfrstcr,
              dsc.dsc_swvgrde,
              spriden,
              scbcrse c1,
              ssbsect
              left join cw_ge_buckets_all on ssbsect_subj_code = cw_subj_code and ssbsect_crse_numb = cw_crse_numb
         where sfrstcr_crn = ssbsect_crn
           and swvgrde_crn = ssbsect_crn
           and spriden_pidm = sfrstcr_pidm
           and swvgrde_pidm = sfrstcr_pidm
           and sfrstcr_term_code = ssbsect_term_code
           and swvgrde_term_code = sfrstcr_term_code
           and ssbsect_subj_code = scbcrse_subj_code
           and ssbsect_crse_numb = scbcrse_crse_numb
           and ssbsect_term_code <= '201840'
           and ssbsect_subj_code != 'CED'
           and f_calc_entry_action(sfrstcr_pidm, sfrstcr_term_code) = 'HS' --IN ('FF','FH')
           and sfrstcr_rsts_code in (select stvrsts_code from stvrsts where stvrsts_incl_sect_enrl = 'Y')
           and spriden_change_ind is null
           and scbcrse_eff_term = (select MAX(c2.scbcrse_eff_term)
                                   from scbcrse c2
                                   where c2.scbcrse_subj_code = ssbsect_subj_code
                                     and c2.scbcrse_crse_numb = ssbsect_crse_numb
                                     and c2.scbcrse_eff_term <= ssbsect_term_code)
           and EXISTS(select 'Y'
                      from bailey.students03@dscir
                      where dsc_pidm = sfrstcr_pidm
                        and dsc_term_code = '201843'
                        and s_entry_action like 'F%')),

     cte_hsce_2017 as (
         --USHE YEAR 2018
         select distinct
                'Fall 2019' as term_desc,
                spriden_pidm as pidm,
                spriden_id as banner_id,
                spriden_last_name as last_name,
                spriden_first_name as first_name,
                'Transfer' as credit_type,
                shrtrce_credit_hours as att_cr,
                cw_dsu_bucket as ge_bucket,
                shrtrce_subj_code as subject,
                shrtrce_crse_numb as course_nbr,
                case
                    when shrtrce_subj_code = 'EL' then 'EL ' || to_char(lpad(shrtrce_crse_numb, 4, '0')) || ' - Various'
                    else shrtrce_crse_title
                end as course_title,
                replace(shrtrce_grde_code, 'T') as grade,
                case
                    when shrtrce_grde_code not like '%D%' and shrtrce_grde_code not like '%F%' and
                         shrtrce_grde_code not like '%W%' and shrtrce_grde_code not like '%C-' then 1
                    else 0
                end as passed_count,
                case
                    when shrtrce_grde_code not like '%D%' and shrtrce_grde_code not like '%F%' and
                         shrtrce_grde_code not like '%W%' and shrtrce_grde_code not like '%C-' then shrtrce_credit_hours
                    else 0
                end as earn_cr
         from spriden
              left join sorhsch on sorhsch.rowid = dsc.f_get_sorhsch_rowid(spriden_pidm),
              stvterm,
              spbpers,
              students_201743,
              shrtrce
              left join cw_ge_buckets_all on shrtrce_subj_code = cw_subj_code and shrtrce_crse_numb = cw_crse_numb
         where shrtrce_pidm = pidm
           and spbpers_pidm = spriden_pidm
           and spriden_pidm = shrtrce_pidm
           and stvterm_code = shrtrce_term_code_eff
           and shrtrce_term_code_eff <= '201740'
           and shrtrce_crse_numb != '0000'
           and spriden_change_ind is null
           and s_entry_action like 'F%'
           and (sorhsch_graduation_date > stvterm_start_date or shrtrce_grde_code = 'P' or
                (sorhsch_graduation_date is null and
                 f_calculate_age(stvterm_start_date, spbpers_birth_date, spbpers_dead_date) < 18))

         union

         select distinct
                'Fall 2019' as term_desc,
                spriden_pidm as pidm,
                spriden_id as banner_id,
                spriden_last_name as last_name,
                spriden_first_name as first_name,
                'DSU HSCE' as credit_type,
                nvl(scbcrse_credit_hr_low, scbcrse_credit_hr_high) as att_cr,
                cw_dsu_bucket as ge_bucket,
                scbcrse_subj_code as subject,
                scbcrse_crse_numb as course_nbr,
                case
                    when scbcrse_subj_code = 'EL' then 'EL ' || to_char(lpad(scbcrse_crse_numb, 4, '0')) || ' - Various'
                    else scbcrse_title
                end as course_title,
                swvgrde_final_grade,
                case
                    when swvgrde_final_grade not like '%D%' and swvgrde_final_grade not like '%F%' and
                         swvgrde_final_grade not like '%W%' and swvgrde_final_grade not like '%C-' then 1
                    else 0
                end as grade,
                case
                    when swvgrde_final_grade not like '%D%' and swvgrde_final_grade not like '%F%' and
                         swvgrde_final_grade not like '%W%' and swvgrde_final_grade not like '%C-'
                        then swvgrde_earned_hours
                    else 0
                end as earn_cr
         from sfrstcr,
              dsc.dsc_swvgrde,
              spriden,
              scbcrse c1,
              ssbsect
              left join cw_ge_buckets_all on ssbsect_subj_code = cw_subj_code and ssbsect_crse_numb = cw_crse_numb
         where sfrstcr_crn = ssbsect_crn
           and swvgrde_crn = ssbsect_crn
           and spriden_pidm = sfrstcr_pidm
           and swvgrde_pidm = sfrstcr_pidm
           and sfrstcr_term_code = ssbsect_term_code
           and swvgrde_term_code = sfrstcr_term_code
           and ssbsect_subj_code = scbcrse_subj_code
           and ssbsect_crse_numb = scbcrse_crse_numb
           and ssbsect_term_code <= '201740'
           and ssbsect_subj_code != 'CED'
           and f_calc_entry_action(sfrstcr_pidm, sfrstcr_term_code) = 'HS' --IN ('FF','FH')
           and sfrstcr_rsts_code in (select stvrsts_code from stvrsts where stvrsts_incl_sect_enrl = 'Y')
           and spriden_change_ind is null
           and scbcrse_eff_term = (select MAX(c2.scbcrse_eff_term)
                                   from scbcrse c2
                                   where c2.scbcrse_subj_code = ssbsect_subj_code
                                     and c2.scbcrse_crse_numb = ssbsect_crse_numb
                                     and c2.scbcrse_eff_term <= ssbsect_term_code)
           and EXISTS(select 'Y'
                      from bailey.students03@dscir
                      where dsc_pidm = sfrstcr_pidm
                        and dsc_term_code = '201743'
                        and s_entry_action like 'F%'))
--Main Query
select dsc_pidm,
       d.s_year - 1 as year,
       h1.pidm as earned_hsce_2019,
       h2.pidm as earned_hsce_2018,
       h3.pidm as earned_hsce_2017,
       case when COALESCE(h1.pidm, h2.pidm, h3.pidm) is null then 'No' else 'Yes' end as precoll_cred,
       s_id as banner_id,
       s_last as last_name,
       s_first as first_name,
       COALESCE(h1.credit_type, h2.credit_type, h3.credit_type, 'Not Concurrent') as credit_type,
       COALESCE(h1.att_cr, h2.att_cr, h3.att_cr) as att_cr,
       COALESCE(h1.ge_bucket, h2.ge_bucket, h3.ge_bucket) as ge_bucket,
       COALESCE(h1.subject, h2.subject, h3.subject) as subject,
       COALESCE(h1.course_nbr, h2.course_nbr, h3.course_nbr) as course_nbr,
       COALESCE(h1.course_title, h2.course_title, h3.course_title) as course_title,
       COALESCE(h1.grade, h2.grade, h3.grade) as grade,
       COALESCE(h1.passed_count, h2.passed_count, h3.passed_count) as passed_count,
       COALESCE(h1.earn_cr, h2.earn_cr, h3.earn_cr) as earn_cr
from bailey.students03@dscir d
     left join cte_hsce_2019 h1 on h1.pidm = d.dsc_pidm and d.s_year = '2020'
     left join cte_hsce_2018 h2 on h2.pidm = d.dsc_pidm and d.s_year = '2019'
     left join cte_hsce_2017 h3 on h3.pidm = d.dsc_pidm and d.s_year = '2018'
where d.s_year in ('2020', '2019', '2018')
  and s_term = '2'
  and s_extract = '3'
  and s_entry_action in ('FF', 'FH');
