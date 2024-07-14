-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "titles" (
    "title_id" varchar(5)   NOT NULL,
    "title" varchar(100)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR(5)   NOT NULL,
    "dept_name" CHAR(100)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employee" (
    "emp_no" integer   NOT NULL,
    "emp_title_id" varchar(5)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(100)   NOT NULL,
    "last_name" varchar(100)   NOT NULL,
    "sex" varchar(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employee" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" integer   NOT NULL,
    "dept_no" varchar(5)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar(5)   NOT NULL,
    "emp_no" integer   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" integer   NOT NULL,
    "salary" integer   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

ALTER TABLE "employee" ADD CONSTRAINT "fk_employee_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employee" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employee" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employee" ("emp_no");

-- Check tables 
select * from departments;
select * from dept_emp;
select * from dept_manager;
select * from employee;
select * from salaries;
select * from titles;


-- 1. List the employee number, last name, first name, sex, and salary of each employee.
select e.emp_no, e.last_name, e.first_name, e.sex, s.salary
from employee as e
join salaries as s on e.emp_no = s.emp_no;


-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
select first_name, last_name, hire_date
from employee 
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
select d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
from employee as e
join dept_manager as m on e.emp_no = m.emp_no
join departments as d on m.dept_no = d.dept_no;

-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
select e.emp_no, e.last_name, e.first_name,de.dept_no, d.dept_name
from employee as e
join dept_emp as de on e.emp_no = de.emp_no
join departments as d on de.dept_no = d.dept_no;

-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
select first_name, last_name, sex
from employee 
WHERE first_name = 'Hercules' and last_name like 'B%';

-- 6. List each employee in the Sales department, including their employee number, last name, and first name.
select e.emp_no, e.last_name, e.first_name
from employee as e
join dept_emp as de on e.emp_no = de.emp_no
join departments as d on de.dept_no = d.dept_no
where d.dept_name = 'Sales';

-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
select e.emp_no, e.last_name, e.first_name, d.dept_name
from employee as e
join dept_emp as de on e.emp_no = de.emp_no
join departments as d on de.dept_no = d.dept_no
where d.dept_name = 'Sales' or d.dept_name = 'Development';

-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
select last_name, count(last_name)
from employee
group by last_name
order by count(last_name) desc;