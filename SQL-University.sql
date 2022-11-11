select name,
count(case when grade='A' or grade='A+' or grade='A-' then 1 end) as A,
count(case when grade='B' or grade='B+' or grade='B-' then 1 end) as B,
count(case when grade='C' or grade='C+' or grade='C-' then 1 end) as C,
count(case when grade='F' then 1 end) as F
from
(select teaches.id,name,course_id,sec_id,semester,year,grade
from teaches inner join instructor using(id)
inner join takes 
using(course_id,sec_id,semester,year))
as question8
where grade is not null
group by name
order by A desc,B desc,C desc,F desc;


create view question_9 as
select building,room_number,semester,tot_hours,tot_student_no
from section
inner join (select time_slot_id,round((sum(end_hr-start_hr)+sum(end_min-start_min)/60)*4*6, 2) as tot_hours
			from time_slot
			group by time_slot_id) as wres using(time_slot_id)
inner join (select count(id) as tot_student_no,course_id,semester,sec_id,year
			from takes
			group by course_id,sec_id,semester,year) as students using(course_id,sec_id,semester,year);


create view question_10 as
select start_hr,start_min,end_hr,end_min,day,sec_id,semester,year,building,room_number,title,course_id,dept_name,instructor.name
from section
inner join time_slot using(time_slot_id)
inner join course using(course_id)
inner join teaches using(course_id,sec_id,semester,year)
inner join instructor using(id,dept_name)
order by year,semester,sec_id,
case
when day='M' then 1
when day='T' then 2
when day='W' then 3
when day='R' then 4
when day='F' then 5
END ASC,
start_hr,start_min;
