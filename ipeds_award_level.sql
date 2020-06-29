with cte_max_term_code_eff as (select
                                   shrdgmr_pidm as pidm,
                                   max(smbpgen_term_code_eff) as max_smbpgen_term_code_eff,
                                   shrdgmr_program
                               from shrdgmr s1
                               left join smbpgen s2 on smbpgen_program = shrdgmr_program
                               group by shrdgmr_pidm, shrdgmr_program)

select distinct
    s1.shrdgmr_pidm,
    smbpgen_req_credits_overall,
    shrdgmr_term_code_ctlg_1,
    s1.shrdgmr_levl_code,
    shrdgmr_degc_code,
    s1.shrdgmr_program,
    s2.smbpgen_program,
    case
        when shrdgmr_levl_code = 'UG' then case
                                               when smbpgen_req_credits_overall between 1 and 8 then '1A'
                                               when smbpgen_req_credits_overall between 9 and 29 then '1B'
                                               when smbpgen_req_credits_overall between 30 and 59 then '2'
                                               when smbpgen_req_credits_overall between 60 and 119 then '3'
                                               when smbpgen_req_credits_overall > 119 then '5'
                                           end

        when shrdgmr_levl_code = 'GR' and smbpgen_req_credits_overall > 0 then '7'
    end ipeds_awrd_lvl
from shrdgmr s1
left join smbpgen s2 on s2.smbpgen_program = s1.shrdgmr_program
left join cte_max_term_code_eff s3 on s3.pidm = s1.shrdgmr_pidm and s3.shrdgmr_program = s2.smbpgen_program
where
-- and shrdgmr_term_code_ctlg_1 >= s2.smbpgen_term_code_eff
    s3.max_smbpgen_term_code_eff = s2.smbpgen_term_code_eff
  and shrdgmr_grad_date > to_date('30-JUN-19')
  and shrdgmr_grad_date < to_date('01-JUL-20')
--   and shrdgmr_degc_code like 'C%'
  and shrdgmr_term_code_grad = '202020'
order by shrdgmr_pidm;

select *
from shrdgmr
where shrdgmr_term_code_grad = '202020';

select
    smbpgen_req_credits_overall,
    s1.*
from smbpgen s1
where smbpgen_program = 'CERT-GENED';

select distinct
    shrdgmr_program,
    max(smbpgen_term_code_eff) as max_smbpgen_term_code_eff,
    smbpgen_req_credits_overall
from shrdgmr s1
left join smbpgen s2 on smbpgen_program = shrdgmr_program
where smbpgen_term_code_eff is null
      --and shrdgmr_degc_code like 'C%'
      --and shrdgmr_term_code_grad in ('201930', '201940', '202020' )
group by shrdgmr_program, smbpgen_req_credits_overall
order by 1;

select *
from smbpgen
where smbpgen_program = 'CERT-GENED';
