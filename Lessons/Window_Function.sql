--Count Rows
SELECT
    COUNT(*) OVER ()
FROM job_postings_fact;



SELECT
    COUNT(*) OVER ()
FROM job_postings_fact;

CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact as jpf
LEFT JOIN skills_job_dim as sjd 
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim as sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;
-- Phân tích median salary per skill, từ bảng temp mới tạo
WITH flat_skills AS (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM job_skills_array
)
SELECT 
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill 
ORDER BY median_salary DESC;

-- ARRAY STRUCT
CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skills_type
FROM job_postings_fact as jpf
LEFT JOIN skills_job_dim as sjd 
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim as sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

-- Phân tích median salary per type of skill, từ bảng temp mới tạo
WITH flat_skills_type AS (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_type).skill_type as skill_type,
        UNNEST(skills_type).skill_name as skill_name
    FROM job_skills_array_struct
)
SELECT 
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills_type
GROUP BY skill_type 
ORDER BY median_salary DESC;