-- look at 16924

--Grabs the previous degree earned at DSU
-- select pidm,
--        prev_degree,
--        stvdegc_code,
--        deg_rank_1,
--        deg_rank_2,
--        prev_degree_max_lvl,
--        case
--            when prev_degree_max_lvl like 'CER0' then '01'
--            when prev_degree_max_lvl like 'CER1' then '02'
--            when prev_degree_max_lvl like 'A%' then '03'
--            when prev_degree_max_lvl like 'B%' then '05'
--            when prev_degree_max_lvl like 'M%' then '07'
--        end as dxgrad_prev_degr
-- from (
select
    pidm,
    deg_desc_1,
    deg_desc_2,
    deg_desc_3,
    greatest(deg_rank_1, deg_rank_2, deg_rank_3) as greatest_rank,
    deg_rank_1,
    deg_rank_2,
    deg_rank_3,
    case
        when deg_rank_1 = greatest(deg_rank_1, deg_rank_2, deg_rank_3) then deg_desc_1
        when deg_rank_2 = greatest(deg_rank_1, deg_rank_2, deg_rank_3) then deg_desc_2
        when deg_rank_3 = greatest(deg_rank_1, deg_rank_2, deg_rank_3) then deg_desc_3
        else coalesce(deg_desc_1, deg_desc_2, deg_desc_3)
    end as prev_degree_max_lvl
from (
    with cte_prev_dgr as (
        select shrdgmr_pidm, max(shrdgmr_seq_no) as shrdgmr_seq_no
        from shrdgmr
        where shrdgmr_seq_no > 1
        group by shrdgmr_pidm),
        -- Grabs Highest Degree earned from a previous institution
        cte_prev_dgr2 as (
            select
                sordegr_pidm as pidm,
                max(sordegr_degc_date) as max_sordegr_degc_date,
                max(case
                        when stvdegc_dlev_code = 'DR' then '5'
                        when stvdegc_dlev_code = 'MA' then '4'
                        when stvdegc_dlev_code = 'BA' then '3'
                        when stvdegc_dlev_code = 'AS' then '2'
                        when stvdegc_dlev_code = 'LA' then '1'
                        else '0'
                    end) as deg_rank
            from saturn.sordegr, saturn.stvdegc, spriden
            where sordegr_pidm = spriden_pidm
              and sordegr_degc_code = stvdegc_code
              and stvdegc_acat_code >= 20
              and sordegr_degc_code <> '000000'
              and spriden_change_ind is null
              and sordegr_degc_date <= to_date('01-JUN-2019')
            group by sordegr_pidm),

        -- used to align pidm and degree to choose whichever degree is the highest level (rank)
        cte_prev_dgr3 as (
            select
                pidm,
                stvdegc_code,
                deg_rank
            from cte_prev_dgr2, saturn.sordegr, saturn.stvdegc, spriden
            where pidm = sordegr_pidm
              and case
                      when stvdegc_dlev_code = 'DR' then '5'
                      when stvdegc_dlev_code = 'MA' then '4'
                      when stvdegc_dlev_code = 'BA' then '3'
                      when stvdegc_dlev_code = 'AS' then '2'
                      when stvdegc_dlev_code = 'LA' then '1'
                      else '0'
                  end = deg_rank
              and max_sordegr_degc_date = sordegr_degc_date
              and sordegr_pidm = spriden_pidm
              and sordegr_degc_code = stvdegc_code
              and stvdegc_acat_code >= 20
              and sordegr_degc_code <> '000000'
              and spriden_change_ind is null
              and sordegr_degc_date <= to_date('01-JUN-2019')),
        cte_prev_deg4 as (
            select
                shrtram_pidm,
                shrtram_degc_code,
                case
                    when stvdegc_dlev_code = 'DR' then '5'
                    when stvdegc_dlev_code = 'MA' then '4'
                    when stvdegc_dlev_code = 'BA' then '3'
                    when stvdegc_dlev_code = 'AS' then '2'
                    when stvdegc_dlev_code = 'LA' then '1'
                    else '0'
                end as deg_rank_3
            from stvdegc, shrtram, spriden
            where shrtram_pidm = spriden_pidm
              and shrtram_degc_code = stvdegc_code
              and stvdegc_acat_code >= 20
              and shrtram_degc_code <> '000000'
              and spriden_change_ind is null)

    select
        s1.shrdgmr_pidm as pidm,
        s2.shrdgmr_degc_code as deg_desc_1,
        case
            when shrdgmr_degc_code like 'M%' then '4'
            when shrdgmr_degc_code like 'B%' then '3'
            when shrdgmr_degc_code like 'A%' then '2'
            when shrdgmr_degc_code like 'C%' then '1'
            when shrdgmr_degc_code like 'L%' then '1'
            else '0'
        end as deg_rank_1,
        s3.deg_rank as deg_rank_2,
        s3.stvdegc_code as deg_desc_2,
        deg_rank_3,
        shrtram_degc_code as deg_desc_3,
        coalesce(greatest(s3.deg_rank, case
                                           when shrdgmr_degc_code like 'M%' then '4'
                                           when shrdgmr_degc_code like 'B%' then '3'
                                           when shrdgmr_degc_code like 'A%' then '2'
                                           when shrdgmr_degc_code like 'C%' then '1'
                                           when shrdgmr_degc_code like 'L%' then '1'
                                           else '0'
                                       end), case
                                                 when shrdgmr_degc_code like 'M%' then '4'
                                                 when shrdgmr_degc_code like 'B%' then '3'
                                                 when shrdgmr_degc_code like 'A%' then '2'
                                                 when shrdgmr_degc_code like 'C%' then '1'
                                                 when shrdgmr_degc_code like 'L%' then '1'
                                                 else '0'
                                             end, s3.deg_rank) as greatest_deg_rank
    from cte_prev_dgr s1
    left join shrdgmr s2 on s1.shrdgmr_pidm = s2.shrdgmr_pidm and s2.shrdgmr_seq_no = s1.shrdgmr_seq_no - 1
    left join cte_prev_dgr3 s3 on s3.pidm = s1.shrdgmr_pidm
    left join cte_prev_deg4 s4 on s4.shrtram_pidm = s1.shrdgmr_pidm
    where s2.shrdgmr_seq_no <> s1.shrdgmr_seq_no
      and pidm = '16924')
order by
    1;

select *
from shrtram
where shrtram_degc_code is not null
  and shrtram_pidm = '6198';

select *
from sordegr
where sordegr_pidm = '6198'
order by
    sordegr_pidm;
