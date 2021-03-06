--------------------------------------------------------------------------------
-- Copyright ? 2022+ ?amonn Anthony Duffy. All Rights Reserved.
--------------------------------------------------------------------------------
--
-- Version: V1.0.0.
--
-- Created: ?amonn A. Duffy, 1-April-2022.
--
-- Updated: ?amonn A. Duffy, 1-April-2022.
--
-- Purpose: Forward Script for the Main Sql File for the Central Security Service Common Sql Server Database.
--
-- Assumptions:
--
--  0.  The Sql Server Database has already been Created by some other means, and has been selected for Use.
--
--  1.  This Sql file may be run as is or may be included via another Sql File along the lines of:
--
--          :R "B:\Projects\CentralSecurityService\CentralSecurityService-Common-Sql-Source\Sql\V1.0.0\00. CentralSecurityService.Common - Forward.sql"
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Some Variables.
--------------------------------------------------------------------------------

:SETVAR DatabaseVersionMajor             1
:SETVAR DatabaseVersionMinor             0
:SETVAR DatabaseVersionPatch             0
:SETVAR DatabaseVersionBuild            "0"
:SETVAR DatabaseVersionDescription      "Initial Database Created."

:SETVAR CommonSqlFolder         "B:\Projects\CentralSecurityService\CentralSecurityService-Common-Sql-Source\Sql"

:R $(CommonSqlFolder)"\CentralSecurityService.Common.Database.Definitions.sql"

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

IF SCHEMA_ID(N'$(CommonSchema)') IS NULL
BEGIN
    PRINT N'Creating the Schema.';

    EXECUTE(N'CREATE SCHEMA $(CommonSchema);');
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

IF OBJECT_ID(N'$(CommonSchema).DatabaseVersions', N'U') IS NULL
BEGIN
    PRINT N'Creating the DatabaseVersions Table.';

    CREATE TABLE $(CommonSchema).DatabaseVersions
    (
        DatabaseVersionId           Int NOT NULL CONSTRAINT PK_$(CommonSchema)_DatabaseVersions PRIMARY KEY IDENTITY(0, 1),
        Major                       Int NOT NULL,
        Minor                       Int NOT NULL,
        Patch                       Int NOT NULL,
        Build                       NVarChar(128) NOT NULL,
        Description                 NVarChar(256) NOT NULL,
        CreatedDateTimeUtc          DateTime2(7) NOT NULL CONSTRAINT DF_$(CommonSchema)_DatabaseVersions_CreatedDateTimeUtc DEFAULT GetUtcDate(),
        LastUpdatedDateTimeUtc      DateTime2(7) NULL,
        
        CONSTRAINT UQ_$(CommonSchema)_DatabaseVersions_Version UNIQUE (Major, Minor, Patch, Build)
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

IF OBJECT_ID(N'$(CommonSchema).Applications', N'U') IS NULL
BEGIN
    PRINT N'Creating the Applications Table.';

    CREATE TABLE $(CommonSchema).Applications
    (
        ApplicationId               Int NOT NULL CONSTRAINT PK_$(CommonSchema)_Applications PRIMARY KEY,
        Name                        NVarChar(128) NOT NULL,
        CreatedDateTimeUtc          DateTime2(7) NOT NULL CONSTRAINT DF_$(CommonSchema)_Applications_CreatedDateTimeUtc DEFAULT GetUtcDate(),
        LastUpdatedDateTimeUtc      DateTime2(7) NULL
    );

    INSERT INTO $(CommonSchema).Applications
        (ApplicationId, Name)
    VALUES
        ($(CentralSecurityServiceAdministrationWebSiteApplicationId), N'Central Security Service Administration Web Site'),
        ($(CentralSecurityServiceWebSiteApplicationId),               N'Central Security Service Web Site');
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

IF NOT EXISTS (SELECT 1 FROM $(CommonSchema).DatabaseVersions WHERE Major = $(DatabaseVersionMajor) AND Minor = $(DatabaseVersionMinor) AND Patch = $(DatabaseVersionPatch) AND Build = N'$(DatabaseVersionBuild)')
BEGIN
    PRINT N'Inserting the Database Version.';

    INSERT INTO $(CommonSchema).DatabaseVersions
        (Major, Minor, Patch, Build, Description)
    VALUES
        ($(DatabaseVersionMajor), $(DatabaseVersionMinor), $(DatabaseVersionPatch), N'$(DatabaseVersionBuild)', N'$(DatabaseVersionDescription)');
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
