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

IF OBJECT_ID('dbo.dim_station') IS NOT NULL
	BEGIN
		DROP EXTERNAL TABLE [dbo].[dim_station];
	END

CREATE EXTERNAL TABLE dbo.dim_station
WITH (
    LOCATION     = 'star_schema/dim_station',
    DATA_SOURCE = [udacityfs_udacityaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS (
	SELECT 
	d.station_id,
	d.name,
	d.latitude,
	d.longitude
	FROM
	dbo.staging_station d
);

GO

SELECT TOP 10 * FROM dbo.dim_station;