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
/*
Se está quitando la columna [dbo].[LugarStock].[barcode_producto]; puede que se pierdan datos.

Debe agregarse la columna [dbo].[LugarStock].[barcode_prodcuto] de la tabla [dbo].[LugarStock], pero esta columna no tiene un valor predeterminado y no admite valores NULL. Si la tabla contiene datos, el script ALTER no funcionará. Para evitar esta incidencia, agregue un valor predeterminado a la columna, márquela de modo que permita valores NULL o habilite la generación de valores predeterminados inteligentes como opción de implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[LugarStock])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
PRINT N'Iniciando recompilación de la tabla [dbo].[LugarStock]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_LugarStock] (
    [id_lugar]         INT            NOT NULL,
    [barcode_prodcuto] INT            NOT NULL,
    [cantidad_bodega]  INT            NOT NULL,
    [cantidad_gondola] INT            NOT NULL,
    [seccion_bodega]   NVARCHAR (MAX) NOT NULL,
    [seccion_gondola]  NVARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([id_lugar] ASC),
    UNIQUE NONCLUSTERED ([barcode_prodcuto] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[LugarStock])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_LugarStock] ([id_lugar], [cantidad_bodega], [cantidad_gondola], [seccion_bodega], [seccion_gondola])
        SELECT   [id_lugar],
                 [cantidad_bodega],
                 [cantidad_gondola],
                 [seccion_bodega],
                 [seccion_gondola]
        FROM     [dbo].[LugarStock]
        ORDER BY [id_lugar] ASC;
    END

DROP TABLE [dbo].[LugarStock];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_LugarStock]', N'LugarStock';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creando Vista [dbo].[VerProducto]...';


GO
CREATE VIEW [dbo].[VerProducto]
	AS SELECT nombre_producto,precio FROM [Producto]
GO
PRINT N'Creando Procedimiento [dbo].[VerProductoBodega]...';


GO
CREATE PROCEDURE [dbo].[VerProductoBodega]
	@codProd int 
AS
    SELECT cantidad_bodega, seccion_bodega FROM LugarStock WHERE barcode_prodcuto=@codProd 
RETURN 0
GO
PRINT N'Creando Procedimiento [dbo].[VerPuntos]...';


GO
CREATE PROCEDURE [dbo].[VerPuntos]
	@user int
AS
    SELECT puntos_acumulados FROM Cliente WHERE cc_cliente=@user
RETURN 0
GO
PRINT N'Actualización completada.';


GO
