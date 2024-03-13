### Trio Exome Sample Analysis
This repository contains two scripts for analyzing trio exome samples using different tools: VarScan and GATK (Genome Analysis Toolkit). The VarScan script performs variant calling based on pileup data, while the GATK script utilizes the HaplotypeCaller tool for variant calling.
Scripts

- **varscan_trio_analysis.sh**: This script performs trio exome sample analysis using VarScan.
- **gatk_trio_analysis.sh:** This script performs trio exome sample analysis using GATK.

## Usage
# VarScan Script
```bash
bash varscan_trio_analysis.sh proband_R1 proband_R2 mother_R1 mother_R2 father_R1 father_R2
```
    proband_R1: Path to the forward reads of the proband sample.
    proband_R2: Path to the reverse reads of the proband sample.
    mother_R1: Path to the forward reads of the mother sample.
    mother_R2: Path to the reverse reads of the mother sample.
    father_R1: Path to the forward reads of the father sample.
    father_R2: Path to the reverse reads of the father sample.

# GATK Script
```bash
bash gatk_trio_analysis.sh ref_genome proband_bam mother_bam father_bam
```
    ref_genome: Path to the reference genome.
    proband_bam: Path to the BAM file of the proband sample.
    mother_bam: Path to the BAM file of the mother sample.
    father_bam: Path to the BAM file of the father sample.

## Requirements

- **VarScan:** Ensure VarScan is installed and its JAR file is accessible.
- **GATK:** Ensure GATK is installed and its JAR file is accessible.
- **Bowtie2:** Ensure Bowtie2 is installed for alignment.
- **Samtools:** Ensure Samtools is installed for manipulating BAM files.
- **Picard:** Ensure Picard tools are installed for adding read groups to BAM files.

## Notes

- Adjust paths to reference genome, output directories, and tool executables within the scripts as needed.
- Ensure all required dependencies are installed and accessible in your environment.
- Make sure input files are in the correct format and follow the expected naming conventions.

## Disclaimer
These scripts are provided as-is and may require customization to fit your specific environment and data.

## Contributors
- Ranjana Mariyam Raju
- Ujjwal Prathap Singh
- Prashanth N Suravajhala

