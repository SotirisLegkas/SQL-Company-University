SELECT dname,COUNT(fname)
FROM employee INNER JOIN department ON
employee.dno=department.dnumber
WHERE dno IN (SELECT dno
			  FROM employee
			  WHERE salary>42000)
GROUP BY dname;


SELECT fname,lname
FROM employee
WHERE dno IN (SELECT dno
			 FROM employee
			 WHERE salary in (SELECT MIN(salary)
						      FROM employee));


SELECT fname,lname
FROM employee
WHERE salary>(SELECT AVG(salary)
			 FROM employee
			 WHERE dno IN (SELECT DISTINCT dno
						  FROM employee,department
						  WHERE dname='Research' AND dnumber=dno))+5000;
						  
						  
CREATE VIEW question_4 AS
SELECT dname,fname,lname,salary
FROM employee INNER JOIN department ON
employee.dno=department.dnumber
WHERE mgrssn=ssn;
				
				
CREATE VIEW question_5 AS
SELECT dname,fname,lname,employee_number,project_number
FROM department 
INNER JOIN (SELECT dno,COUNT(fname) AS employee_number
		   FROM employee
		   GROUP BY dno) AS employee_num ON dno=dnumber 
INNER JOIN (SELECT dnum,COUNT(pnumber) AS project_number
		   FROM project
		   GROUP BY dnum) AS project_num ON dnum=dno
NATURAL JOIN question_4;


CREATE VIEW question_6 AS
SELECT pname,dname,project_employee_number,workhours,male,female
FROM project
INNER JOIN department ON dnum=dnumber
INNER JOIN (SELECT pno,COUNT(essn) AS project_employee_number,SUM(hours) AS workhours
		   from works_on
		   GROUP BY pno) AS workons ON pno=pnumber
INNER JOIN (select pno,
			COUNT(CASE WHEN sex = 'M' THEN 1 END) as male,
			COUNT(CASE WHEN sex = 'F' THEN 1 END) as female
			FROM works_on
			INNER JOIN (select ssn,sex
						from employee) AS sextoworkon ON ssn=essn
			group by pno) AS male_female ON male_female.pno=pnumber;



select fname,lname,dname,hours,pno,sumhours
from
(SELECT essn,sum(hours) as sumhours,
 rank() over(order by sum(hours) desc) rankhours
from works_on
group by essn
having sum(hours) is not null) as wres
inner join employee on essn=ssn
inner join department on dnumber=dno
inner join works_on on works_on.essn=wres.essn
where rankhours<=3;
