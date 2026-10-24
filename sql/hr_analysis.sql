-- HR snapshot analysis. Each row represents one employee.
-- Attrition rate = Attrition Yes records / all records in the selected cohort.
-- SQLite 3 is the executed engine. The CASE, GROUP BY, NULLIF and window
-- expressions are also supported in MySQL 8; this project does not claim a live MySQL connection.

-- result: overview
SELECT COUNT(*) AS employees, SUM(attrition_flag) AS attrition_count,
       COUNT(*)-SUM(attrition_flag) AS active_employees,
       ROUND(100.0*SUM(attrition_flag)/NULLIF(COUNT(*),0),2) AS attrition_rate_pct,
       ROUND(AVG(age),2) AS average_age
FROM hr_employees;

-- result: department
SELECT department, COUNT(*) AS employees, SUM(attrition_flag) AS attrition_count,
       ROUND(100.0*SUM(attrition_flag)/NULLIF(COUNT(*),0),2) AS attrition_rate_pct
FROM hr_employees GROUP BY department ORDER BY attrition_rate_pct DESC,department;

-- result: job_role
WITH cohort AS (
 SELECT job_role,COUNT(*) AS employees,SUM(attrition_flag) AS attrition_count,
        100.0*SUM(attrition_flag)/NULLIF(COUNT(*),0) AS rate
 FROM hr_employees GROUP BY job_role
)
SELECT job_role,employees,attrition_count,ROUND(rate,2) AS attrition_rate_pct,
       DENSE_RANK() OVER(ORDER BY rate DESC) AS rate_rank
FROM cohort ORDER BY rate DESC,job_role;

-- result: overtime
SELECT overtime,COUNT(*) AS employees,SUM(attrition_flag) AS attrition_count,
       ROUND(100.0*SUM(attrition_flag)/NULLIF(COUNT(*),0),2) AS attrition_rate_pct
FROM hr_employees GROUP BY overtime ORDER BY overtime DESC;

-- result: overtime_gap
WITH cohort AS (
 SELECT overtime,COUNT(*) AS employees,SUM(attrition_flag) AS exits,
        100.0*SUM(attrition_flag)/NULLIF(COUNT(*),0) AS rate
 FROM hr_employees GROUP BY overtime
)
SELECT ROUND(MAX(CASE WHEN overtime='Yes' THEN rate END)-
             MAX(CASE WHEN overtime='No' THEN rate END),2) AS percentage_point_gap,
       ROUND(MAX(CASE WHEN overtime='Yes' THEN rate END)/
             NULLIF(MAX(CASE WHEN overtime='No' THEN rate END),0),2) AS rate_ratio
FROM cohort;

-- result: age_band
SELECT age_band,COUNT(*) AS employees,SUM(attrition_flag) AS attrition_count,
       ROUND(100.0*SUM(attrition_flag)/NULLIF(COUNT(*),0),2) AS attrition_rate_pct
FROM hr_employees GROUP BY age_band
ORDER BY CASE age_band WHEN 'Under 25' THEN 1 WHEN '25-34' THEN 2 WHEN '35-44' THEN 3 WHEN '45-54' THEN 4 ELSE 5 END;

-- result: tenure_band
SELECT tenure_band,COUNT(*) AS employees,SUM(attrition_flag) AS attrition_count,
       ROUND(100.0*SUM(attrition_flag)/NULLIF(COUNT(*),0),2) AS attrition_rate_pct
FROM hr_employees GROUP BY tenure_band
ORDER BY CASE tenure_band WHEN '0-1 years' THEN 1 WHEN '2-5 years' THEN 2 WHEN '6-10 years' THEN 3 ELSE 4 END;

-- result: job_satisfaction
SELECT job_satisfaction,COUNT(*) AS employees,SUM(attrition_flag) AS attrition_count,
       ROUND(100.0*SUM(attrition_flag)/NULLIF(COUNT(*),0),2) AS attrition_rate_pct
FROM hr_employees GROUP BY job_satisfaction ORDER BY job_satisfaction;

-- result: role_satisfaction
SELECT job_role,job_satisfaction,COUNT(*) AS employees,SUM(attrition_flag) AS attrition_count,
       ROUND(100.0*SUM(attrition_flag)/NULLIF(COUNT(*),0),2) AS attrition_rate_pct
FROM hr_employees GROUP BY job_role,job_satisfaction ORDER BY job_role,job_satisfaction;

-- result: department_overtime
SELECT department,overtime,COUNT(*) AS employees,SUM(attrition_flag) AS attrition_count,
       ROUND(100.0*SUM(attrition_flag)/NULLIF(COUNT(*),0),2) AS attrition_rate_pct
FROM hr_employees GROUP BY department,overtime ORDER BY department,overtime DESC;
