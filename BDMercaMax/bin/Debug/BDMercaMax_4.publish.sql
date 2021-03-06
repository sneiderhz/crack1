/*
Script de implementación para BDMercaMax

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "BDMercaMax"
:setvar DefaultFilePrefix "BDMercaMax"
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
PRINT N'La siguiente operación se generó a partir de un archivo de registro de refactorización 7a1cf429-bffb-441b-a34b-4672c0020ebb';

PRINT N'Cambiar el nombre de [dbo].[LugarStock].[barcode_prodcuto] a barcode_producto';


GO
EXECUTE sp_rename @objname = N'[dbo].[LugarStock].[barcode_prodcuto]', @newname = N'barcode_producto', @objtype = N'COLUMN';


GO
PRINT N'Modificando Procedimiento [dbo].[VerProductoBodega]...';


GO
ALTER PROCEDURE [dbo].[VerProductoBodega]
	@codProd int 
AS
    SELECT cantidad_bodega, seccion_bodega FROM LugarStock WHERE barcode_producto=@codProd 
RETURN 0
GO
-- Paso de refactorización para actualizar el servidor de destino con los registros de transacciones implementadas
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7a1cf429-bffb-441b-a34b-4672c0020ebb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7a1cf429-bffb-441b-a34b-4672c0020ebb')

GO

GO
PRINT N'Actualización completada.';


GO
