CREATE PROCEDURE [dbo].[LoginCliente]
	@user int
AS
	SELECT cc_cliente,nombre_apellido_cliente FROM cliente WHERE cc_cliente=@user 
RETURN 0
