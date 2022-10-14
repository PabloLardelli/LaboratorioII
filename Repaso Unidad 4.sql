-- REPASO UNIDAD 4

--Funciones
--ej: una funcion que devuelva el largo de una cadena

create function f_devuelve_largo
(@cadena varchar(100))
returns varchar(100)
as
begin
	declare @largo int
	set @largo = len(@cadena)
	return @largo
end


select dbo.f_devuelve_largo('cadena') 'Largo de Columna'

--consulta de articulos con la función anterior
select descripcion, dbo.f_devuelve_largo(descripcion) 'Largo de Columna'
from articulos


--ej: funcion que recibiendo un año devuelva el cliente, el vendedor, el nro de factura de ese año

create function f_factura_datos
(@año int)
returns TABLE
as
	 return(select f.nro_factura, c.ape_cliente, v.ape_vendedor, f.fecha
			from facturas f
			join clientes c on  c.cod_cliente = f.cod_cliente
			join vendedores v on v.cod_vendedor = f.cod_vendedor
			where year(f.fecha) = @año)


select * from dbo.f_factura_datos(2019)


--Ej: funcion que recibiendo un monto en pesos y una cotizacion en dolar, me devuelva el monto en dolar

create function f_devuelve_dolar
(@pesos decimal(8,2),
@cotizacion decimal(8,2))
returns decimal(8,2)
as
begin
	declare @valor decimal(8,2)
	set @valor = @pesos / @cotizacion
	return @valor
end

select dbo.f_devuelve_dolar (200,174.5) 'Cotización dolar'


--ej: funcion que devuelva la cotizacion en pesos o dolares dependiendo de un parametro de entrada

alter function f_devuelve_dolar_o_pesos
(@pesos decimal(8,2),
@cotizacion decimal(8,2),
@moneda varchar(50))
returns decimal(8,2)
as
begin
	declare @valor decimal(8,2)
if(@moneda = 'dolar')
	set @valor = @pesos / @cotizacion
	
if(@moneda = 'pesos')
	set @valor = @pesos * @cotizacion

return @valor
end


select dbo.f_devuelve_dolar_o_pesos (200,174.5,'pesos') 'Cotización moneda'


--TRIGGERS

--ej: controlar que la cantidad vendida sea menor o igual al stock disponible

create trigger dis_control_stock
on detalle_facturas
for insert
as
	declare @stock int
	select @stock = stock
	from articulos
	join inserted on inserted.cod_articulo = articulos.cod_articulo
	
	if(@stock >= (select cantidad from inserted))
		update articulos
		set stock = stock - inserted.cantidad
		from articulos
		join inserted on inserted.cod_articulo = articulos.cod_articulo
	else
		begin 
		raiserror('El stock es menor a la cantidad solicitada', 16,1) --severidad: 16, estado: 1
		rollback transaction
		end

--Cuando queremos ingresar nos tira error porque insertamos más que lo que hay en stock
insert into detalle_facturas(nro_factura,cod_articulo,pre_unitario,cantidad)
					values	(56         , 1          , 160          , 180      )



--TABLAS TEMPORALES
-- me sirve para escenarios donde tengo muchas operaciones, 
--ej. trabajar sobre datos de dos días, trabajo sobre eso para ese momento y no lo uso más (se borra)

create table ##TablaTemporal -- creo tabla temporal
(cod int,
nombre varchar(50)
)

insert into ##TablaTemporal --cargo datos
			values (1,'Jose')

select * from tempdb.sys.objects  --muestro