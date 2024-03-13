#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 ref_genome proband_bam mother_bam father_bam"
    exit 1
fi

# Assign arguments to variables
REF_GENOME="$1"
PROBAND_BAM="$2"
MOTHER_BAM="$3"
FATHER_BAM="$4"

# Define variables
START_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
echo "____________________________________________________"
echo "read_groups started: $START_TIMESTAMP"
echo "____________________________________________________"

# Run AddOrReplaceReadGroups
java -jar /path/to/picard/picard.jar AddOrReplaceReadGroups \
		I="$PROBAND_BAM" \
		O="${PROBAND_BAM%.bam}_RG.bam" \
		RGID=RG1 RGLB=Library1 RGPL=illumina RGPU=unit1 RGSM=Z15

java -jar /path/to/picard/picard.jar AddOrReplaceReadGroups \
                I="$MOTHER_BAM" \
                O="${MOTHER_BAM%.bam}_RG.bam" \
                RGID=RG1 RGLB=Library1 RGPL=illumina RGPU=unit1 RGSM=Z16

java -jar /path/to/picard/picard.jar AddOrReplaceReadGroups \
                I="$FATHER_BAM" \
                O="${FATHER_BAM%.bam}_RG.bam" \
                RGID=RG1 RGLB=Library1 RGPL=illumina RGPU=unit1 RGSM=Z17

END_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
echo "____________________________________________________"
echo "read_groups ended: $END_TIMESTAMP"
echo "____________________________________________________"

# Index BAM files
echo "Indexing BAM files"
samtools index "${PROBAND_BAM%.bam}_RG.bam"
samtools index "${MOTHER_BAM%.bam}_RG.bam"
samtools index "${FATHER_BAM%.bam}_RG.bam"

echo "Samtools indexing done"

# Variant calling
VARIANTCALLING_START_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
echo "____________________________________________________"
echo "variant calling started: $VARIANTCALLING_START_TIMESTAMP"
echo "____________________________________________________"

java -jar /home/NGS/tools/gatk/gatk-4.3.0.0/gatk-package-4.3.0.0-local.jar HaplotypeCaller -R "$REF_GENOME" \
			-I "${PROBAND_BAM%.bam}_RG.bam" \
			-O "${PROBAND_BAM%.bam}_proband.g.vcf.gz" \
			-ERC GVCF

java -jar /home/NGS/tools/gatk/gatk-4.3.0.0/gatk-package-4.3.0.0-local.jar HaplotypeCaller -R "$REF_GENOME" \
                        -I "${FATHER_BAM%.bam}_RG.bam" \
                        -O "${FATHER_BAM%.bam}_father.g.vcf.gz" \
                        -ERC GVCF

java -jar /home/NGS/tools/gatk/gatk-4.3.0.0/gatk-package-4.3.0.0-local.jar HaplotypeCaller -R "$REF_GENOME" \
                        -I "${MOTHER_BAM%.bam}_RG.bam" \
                        -O "${MOTHER_BAM%.bam}_mother.g.vcf.gz" \
                        -ERC GVCF

END_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
echo "____________________________________________________"
echo "variant calling done: $END_TIMESTAMP"
echo "____________________________________________________"
echo "        
