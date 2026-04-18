USE [master]
GO
CREATE DATABASE [AnalyticsAuditing] ON 
( FILENAME = N'Y:\SQL\DATA\AnalyticsAuditing.mdf' ),
( FILENAME = N'Z:\SQL\LOG\AnalyticsAuditing_log.ldf' )
 FOR ATTACH
GO
