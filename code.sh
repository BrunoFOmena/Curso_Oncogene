#criar ambiente conda
conda create -n curso_oncogene

# Ativar o ambiente
conda activate curso_oncogene

# Para desativar o ambiente
#conda deactivate

conda install -c bioconda bwa gatk4 freebayes snpeff fastqc cutadapt bcftools

#rodar o fastqc
fastqc 510-7-BRCA_S8_L001_R1_001.fastq.gz --nogroup 
fastqc 510-7-BRCA_S8_L001_R2_001.fastq.gz --nogroup 

#abrir o arquivo .html
explorer.exe .

#baixar o genoma de referencia e cortar apenas o cromossomo 13 e 17
wget --timestamping 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr13.fa.gz'
wget --timestamping 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr17.fa.gz'

#descomprimir e concatenar os arquivos
gunzip chr13.fa.gz
gunzip chr17.fa.gz

#concatenar os arquivos
cat chr13.fa chr17.fa > ucsc-chr13-chr17.hg19.fa

#Gerar arquivos de index do FASTA para o BWA e Samtools
bwa index -a bwtsw ucsc-chr13-chr17.hg19.fa

#Cria um índice para o arquivo FASTA, permitindo acessos rápidos a regiões específicas do genoma, o que é útil para várias etapas de análise.
samtools faidx ucsc-chr13-chr17.hg19.fa

#verificar contigs no arquivo de referencia:
grep '>' ucsc-chr13-chr17.hg19.fa
#resposta:
#>chr13
#>chr17

#contar as linhas de DNA no arquivo
grep -v '>' ucsc-chr13-chr17.hg19.fa | wc -l
#resposta: 3927303

#ALINHAMENTO
bwa mem -t 2 -R "@RG\tID:510-7\tSM:510-7\tPL:Illumina\tPU:unit1\tLB:lib1" ucsc-chr13-chr17.hg19.fa 510-7-BRCA_S8_L001_R1_001.fastq.gz 510-7-BRCA_S8_L001_R2_001.fastq.gz > 510-7-BRCA_S8.sam

#verificar se funcionou:
head 510-7-BRCA_S8.sam

#converter sam para bam
samtools sort 510-7-BRCA_S8.sam > 510-7-BRCA_S8.bam

#indexar
samtools index 510-7-BRCA_S8.bam

#VERIFICAÇÃO SAM:
#Quantas reads na região de interesse?
samtools view 510-7-BRCA_S8.bam chr17:41197694-41197819 | wc -l
#2213

#Quantas reads não foram mapeadas
samtools view  510-7-BRCA_S8.bam | cut -f6 | grep '*' | wc -l
#34621

#CHAMAR VARIANTE USANDO O bam
###primeiro entrar no site do ucsc e conseguir o arquivo brca.bed
freebayes -f ucsc-chr13-chr17.hg19.fa --targets BRCA.bed 510-7-BRCA_S8.bam > 510-7-BRCA_S8.vcf
#assim gerou o arquivo vcf

#FILTRAR VARIANTES COM QUALIDADE MAIOR QUE 30 - OPCIONAL
bcftools filter -i 'QUAL>30' 510-7-BRCA_S8.vcf -o 510-7-BRCA_S8.filtered.vcf

#anotar variantes com snpEff
snpEff hg19 510-7-BRCA_S8.vcf > 510-7-BRCA_S8.ann.vcf

#ETAPAS ADICIONAIS:

###BAIXAR O bcftools
conda install -c bioconda bcftools

###Visualizar o relatório de anotação do SnpEff
explorer.exe SnpEff_summary.html

###Inspecionar o arquivo VCF anotado
head 510-7-BRCA_S8.ann.vcf

###Filtrar variantes de alto impacto
bcftools view -i 'ANN[*].IMPACT="HIGH"' 510-7-BRCA_S8.ann.vcf -o 510-7-BRCA_S8_high_impact.vcf

###Filtrar variantes com qualidade maior que 30
bcftools filter -i 'QUAL>30' 510-7-BRCA_S8.vcf -o 510-7-BRCA_S8.filtered.vcf

###Criar relatórios customizados e tabelados
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%ANN\n' 510-7-BRCA_S8.ann.vcf > variantes_anotadas.tsv
