# Tableau calculated fields

## Attrition count

~~~text
IF UPPER(TRIM([Attrition])) = 'YES' THEN 1 ELSE 0 END
~~~

## Attrition rate

~~~text
SUM([Calculation_661466249459232768])/SUM([Employee Count])
~~~

## Active employees

~~~text
sum([Employee Count])-SUM([Calculation_661466249459232768])
~~~

## Age Band

~~~text
IF [Age] < 25 THEN 'Under 25' ELSEIF [Age] < 35 THEN '25-34' ELSEIF [Age] < 45 THEN '35-44' ELSEIF [Age] < 55 THEN '45-54' ELSE '55+' END
~~~

## Tenure Band

~~~text
IF [Years At Company] < 2 THEN '0-1 years' ELSEIF [Years At Company] <= 5 THEN '2-5 years' ELSEIF [Years At Company] <= 10 THEN '6-10 years' ELSE '11+ years' END
~~~

The attrition denominator is the employee count in each displayed cohort. Shared filters and the department action change that cohort. No date field is available for an annual turnover calculation.
