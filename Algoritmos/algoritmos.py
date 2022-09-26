import re
from string import *
#1. Bases por Gen X
def basesPorGen(bases, genes):
	"""
    (float, float) -> float
    Obtiene el numero promedio de bases por gen.
    >>> b = 100.0
    >>> g = 10.0
    >>> basesPorGen(b,g)
    10.0
	"""
	assert type(bases and genes) == int or float, '(!) Formato no válido. Los parámetros de entrada tienen que ser numéricos (!)'
	assert (bases > 0), '(!) El número de bases tiene que ser un valor mayor que cero (!)'
	assert (genes > 0), '(!) El número de genes tiene que ser un valor mayor que cero (!)'
	return round((bases/genes), 3)

#2. Concatenación 2 cadenas X
def concatena(string1, string2):
	"""
    (string, string) -> string
    Obtiene la cadena resultante de concatenar los parámetros de entrada.
    >>> s1 = 'abc'
    >>> s2 = 'def'
    >>> concatena(s1, s2)
    'abcdef'
	"""
	assert type(string1 and string2) == str, '(!) Formato no válido. La secuencia tiene que ser tipo String (!)'
	return string1+string2

#3. Sustituir T por U (sin método .replace) X
def sustituirTxU(dna):
	"""
    (string) -> string
    Obtiene la secuencia resultante despues de sustituir las apariciones de
    T por U.
    >>> dna = 'ATGC'
    >>> sustituirTxU(dna)
    'AUGC'
	"""
	assert type(dna) == str, '(!) Formato no válido. La secuencia tiene que ser tipo String (!)'
	dna1 = []
	for i in range(len(dna)):
		assert dna[i] in ['A', 'T', 'G', 'C', 'a', 't', 'g', 'c', 'u', 'U'], '(!) La secuencia contiene uno o varios caracteres no válidos (!)'
		if dna[i] == 'U':
			raise Exception('(!) La secuencia introducida contiene una o varias bases U (!)\n(!) Tiene que ser DNA (!)')
		if dna[i] == 'T' or dna[i] == 't':
			dna1.insert(i, 'U')
		else:
			dna1.insert(i, dna[i].upper())
	dna1 = ''.join(dna1)
	return dna1

#4. Complemento de la inversa (sin .translate() ni .maketrans()). X
def complementoInversa(dna):
	"""
    (string) -> string
    Obtiene la secuencia complementaria a la inversa de la secuencia de entrada.
    >>> dna = 'ATGC'
    >>> complementoInversa(dna)
    'GCAT'
	"""
	assert type(dna) == str, '(!) Formato no válido. La secuencia tiene que ser tipo String (!)'
	inversa = list()
	complemento = list()
	for i in range(len(dna)):
		assert dna[i] in ['A', 'T', 'G', 'C', 'U', 'a', 't', 'g', 'c', 'u'], '(!) La secuencia contiene uno o varios caracteres no válidos (!)' #Comprobar bases correctas
		inversa.insert(-i-1, dna[i].upper())
	if 'T' in inversa:
		if 'U' in inversa:
			raise Exception('(!) La secuencia contiene ocurrencias de T y U (!)\n(!) Tiene que ser secuencia de DNA o RNA exclusivamente (!)')
	if 'T' in inversa:
		for i in range(len(inversa)):
			if inversa[i] == 'A':
				complemento.append('T')
			elif inversa[i] == 'T':
				complemento.append('A')
			elif inversa[i] == 'C':
				complemento.append('G')
			else:
				complemento.append('C')
	else:
		for i in range(len(inversa)):
			if inversa[i] == 'A':
				complemento.append('U')
			elif inversa[i] == 'U':
				complemento.append('A')
			elif inversa[i] == 'C':
				complemento.append('G')
			else:
				complemento.append('C')		
	return ''.join(complemento)

#5. Mayor de dos números enteros X
def mayor(numero1, numero2):
    """
    Devuelve el número mayor de los dos introducidos.
    >>> numero1 = 2
    >>> numero2 = 1
    >>> mayor(numero1,numero2)
    2
    """
    assert type(numero1 and numero2) == int, '(!) Formato introducido no válido. Los parámetros tienen que ser números enteros (!)'
    assert (numero1 != numero2), '(!) Los números son iguales (!)'
    if numero1 > numero2:
        return numero1
    else:
        return numero2

#6. Ordena de mayor a menor. X
def ordenaMayorAMenor(num1, num2, num3):
    """
    (int, int, int) -> list(int, int, int)
    Devuelve una lista con los tres números ordenados de mayor a menor.
    >>> num1 = 1
    >>> num2 = 2
    >>> num3 = 3
    >>> ordenaMayorAMenor(num1, num2, num3)
    [3, 2, 1]
    """
    assert type(num1 and num2 and num3) == int, '(!) Formato introducido no válido. Los parámetros tienen que ser números enteros (!)'
    assert (num1 != num2 and num1 != num3 and num2 != num3), '(!) Hay dos o más números iguales (!)'
    if num1 > num2 and num1 > num3:
        pos1 = num1
        if num2 > num3:
            pos2 = num2
            pos3 = num3
        else:
            pos2 = num3
            pos3 = num2
    elif num2 > num1 and num2 > num3:
        pos1 = num2
        if num1 > num3:
            pos2 = num1
            pos3 = num3
        else:
            pos2 = num3
            pos3 = num1
    elif num3 > num2 and num3 > num1:
        pos1 = num3
        if num2 > num1:
            pos2 = num2
            pos3 = num1
        else:
            pos2 = num1
            pos3 = num2
    return [pos1, pos2, pos3]

#7. Aminoácido correspondiente a codón. ANÁLISIS DE CASOS
def codonAminoacidoAC(codon):
	"""
    (string) -> string
    Devuelve el aminoácido correspondiente al codón introducido como parámetro de entrada.
    >>> codon = 'AUG'
    >>> codonAminoacidoTH(codon)
    'M'
	"""
	assert type(codon) == str, '(!) Formato no válido. La secuencia tiene que ser tipo String (!)'
	if len(codon) != 3:
		raise Exception('(!) Longitud del codón no válida (!)')
    #Filtro de la secuencia de entrada: bases válidas y todas en mayús. 
	for i in range(len(codon)):
		assert codon[i] in ['A', 'a', 'U', 'u', 'C', 'c', 'G', 'g'], '(!) Base/s no válida/s (!)'
		if codon[i].islower():
			codon = codon.replace(codon[i], codon[i].upper())
    if codon == "UUU":
        return "Fenilalanina"
    elif codon == "UUC":
        return "Fenilalanina"
    elif codon == "UUA":
        return "Leucina"
    elif codon == "UUG":
        return "Leucina"
    elif codon == "CUU":
        return "Leucina"
    elif codon == "CUC":
        return "Leucina"
    elif codon == "CUA":
        return "Leucina"
    elif codon == "CUG":
        return "Leucina"
    elif codon == "AUU":
        return "Isoleucina"
    elif codon == "AUC":
        return "Isoleucina"
    elif codon == "AUA":
        return "Isoleucina"
    elif codon == "AUG":
        return "Metionina"
    elif codon == "GUU":
        return "Valina"
    elif codon == "GUC":
        return "Valina"
    elif codon == "GUA":
        return "Valina"
    elif codon == "GUG":
        return "Valina"
    elif codon == "UCU":
        return "Serina"
    elif codon == "UCC":
        return "Serina"
    elif codon == "UCA":
        return "Serina"
    elif codon == "UCG":
        return "Serina"
    elif codon == "CCU":
        return "Prolina"
    elif codon == "CCC":
        return "Prolina"
    elif codon == "CCA":
        return "Prolina"
    elif codon == "CCG":
        return "Prolina"
    elif codon == "ACU":
        return "Treonina"
    elif codon == "ACC":
        return "Treonina"
    elif codon == "ACA":
        return "Treonina"
    elif codon == "ACG":
        return "Treonina"
    elif codon == "UAU":
        return "Tirosina"
    elif codon == "UAC":
        return "Tirosina"
    elif codon == "UAA":
        return "Stop"
    elif codon == "UAG":
        return "Stop"
    elif codon == "UGA":
        return "Stop"
    elif codon == "CAU":
        return "Histidina"
    elif codon == "CAC":
        return "Histidina"
    elif codon == "CAA":
        return "Glutamina"
    elif codon == "CAG":
        return "Glutamina"
    elif codon == "AAU":
        return "Asparagina"
    elif codon == "AAC":
        return "Asparagina"
    elif codon == "AAA":
        return "Lisina"
    elif codon == "AAG":
        return "Lisina"
    elif codon == "GAU":
        return "Ácido aspártico"
    elif codon == "GAC":
        return "Ácido aspártico"
    elif codon == "GAA":
        return "Ácido glutámico"
    elif codon == "GAG":
        return "Ácido glutámico"
    elif codon == "UGU":
        return "Cisteína"
    elif codon == "UGC":
        return "Cisteína"
    elif codon == "UGG":
        return "Triptófano"
    elif codon == "GCU":
        return "Alanina"
    elif codon == "GCC":
        return "Alanina"
    elif codon == "GCA":
        return "Alanina"
    elif codon == "GCG":
        return "Alanina"
    elif codon == "AGU":
        return "Serina"
    elif codon == "AGC":
        return "Serina"
    elif codon == "AGA":
        return "Arginina"
    elif codon == "AGG":
        return "Arginina"
    elif codon == "GGU":
        return "Glicina"
    elif codon == "GGC":
        return "Glicina"
    elif codon == "GGA":
        return "Glicina"
    elif codon == "GGG":
        return "Glicina"
    elif codon == "CGU":
        return "Arginina"
    elif codon == "CGC":
        return "Arginina"
    elif codon == "CGA":
        return "Arginina"
    elif codon == "CGG":
        return "Arginina"


#8. Aminoácido correspondiente a codón. TABLA HASH. X
def codonAminoacidoTH(codon):
	"""
    (string) -> string
    Devuelve el aminoácido correspondiente al codón introducido como parámetro de entrada.
    >>> codon = 'AUG'
    >>> codonAminoacidoTH(codon)
    'M'
	"""
	assert type(codon) == str, '(!) Formato no válido. La secuencia tiene que ser tipo String (!)'
	if len(codon) != 3:
		raise Exception('(!) Longitud del codón no válida (!)')
    #Filtro de la secuencia de entrada: bases válidas y todas en mayús. 
	for i in range(len(codon)):
		assert codon[i] in ['A', 'a', 'U', 'u', 'C', 'c', 'G', 'g'], '(!) Base/s no válida/s (!)'
		if codon[i].islower():
			codon = codon.replace(codon[i], codon[i].upper())
	codigo_genetico = {
        "UCA": "S", "UCU": "S", "UCC": "S", "UCG": "S", "UUU": "F", "UUC": "F", "UUA": "L", "UUG": "L", "UAU": "Y",
        "UAC": "Y", "UAA": "O (STOP)", "UAG": "U (STOP)", "UGU": "C", "UGC": "C", "UGA": "X (STOP)", "UGG": "W",
        "CUU": "L", "CUC": "L", "CUA": "L", "CUG": "L", "CCU": "P", "CCC": "P", "CCA": "P", "CCG": "P", "CAT": "H",
        "CAC": "H", "CAA": "Q", "CAG": "Z", "CGU": "R", "CGC": "R", "CGA": "R", "CGG": "R", "AUU": "I", "AUC": "I",
        "AUA": "J", "AUG": "M", "ACU": "T", "ACC": "T", "ACA": "T", "ACG": "T", "AAU": "N", "AAC": "B", "AAA": "K",
        "AAG": "K", "AGU": "S", "AGC": "S", "AGA": "R", "AGG": "R", "GUU": "V", "GUC": "V", "GUA": "V", "GUG": "V",
        "GCU": "A", "GCC": "A", "GCA": "A", "GCG": "A", "GAU": "D", "GAC": "D", "GAA": "E", "GAG": "E", "GGU": "G",
        "GGC": "G", "GGA": "G", "GGG": "G"
    }
	return codigo_genetico[codon]

#9. Aminoácido correspondiente a codón. ANÁLISIS DE CASOS Y EXPRESIONES REGULARES. X
def codonAminoacidoACER(codon):
	"""
    (string) -> string
    Devuelve el aminoácido correspondiente al codón introducido como parámetro de entrada.
    >>> codon = 'AUG'
    >>> codonAminoacidoACER(codon)
    'Metionina'
	"""
	assert type(codon) == str, '(!) Formato no válido. La secuencia tiene que ser tipo String (!)'
	if len(codon) != 3:
		raise Exception('(!) Longitud del codón no válida (!)')
    #Filtro de la secuencia de entrada: bases válidas y todas en mayús. 
	for i in range(len(codon)):
		assert codon[i] in ['A', 'a', 'U', 'u', 'C', 'c', 'G', 'g'], '(!) Base no válida (!)'
		if codon[i].islower():
			codon = codon.replace(codon[i], codon[i].upper())
	if re.match('UC.|AG[UC]', codon):
		return 'Serina'
	elif re.match('UU[UC]', codon):
		return 'Fenilalanina'
	elif re.match('UU[AG]|CU.', codon):
		return 'Leucina'
	elif re.match('UA[UC]', codon):
		return 'Tirosina'
	elif re.match('UG[UC]', codon):
		return 'Cisteina'
	elif re.match('CC.', codon):
		return 'Prolina'
	elif re.match('CA[UC]', codon):
		return 'Histidina'
	elif re.match('CA[AG]', codon):
		return 'Glutamina'
	elif re.match('CG.|AG[AG]', codon):
		return 'Arginina'
	elif re.match('AU[UCA]', codon):
		return 'Isoleucina'
	elif re.match('AUG', codon):
		return 'Metionina'
	elif re.match('AC.', codon):
		return 'Treonina'
	elif re.match('AA[UC]', codon):
		return 'Asparagina'
	elif re.match('AA[AG]', codon):
		return 'Lisina'
	elif re.match('GU.', codon):
		return 'Valina'
	elif re.match('GC.', codon):
		return 'Alanina'
	elif re.match('GA[UC]', codon):
		return 'Acido aspartico'
	elif re.match('GA[AG]', codon):
		return 'Acido glutamico'
	elif re.match('GG.', codon):
		return 'Glicina'
	elif re.match('UA[AG]|UGA', codon):
		return 'STOP (Parada)'

#10. Distancia de Hamming.
def distanciaHamming(dnap, dnaq):
	"""
	(string, string) -> int
	Dadas dos secuencias de entrada, devuelve la Distancia de Hamming existente entre ambas, 
	el número de missmatches entre ambas en la misma posición. Válido para DNA o RNA.
	>>> dnap = 'ACG'
	>>> dnaq = 'ACT'
	>>> distanciaHamming(dnap, dnaq)
	1
	"""
	assert type(dnap and dnaq) == str, '(!) Formato no válido. La secuencia tiene que ser tipo String (!)' #Tipo de entrada
	if len(dnap) != len(dnaq):
		raise Exception('(!) Las secuencias tienen que tener la misma longitud (!)')
	for j in range(len(dnap)):
	 	assert dnap[j] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)' #Bases válidas.
	 	if dnap[j].islower():
	 		dnap = dnap.replace(dnap[j], dnap[j].upper()) #Todas en mayús. 
	for k in range(len(dnaq)):
	 	assert dnaq[k] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)' #Bases válidas. Secuencia 2.
	 	if dnaq[k].islower():
	 		dnaq = dnaq.replace(dnaq[k], dnaq[k].upper()) #Todas en mayús. 
	if len(dnap) != len(dnaq):
		raise Exception('(!) Secuencias de distinta longitud (!)')
	contador = 0
	for i in range(len(dnap)):
		if dnap[i] != dnaq[i]:
			contador += 1
	return contador

#11. Vecinas.
def vecinas1(patron):
	"""
	(string) -> set(string)
	A partir de una secuencia patrón dada, se devuelve un set con todas las combinaciones posibles que tienen una 
	distancia de Hamming igual a 1 con el patrón de entrada. 
	>>> patron = 'AAA'
	>>> vecinas1(patron)
	set(['ACA', 'AAA', 'AAC', 'ATA', 'AAG', 'AGA', 'AAT', 'TAA', 'CAA', 'GAA'])
	"""
	assert type(patron) == str, '(!) Formato no válido. La secuencia tiene que ser tipo String (!)'
	for j in range(len(patron)):
		assert patron[j] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)' #Bases válidas.
		if patron[j].islower():
			patron = patron.replace(patron[j], patron[j].upper()) #Todas en mayús.
	vecinas = set()
	nucleotidos = ['A', 'T', 'G', 'C']
	vecinas.add(patron)
	for i in range(len(patron)):
		for x in nucleotidos:
			if x != patron[i]:
				vecinas.add(patron[:i]+x+patron[i+1:])
	return vecinas

#11.1 Vecinas, d
def vecinas(patron, distancia):
	"""
	(string, int) -> set(string)
	A partir de una secuencia patrón dada, se devuelve un set con todas las combinaciones posibles que tienen una 
	distancia de Hamming igual o menor al valor 'd' introducido con el patrón de entrada. 
	>>> patron = 'AAA'
	>>> d = 2
	>>> vecinas(patron, d)
	set(['ACC', 'ATG', 'ACA', 'AAA', 'ATC', 'AAC', 'ATA', 'AGG', 'AGC', 'AAG', 'AGA', 'CAT', 'AAT', 'ATT', 'CTA', 
	'ACT', 'CAC', 'ACG', 'CAA', 'AGT', 'CCA', 'TAT', 'CGA', 'CAG', 'GAT', 'TAG', 'GGA', 'TAA', 'TAC', 'GAG', 'TTA', 
	'GAC', 'GAA', 'TCA', 'GCA', 'GTA', 'TGA'])
	"""
	assert type(patron) == str, '(!) Formato no válido. La secuencia tiene que ser tipo String (!)'
	assert type(distancia) == int, '(!) Formato no válido. La distancia tiene que ser tipo Int (!)'
	if distancia > len(patron):
		raise Exception('(!) La distancia es mayor que la longitud del patrón (!)')
	for j in range(len(patron)):
		assert patron[j] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)' #Bases válidas.
		if patron[j].islower():
			patron = patron.replace(patron[j], patron[j].upper()) #Todas en mayús.   
	vecinas = set()
	vecinas.add(patron)
	if distancia == 1:
		return vecinas1(patron)
	else:
		for i in range(1, distancia):
			for v in vecinas1(patron):
				vecinas.update(vecinas1(v))
		return vecinas

#12. Palabras frecuentes.
def contar(texto, patron):
	"""
	(string, string) -> int
	Contador de ocurrencias de un patrón introducido como entrada en un texto. 
	>>> patron = 'ATA' 
	>>> texto = 'CGATATATCCATAG'
	>>> contar(texto, patron)
	3
	"""
	assert type(patron and texto) == str, '(!) Formato no válido. Los parámetros de entrada tienen que ser tipo String (!)'
	if len(patron) > len(texto):
		raise Exception('(!) El texto no puede ser más corto que el patrón (!)')
	for j in range(len(texto)):
		assert texto[j] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)' #Bases válidas.
		if texto[j].islower:
			texto = texto.replace(texto[j], texto[j].upper())
	for k in range(len(patron)):
		assert patron[k] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)'
		if patron[k].islower():
			patron = patron.replace(patron[k], patron[k].upper()) #Todas en mayús. 
	cont = 0
	for i in range(len(texto)):
		if texto[i:i+len(patron)] == patron:
			cont = cont + 1
	return cont

def palabrasFrecuentes(texto, k):
	"""
	(string, int) -> list(string)
	Encuentra los fragmentos de tamaño k (k-meros) más frecuentes en la secuencia texto de entrada. 
	>>> texto = 'ACGTTGCATGTCGCATGATGCATGAGAGCT'
	>>> k = 4
	>>> palabrasFrecuentes(texto, k)
	['CATG', 'CGAT']
	"""
	assert type(texto) == str, '(!) Formato no válido. El texto de entrada tiene que ser tipo String (!)'
	assert type(k) == int, '(!) Formato no válido. El parámetro k tiene que ser tipo entero (!)'
	if k > len(texto):
		raise Exception('(!) El parámetro k es mayor que la longitud del texto (!)')
	for j in range(len(texto)):
	 	assert texto[j] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)' #Bases válidas.
	 	if texto[j].islower:
	 		texto = texto.replace(texto[j], texto[j].upper())
	kmeros = {}
	ocurrenciasMax = 0
	solucion = list()
	for i in range(len(texto)-(k-1)):
		kmero = texto[i:i+k]
		ocurrencia = contar(texto,kmero)
		kmeros[kmero] = ocurrencia
		if ocurrencia > ocurrenciasMax:
			ocurrenciasMax = ocurrencia
	claves = list(kmeros.keys())
	valores = list(kmeros.values())
	for i in range(len(valores)):
		if valores[i] == ocurrenciasMax:
			solucion.append(claves[i])
	return solucion

#13. Búsqueda de patrones.
def busquedaPatron(patron, texto):
	"""
	(string, string) -> list(int)
	Encuentra y almacena las ocurrencias de un patron en un texto. El patrón puede solaparse. 
	>>> patron = 'ATAT'
	>>> texto = 'GATATATGCATATACTT'
	>>> busquedaPatron(patron, texto)
	[1, 3, 9]
	"""
	assert type(patron and texto) == str, '(!) Formato no válido. Los parámetros de entrada tienen que ser tipo String (!)'
	if len(patron) > len(texto):
		raise Exception('(!) El texto no puede ser más corto que el patrón (!)')
	for j in range(len(texto)):
	 	assert texto[j] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)' #Bases válidas.
	 	if texto[j].islower:
	 		texto = texto.replace(texto[j], texto[j].upper())
	for k in range(len(patron)):
	 	assert patron[k] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)'
	 	if patron[k].islower():
	 		patron = patron.replace(patron[k], patron[k].upper()) #Todas en mayús. 
	pos = list()
	for i in range(len(texto)-(len(patron)-1)):
		if texto[i:i+len(patron)]==patron:
			pos.append(i)
	return pos

#14. Búsqueda aproximada de patrones.
def busquedaAproximadaPatron(patron, texto, d):
	"""
	(string, string, int) -> list(int)
    Encuentra y almacena las ocurrencias de los patrones con distancia de Hamming d en un texto.
    El patrón puede solaparse.
	>>> patron = 'ATTCTGGA'
	>>> texto = 'CGCCCGAATCCAGAACGCATTCCCATATTTCGGGACCACTGGCCTCCACGGTACGGACGTCAATCAAATGCCTAGCGGCTTGTGGTTTCTCCTACGCTCC'
	>>> d = 3
	>>> busquedaAproximadaPatron(patron, texto, d)
	[6, 7, 26, 27, 78]
	"""
	assert type(patron and texto) == str, '(!) Formato no válido. Los parámetros de entrada tienen que ser tipo String (!)'
	if len(patron) > len(texto):
		raise Exception('(!) El texto no puede ser más corto que el patrón (!)')
	if d > len(patron):
		raise Exception('(!) El parámetro d es mayor que la longitud del patrón (!)')
	for j in range(len(texto)):
		assert texto[j] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)' #Bases válidas.
		if texto[j].islower:
			texto = texto.replace(texto[j], texto[j].upper())
	for k in range(len(patron)):
	 	assert patron[k] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)'
	 	if patron[k].islower():
	 		patron = patron.replace(patron[k], patron[k].upper()) #Todas en mayús.
	pos = list()
	for i in range(len(texto)-(len(patron)-1)):
		if distanciaHamming(patron, texto[i:i+(len(patron))]) <= d:
			pos.append(i)
	return pos

#15. Palabras frecuentes con discrepancias.
def palabrasFrecuentesDiscrepancias(texto, k, d):
	"""
    (string, int, int) -> set(string)
    Encuentra las palabras frecuentes en un texto con hasta un número máximo de discrepancias.
    >>> texto = 'ACGTTGCATGTCGCATGATGCATGAGAGCT'
    >>> k = 4
    >>> d = 1
    >>> palabrasFrecuentesDiscrepancias(texto, k, d)
    [GATG, ATGC, ATGT]
	"""
	assert type(texto) == str, '(!) Formato no válido. El texto de entrada tiene que ser tipo String (!)'
	assert type(k) == int, '(!) Formato no válido. El parámetro k tiene que ser tipo entero (!)'
	if k > len(texto):
		raise Exception('(!) El parámetro k es mayor que la longitud del texto (!)')
	if d > len(texto):
		raise Exception('(!) El parámetro d es mayor que la longitud del texto (!)')
	if d > k:
		raise Exception('(!) El parámetro d no puede ser mayor que k (!) ')
	for j in range(len(texto)):
		assert texto[j] in ['a', 'A', 't', 'T', 'g', 'G', 'c', 'C', 'u', 'U'], '(!) Base no válida (!)' #Bases válidas.
		if texto[j].islower:
			texto = texto.replace(texto[j], texto[j].upper())
	solucion = set()
	kmeros = {}
	ocurrenciasMax = 0
	for i in range(len(texto)-(k-1)):
		kmero = texto[i:i+k]
		candidatas = vecinas(kmero, d)
		for j in candidatas:
			ocurrencia = len(busquedaAproximadaPatron(j, texto, d))
			kmeros[j] = ocurrencia
			if ocurrencia > ocurrenciasMax:
				ocurrenciasMax = ocurrencia
	claves = list(kmeros.keys())
	valores = list(kmeros.values())
	for i in range(len(valores)):
		if valores[i] == ocurrenciasMax: \
			solucion.add(claves[i])
	return solucion
            

def main():

if __name__ == "__main__":
	#import doctest
	#doctest.testmod(verbose=True)
	main()

