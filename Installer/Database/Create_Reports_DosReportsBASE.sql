USE [Shared]
GO
CREATE SCHEMA [Reports]
GO
CREATE TABLE [Reports].[DosReportsBASE](
	[ID] [int] NOT NULL,
	[SlugCD] [varchar](255) NOT NULL,
	[ReportJSON] [nvarchar](max) NOT NULL,
	[StatusCD] [varchar](255) NOT NULL DEFAULT 'Active',
 CONSTRAINT [pkDosReportsBASE] PRIMARY KEY CLUSTERED ([ID] ASC)) ON [HCSharedData1]
GO