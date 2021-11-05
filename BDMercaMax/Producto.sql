CREATE TABLE [dbo].[Producto]
(
	[id_producto] INT NOT NULL PRIMARY KEY, 
    [nombre_producto] VARCHAR(MAX) NOT NULL, 
    [fecha_llegada] DATE NOT NULL, 
    [fecha_nacimiento] DATE NOT NULL, 
    [barcode] INT NOT NULL, 
    [precio] DECIMAL(18, 2) NOT NULL, 
    [nit] INT NOT NULL, 
    [id_tipo] INT NOT NULL
)
