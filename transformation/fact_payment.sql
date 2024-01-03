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

IF OBJECT_ID('dbo.fact_payment') IS NOT NULL
	BEGIN
		DROP EXTERNAL TABLE [dbo].[fact_payment];
	END

CREATE EXTERNAL TABLE dbo.fact_payment
WITH (
    LOCATION     = 'star_schema/fact_payment',
    DATA_SOURCE = [udacityfs_udacityaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS (
	SELECT 
	p.payment_id,
	p.date,
	p.amount,
	p.rider_id
	FROM
	dbo.staging_payment p
	JOIN dbo.staging_rider r on r.rider_id = p.rider_id
);

GO

SELECT TOP 10 * FROM dbo.fact_payment;