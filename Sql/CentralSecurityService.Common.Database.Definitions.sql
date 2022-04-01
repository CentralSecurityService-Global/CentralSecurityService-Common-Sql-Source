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
-- Purpose: Database Definitions for the Central Security Service Common Sql Server Database.
--
-- Assumptions:
--
--  0.  The Sql Server Database has already been Created by some other means, and has been selected for Use.
--
--  1.  This Sql file may be run as is or may be included via another Sql File along the lines of:
--
--          :R "..\CentralSecurityService.Common.Database.Definitions.sql"
--
--------------------------------------------------------------------------------

:SETVAR CommonSchema            "Dad"

:SETVAR CentralSecurityServiceAdministrationWebSiteApplicationId         0
:SETVAR CentralSecurityServiceWebSiteApplicationId                       1

--------------------------------------------------------------------------------
-- End Of File.
--------------------------------------------------------------------------------
