SELECT job_title_short,
        salary_year_avg,
        (
            SELECT MEDIAN(salary_year_avg)
            FROM job_postings_fact
        ) AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


SELECT job_title_short,
       MEDIAN(salary_year_avg) AS median_salary,
        (
            SELECT MEDIAN(salary_year_avg)
            FROM job_postings_fact
        ) AS market_median_salary
FROM (
        SELECT 

    )
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

SELECT 
    job_title_short,
    COUNT(*) AS total_postings,
    MEDIAN(
        CASE 
            WHEN salary_year_avg < 100000 THEN salary_year_avg
        END
    ) AS median_low_salary,
    MEDIAN(
        CASE 
            WHEN salary_year_avg >= 100000 THEN salary_year_avg
        END
    ) AS median_high_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short;

--TÍNH TOÁN TỪ DỮ LIỆU LƯƠNG CỦA NĂM THÀNH DỮ LIỆU LƯƠNG THEO GIỜ
WITH salaries AS (
    SELECT 
    job_title_short,
    salary_hour_avg,
    salary_year_avg,
    CASE   
        WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
        WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg * 2080
    END AS standardized_salary
    FROM 
        job_postings_fact
    WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
    LIMIT 10
)
SELECT *,
    CASE
        WHEN standardized_salary IS NULL THEN 'MISSING'
        WHEN standardized_salary < 75000 THEN 'LOW'
        WHEN standardized_salary > 75000 THEN 'HIGH'
    END AS salary_bucket
FROM salaries
ORDER BY standardized_salary
LIMIT 10;

-- ETRACT-DATE_TRUNC_AT TIME ZONE
SELECT 
    job_posted_date,
    job_posted_date::DATE as date,
    job_posted_date::TIME as time,
    job_posted_date::TIMESTAMP as timestamp,
    job_posted_date::TIMESTAMPTZ as timestampz
FROM job_postings_fact 
LIMIT 10;

--EXTRACT
-- có thể thay thế Year bằng một từ khác muốn extract
SELECT 
    EXTRACT(YEAR FROM job_posted_date ) as year
FROM job_postings_fact;

--DATE_TRUNC
--Dùng để làm phẳng thời gian về cùng 1 thời điểm vd như ngày tháng hoặc năm
--AT TIME ZONE
--Dùng để đổi time zone của 
