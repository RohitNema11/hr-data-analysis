-- gender breakdown
SELECT gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate='0000-00-00'
GROUP BY gender;

-- race/ethnicity breakdown
SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate='0000-00-00'
GROUP BY race
ORDER BY count DESC;

-- age distribution
SELECT 
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate='0000-00-00';

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, 
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18 AND termdate='0000-00-00'
GROUP BY age_group
ORDER BY age_group;

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, gender,
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18 AND termdate='0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- headquarters vs remote locations
SELECT location, COUNT(*) as count
FROM hr
WHERE age >= 18 AND termdate='0000-00-00'
GROUP BY location;

-- avg length of employment of those who have been terminated
SELECT ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0) AS avg_length_of_employment
FROM hr
WHERE termdate <> '0000-00-00' AND termdate <= CURDATE() AND age >= 18;

-- gender distribution across departments
SELECT department, gender, COUNT(*) as count
FROM hr
WHERE age >= 18 AND termdate='0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- distribution of job titles
SELECT jobtitle, COUNT(*) as count
FROM hr
WHERE age >= 18 AND termdate='0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- department with highest turnover rate
SELECT department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate <= CURDATE() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate = '0000-00-00' THEN 1 ELSE 0 END) as active_count,
    ROUND (SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*), 4) as termination_rate
FROM hr
WHERE age >= 18
GROUP BY department
ORDER BY termination_rate DESC;

-- distribution of employees by state
SELECT location_state, COUNT(*) as count
FROM hr
WHERE age >= 18 AND termdate='0000-00-00'
GROUP BY location_state
ORDER BY count DESC;

-- change in employee count over time based on hire and term dates
SELECT 
    year, 
    hires, 
    terminations, 
    (hires - terminations) AS net_change,
    ROUND(((hires - terminations) / hires * 100), 2) AS net_change_percent
FROM (
    SELECT 
        YEAR(hire_date) AS year, 
        COUNT(*) AS hires, 
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
    FROM 
        hr
    WHERE age >= 18
    GROUP BY 
        YEAR(hire_date)
) subquery
ORDER BY 
    year ASC;
    
-- tenure distribution for each department
SELECT department, ROUND(AVG(DATEDIFF(CURDATE(), termdate)/365),0) as avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department;