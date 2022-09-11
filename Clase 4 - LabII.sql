--SUBCONSULTAS

--Ejemplo 1: listado de artículos cuyos precios son menores al promedio
select a.descripcion, a.pre_unitario
from articulos a
where a.pre_unitario < (select avg(pre_unitario) from articulos) 
order by 2 desc

--IN

--Ejemplo 2 : Listar los clientes que compraron este año
select cod_cliente 'Código', ape_cliente + ' ' + nom_cliente 'Cliente'
from clientes c
where cod_cliente in (select cod_cliente from facturas f where year(f.fecha) = year(GETDATE()) )

--Ejemplo 3 : Listar los clientes que compraron el año pasado
select cod_cliente 'Código', ape_cliente + ' ' + nom_cliente 'Cliente'
from clientes c
where cod_cliente not in (select cod_cliente from facturas f where year(f.fecha) = year(GETDATE())-1 )

--EXISTS

--Ejemplo 4: Listar los datos de los clientes que compraron este año
select cod_cliente Codigo, ape_cliente + ' ' + nom_cliente 'Cliente'
from clientes c
where exists (select cod_cliente from facturas f where f.cod_cliente = c.cod_cliente and year(fecha) = year(GETDATE()))

--Ejemplo 5: Listar los datos de los clientes que no compraron el año pasado
select cod_cliente Codigo, ape_cliente + ' ' + nom_cliente 'Cliente'
from clientes c
where not exists (select c.cod_cliente from facturas f where f.cod_cliente = c.cod_cliente and year(fecha) = year(GETDATE())-1)

--ANY, ALL

--Ejemplo 6: listar los clientes que alguna vez compraron un producto menor a $10
select c.cod_cliente Codigo, c.ape_cliente + ' ' + c.nom_cliente 'Cliente'
from clientes c
where 10 < any (select pre_unitario 
				from facturas f 
				join detalle_facturas d on f.nro_factura = d.nro_factura
				where c.cod_cliente = f.cod_cliente)

--Ejemplo 7: listar los clientes que siempre fueron atendidos por el vendedor 3
select c.cod_cliente Codigo, c.ape_cliente + ' ' + c.nom_cliente 'Cliente'
from clientes c
where 3 = all (select f.cod_vendedor
			   from facturas f 
			   where c.cod_cliente = f.cod_cliente)

--Guia 2

--Ejercicio 2: Emitir un listado de los artículos que no fueron vendidos este año. En ese
--listado solo incluir aquellos cuyo precio unitario del artículo oscile entre
--50 y 100. 

select a.cod_articulo Codigo, a.descripcion Articulo, a.pre_unitario Precio
from articulos a
where a.pre_unitario between 50 and 100
  and a.cod_articulo not in (select d.cod_articulo
						     from detalle_facturas d
						     join facturas f on d.nro_factura = f.nro_factura
						     where year(f.fecha) = year(GETDATE()))

--Ejercicio 3: Genere un reporte con los clientes que vinieron más de 2 veces el año pasado

select c.cod_cliente, ape_cliente + ' ' + nom_cliente Cliente
from clientes c
where c.cod_cliente in (select cod_cliente
					from facturas 
					where year(fecha) = year(GETDATE())-1
					group by cod_cliente
					having count(cod_cliente) > 2)


--Ejercicio para mandar al profe
-- Guia  1  Pág. 9  Ej. 14  
--ccanovas@frc.utn.edu.ar

--14.Se quiere saber la cantidad de veces y la última vez que vino el cliente de
--apellido Abarca y cuánto gastó en total.
select ape_cliente Cliente ,count(distinct f.nro_factura) 'Cant. de veces', max(f.fecha) 'Ultima Fecha', sum(d.cantidad*d.pre_unitario) 'Total Gastado'
from facturas f
join clientes c on f.cod_cliente = c.cod_cliente
join detalle_facturas d on f.nro_factura = d.nro_factura
where ape_cliente = 'Abarca'
group by ape_cliente


