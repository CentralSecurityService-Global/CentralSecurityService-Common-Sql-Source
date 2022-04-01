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
-- Purpose: Forward Script for the Main Sql File for the Central Security Service Common Sql Server Database.
--
-- Assumptions:
--
--  0.  The Sql Server Database has already been Created by some other means, and has been selected for Use.
--
--  1.  This Sql file may be run as is or may be included via another Sql File along the lines of:
--
--          :R "\Projects\CentralSecurityService\CentralSecurityService-Common-Sql-Source\Sql\V1.0.0\00. CentralSecurityService.Common - Forward.sql"
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Some Variables.
--------------------------------------------------------------------------------

:R "..\CentralSecurityService.Common.Database.Definitions.sql"

--------------------------------------------------------------------------------
-- Begin.
--------------------------------------------------------------------------------

SET CONTEXT_INFO 0x00;
GO

PRINT N'Begin.';
GO

BEGIN TRANSACTION;
GO

--------------------------------------------------------------------------------
-- Create Schema if/as appropriate.
--------------------------------------------------------------------------------

IF SCHEMA_ID(N'$(CommonDatabaseSchema)') IS NULL
BEGIN
    EXECUTE(N'CREATE SCHEMA $(CommonDatabaseSchema);');
END
GO

DECLARE @Error AS Int = @@ERROR;
IF (@Error != 0)
BEGIN
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    BEGIN TRANSACTION;
    SET CONTEXT_INFO 0x01;
END
GO

--------------------------------------------------------------------------------
-- Create Tables if/as appropriate.
--------------------------------------------------------------------------------

PRINT N'Creating the DatabaseVersions Table.';
GO

IF OBJECT_ID(N'$(CommonDatabaseSchema).DatabaseVersions', N'U') IS NULL
BEGIN
    CREATE TABLE $(CommonDatabaseSchema).DatabaseVersions
    (
        DatabaseVersionId           Int NOT NULL CONSTRAINT PK_$(CommonDatabaseSchema)_DatabaseVersions PRIMARY KEY IDENTITY(0, 1),
        Major                       Int NOT NULL,
        Minor                       Int NOT NULL,
        Patch                       Int NOT NULL,
        Build                       NVarChar(128) NOT NULL,
        Description                 NVarChar(256) NOT NULL,
        CreatedDateTimeUtc          DateTime2(7) NOT NULL CONSTRAINT DF_$(CommonDatabaseSchema)_DatabaseVersions_CreatedDateTimeUtc DEFAULT GetUtcDate(),
        LastUpdatedDateTimeUtc      DateTime2(7) NULL
    );

END
GO

DECLARE @Error AS Int = @@ERROR;
IF (@Error != 0)
BEGIN
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    BEGIN TRANSACTION;
    SET CONTEXT_INFO 0x01;
END
GO

--------------------------------------------------------------------------------

PRINT N'Creating the Application Table.';
GO

IF OBJECT_ID(N'$(CommonDatabaseSchema).Applications', N'U') IS NULL
BEGIN
    CREATE TABLE $(CommonDatabaseSchema).Applications
    (
        ApplicationId               Int NOT NULL CONSTRAINT PK_$(CommonDatabaseSchema)_Applications PRIMARY KEY,
        Name                        NVarChar(128) NOT NULL,
        CreatedDateTimeUtc          DateTime2(7) NOT NULL CONSTRAINT DF_$(CommonDatabaseSchema)_Applications_CreatedDateTimeUtc DEFAULT GetUtcDate(),
        LastUpdatedDateTimeUtc      DateTime2(7) NULL
    );

    INSERT INTO $(CommonDatabaseSchema).Applications
        (ApplicationId, Name)
    VALUES
        (  $(CentralSecurityServiceAdministrationWebSiteApplicationId), N'Central Security Service Administration Web Site'),
        (  $(CentralSecurityServiceWebSiteApplicationId),               N'Central Security Service Web Site');
END
GO

DECLARE @Error AS Int = @@ERROR;
IF (@Error != 0)
BEGIN
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    BEGIN TRANSACTION;
    SET CONTEXT_INFO 0x01;
END
GO

--------------------------------------------------------------------------------
-- Insert the Database Version.
--------------------------------------------------------------------------------

PRINT N'Inserting the Database Version.';
GO

INSERT INTO $(CommonDatabaseSchema).DatabaseVersions
    (Major, Minor, Patch, Build, Description)
VALUES
    (1, 0, 0, N'0', N'Initial Database Created.');
GO

DECLARE @Error AS Int = @@ERROR;
IF (@Error != 0)
BEGIN
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    BEGIN TRANSACTION;
    SET CONTEXT_INFO 0x01;
END
GO

--------------------------------------------------------------------------------
-- End.
--------------------------------------------------------------------------------

IF CONTEXT_INFO() != 0x00
BEGIN
    PRINT N'Script Failed - One or more Errors Occurred. Rolling Back the Transaction.';

    ROLLBACK TRANSACTION;
END
ELSE
BEGIN
    PRINT N'Script Succeeded. Committing the Transaction.';

    COMMIT TRANSACTION;
END

PRINT N'End.';
GO

--------------------------------------------------------------------------------
-- End Of File.
--------------------------------------------------------------------------------
