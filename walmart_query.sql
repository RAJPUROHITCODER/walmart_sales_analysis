# 1)
SELECT DISTINCT* from (SELECT branch , category ,rating,AVG(rating) over(PARTITION BY branch,category) as avgerage_rating ,rank() over(PARTITION by branch,category order by rating DESC) as rn from walmart) as t where t.rn=1;

# 2)idetify busiest date based on number of transaction
SELECT date,count(*) as c from walmart GROUP by date HAVING C=(SELECT MAX(count) from (SELECT COUNT(*) as count from walmart GROUP by date) as t)

# 3)idetify busiest day for each branch based on number of transaction 
with d as (select branch,city,DAYName(str_to_date(date,"%d/%m/%y")) as Day from walmart) SELECT * from (SELECT *,count(Day) as c,rank() over(PARTITION by branch order by c DESC) as rn from d group by branch,Day) as t where rn=1;

# 4)calaculate the total quantity  of item sold per p[ayment method ,list  payment_method and total_quantity
SELECT payment_method,sum(quantity) from walmart GROUP BY payment_method

# 5)determine the average.minimum , maximum rating of category for each city 
#List the city,average_rating,and max_rating
SELECT city,category,AVG(rating),MAX(rating),MIN(rating) from walmart GROUP by city , category;

#6) calculate the total profit for each category by considering total_profit as (amount)*Profit_margin 
#List category and total profit ,ordered from hihest to lowest profit
SELECT category,SUM(amount*profit_margin) as total_profit FROM walmart GROUP by category

# 7)Determine the most common payment method for each branch
#Display Branch and the prefered payment method
SELECT * from (select branch,payment_method ,count(*) as c ,rank() over(PARTITION by branch order by c desc) as rn from walmart GROUP by branch,payment_method
) as t where rn=1

# 8) category sales into 3 groups Morining ,Afternoon <evvening
# Find out each of the shift and number of invoices
select branch, 
	case 
    	when hour(time(time))>=12 and hour(time(time))<17 then "Afternoon" 
        when hour(time(time))>=17 and hour(time(time))<=23 then "Evening" 
        when hour(time(time))>=6 and hour(time(time))<12 then "Morning" end  Day_time,count(*) as c from  walmart GROUP by branch,day_time ORDER by branch,c DESC  


# 9)Identify 5 branch with hihest decrease ratio in 
# revenue  compare to last year(current year 2023 and last year 2022)
with ls_revenue as(
SELECT branch,sum(amount) as rev,YEAR(str_to_date(date,"%d/%m/%y")) as year from walmart WHERE YEAR(str_to_date(date,"%d/%m/%y"))=2022  group by branch ),
cs_revenue as (
    
SELECT branch,sum(amount) as rev ,YEAR(str_to_date(date,"%d/%m/%y")) as year from walmart WHERE YEAR(str_to_date(date,"%d/%m/%y"))=2023  group by branch )
select  ls.branch ,ls.rev as "2022 revevnue",cs.rev as "2023 revenue",((ls.rev-cs.rev)/ls.rev)*100 as ratio from ls_revenue as ls JOIN cs_revenue as cs on ls.branch=cs.branch where ls.rev>cs.rev order by ratio DESC limit 5








