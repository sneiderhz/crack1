CREATE PROCEDURE [dbo].[CrearVenta]
	@id int ,
	@n int,
	@factura int
AS
insert into Venta(barcode_producto,cantidad,id_factura) VALUES ((SELECT barcode from Producto where id_producto= @id), @n , @factura)  
RETURN 0
