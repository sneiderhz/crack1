/*
Script de implementación para SQLDBPrac1

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "SQLDBPrac1"
:setvar DefaultFilePrefix "SQLDBPrac1"
:setvar DefaultDataPath "C:\Users\Sneider\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"
:setvar DefaultLogPath "C:\Users\Sneider\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"

GO
:on error exit
GO
/*
Detectar el modo SQLCMD y deshabilitar la ejecución del script si no se admite el modo SQLCMD.
Para volver a habilitar el script después de habilitar el modo SQLCMD, ejecute lo siguiente:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'El modo SQLCMD debe estar habilitado para ejecutar correctamente este script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'La operación de refactorización Cambiar nombre con la clave e4bce3a7-f961-4c2a-b355-367368b349a0 se ha omitido; no se cambiará el nombre del elemento [dbo].[ALUMNO].[NOMBRE] (SqlSimpleColumn) a Nombre';


GO
PRINT N'La operación de refactorización Cambiar nombre con la clave d3d3b085-59f7-4a48-bf49-3df248007a09 se ha omitido; no se cambiará el nombre del elemento [dbo].[CURSO].[Id] (SqlSimpleColumn) a Cod';


GO
-- Paso de refactorización para actualizar el servidor de destino con los registros de transacciones implementadas
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e4bce3a7-f961-4c2a-b355-367368b349a0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e4bce3a7-f961-4c2a-b355-367368b349a0')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd3d3b085-59f7-4a48-bf49-3df248007a09')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d3d3b085-59f7-4a48-bf49-3df248007a09')

GO

GO
PRINT N'Actualización completada.';


GO
