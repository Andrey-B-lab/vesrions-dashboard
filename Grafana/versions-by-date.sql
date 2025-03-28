SELECT
  job_name AS "אפליקציה",

  -- DEV
  MAX(CASE WHEN environment = 'DEV' THEN 'v' || version END) AS "DEV Version",
  MAX(CASE WHEN environment = 'DEV' THEN TO_CHAR(deployed_at, 'YYYY-MM-DD') END) AS "DEV Date",
  MAX(CASE WHEN environment = 'DEV' THEN SPLIT_PART(deployed_by, ' ', 1) || ' ' || LEFT(SPLIT_PART(deployed_by, ' ', 2), 1) END) AS "DEV User",
  
  -- Blank before TEST
  NULL AS "  ",

  -- TEST
  MAX(CASE WHEN environment = 'TEST' THEN 'v' || version END) AS "TEST Version",
  MAX(CASE WHEN environment = 'TEST' THEN TO_CHAR(deployed_at, 'YYYY-MM-DD') END) AS "TEST Date",
  MAX(CASE WHEN environment = 'TEST' THEN SPLIT_PART(deployed_by, ' ', 1) || ' ' || LEFT(SPLIT_PART(deployed_by, ' ', 2), 1) END) AS "TEST User",

  -- Blank before STAGE
  NULL AS "   ",

  -- STAGE
  MAX(CASE WHEN environment = 'STAGE' THEN 'v' || version END) AS "STAGE Version",
  MAX(CASE WHEN environment = 'STAGE' THEN TO_CHAR(deployed_at, 'YYYY-MM-DD') END) AS "STAGE Date",
  MAX(CASE WHEN environment = 'STAGE' THEN SPLIT_PART(deployed_by, ' ', 1) || ' ' || LEFT(SPLIT_PART(deployed_by, ' ', 2), 1) END) AS "STAGE User",

  -- Blank before PROD
  NULL AS "    ",

  -- PROD
  MAX(CASE WHEN environment = 'PROD' THEN 'v' || version END) AS "PROD Version",
  MAX(CASE WHEN environment = 'PROD' THEN TO_CHAR(deployed_at, 'YYYY-MM-DD') END) AS "PROD Date",
  MAX(CASE WHEN environment = 'PROD' THEN SPLIT_PART(deployed_by, ' ', 1) || ' ' || LEFT(SPLIT_PART(deployed_by, ' ', 2), 1) END) AS "PROD User"

FROM deployed_versions
WHERE
  system = '${system}'
  AND deployed_at <= '${selected_date}'::date + interval '1 day'
GROUP BY job_name
ORDER BY job_name;
