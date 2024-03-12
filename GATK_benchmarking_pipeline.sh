# Define variables
# Specify the location of reference genome and index files
REF_GENOME=/path_to_reference_genome/

# Specify the input directory where the data files are stored
INPUT_DIR=/path_to_input_directory/

# Specify the output directory where the generated files will be stored
OUTPUT_DIR=/path_to_output_directory/

pipeline_start_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "____________________________________________________"

echo "Pipeline Start time: $pipeline_start_timestamp"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Step 1: Quality control (QC) of raw sequencing data
fastqc -o $OUTPUT_DIR $INPUT_DIR/*.fastq.gz

alignment_start_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "____________________________________________________"

echo "Alignment Start time: $alignment_start_timestamp"

# Step 2: Alignment of reads to a reference genome
bwa mem \
    -t 2 $REF_GENOME \
    $INPUT_DIR/*.fastq.gz \
    > $OUTPUT_DIR/aligned_reads.sam
alignment_end_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "Alignment end time: $alignment_end_timestamp"
echo "_________________________________________________"

# Adding readgroups
readgroups_start_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "adding read groups to sam file started: $readgroups_start_timestamp"
echo "____________________________________________________"
java -jar /path/to/picard.jar AddOrReplaceReadGroups I=$OUTPUT_DIR/aligned_reads.sam O=$OUTPUT_DIR/aligned_RGreads.sam RGID=RG1 RGLB=Library1 RGPL=illumina RGPU=unit1 RGSM=Sample1
echo "_________________________________________________"

readgroups_end_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "adding read groups ended: $readgroups_end_timestamp"
echo "____________________________________________________"


markduplicates_start_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "mark duplicates started: $markduplicates_start_timestamp"
echo"____________________________________________________"

# Step 3: Mark duplicates
java -jar /path/to/gatk-package-4.3.0.0-local.jar  MarkDuplicatesSpark \
        -I $OUTPUT_DIR/aligned_RGreads.sam \
        -M $OUTPUT_DIR/dedup_metrics.txt \
        -O $OUTPUT_DIR/sorted_dedup_reads.bam \
    --conf spark.executor.cores=8

markduplicates_end_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "mark duplicates end: $markduplicates_end_timestamp"
echo "____________________________________________________"


variantcalling_start_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
# Step 4: Variant calling
echo "____________________________________________________"

echo "variant calling started: $variantcalling_start_timestamp"
echo "____________________________________________________"
java -jar /path/to/gatk-package-4.3.0.0-local.jar HaplotypeCaller -R $REF_GENOME -I $OUTPUT_DIR/sorted_dedup_reads.bam -O $OUTPUT_DIR/raw_variants.vcf
java -jar /path/to/gatk-package-4.3.0.0-local.jar SelectVariants -R $REF_GENOME -V $OUTPUT_DIR/raw_variants.vcf -O $OUTPUT_DIR/raw_snp_variants.vcf

end_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "____________________________________________________"

echo "variant calling done: $end_timestamp"
echo "____________________________________________________"


echo "____________________________________________________"
pipeline_end_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "Pipeline Done: $pipeline_end_timestamp" 
echo "____________________________________________________"



# Convert timestamps to Unix timestamps
timestamp1_unix=$(date -d "$pipeline_start_timestamp" +"%s")
timestamp2_unix=$(date -d "$pipeline_end_timestamp" +"%s")

# Calculate the time difference in seconds
elapsed_seconds=$((timestamp2_unix - timestamp1_unix))

# Convert seconds to hours, minutes, and seconds
hours=$((elapsed_seconds / 3600))
minutes=$((elapsed_seconds / 60 % 60))
seconds=$((elapsed_seconds % 60))

# Print the elapsed time
echo "Total time taken by pipeline: $hours hours, $minutes minutes, $seconds seconds"
