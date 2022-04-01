--------------------------------------------------------------------------------
-- Copyright © 2022+ Éamonn Anthony Duffy. All Rights Reserved.
--------------------------------------------------------------------------------
--
-- Version: V1.0.0.
--
-- Created: Éamonn A. Duffy, 1-April-2022.
--
-- Updated: Éamonn A. Duffy, 1-April-2022.
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

:R "..\CentralSecurityService.Common.Database.Definitions.sql"

--------------------------------------------------------------------------------
-- Drop Tables.
--------------------------------------------------------------------------------

DROP TABLE IF EXISTS $(CommonDatabaseSchema).Applications;

-- NOTE: In Future Versions *ONLY* DELETE the relevant Database Version Entry and leave the Table otherwise intact.
DROP TABLE IF EXISTS $(CommonDatabaseSchema).DatabaseVersions;

--------------------------------------------------------------------------------
-- Drop Schema if/as appropriate.
--------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS $(CommonDatabaseSchema);

--------------------------------------------------------------------------------

GO

--------------------------------------------------------------------------------
-- End Of File.
--------------------------------------------------------------------------------
