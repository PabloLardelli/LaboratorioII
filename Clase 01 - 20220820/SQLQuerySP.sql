CREATE PROCEDURE ARTICULOS_MAY_70
AS
SELECT descripcion,pre_unitario
from articulos
where pre_unitario < 70

exec ARTICULOS_MAY_70

CREATE PROCEDURE ARTICULOS_ENTRE_80_120
AS
SELECT descripcion,pre_unitario
from articulos
where pre_unitario BETWEEN 80 AND 120

exec ARTICULOS_ENTRE_80_120

ALTER PROCEDURE ARTICULOS_MAY_70
AS
SELECT descripcion,pre_unitario
from articulos
where pre_unitario < 80

exec ARTICULOS_MAY_70


--SP con parametros

CREATE PROC ARTICULOS_MAY_70_PARAMETROS
@precioLimite int = 70 -->Valor por defecto
AS
SELECT descripcion,pre_unitario
from articulos
where pre_unitario < @precioLimite

exec ARTICULOS_MAY_70_PARAMETROS

CREATE PROC ARTICULOS_ENTRE_PARAMETROS
@precio1 int, @precio2 int
AS
SELECT descripcion,pre_unitario
from articulos
where pre_unitario between @precio1 and @precio2

exec ARTICULOS_ENTRE_PARAMETROS 70,100
exec ARTICULOS_ENTRE_PARAMETROS 100,150
exec ARTICULOS_ENTRE_PARAMETROS 50,100
exec ARTICULOS_ENTRE_PARAMETROS @precio1 =50, @precio2=100


-- SP CON PARAMETRO DE SALIDA

--se crea el procedimiento almacenado
create proc precio_prom_parametro
@promedio decimal (10,2) output --se crea variable de salida 
as 
select @promedio = avg(pre_unitario) --se asigna el promedio que se busco en la varible de salida
from articulos

--se guarda el valor en una variable de salida y se muestra
declare @prom decimal (10,2) --se crea una variable donde se guarda el resultado obtenido en el SP
exec precio_prom_parametro @prom output --se ejecuta el SP
print @prom --lo muestra por pantalla


--ejemplo 2
--SP
create proc pa_articulos_sumaypromedio
@descripcion varchar(100) = '%',
@suma decimal (10,2) output,
@promedio decimal (8,2) output
as
select descripcion, pre_unitario, observaciones
from articulos
where descripcion like @descripcion

select @suma = sum(pre_unitario)
from articulos
where descripcion like @descripcion

select @promedio = avg(pre_unitario)
from articulos
where descripcion like @descripcion

--ejecutar
declare @s decimal (10,2), @p decimal(8,2)
exec pa_articulos_sumaypromedio 'lápiz%', @s output, @p output
select @s as total, @p as promedio
