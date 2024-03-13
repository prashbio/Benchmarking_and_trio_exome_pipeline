REF_GENOME=/home/NGS/tools/hg38/hg38.fa
OUTPUT_FILE=/home/NGS/ranjana

# VariantFilteration
java -jar /home/NGS/tools/gatk/gatk-4.3.0.0/gatk-package-4.3.0.0-local.jar VariantFiltration \
                                                        -R $REF_GENOME \
                                                        -V $OUTPUT_FILE/NA12878_snps.vcf \
                                                        -filter "QD < 2.0" --filter-name "QD2" \
                                                        -filter "QUAL < 30.0" --filter-name "QUAL30" \
                                                        -filter "SOR > 3.0" --filter-name "SOR3" \
                                                        -filter "FS > 60.0" --filter-name "FS60" \
                                                        -filter "MQ < 40.0" --filter-name "MQ40" \
                                                        -filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
                                                        -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
                                                        -O $OUTPUT_FILE/filtered.vcf

bcftools view -f PASS filtered.vcf > PASS_filtered.vcf
