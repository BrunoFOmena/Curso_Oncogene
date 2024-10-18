# Curso ONCOGEN 2022

Este repositório contém os dados, scripts e resultados gerados durante o **Curso ONCOGEN 2022** de bioinformática aplicada à medicina de precisão, focado na análise de dados genômicos.

## Visão Geral

O curso visa ensinar ferramentas e técnicas modernas de bioinformática para análise genômica, com foco em:
- **Alinhamento de sequências**.
- **Chamada de variantes** (SNPs e INDELs).
- **Anotação e interpretação de variantes**.

Durante o curso, foram utilizadas leituras de sequenciamento de DNA de Escherichia coli e genomas humanos para identificar e interpretar variantes genéticas.

## Estrutura do Repositório

O repositório está organizado em pastas específicas para cada etapa do pipeline de análise genômica:

- **`fastq/`**: Contém os arquivos de sequenciamento (FASTQ) usados como entrada para as análises.
- **`fastqc/`**: Resultados do controle de qualidade das leituras de sequenciamento com **FastQC**.
- **`alignment/`**: Arquivos de alinhamento das sequências com o genoma de referência (BAM/SAM).
- **`variants/`**: Arquivos VCF contendo as variantes chamadas nas amostras.
- **`annotations/`**: Relatórios e anotações de variantes gerados com **SnpEff**.

## Ferramentas e Softwares Utilizados

As ferramentas usadas ao longo do curso incluem:

- **BWA**: Para o alinhamento de sequências.
- **Samtools**: Para manipulação de arquivos de alinhamento (BAM/SAM).
- **bcftools**: Para chamada e filtragem de variantes.
- **SnpEff**: Para anotação de variantes.
- **FastQC**: Para controle de qualidade das leituras de sequenciamento.

## Clonar o Repositório
```bash
git clone https://github.com/seu-usuario/Curso-ONCOGEN-2022.git
cd Curso-ONCOGEN-2022
