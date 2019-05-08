--select distinct [Primary Description]
--from co_product('1')
----where [Primary Description] = 'DROSS'

--select * from co_product('1')
--where [Primary Description] = ''

declare @ncust float
declare @totrev float

select @ncust = count(distinct [Customer ID]) from co_lineitem('1')
select @totrev =sum(cast([Total Price] as float)) from co_lineitem('1')

;with products as (
	select *,
		concat(case when [Primary Description] = '' then 'UnspecPrimary' else [Primary Description] end,
			': ',
			case	when [Secondary Description] = '' then 'UnspecSecondary'
					else [Secondary Description] end

					) Category
	from co_product('1')
		where [Primary Description] in (
					'Adhesives & Sealants',
					'Soldering & Rework',
					'Hisco Fab DRY',
					'Tapes & Pads',
					'Chemicals/Cleaners',
					'Electrical',
					'Other',
					'Identification',
					'Packaging/Shipping',
					'Hisco Fab WET',
					'Tools & Equipment',
					'ESD (Static Control)'
					)
	)
select pr.Category,
		sum(cast(li.[Total Price] as float)) Revenue,
		sum(cast(li.[Total Price] as float))/@totrev RevenuePCT,
		count(*) Transactions,
		count(distinct li.[Customer ID]) NCustomers,
		cast(count(distinct li.[Customer ID]) as float)/@ncust Support

from		co_lineitem('1') li
join	products pr on li.[Product code] = pr.[Product Code]
group by pr.Category
order by Revenue desc