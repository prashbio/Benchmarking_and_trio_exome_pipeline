# Clinvar

echo "Finding valid Clinvar variant id's corresponding to the consensus"

mkdir PASSclinvarResults
cd PASSclinvarResults

awk 'NR==FNR { a[$1,$2,$4,$5]; next } (("chr"$1,$2,$4,$5) in a)' ../PASS_filtered.vcf /home/NGS/tools/clinvar_20230520.vcf > validated_clinvar_variants.vcf
#awk 'NR == FNR {a[$2];next} $2 in a' ../ERR031940_raw_snp_variants.vcf /home/NGS/tools/clinvar_20230520.vcf > validated_clinvar_variants.vcf


echo "Total number of validated Clinvar entries corresponding to your list of variants is:"
awk '!/^#/' validated_clinvar_variants.vcf | wc -l

echo "Downstream Pathgenicity Analysis"

grep -w 'CLNSIG' validated_clinvar_variants.vcf > clnsig_id_available.vcf

grep 'CLNSIG=Pathogenic;' validated_clinvar_variants.vcf > pathogenic_variants.vcf
echo "Number of pathogenic variants"
awk '!/^#/' pathogenic_variants.vcf | wc -l

grep 'CLNSIG=Pathogenic/Likely_pathogenic;' validated_clinvar_variants.vcf > Pathogenic_Likely_pathogenic_variants.vcf
echo "Number of Pathogenic/Likely_pathogenic variants"
awk '!/^#/' Pathogenic_Likely_pathogenic_variants.vcf | wc -l

grep 'CLNSIG=Likely_pathogenic;' validated_clinvar_variants.vcf > Likely_pathogenic.vcf
echo "Number of Likely pathogenic variants"
awk '!/^#/' Likely_pathogenic.vcf | wc -l

grep  'CLNSIG=Conflicting_interpretations_of_pathogenicity;' validated_clinvar_variants.vcf > conflicting_interpretations_of_pathogenicity_variants.vcf
echo "Number of variants with conflicting interpretations of pathogenicity"
awk '!/^#/' conflicting_interpretations_of_pathogenicity_variants.vcf | wc -l

grep  'CLNSIG=Uncertain_significance;' validated_clinvar_variants.vcf > uncertain_significance_variants.vcf
echo "Number of variants with uncertain significance"
awk '!/^#/' uncertain_significance_variants.vcf | wc -l
