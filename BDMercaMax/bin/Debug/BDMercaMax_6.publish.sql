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
Se está quitando la columna [dbo].[Facturacion].[id_venta]; puede que se pierdan datos.
*/

IF EXISTS (select top 1 1 from [dbo].[Facturacion])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
/*
Se está quitando la columna [dbo].[LugarStock].[barcode_producto]; puede que se pierdan datos.

Se está quitando la columna [dbo].[LugarStock].[id_lugar]; puede que se pierdan datos.

Debe agregarse la columna [dbo].[LugarStock].[barcode_prodcuto] de la tabla [dbo].[LugarStock], pero esta columna no tiene un valor predeterminado y no admite valores NULL. Si la tabla contiene datos, el script ALTER no funcionará. Para evitar esta incidencia, agregue un valor predeterminado a la columna, márquela de modo que permita valores NULL o habilite la generación de valores predeterminados inteligentes como opción de implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[LugarStock])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
/*
Se está quitando la columna [dbo].[Venta].[id_venta]; puede que se pierdan datos.
*/

IF EXISTS (select top 1 1 from [dbo].[Venta])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
PRINT N'La operación de refactorización Cambiar nombre con la clave 99ff548e-5c03-40be-bce9-13412cf8b7e9 se ha omitido; no se cambiará el nombre del elemento [dbo].[Cliente].[fecha_nacimiento_cliente] (SqlSimpleColumn) a fecha_nacimiento';


GO
PRINT N'La siguiente operación se generó a partir de un archivo de registro de refactorización 6f9b19c1-f367-4d2f-aa25-473bc9494819';

PRINT N'Cambiar el nombre de [dbo].[Personal].[fecha_nacimiento] a fecha_nacimiento_personal';


GO
EXECUTE sp_rename @objname = N'[dbo].[Personal].[fecha_nacimiento]', @newname = N'fecha_nacimiento_personal', @objtype = N'COLUMN';


GO
PRINT N'Quitando Clave externa [dbo].[FK_Facturacion_ToTable_2]...';


GO
ALTER TABLE [dbo].[Facturacion] DROP CONSTRAINT [FK_Facturacion_ToTable_2];


GO
PRINT N'Quitando Clave principal restricción sin nombre en [dbo].[Venta]...';


GO
ALTER TABLE [dbo].[Venta] DROP CONSTRAINT [PK__Venta__459533BF3709121F];


GO
PRINT N'Modificando Tabla [dbo].[Facturacion]...';


GO
ALTER TABLE [dbo].[Facturacion] DROP COLUMN [id_venta];


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[LugarStock]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_LugarStock] (
    [barcode_prodcuto] INT            NOT NULL,
    [cantidad_bodega]  INT            NOT NULL,
    [cantidad_gondola] INT            NOT NULL,
    [seccion_bodega]   NVARCHAR (MAX) NOT NULL,
    [seccion_gondola]  NVARCHAR (MAX) NOT NULL,
    UNIQUE NONCLUSTERED ([barcode_prodcuto] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[LugarStock])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_LugarStock] ([cantidad_bodega], [cantidad_gondola], [seccion_bodega], [seccion_gondola])
        SELECT [cantidad_bodega],
               [cantidad_gondola],
               [seccion_bodega],
               [seccion_gondola]
        FROM   [dbo].[LugarStock];
    END

DROP TABLE [dbo].[LugarStock];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_LugarStock]', N'LugarStock';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Modificando Tabla [dbo].[Venta]...';


GO
ALTER TABLE [dbo].[Venta] DROP COLUMN [id_venta];


GO
-- Paso de refactorización para actualizar el servidor de destino con los registros de transacciones implementadas
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '99ff548e-5c03-40be-bce9-13412cf8b7e9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('99ff548e-5c03-40be-bce9-13412cf8b7e9')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '6f9b19c1-f367-4d2f-aa25-473bc9494819')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('6f9b19c1-f367-4d2f-aa25-473bc9494819')

GO

GO
PRINT N'Actualización completada.';


GO
