/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

SELECT
    sd.skills,
    round(MEDIAN(jpf.salary_year_avg), 0) as median_salary,
    COUNT(*) as demand_count,
    round(LN(COUNT(*)), 1) as ln_demand_count,
    round(((round(MEDIAN(jpf.salary_year_avg), 0) * LN(COUNT(*)))/1000000), 2) as optimal_score,
    round(((round(MEDIAN(jpf.salary_year_avg), 0) * COUNT(*))/1000000), 0) as optimal_score_noln
FROM job_postings_fact as jpf
JOIN skills_job_dim as jsd ON jpf.job_id = jsd.job_id
JOIN skills_dim as sd ON jsd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer' AND
    jpf.job_work_from_home = TRUE AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING demand_count > 100
ORDER BY
    optimal_score DESC
LIMIT 25;

--Result
/*
────────────┬───────────────┬──────────────┬─────────────────┬───────────────┬────────────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │ optimal_score_noln │
│  varchar   │    double     │    int64     │     double      │    double     │       double       │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┼────────────────────┤
│ terraform  │      184000.0 │          193 │             5.3 │          0.97 │               36.0 │
│ python     │      135000.0 │         1133 │             7.0 │          0.95 │              153.0 │
│ sql        │      130000.0 │         1128 │             7.0 │          0.91 │              147.0 │
│ aws        │      137320.0 │          783 │             6.7 │          0.91 │              108.0 │
│ airflow    │      150000.0 │          386 │             6.0 │          0.89 │               58.0 │
│ spark      │      140000.0 │          503 │             6.2 │          0.87 │               70.0 │
│ snowflake  │      135500.0 │          438 │             6.1 │          0.82 │               59.0 │
│ kafka      │      145000.0 │          292 │             5.7 │          0.82 │               42.0 │
│ azure      │      128000.0 │          475 │             6.2 │          0.79 │               61.0 │
│ java       │      135000.0 │          303 │             5.7 │          0.77 │               41.0 │
│ scala      │      137290.0 │          247 │             5.5 │          0.76 │               34.0 │
│ kubernetes │      150500.0 │          147 │             5.0 │          0.75 │               22.0 │
│ git        │      140000.0 │          208 │             5.3 │          0.75 │               29.0 │
│ databricks │      132750.0 │          266 │             5.6 │          0.74 │               35.0 │
│ redshift   │      130000.0 │          274 │             5.6 │          0.73 │               36.0 │
│ gcp        │      136000.0 │          196 │             5.3 │          0.72 │               27.0 │
│ nosql      │      134415.0 │          193 │             5.3 │          0.71 │               26.0 │
│ hadoop     │      135000.0 │          198 │             5.3 │          0.71 │               27.0 │
│ pyspark    │      140000.0 │          152 │             5.0 │           0.7 │               21.0 │
│ mongodb    │      135750.0 │          136 │             4.9 │          0.67 │               18.0 │
│ docker     │      135000.0 │          144 │             5.0 │          0.67 │               19.0 │
│ go         │      140000.0 │          113 │             4.7 │          0.66 │               16.0 │
│ r          │      134775.0 │          133 │             4.9 │          0.66 │               18.0 │
│ bigquery   │      135000.0 │          123 │             4.8 │          0.65 │               17.0 │
│ github     │      135000.0 │          127 │             4.8 │          0.65 │               17.0 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┴────────────────────┘
*/