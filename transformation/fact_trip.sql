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

IF OBJECT_ID('dbo.fact_trip') IS NOT NULL
	BEGIN
		DROP EXTERNAL TABLE [dbo].[fact_trip];
	END

CREATE EXTERNAL TABLE dbo.fact_trip
WITH (
    LOCATION     = 'star_schema/fact_trip',
    DATA_SOURCE = [udacityfs_udacityaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS (
	SELECT 
	t.trip_id,
	t.rider_id,
	t.rideable_type,
	t.start_at,
	t.ended_at,
	DATEDIFF(MINUTE, t.start_at, t.ended_at) as duration,
	t.start_station_id,
	t.end_station_id,
	DATEDIFF(YEAR, r.birthday, t.start_at) as rider_age
	FROM
	dbo.staging_trip t
	JOIN dbo.staging_rider r on r.rider_id = t.rider_id
);

GO

SELECT TOP 10 * FROM dbo.fact_trip;