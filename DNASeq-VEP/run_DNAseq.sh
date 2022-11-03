#!/bin/bash

#Crear árbol de directorios
mkdir $PWD/DNASeq
mkdir $PWD/DNASeq/tmp

#Tratamiento de muestras individuales
for f in $PWD/VCF/*
do
	#Creación directorio individual
	bn=$(basename ${f%.vcf}) #Hay que definir qué parte del nombre del fichero .VCF se quiere tomar.
	mkdir $PWD/DNASeq/${bn}

	#Filtro I: GQ y RD
	echo $(date) : Filtrando GQ y RD en $PWD/VCF/${bn}.vcf ...
	gatk VariantFiltration -V $PWD/VCF/${bn}.vcf -O $PWD/DNASeq/tmp/FiltRDGQ.vcf --filter-expression "DP < 10" --filter-name "RDPASS" --genotype-filter-expression "GQ < 20" --genotype-filter-name "GQPASS"

	#Se genera un VCF con las líneas filtradas (valores RDPASS y GQPASS). Ahora se eliminan esas líneas.
	while read -r line
	do
		if [[ ${line} != *"DPPASS"*"GQPASS"* ]]
		then
			echo $line >> $PWD/DNASeq/tmp/FILTRO1.vcf
		fi
	done < $PWD/DNASeq/tmp/FiltRDGQ.vcf
	rm $PWD/DNASeq/tmp/FiltRDGQ.vcf

	#Anotación de variantes con Ensembl VEP
	echo $(date) : Ejecutando Ensembl VEP en ${bn} ...
	vep --af_gnomadg --buffer_size 25000 --failed 1 --species homo_sapiens --symbol --plugin CADD,/home/mario/ensembl-vep/CADD_db/whole_genome_SNVs.tsv.gz --no_intergenic --cache --force_overwrite --input_file $PWD/DNASeq/tmp/FILTRO1.vcf --tab -o $PWD/DNASeq/tmp/VEP.tsv --fork 5 --variant_class --pick --pick_order canonical,tsl,biotype,appris --no_stats
	rm $PWD/DNASeq/tmp/FILTRO1.vcf

	#Filtro II: GnomAD_AF < 0.01 (v3.1.2)
	echo $(date) : Filtrando MAF < 0.01 GnomAD v3.1.2 ...
	tr " " "\t" < $PWD/DNASeq/tmp/VEP.tsv | tr -s "\t" > $PWD/DNASeq/${bn}/${bn}_FILT1_RDGQ.tsv
	rm $PWD/DNASeq/tmp/*
	awk '$22 < 0.01 {print $0}' $PWD/DNASeq/${bn}_FILT1_RDGQ.tsv > $PWD/DNASeq/tmp/F2.tsv
	tr " " "\t" < $PWD/DNASeq/tmp/F2.tsv | tr -s "\t" > $PWD/DNASeq/${bn}/${bn}_FILT2_MAF.tsv
	rm $PWD/DNASeq/tmp/F2.tsv

	#Filtro III: CADD Phred > 15 (v1.6)
	echo $(date) : Filtrando CADD Score > 15  v1.6 ... 
	awk '$37 > 15 {print $0}' $PWD/DNASeq/${bn}/${bn}_FILT2_MAF.tsv > $PWD/DNASeq/tmp/FILT3.tsv
      	tr " " "\t" < $PWD/DNASeq/tmp/FILT3.tsv | tr -s "\t" > $PWD/DNASeq/${bn}/${bn}_FILT3_CADD.tsv
      	rm $PWD/DNASeq/tmp/FILT3.tsv

	#Filtro IV: Sequence Ontology
	echo $(date) : Filtrando Sequence Ontology ...
	awk '$7 != "3_prime_UTR_variant" {print $0}' $PWD/DNASeq/${bn}/${bn}_FILT3_CADD.tsv > $PWD/DNASeq/tmp/tmp_filtro4_1.tsv
      	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_1.tsv | tr -s "\t" > $PWD/DNASeq/tmp/tmp_filtro4-1.tsv

	awk '$7 != "5_prime_UTR_variant" {print $0}' $PWD/DNASeq/tmp/tmp_filtro4-1.tsv > $PWD/DNASeq/tmp/tmp_filtro4_2.tsv
	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_2.tsv | tr -s "\t" > $PWD/DNASeq/tmp/tmp_filtro4-2.tsv

	awk '$7 != "5_prime_UTR_premature_start_codon_gain_variant" {print $0}' $PWD/DNASeq/tmp/tmp_filtro4-2.tsv > $PWD/DNASeq/tmp/tmp_filtro4_3.tsv
	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_3.tsv | tr -s "\t" > $PWD/DNASeq/tmp/tmp_filtro4-3.tsv

	awk '$7 != "downstream_gene_variant" {print $0}' $PWD/DNASeq/tmp/tmp_filtro4-3.tsv > $PWD/DNASeq/tmp/tmp_filtro4_4.tsv
      	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_4.tsv | tr -s "\t" > $PWD/DNASeq/tmp/tmp_filtro4-4.tsv

	awk '$7 != "exon_loss_variant" {print $0}' $PWD/DNASeq/tmp/tmp_filtro4-4.tsv > $PWD/DNASeq/tmp/tmp_filtro4_5.tsv
      	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_5.tsv | tr -s "\t" > $PWD/DNASeq/tmp/tmp_filtro4-5.tsv

	awk '$7 != "intergenic_variant" {print $0}' $PWD/DNASeq/tmp/tmp_filtro4-5.tsv > $PWD/DNASeq/tmp/tmp_filtro4_6.tsv
      	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_6.tsv | tr -s "\t" > $PWD/DNASeq/tmp/tmp_filtro4-6.tsv

	awk '$7 != "intron_variant" {print $0}' $PWD/DNASeq/tmp/tmp_filtro4-6.tsv > $PWD/DNASeq/tmp/tmp_filtro4_7.tsv
      	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_7.tsv | tr -s "\t" > $PWD/DNASeq/tmp/tmp_filtro4-7.tsv

	awk '$7 != "invalid" {print $0}' $PWD/DNASeq/tmp/tmp_filtro4-7.tsv > $PWD/DNASeq/tmp/tmp_filtro4_8.tsv
      	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_8.tsv | tr -s "\t" > $PWD/DNASeq/tmp/tmp_filtro4-8.tsv

      	awk '$7 != "non_coding_exon_variant" {print $0}' $PWD/DNASeq/tmp/tmp_filtro4-8.tsv > $PWD/DNASeq/tmp/tmp_filtro4_9.tsv
      	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_9.tsv | tr -s "\t" > $PWD/DNASeq/tmp/tmp_filtro4-9.tsv

      	awk '$7 != "synonymous_variant" {print $0}' $PWD/DNASeq/tmp/tmp_filtro4-9.tsv > $PWD/DNASeq/tmp/tmp_filtro4_10.tsv
      	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_10.tsv | tr -s "\t" > $PWD/DNASeq/tmp/tmp_filtro4-10.tsv

      	awk '$7 != "transcript_ablation" {print $0}' $PWD/DNASeq/tmp/tmp_filtro4-10.tsv > $PWD/DNASeq/tmp/tmp_filtro4_11.tsv
      	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_11.tsv | tr -s "\t" > $PWD/DNASeq/tmp/tmp_filtro4-11.tsv

      	awk '$7 != "unknown" {print $0}' $PWD/DNASeq/tmp/tmp_filtro4-11.tsv > $PWD/DNASeq/tmp/tmp_filtro4_12.tsv
      	tr " " "\t" < $PWD/DNASeq/tmp/tmp_filtro4_12.tsv | tr -s "\t" > $PWD/DNASeq/${bn}/${bn}_FILT4_SO.tsv
      	rm $PWD/DNASeq/tmp/*

	#Filtro V: Paneles // Se puede añadir aquí cualquier panel de genes
	#Portadores V1
	echo $(date) : Panel CARRIERS v1 $PWD/DNASeq/${bn}/${bn}_FILT5_CARRIERS.tsv
	while read -r line
	do
      		awk '$19 == $line {print $0}' $PWD/DNASeq/${bn}_FILT4_SO.tsv >> $PWD/DNASeq/${bn}/${bn}_FILT5_CARRIERS.tsv
	done < $PWD/Paneles/PortadoresV1.tsv

	#Oncology predisposition V1
	echo $(date) : Panel ONCOLOGY PRED. v1 $PWD/DNASeq/${bn}/${bn}_FILT5_ONCOLOGY.tsv
	while read -r line
	do
      		awk '$19 == $line {print $0}' $PWD/DNASeq/${bn}_FILT4_SO.tsv >> $PWD/DNASeq/${bn}/${bn}_FILT5_ONCOLOGY.tsv
	done < $PWD/Paneles/CancerPredispositionV1.tsv

	#Cardiac predisposition V1
	echo $(date) : Panel CARDIAC PRED. v1 $PWD/DNASeq/${bn}/${bn}_FILT5_CARDIAC.tsv
	while read -r line
	do
      		awk '$19 == $line {print $0}' $PWD/DNASeq/${bn}_FILT4_SO.tsv >> $PWD/DNASeq/${bn}/${bn}_FIL5_CARIDAC.tsv
	done < $PWD/Paneles/CardiacPredispositionV1.tsv

	#Neurological disease predisposition V1
	echo $(date) : Panel NEUROLOGICAL PRED. v1 $PWD/DNASeq/${bn}/${bn}_FILT5_NEURO.tsv
	while read -r line
	do
      		awk '$19 == $line {print $0}' $PWD/DNASeq/${bn}_FILT4_SO.tsv >> $PWD/DNASeq/${bn}/${bn}_FILT5_NEURO.tsv
	done < $PWD/Paneles/NeurologicalPredispositionV1.tsv

      	#rm -rf $PWD/AnalisisOctubre/tmp/*
      	echo $(date) : Los archivos los puedes encontrar en $PWD/DNASeq/${bn}
done
