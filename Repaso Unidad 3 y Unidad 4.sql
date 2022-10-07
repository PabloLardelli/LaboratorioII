use LIBRERIA_114283
go

--REPASO UNIDAD 3

--Funciones escalares
create function f_descripcion
(@desc varchar(50)='%')
returns varchar(50)
as
begin
	declare @descripcion varchar(50)
	set @descripcion = (select top 1 descripcion
						from articulos
						where descripcion like '%' + @desc + '%')
	return @descripcion
end


select dbo.f_descripcion('lap')

drop function f_descripcion	

--Funcionescon valores de tabla de varias instrucciones

create function f_descripcion_tabla
(@descripcion varchar(50))
returns @tablaArt TABLE(
descrip varchar(50)
)
as
begin
	insert @tablaArt
	select descripcion
	from articulos
	where descripcion like '%' + @descripcion + '%'
	return
end


select * from dbo.f_descripcion_tabla('lap')


--UNIDAD 4: Programación en SQL Server

--Introduccion a la Programacion

--sentencias de control de flujo. Ej: mostrar los articulo cuya descripcion se ingresa como parametro

create procedure sp_articulos_descripcion
@descripcion varchar(100) = null
as
if @descripcion is null
begin
	select 'Debe indicar una descripcion'
	return
end

select descripcion, pre_unitario, observaciones
from articulos
where descripcion like '%' + @descripcion + '%'


exec sp_articulos_descripcion 'lapiz'

-- SP: devolver articulos con un parametro de stock


--Manejo de Errores

--Ej: mostrar el error en el caso de una division por cero

begin try
	select 15/0 as error
end try
begin catch
	select 'Se produjo el siguiente error',
		error_number() as Numero,
		error_state() as Estado,
		error_severity() as Gravedad,
		error_procedure() as Procedimiento,
		error_line() as Linea,
		error_message() as Mensaje
end catch


--@@ERROR. Ej:mostrar el numero de error en el caso de una division por cero

declare @err int
select 1/0 as error
select @err = @@error
if @err <> 0
	print 'Nro. De error es: ' + ltrim(str(@err))



--Todos los errores
select * from sys.messages 


--Ejercicio 4.3.2.a

--2. Programar funciones que permitan realizar las siguientes tareas:
--a. Devolver una cadena de caracteres compuesto por los siguientes datos: 
--Apellido, Nombre, Telefono, Calle, Altura y Nombre del Barrio, de un determinado cliente, que se puede informar por codigo de cliente
--o email.
alter function f_devolverCadena
(@codigo int)
returns int
as 
begin
	declare @cliente int 
	set @cliente = (select CONCAT(ape_cliente,' ',nom_cliente,' ',convert(varchar(50),nro_tel),' ',calle,' ',convert(varchar(50),altura),' ',barrio) 
					from clientes c
					join barrios b on c.cod_barrio = b.cod_barrio
					where c.cod_cliente = @codigo)
	return @cliente
end


select dbo.f_devolverCadena(2)





