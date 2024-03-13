#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 proband_R1 proband_R2 mother_R1 mother_R2 father_R1 father_R2"
    exit 1
fi

# Assign arguments to variables
proband_R1="$1"
proband_R2="$2"
mother_R1="$3"
mother_R2="$4"
father_R1="$5"
father_R2="$6"

# Define variables
REF_GENOME="/path_to_reference_genome/"
OUTPUT_DIR="/path_to_output_dir/"

# bowtie2 alignment for proband
echo "bowtie started for proband"
bowtie2 -x "$REF_GENOME" -1 "$proband_R1" -2 "$proband_R2" -S "$OUTPUT_DIR/proband.sam"
samtools view "$OUTPUT_DIR/proband.sam" -o "$OUTPUT_DIR/proband.bam"
samtools sort "$OUTPUT_DIR/proband.bam" -o "$OUTPUT_DIR/proband.sorted.bam"

# bowtie2 alignment for mother
echo "bowtie started for mother"
bowtie2 -x "$REF_GENOME" -1 "$mother_R1" -2 "$mother_R2" -S "$OUTPUT_DIR/mother.sam"
samtools view "$OUTPUT_DIR/mother.sam" -o "$OUTPUT_DIR/mother.bam"
samtools sort "$OUTPUT_DIR/mother.bam" -o "$OUTPUT_DIR/mother.sorted.bam"

# bowtie2 alignment for father
echo "bowtie started for father"
bowtie2 -x "$REF_GENOME" -1 "$father_R1" -2 "$father_R2" -S "$OUTPUT_DIR/father.sam"
samtools view "$OUTPUT_DIR/father.sam" -o "$OUTPUT_DIR/father.bam"
samtools sort "$OUTPUT_DIR/father.bam" -o "$OUTPUT_DIR/father.sorted.bam"

echo "samtools mpileup running"
samtools mpileup -B -q 1 -f "$REF_GENOME" "$OUTPUT_DIR/father.sorted.bam" "$OUTPUT_DIR/mother.sorted.bam" "$OUTPUT_DIR/proband.sorted.bam" > "$OUTPUT_DIR/trio.mpileup"

echo "variant calling started"
java -jar /path/to/varscan/VarScan.v2.4.5.jar trio "$OUTPUT_DIR/trio.mpileup" "$OUTPUT_DIR/trio.mpileup.output" \
      --min-coverage 10 --min-var-freq 0.20 --p-value 0.05 \
      -adj-var-freq 0.05 -adj-p-value 0.15

echo "Variant calling completed"
echo "VCF files generated: $OUTPUT_DIR/trio.mpileup.output.snp.vcf and $OUTPUT_DIR/trio.mpileup.output.indel.vcf"
