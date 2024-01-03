IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'udacityfs_udacityaccount_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [udacityfs_udacityaccount_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://udacityfs@udacityaccount.dfs.core.windows.net' 
	)
GO

IF OBJECT_ID('dbo.dim_date') IS NOT NULL
	BEGIN
		DROP EXTERNAL TABLE [dbo].[dim_date];
	END

CREATE EXTERNAL TABLE dbo.dim_date
WITH (
    LOCATION     = 'star_schema/dim_date',
    DATA_SOURCE = [udacityfs_udacityaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS (
	SELECT 
	ROW_NUMBER() OVER(ORDER BY date) as date_id,
	p.date,
	DATEPART(weekday, convert(date,p.date)) as day_of_week,
	DATEPART(day, convert(date,p.date)) as day_of_month,
	DATEPART(week, convert(date,p.date)) as week_of_year,
	DATEPART(quarter, convert(date,p.date)) as quarter,
	DATEPART(MONTH, convert(date,p.date)) as month,
	DATEPART(year, convert(date,p.date)) as year
	FROM
	dbo.staging_payment p
);

GO

SELECT TOP 10 * FROM dbo.dim_date;