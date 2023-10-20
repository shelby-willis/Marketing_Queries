##--COMPLETED JOBS YOY
--NEW: With Buildertrend, our customers completed #+ more projects than last year
with

jobsites AS (
  SELECT 
jobid,
dateopened,
CASE 
  WHEN jobstatus = 0 THEN statusupdatedbydate ELSE NULL
  END AS dateclosed
--closed jobs = 0 and then status updated would indicate when it was closed

FROM btdatascience.btreporting_dimension.jobsites j
LEFT JOIN btdatascience.btreporting_dimension.builders b
  ON b.builderid = j.builderid
WHERE  b.isDemoAccount = FALSE
  AND j.isSampleJob = FALSE
  AND j.Template <> 2
  AND j.jobstatus != 2
),

YoY AS(
SELECT
  jobid,
  dateopened,
  dateclosed,
  CASE
    WHEN DATE_DIFF(CURRENT_DATE(), dateclosed, YEAR) = 0 THEN 'THIS YEAR'
    WHEN DATE_DIFF(CURRENT_DATE(), dateclosed, YEAR) = 1 THEN 'LAST YEAR'
    WHEN DATE_DIFF(CURRENT_DATE(), dateclosed, YEAR) = 2 THEN 'YEAR BEFORE LAST YEAR'
    else 'other'
    END AS Date_Category
FROM jobsites
WHERE dateclosed IS NOT NULL
)

SELECT 
Date_category,
COUNT(DISTINCT jobid) AS job_count
FROM YoY
GROUP BY Date_category
