-- consulta 1
create view consulta1 (id, nombre, fecha_modificacion) as
select id, name, status, modified_on -- parent_id, source 
from compounds						 -- para comprobar que está correcta la consulta
where (parent_id is null) and (source in ('Rhea', 'IntEnz'));

-- consulta 2
create view consulta2 as
select *
from compounds
where star < 3 and
	  name like '%phosphatid%';
      
-- consulta 3
create view consulta3 as
select id, chebi_accession, source, status
from compounds
where source in (select source
				from names 
				where source like '%chem%');

-- consulta 4
create view consulta4 (tipo_de_dato, cantidad) as 
select datatype, count(*) as cantidad
from comments
group by datatype
order by datatype;

-- consulta 5
create view consulta5 (numero_referencias, id_compuesto) as
select count(*) as nreferencias, compound_id 
from reference								
where reference_db_name = 'Patent' and
	  compound_id in (select id 
					  from compounds
                      where star = 3)
group by compound_id
having count(*) > 60
order by nreferencias ASC;

-- consulta 6
create view consulta6 (masa_media, id_componente) as 
select avg(mass_value) as masa_media, compound_id 
from mass							
where compound_id in (select id
					  from compounds
                      where status in ('C', 'D'))
group by compound_id
order by masa_media desc;

-- consulta 7
create view consutla7 (id_componente, chebi_accession, formula) as
select id, chebi_accession, (select formula_value from formula where compound_id=compounds.id limit 1) as formula
from compounds			  
where id in (select compound_id
			 from formula) and
	  id in (select compound_id
			 from charge
		     where charge_value = 0)
order by id;

-- consulta 8
create view consulta8 (id_componente, nombre, fuente, vertice) as
select id, name, source, ifnull((select vertice_ref from vertice where compound_id=compounds.id), 'Sin vertice') vertice
from compounds
where star = 2
order by id;

-- consulta 9
create view consulta9 (masa_maxima, estado) as
select round(max(mass_value), 4) as max_mass, (select status from compounds where id = mass.compound_id) as tipo
from mass
where mass_value > 0
group by tipo
order by max_mass;

-- consulta 10
create view consulta10 as
select  N.name nombre, T.text comentario, C.id, C.status, C.star
from compounds C, names N, comments T
where C.star < 3 and
	  C.id=N.compound_id and
      C.id=T.compound_id
order by nombre;

