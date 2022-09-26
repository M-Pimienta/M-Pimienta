-- consulta 1
select id, name, status, modified_on -- parent_id, source 
from compounds						 -- para comprobar que está correcta la consulta
where (parent_id is null) and (source in ('Rhea', 'IntEnz'));

-- consulta 2
select *
from compounds
where star < 3 and
	  name like '%phosphatid%';

-- consulta 3
select id, chebi_accession, source, status
from compounds
where source in (select source
				from names 
				where source like '%chem%');
           
-- consulta 4
select datatype, count(*) as cantidad
from comments
group by datatype
order by datatype;

-- consulta 5
select count(*) as nreferencias, compound_id -- reference_db_name, (select star from compounds where id=reference.compound_id)
from reference								 -- para comprobar si se ha realizado correctamente la consulta
where reference_db_name = 'Patent' and
	  compound_id in (select id 
					  from compounds
                      where star = 3)
group by compound_id
having count(*) > 60
order by nreferencias ASC;

-- consulta 6
select avg(mass_value) as masa_media, compound_id -- (select status from compounds where id = mass.compound_id) status
from mass							-- para comprobar si la consulta es correcta
where compound_id in (select id
					  from compounds
                      where status in ('C', 'D'))
group by compound_id
order by masa_media desc;

-- consulta 7
select compound_id from formula where formula_value is null; -- comprobar si hay compuestos sin formula
select compound_id from charge where charge_value = 0; -- comprobar si hay compuestos sin carga definida

select id, chebi_accession, (select formula_value from formula where compound_id=compounds.id limit 1) as formula -- (select charge_value from charge where compound_id=compounds.id limit 1) as carga
from compounds			   -- para comprobar si la consulta es correcta
where id in (select compound_id
			 from formula) and
	  id in (select compound_id
			 from charge
		     where charge_value = 0)
order by id; -- da igual como ordenarlo, son equivalentes los valores de salida

-- consulta 8
select id, name, source, ifnull((select vertice_ref from vertice where compound_id=compounds.id), 'Sin vertice') vertice
from compounds
where star = 2
order by id;

-- consulta 9
select round(max(mass_value), 4) as max_mass, (select status from compounds where id = mass.compound_id) as tipo
from mass
where mass_value > 0
group by tipo
order by max_mass;

select status from compounds group by status; -- ver cuantos tipos de estados (status) hay
select status, count(*) from compounds where status in ('D', 'O') group by status; -- ver cuantos compuestos con estados C o D (sin masa)

-- consulta 10
select  N.name nombre, T.text comentario, C.id, C.status, C.star
from compounds C, names N, comments T
where C.star < 3 and
	  C.id=N.compound_id and
      C.id=T.compound_id
order by nombre;






