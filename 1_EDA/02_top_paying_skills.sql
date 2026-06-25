/*
Question: What are the highest-paying skills for data engineers?
- Calculate the median salary for each skill required in data engineer positions
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing 
    how common those skills are, providing a more complete picture for skill development priorities
*/
SELECT
    sd.skills,
    round(MEDIAN(jpf.salary_year_avg), 0) as median_salary,
    COUNT(*) as demand_count
FROM job_postings_fact as jpf
JOIN skills_job_dim as jsd ON jpf.job_id = jsd.job_id
JOIN skills_dim as sd ON jsd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer' AND
    jpf.job_work_from_home = TRUE AND
GROUP BY
    sd.skills
HAVING demand_count > 100
ORDER BY
    median_salary DESC
LIMIT 10;

--Result
/*
┌───────────┬───────────────┬──────────────┐
│  skills   │ median_salary │ demand_count │
│  varchar  │    double     │    int64     │
├───────────┼───────────────┼──────────────┤
│ rust      │      210000.0 │          232 │
│ terraform │      184000.0 │         3248 │
│ golang    │      184000.0 │          912 │
│ spring    │      175500.0 │          364 │
│ neo4j     │      170000.0 │          277 │
│ gdpr      │      169616.0 │          582 │
│ zoom      │      168438.0 │          127 │
│ graphql   │      167500.0 │          445 │
│ mongo     │      162250.0 │          265 │
│ fastapi   │      157500.0 │          204 │
└───────────┴───────────────┴──────────────┘
*/