-- GROUP BY

--ejemplo clase
select v.cod_vendedor 'Codigo', v.ape_vendedor 'Apellido', sum(cantidad*pre_unitario) 'Total'
from facturas f
join detalle_facturas d on f.nro_factura = d.nro_factura
join vendedores v on f.cod_vendedor = v.cod_vendedor
group by v.cod_vendedor, v.ape_vendedor

--Ejemplo 2 - Cual fue el monto vendido por cada vendedor a cada cliente el año pasado
select v.ape_vendedor 'Vendedor', c.ape_cliente 'Cliente', sum(d.cantidad*d.pre_unitario) 'Total Vendido'
from facturas f
join detalle_facturas d on f.nro_factura = d.nro_factura
join vendedores v on v.cod_vendedor = f.cod_vendedor
join clientes c on c.cod_cliente = f.cod_cliente
where year(f.fecha) = year(getdate())-1 
group by v.ape_vendedor, c.ape_cliente
order by 1, 2

--HAVING CLASE
--Ejercicio clase
select nro_factura, sum(pre_unitario*cantidad) 'Total'
from detalle_facturas
group by nro_factura
having sum(pre_unitario*cantidad) between 2500 and 3000

--Ejemplo 2. que vendedores vendieron menos de 20000 en total, el año anterior y cual es el monto
select v.ape_vendedor Vendedor, sum(d.pre_unitario*d.cantidad)
from facturas f
join detalle_facturas d on f.nro_factura = d.nro_factura
join vendedores v on f.cod_vendedor = v.cod_vendedor
where year(f.fecha) = year(GETDATE())-1
group by v.ape_vendedor
having sum(d.pre_unitario*d.cantidad) < 20000









--GUIA UNIDAD 1

--Ejercicio 1-2 
select f.nro_factura, f.fecha, sum(d.cantidad) 'Cantidades Vend.', count(d.cantidad) 'Cant Registros por detalle' ,sum(d.pre_unitario*d.cantidad) 'Importe Total' 
from facturas f
join detalle_facturas d on f.nro_factura = d.nro_factura 
join articulos a on d.cod_articulo = a.cod_articulo
where year(f.fecha) = year(getdate()) 
Group by f.nro_factura, f.fecha


--Ejercicio 1-3
select f.fecha Dias, sum(d.pre_unitario*d.cantidad) 'Fact. diaria'
from facturas f
join detalle_facturas d on f.nro_factura = d.nro_factura
where f.fecha = '15/02/2008'
group by f.fecha
order by 1

select month(f.fecha) Meses, sum(d.pre_unitario*d.cantidad) 'Fact. Mensual'
from facturas f
join detalle_facturas d on f.nro_factura = d.nro_factura
where month(f.fecha) = month(getdate())
group by month(f.fecha)
order by 1

select year(f.fecha) Año, sum(d.pre_unitario*d.cantidad) 'Fact. Anual' 
from facturas f
join detalle_facturas d on f.nro_factura = d.nro_factura
where year(f.fecha) = year(getdate())
group by year(f.fecha)
order by 1

--Ejercicio 1-3 BIS
select sum(pre_unitario*cantidad) 'Total', day(fecha) 'Lapso', 'DIA' Tipo
from detalle_facturas d
join facturas f on d.nro_factura = f.nro_factura
where day(fecha) = day(GETDATE()) and  month(fecha) = month(GETDATE())-1 and year(fecha) = year(GETDATE())
group by day(fecha)
UNION
select sum(pre_unitario*cantidad), month(fecha), 'MES'
from detalle_facturas d
join facturas f on d.nro_factura = f.nro_factura
where month(fecha) = month(getdate()) and year(fecha) = year(getdate())
group by month(fecha)
UNION
select sum(pre_unitario*cantidad), year(fecha), 'AÑO'
from detalle_facturas d
join facturas f on d.nro_factura = f.nro_factura
where year(fecha) = year(getdate())
group by year(fecha)
order by Tipo

--Ejercicio 1-4
select f.fecha Fecha, count(f.nro_factura) 'Cant. de facturas'
from facturas f
where month(f.fecha) not in(1,7,12) and year(f.fecha) = year(GETDATE())
group by f.fecha
order by 2 desc, 1

--Ejercicio 1-5 VER
select v.cod_vendedor, v.ape_vendedor, f.fecha, c.ape_cliente ,count(f.nro_factura) 'Cant', sum(d.pre_unitario*d.cantidad)/count(distinct f.nro_factura) 'Fact Prom' 
from facturas f
join detalle_facturas d on f.nro_factura = d.nro_factura
join clientes c on f.cod_cliente = c.cod_cliente
join vendedores v on f.cod_vendedor = v.cod_vendedor
where v.cod_vendedor > 2
group by v.cod_vendedor, v.ape_vendedor, f.fecha, c.ape_cliente
order by 3, 4
