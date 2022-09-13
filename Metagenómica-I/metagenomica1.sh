#!/bin/bash

mkdir Output
mkdir Output/QC

for f in $PWD/FastqFiles/*_1*
do
	bn=$(basename ${f%_1.fastq})
	echo $(date) : Realizando QC y filtrado de secuencias en ${bn} ...
	fastp -i FastqFiles/${bn}_1.fastq -o Output/QC/${bn}_1.fastq -q 30
	fastp -i FastqFiles/${bn}_2.fastq -o Output/QC/${bn}_2.fastq -q 30
done

mkdir Output/FeatureTables
mkdir Output/TaxProfiles
mkdir Output/Sams
mkdir Output/Bowtie2Out
#
for f in $PWD/Output/QC/*fast*
do
	bn=$(basename ${f%.fast*})
	echo $(date) : Ejecutando MetaPhlAn3.0 en ${bn} ...
	metaphlan $f --input_type fastq -s Output/Sams/${bn}.sam.bz2 --bowtie2out Output/Bowtie2Out/${bn}.bowtie2.bz2 -o Output/TaxProfiles/${bn}_profile.tsv --biom Output/FeatureTables/${bn}.biom
done
#
mkdir Output/Krona
#
for f in $PWD/Output/TaxProfiles/*
do
	bn=$(basename ${f%_profile.tsv})
	touch Output/Krona/Krona-$bn.tsv
	while read -r linea
	do
        	if [[ ${linea} == *"s__"* ]]
        	then
                	k=$(echo ${linea} | cut -f1 | cut -d '|' -f1 | sed 's/k__//')
                	p=$(echo ${linea} | cut -f1 | cut -d '|' -f2 | sed 's/p__//')
                	c=$(echo ${linea} | cut -f1 | cut -d '|' -f3 | sed 's/c__//')
                	o=$(echo ${linea} | cut -f1 | cut -d '|' -f4 | sed 's/o__//')
                	f=$(echo ${linea} | cut -f1 | cut -d '|' -f5 | sed 's/f__//')
                	g=$(echo ${linea} | cut -f1 | cut -d '|' -f6 | sed 's/g__//')
                	s=$(echo ${linea} | cut -f1 | cut -d '|' -f7 | sed 's/s__//' | cut -d ' ' -f1)
                	abun=$(echo ${linea} | cut -d' ' -f3)
                	echo -e $abun' \t '$k' \t '$p" \t "$c" \t "$o" \t "$f" \t "$g" \t "$s >> Output/Krona/Krona-$bn.tsv
        	fi
	done < $f
#
done
#
mkdir Output/KronaCharts
#
for f in Output/Krona/*
do
	bn=$(basename ${f%.tsv})
	echo $(date) : Obteniendo visualización de ${bn} ...
	ktImportText $f -o Output/KronaCharts/$bn.html
done
#
rm -rf Output/Krona

mkdir Output/Individ
#
for f in Output/TaxProfiles/SRR*_1*
do
	bn=$(basename ${f%_*_profile.tsv})
	echo $(date) : Generando tablas Taxonómicas y de Abundancias de ${bn} ...
	mkdir Output/Individ/${bn}
	touch Output/Individ/${bn}/OTU_${bn}.tsv
	touch Output/Individ/${bn}/TAX_${bn}.tsv
	echo -e "Especie\tAbundancia(%)" >> Output/Individ/${bn}/OTU_${bn}.tsv
	echo -e "Dominio\tPhylum\tClase\tOrden\tFamilia\tGénero\tEspecie" >> Output/Individ/${bn}/TAX_${bn}.tsv
	while read -r line
	do
		if [[ ${line} == *"s__"* ]]
		then
	  		sp=$(echo $line | cut -d ' ' -f1 | cut -d '|' -f7)
	  		ab=$(echo $line | cut -d ' ' -f3- )
	  		echo -e $sp"\t"$ab >> Output/Individ/${bn}/OTU_${bn}.tsv
			do=$(echo $line | cut -d ' ' -f1 | cut -d '|' -f1 | cut -d '_' -f3)
			ph=$(echo $line | cut -d ' ' -f1 | cut -d '|' -f2 | cut -d '_' -f3)
			cl=$(echo $line | cut -d ' ' -f1 | cut -d '|' -f3 | cut -d '_' -f3)
			or=$(echo $line | cut -d ' ' -f1 | cut -d '|' -f4 | cut -d '_' -f3)
			fa=$(echo $line | cut -d ' ' -f1 | cut -d '|' -f5 | cut -d '_' -f3)
			ge=$(echo $line | cut -d ' ' -f1 | cut -d '|' -f6 | cut -d '_' -f3)
			sp=$(echo $line | cut -d ' ' -f1 | cut -d '|' -f7)
			echo -e $do"\t"$ph"\t"$cl"\t"$or"\t"$fa"\t"$ge"\t"$sp >> Output/Individ/${bn}/TAX_${bn}.tsv
		fi
	done < $f
done
#
mkdir Output/AMRFinder
mkdir Output/SPAdes

for f in $PWD/Output/QC/*_1*
do
	bn=$(basename ${f%_1.fastq})
	echo $(date) : Realizando ensamblado de secuencias en ${bn} ...
	python3 /home/mario/SPAdes-3.15.5-Linux/bin/spades.py -k 21,33,55,77 --careful --only-assembler --s1 Output/QC/${bn}_1.fastq -o Output/SPADes/${bn}-SPAdes
	echo $(date) : Ejecutando análisis de resistencia a antibióticos en ${bn} ...
	amrfinder -n Output/SPADes/${bn}-SPAdes/K77/final_contigs.fasta -o Output/AMRFinder/${bn}-AMR_1.tsv
done
