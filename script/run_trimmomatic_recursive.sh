#!/bin/bash


# Define las variables de entrada y salida
INPUT_DIR="/home/mtripp/CURSO_RNASEQ2024/transcriptomica/reads"  # Cambia esta ruta a donde estén tus archivos de entrada
OUTPUT_DIR="/home/mtripp/CURSO_RNASEQ2024/transcriptomica/trimmed"  # Cambia esta ruta a donde quieras guardar los archivos procesados
ADAPTERS="/home/mtripp/CURSO_RNASEQ2024/trimmomatic/adapters/TruSeq3-PE.fa"  # Cambia esta ruta al archivo de adaptadores que quieres usar

LOG_FILE="trimmomatic.log"
ERR_FILE="trimmomatic.err"


# Inicializa los archivos de log y error
echo "Iniciando procesamiento con Trimmomatic" > $LOG_FILE
echo "Errores en el procesamiento con Trimmomatic" > $ERR_FILE

# Procesa cada archivo fastq en pares (R1 y R2)
for INPUT_R1 in ${INPUT_DIR}/*_R1.fastq.gz
do
    # Define el archivo correspondiente de lectura inversa (R2)
    SAMPLE_BASE=$(basename $INPUT_R1 "_R1.fastq.gz")
    INPUT_R2=${INPUT_DIR}/${SAMPLE_BASE}_R2.fastq.gz
    
    # Define los archivos de salida
    OUTPUT_BASE=${OUTPUT_DIR}/trimmed_${SAMPLE_BASE}
    
    # Ejecuta Trimmomatic y redirige la salida a los archivos log y err
    trimmomatic PE -threads 4 \
        $INPUT_R1 $INPUT_R2 \
        -baseout $OUTPUT_BASE.fastq.gz \
        ILLUMINACLIP:${ADAPTERS}:2:30:10:8:true LEADING:5 TRAILING:5 SLIDINGWINDOW:4:15 MINLEN:36 \
        1>> $LOG_FILE 2>> $ERR_FILE

    echo "Procesado ${SAMPLE_BASE} completado." >> $LOG_FILE
done

echo "Procesamiento completo." >> $LOG_FILE









