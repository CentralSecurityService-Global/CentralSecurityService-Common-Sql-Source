--------------------------------------------------------------------------------
-- Copyright � 2022+ �amonn Anthony Duffy. All Rights Reserved.
--------------------------------------------------------------------------------
--
-- Version: V1.0.0.
--
-- Created: �amonn A. Duffy, 1-April-2022.
--
-- Updated: �amonn A. Duffy, 1-April-2022.
--
-- Purpose: Roll Back Script for the Main Sql File for the Central Security Service Common Sql Server Database.
--
-- Assumptions:
--
--  0.  The Sql Server Database has already been Created by some other means, and has been selected for Use.
--
--  1.  This Sql file may be run as is or may be included via another Sql File along the lines of:
--
--          :R "\Projects\CentralSecurityService\CentralSecurityService-Common-Sql-Source\Sql\V1.0.0\00. CentralSecuritySerivce.Common - Roll Back.sql"
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Some Variables.
--------------------------------------------------------------------------------

:SETVAR DatabaseVersionMajor             1
:SETVAR DatabaseVersionMinor             0
:SETVAR DatabaseVersionPatch             0
:SETVAR DatabaseVersionBuild            "0"

:SETVAR CommonSqlFolder         "B:\Projects\CentralSecurityService\CentralSecurityService-Common-Sql-Source\Sql"

:R $(CommonSqlFolder)"\CentralSecurityService.Common.Database.Definitions.sql"

--------------------------------------------------------------------------------
-- Drop Tables.
--------------------------------------------------------------------------------

DROP TABLE IF EXISTS $(CommonSchema).Applications;

IF OBJECT_ID(N'$(CommonSchema).DatabaseVersions', N'U') IS NOT NULL
BEGIN
    DELETE FROM $(CommonSchema).DatabaseVersions
    WHERE Major = $(DatabaseVersionMajor) AND Minor = $(DatabaseVersionMinor) AND Patch = $(DatabaseVersionPatch) AND Build = N'$(DatabaseVersionBuild)';
END
GO

-- NOTE: In Future Versions *ONLY* DELETE the relevant Database Version Row and leave the Table otherwise intact.
DROP TABLE IF EXISTS $(CommonSchema).DatabaseVersions;

--------------------------------------------------------------------------------
-- Drop Schema if/as appropriate.
--------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS $(CommonSchema);

--------------------------------------------------------------------------------

GO

--------------------------------------------------------------------------------
-- End Of File.
--------------------------------------------------------------------------------
