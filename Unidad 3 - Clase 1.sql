-- UNIDAD 3

--VISTAS

--Ejemplo 1

create view vis_clientes as

select c.ape_cliente +' '+c.nom_cliente 'Cliente', barrio, calle, altura
from clientes c
join barrios b on c.cod_barrio = b.cod_barrio

select * from vis_clientes --para poder ver la vista


-- Vista de los clientes que no tienen mail

create view vis_noMail as

select c.ape_cliente+' '+c.nom_cliente 'Cliente', c.nro_tel ,c.[e-mail]
from clientes c
where c.[e-mail] is null

select * from vis_noMail

--Modificar

alter view vis_noMail as

select c.ape_cliente+' '+c.nom_cliente 'Cliente', c.nro_tel ,c.[e-mail]
from clientes c
where c.[e-mail] is null
and c.nro_tel is not null

select * from vis_noMail


-- Vista de los clientes que tienen mail

create view vis_siMail as

select c.ape_cliente+' '+c.nom_cliente 'Cliente', c.nro_tel ,c.[e-mail]
from clientes c
where c.[e-mail] is not null

select * from vis_siMail

--Modificar

alter view vis_siMail
as
select c.ape_cliente+' '+c.nom_cliente 'Cliente',c.[e-mail]
from clientes c
where c.[e-mail] is not null

select * from vis_siMail

--Eliminar

drop view vis_siMail

--VISTAS ENCRIPTADAS

create view vis_clientes_barrios (nombre,barrio)
with encryption
as
select ape_cliente+' '+nom_cliente, barrio
from clientes c
join barrios b on b.cod_barrio = c.cod_barrio

select * from vis_clientes_barrios

--Modificar

alter view vis_clientes_barrios
with encryption
as
select cod_cliente 'Codigo', ape_cliente+' '+nom_cliente 'Cliente', barrio 'Barrio'
from clientes c
join barrios b on b.cod_barrio = c.cod_barrio

select * from vis_clientes_barrios


--A ENTREGAR FORO

--2. Cree una vista que liste la fecha, la factura, el código y nombre del vendedor, el
--artículo, la cantidad e importe, para lo que va del año. Rotule como FECHA,
--NRO_FACTURA, CODIGO_VENDEDOR, NOMBRE_VENDEDOR, ARTICULO,
--CANTIDAD, IMPORTE.

create view vis_ej2 as

select f.fecha, f.nro_factura, v.cod_vendedor, ape_vendedor, a.descripcion, d.cantidad, d.pre_unitario*d.cantidad 'Importe'
from facturas f
join vendedores v on f.cod_vendedor = v.cod_vendedor
join detalle_facturas d on d.nro_factura = f.nro_factura
join articulos a on a.cod_articulo = d.cod_articulo
where year(fecha) = year(getdate())

select * from vis_ej2

--3. Modifique la vista creada en el punto anterior, agréguele la condición de que
--solo tome el mes pasado (mes anterior al actual) y que también muestre la
--dirección del vendedor.create view vis_ej3 asselect f.fecha, f.nro_factura, v.cod_vendedor, ape_vendedor,v.calle+' '+cast(v.altura as varchar) 'Direccion',
		a.descripcion, d.cantidad, d.pre_unitario*d.cantidad 'Importe'
from facturas f
join vendedores v on f.cod_vendedor = v.cod_vendedor
join detalle_facturas d on d.nro_factura = f.nro_factura
join articulos a on a.cod_articulo = d.cod_articulo
where datediff(month, fecha, getdate()) = 1

select * from vis_ej3

--PROCEDIMIENTOS ALMACENADOS

--ejemplo clase

create proc pa_articulos_sumaypromedio
@descripcion varchar(100) = '%',
@suma decimal(10,2) output,
@promedio decimal(8,2) output
as
select descripcion,pre_unitario,observaciones
from articulos
where descripcion like @descripcion
select @suma = sum(pre_unitario)
from articulos
where descripcion like @descripcion
select @promedio = avg(pre_unitario)
from articulos
where descripcion like @descripcion

--ejecutar


--FUNCIONES

create function preDesc
(@desc decimal(6,2)=0
)
returns decimal (6,2)
as
begin 
	declare @resultado decimal (6,2)		
	set @resultado = @desc * 0.8
	return @resultado
end

drop function preDesc
--ejecutar
select dbo.preDesc(100)










