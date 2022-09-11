--sqlgabineteinformatico.frc.utn.edu.ar
--usuario. alumnolab22
--contrasena. SQL+Alu22 (VER)

use LIBRERIA_114283
go

-- UNION

--Ejemplo 1
select cod_cliente Codigo, nom_cliente + ' ' + ape_cliente Nombre, 'Cliente' Tipo
from clientes 
UNION
select cod_vendedor, nom_vendedor + ' ' + ape_vendedor, 'Vendedor'
from vendedores 
order by 3,2

--Ejemplo 2
select barrio
from clientes c 
join barrios b on b.cod_barrio = c.cod_barrio
UNION ALL
select barrio
from vendedores v 
join barrios b on b.cod_barrio = v.cod_barrio

--Ejemplo 2.1
select barrio Barrio, ape_cliente + ' ' + nom_cliente Nombre, 'Cliente' Tipo
from clientes c 
join barrios b on b.cod_barrio = c.cod_barrio
UNION ALL
select barrio, ape_vendedor + ' ' + nom_vendedor, 'Vendedor'
from vendedores v 
join barrios b on b.cod_barrio = v.cod_barrio
order by 1,3


--CONSULTAS SUMARIAS

--Corregir con libro teorico
select sum(d.cantidad) 'Cant articulos vendidos', sum(distinct f.nro_factura) 'Cant Ventas', max(d.pre_unitario) 'Mayor precio', min(d.pre_unitario) 'Menor precio'
from articulos a, detalle_facturas d, facturas f
where f.nro_factura = d.nro_factura and d.cod_articulo = a.cod_articulo and f.nro_factura = 236


--Promedio
select avg(d.cantidad * d.pre_unitario) 'Promedio por detalle de factura',
	SUM(d.cantidad * d.pre_unitario) / COUNT(distinct f.nro_factura) 'Promedio por factura'	
from detalle_facturas d
join facturas f on d.nro_factura = f.nro_factura and year(f.fecha) = year(GETDATE())-1 


--CASE

--Ejemplo 1
select pre_unitario Promedio,
CASE
	WHEN pre_unitario >= 50
	THEN 'Mayor'
	WHEN pre_unitario < 50
	THEN 'Menor'
END as 'Mayor o Menor'
from detalle_facturas
where pre_unitario > 20
order by Promedio desc

--Ejemplo 2
select d.cantidad 'Cant vendida', a.descripcion,
case
	when d.cantidad <= 10 
	then 'Poco'
	when d.cantidad > 10 
	then 'Mucho'
end as 'Vendido'
from detalle_facturas d, articulos a

--Ejemplo3
select nom_cliente + ' ' + ape_cliente 'Cliente',
case
	when nro_tel is null
	then 'Numero de telefono'
	when [e-mail] is null
	then 'E-Mail'
end as 'Falta Completar'
from clientes
where nro_tel is null or [e-mail] is null
order by 1 desc

--Ejemplo4
select a.descripcion 'Articulo', a.pre_unitario 'Precio', a.stock 'Stock', a.stock_minimo 'Stock minimo',
case
	when a.pre_unitario >= 100 and a.stock < a.stock_minimo then 'Falta Stock'
	when a.stock = 0 then 'Falta Stock'
	else 'Stock suficiente'
end	as 'completar stock'
from articulos a


--Contar Registro

--Calcular Promedios

select avg(d.cantidad * d.pre_unitario) 'Promedio por detalle de factura',
	SUM(d.cantidad * d.pre_unitario) / COUNT(distinct f.nro_factura) 'Promedio por factura'	
from detalle_facturas d
join facturas f on d.nro_factura = f.nro_factura and year(f.fecha) = year(GETDATE())-1 

select avg(d.cantidad * d.pre_unitario) 'Promedio por detalle de factura',
	SUM(d.cantidad * d.pre_unitario) / COUNT(distinct f.nro_factura) 'Promedio por factura'	
from detalle_facturas d, facturas f
where   d.nro_factura = f.nro_factura and year(f.fecha) = year(GETDATE())-1 


--EJERCICIOS DE GUIA

--PROBLEMA 1.1 UNION
--2
--Se quiere saber que vendedores y clientes hay en la empresa; para los casos en
--que su telefono y direccion de e-mail sean conocidos. Se debera visualizar el
--codigo, nombre y si se trata de un cliente o de un vendedor. Ordene por la
--columna tercera y segunda.
select ape_cliente + ' ' + nom_cliente 'Nombre', nro_tel 'Telefono', [e-mail] 'E-mail', 'Cliente' Tipo
from clientes
where nro_tel is not null and [e-mail] is not null
UNION
select ape_vendedor + ' ' + nom_vendedor, nro_tel, [e-mail], 'Vendedor'
from vendedores
where nro_tel is not null and [e-mail] is not null
order by 3,2

--3
--Emitir un listado donde se muestren que articulos, clientes y vendedores hay en
--la empresa. Determine los campos a mostrar y su ordenamiento.select a.descripcion Nombre, 'Articulo' Tipo
from articulos a
union
select c.ape_cliente + ' ' + c.nom_cliente, 'Cliente'
from clientes c
union
select v.ape_vendedor + ' ' + v.nom_vendedor, 'Vendedor'
from vendedores v
order by 2

--4
--Se quiere saber las direcciones (incluido el barrio) tanto de clientes como de
--vendedores. Para el caso de los vendedores, codigos entre 3 y 12. En ambos
--casos las direcciones deberan ser conocidas. Rotule como NOMBRE,
--DIRECCION, BARRIO, INTEGRANTE (en donde indicar si es cliente o vendedor).
--Ordenado por la primera y la ultima columna.
select c.cod_cliente Codigo,c.ape_cliente + ' ' + c.nom_cliente Nombre,c.calle Direccion,b.barrio Barrio, 'Cliente' Integrante
from clientes c
join barrios b on b.cod_barrio = c.cod_barrio
union
select v.cod_vendedor,v.ape_vendedor + ' ' + v.nom_vendedor, v.calle,b.barrio, 'Vendedor'
from vendedores v
join barrios b on b.cod_barrio = v.cod_barrio
where v.cod_vendedor between 3 and 12
order by 5,1



--5. Idem al ejercicio anterior, solo que ademas del codigo, identifique de donde
--obtiene la informacion (de que tabla se obtienen los datos).




--1.3 consultas sumarias