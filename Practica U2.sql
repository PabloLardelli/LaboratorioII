use LIBRERIA_LABII
go
--Ejercicio 2.1.1
--Se solicita un listado de artículos cuyo precio es inferior al promedio de precios de todos los artículos

select a.cod_articulo, a.descripcion, a.pre_unitario
from articulos a
where a.pre_unitario <  (select avg(a.pre_unitario) 
						 from articulos a)
order by 1

--Ejercicio 2.1.2
--Emitir un listado de los artículos que no fueron vendidos este año. 
--En ese listado solo incluir aquellos cuyo precio unitario del artículo oscile entre 50 y 100

select a.cod_articulo, a.descripcion, a.pre_unitario
from articulos a
where a.cod_articulo not in (select d.cod_articulo
							from detalle_facturas d
							join facturas f on d.nro_factura = f.nro_factura
							where year(f.fecha) = year(GETDATE()))
and a.pre_unitario between 50 and 100

--Ejercicio 2.1.3
--Genere un reporte con los clientes que vinieron más de 2 veces el año pasado

select c.cod_cliente, ape_cliente + ' ' + nom_cliente Cliente
from clientes c
where c.cod_cliente in (select cod_cliente
					from facturas 
					where year(fecha) = year(GETDATE())-1
					group by cod_cliente
					having count(cod_cliente) > 2)

--control: select cod_cliente from facturas where year(fecha) = year(GETDATE())-1 order by 1

--Ejercicio 2.1.4
--Se quiere saber qué clientes no vinieron entre el 12/12/2015 y el 13/7/2020

select cod_cliente, ape_cliente + ' ' + nom_cliente Cliente
from clientes
where cod_cliente not in (select cod_cliente 
							from facturas
							where fecha between '2015/12/12' and '2020/7/13')

--Ejercicio 2.1.5
--Listar los datos de las facturas de los clientes que solo vienen a comprar
--en febrero es decir que todas las veces que vienen a comprar haya sido en el mes de febrero (y no otro mes)

select f.nro_factura, c.cod_cliente, ape_cliente + ' ' + nom_cliente Cliente, f.fecha
from clientes c
join facturas f on c.cod_cliente = f.cod_cliente
where 2 = all (select MONTH(fecha)
				from facturas f
				where c.cod_cliente = f.cod_cliente) 
				

--Ejercicio 2.1.6
--Mostrar los datos de las facturas para los casos en que por año se hayan hecho menos de 9 facturas. 

select f.nro_factura, ape_cliente + ' ' + nom_cliente Cliente, year(f.fecha) 'Año', f.fecha 'Fecha' 
from facturas f
join clientes c on c.cod_cliente = f.cod_cliente
where 9 >		(select count(*)
				from facturas
				where year(f.fecha) = year(fecha)
				)

--Ejercicio 2.1.7
--Emitir un reporte con las facturas cuyo importe total haya sido superior a
--1.500 (incluir en el reporte los datos de los artículos vendidos y los importes)

select f.nro_factura Factura, f.fecha 'Fecha', (d.cantidad*d.pre_unitario) 'Importe'
from facturas f
join detalle_facturas d on f.nro_factura = d.nro_factura
where 1500 < (select sum(d.cantidad*d.pre_unitario) 
				from detalle_facturas
				where d.nro_factura = nro_factura)
order by 1


--Ejercicio 2.1.8
--Se quiere saber qué vendedores nunca atendieron a estos clientes: 1 y 6. Muestre solamente el nombre del vendedor

select v.nom_vendedor+' '+v.ape_vendedor Vendedor
from vendedores v
where cod_vendedor not in (select cod_vendedor
							from facturas f
							where cod_cliente in (1,6)
							and v.cod_vendedor = f.cod_vendedor)

--resolucion profe kunda

select v.nom_vendedor+' '+v.ape_vendedor Vendedor
from vendedores v
where  not exists (select cod_vendedor
					from facturas f
					where cod_cliente in (1,6)
					and v.cod_vendedor = f.cod_vendedor)
	

--Ejercicio 2.1.9
--Listar los datos de los artículos que superaron el promedio del Importe de ventas de $ 1.000

select a.cod_articulo, a.descripcion
from articulos a
where a.cod_articulo in (select cod_articulo
						from detalle_facturas d
						where a.cod_articulo = d.cod_articulo
						group by cod_articulo
						having avg(pre_unitario*cantidad)>1000)
order by 1					

--resolucion profe kunda

select a.cod_articulo, a.descripcion
from articulos a
where 1000 < (select avg(d.pre_unitario*d.cantidad)
				from detalle_facturas d
				where cod_articulo = a.cod_articulo)


--Ejercicio 2.2.1
--Se quiere saber ¿cuándo realizó su primer venta cada vendedor? y ¿cuánto fue el importe total de las ventas que ha realizado? Mostrar estos
--datos en un listado solo para los casos en que su importe promedio de vendido sea superior al importe promedio general (importe promedio de
--todas las facturas)

select v.ape_vendedor+', '+v.nom_vendedor 'Vendedor', min(f.fecha) '1° Venta', sum(d.cantidad*d.pre_unitario) 'Total Ventas' from vendedores vjoin facturas f on f.cod_vendedor = v.cod_vendedorjoin detalle_facturas d on d.nro_factura = f.nro_facturagroup by v.ape_vendedor+', '+v.nom_vendedorhaving sum(d.cantidad*d.pre_unitario) > (select sum(d.cantidad*d.pre_unitario)/count(distinct d.nro_factura)																from detalle_facturas d)--Ejercicio 2.2.2--Liste los montos totales mensuales facturados por cliente y además del
--promedio de ese monto y el promedio de precio de artículos Todos esto
--datos correspondientes a período que va desde el 1° de febrero al 30 de
--agosto del 2014. Sólo muestre los datos si esos montos totales son superiores o iguales al promedio globalselect c.ape_cliente+', '+c.nom_cliente Cliente, month(f.fecha) 'Mes', sum(d.cantidad*d.pre_unitario) 'Total Ventas',
avg(d.pre_unitario) 'Promedio Precio Art.'
from facturas f
join clientes c on f.cod_cliente = c.cod_cliente
join detalle_facturas d on d.nro_factura = f.nro_factura
join articulos a on a.cod_articulo = d.cod_articulo
--where f.fecha between '2014/02/01' and '2014/08/30'
group by c.ape_cliente+', '+c.nom_cliente, month(f.fecha)
having sum(d.cantidad*d.pre_unitario) >= (select sum(d.cantidad*d.pre_unitario)/count(distinct d.nro_factura)											from detalle_facturas d)
order by 1


----Ejercicio 2.2.3
--Por cada artículo que se tiene a la venta, se quiere saber el importe
--promedio vendido, la cantidad total vendida por artículo, para los casos
--en que los números de factura no sean uno de los siguientes: 2, 10, 7, 13,
--22 y que ese importe promedio sea inferior al importe promedio de ese artículo

select a.descripcion, avg(d.pre_unitario*d.cantidad) 'Promedio vendido x art.', sum(d.cantidad) 'Cant. vendida x art.'
from articulos a
join detalle_facturas d on a.cod_articulo = d.cod_articulo
where d.nro_factura not in (2,10,7,13,22)
group by a.descripcion
having avg(d.pre_unitario*d.cantidad) < (select avg(d.pre_unitario*d.cantidad)
										from detalle_facturas d)
order by 2 desc







