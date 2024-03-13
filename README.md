# Benchmarking exome sequencing pipeline

Benchmarking exome pipelines is crucial for evaluating their performance in variant calling and clinical significance annotation. It allows researchers and clinicians to assess accuracy, sensitivity, and specificity, identifying the most effective pipelines. In this study, we compared our in-house consensus exome pipeline (https://github.com/prashbio/CONVEX) with the gold standard Genome Analysis Toolkit (GATK) pipeline using four datasets.  We also performed trio exome analysis using VarScan Trio and GATK joint calling pipelines on our previously published Congenital Pouch Colon (CPC) samples.

# GATK Pipeline
This repository contains a GATK (Genome Analysis Toolkit) pipeline designed to benchmark the CONVEX pipeline for genomic analysis. The pipeline includes several steps such as quality control, alignment, adding read groups, marking duplicates, and variant calling.

## Pipeline Steps

- **Quality Control (QC):** Raw sequencing data quality control using FastQC.
- **Alignment:** Alignment of reads to a reference genome using BWA mem.
- **Adding Read Groups:** Adding read groups to the aligned reads using Picard tools.
- **Mark Duplicates:** Marking duplicates in the aligned reads using GATK MarkDuplicatesSpark.
- **Variant Calling:** Calling variants using GATK HaplotypeCaller and selecting SNP variants.

## Usage

Execute the script `GATK_benchmarking_pipeline.sh` with appropriate parameters:

```bash
bash GATK_benchmarking_pipeline.sh
```

Ensure to specify the paths to the reference genome, input directory, and output directory within the script before execution.

## Requirements
- **BWA:** Burrows-Wheeler Aligner for aligning reads.
- **Picard Tools:** For adding read groups and marking duplicates.
- **GATK:** Genome Analysis Toolkit for variant calling.
- **Samtools:** For manipulating SAM/BAM files.
- **FastQC:** For quality control of raw sequencing data.

## Benchmarking
The pipeline records timestamps at the beginning and end of execution to calculate the total time taken. The elapsed time is printed in hours, minutes, and seconds.

## Contributors

- Ranjana Mariyam Raju
- Ujjwal Prathap Singh
- Prashant N Suravajhala
- System Genomics Lab, Amrita School of Biotechnology, Kollam, Kerala

## LICENSE


## Disclaimer
This pipeline is provided as-is and may require customization to fit your specific environment and data. 
