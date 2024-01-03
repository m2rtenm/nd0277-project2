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

IF OBJECT_ID('dbo.dim_rider') IS NOT NULL
	BEGIN
		DROP EXTERNAL TABLE [dbo].[dim_rider];
	END

CREATE EXTERNAL TABLE dbo.dim_rider
WITH (
    LOCATION     = 'star_schema/dim_rider',
    DATA_SOURCE = [udacityfs_udacityaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS (
	SELECT 
	r.rider_id,
	r.address,
	r.first as firstname,
	r.last as lastname,
	CONVERT(DATE, r.birthday) as birthday,
	r.is_member,
	CONVERT(DATE, r.account_start_date) as account_start_date,
	CONVERT(DATE, r.account_end_date) as account_end_date
	FROM
	dbo.staging_rider r
);

GO

SELECT TOP 10 * FROM dbo.dim_rider;