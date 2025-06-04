# Diffusion Tensor Imaging and Cognition Analysis in Alzheimer’s Disease

This repository contains the code, data, and documentation for a Master’s Thesis project in Bioinformatics and Biostatistics. 

Through the integration of neuroimaging and clinical data, the project applies a reproducible and automated workflow to process DTI images, extract quantitative metrics (FA, MD, RD, AxD), and analyze their statistical associations with cognitive scores (MMSE, FAQ, CDR, ADAS) across three groups: Cognitively Normal (CN), Mild Cognitive Impairment (MCI), and Alzheimer’s Disease (AD).

## Objectives 

The general objectives of this project are outlined below, followed by their corresponding specific objectives and tasks: 

- General Objective 1: To understand DTI analysis by brain regions.
    - Specific Objective 1.1: To study steps required to perform brain region-based DTI analysis.
    - Specific Objective 1.2: To create a pipeline to perform brainr egion-based DTI analysis.
- General Objective 2: To perform statistical analysis of demographic, neuropsychological, and DTI-derived data.
    - Specific Objective 2.1: To analyze differences in demographic, neuropsychological, and DTI-derived data across CN, MCI, and AD groups.
    - Specific Objective 2.2: To investigate correlations between neuropsychological outcomes and DTI-derived metrics.

## Data Source: ADNI

The data used in this project were obtained from the Alzheimer's Disease Neuroimaging Initiative (ADNI) database, a longitudinal, multicenter study launched in 2004 aimed at identifying biomarkers of Alzheimer's disease progression. ADNI provides access to high-quality imaging data (including T1-weighted MRI and DTI), clinical assessments, and neuropsychological evaluations across multiple diagnostic stages of Alzheimer's disease.

- Reference:
Jack CR Jr, Bernstein MA, Fox NC, et al. The Alzheimer's Disease Neuroimaging Initiative (ADNI): MRI methods. J Magn Reson Imaging. 2008;27(4):685–691. doi:10.1002/jmri.21049
Website: http://adni.loni.usc.edu

## Project Workflow

### Data Preparation

The first phase focused on building a comprehensive clinical-cognitive dataset from raw ADNI files. Subjects were selected based on the availability of both T1-weighted (IR-SPGR) and DTI sequences from the ADNI-2 cohort. Demographic information was extracted, including diagnostic group (CN, MCI, AD), age, gender, and years of education.

Neurocognitive test scores were obtained for the following assessments:

- Mini-Mental State Examination (MMSE).

- Functional Activities Questionnaire (FAQ).

- Clinical Dementia Rating (CDR).

- Alzheimer’s Disease Assessment Scale (ADAS and ADAS-13).

The Bash script modify.sh was developed to automate the merging of demographic and neuropsychological variables and generate the final dataset: demographic_neurocognitive_tests.csv, comprising 185 subjects.

## Image Processing and Metric Extraction

This phase involved the automated computation of volume and diffusion-based brain metrics using various neuroimaging tools. T1-weighted images were segmented using FastSurfer with the DKTatlas+aseg protocol to label cortical and subcortical brain regions.

DTI images were preprocessed using FSL, including:

- Skull stripping.

- Eddy current correction.

- Tensor fitting.

Four main diffusion tensor metrics were computed:

- Fractional Anisotropy (FA).

- Mean Diffusivity (MD).

- Radial Diffusivity (RD).

- Axial Diffusivity (AxD).

Anatomical segmentations were registered to diffusion space, and regional/global metrics were extracted using binary masks. Quality validation was performed through tractography using DSI Studio, applying a 70% threshold to confirm proper b-vector orientation. Output metrics were stored in volume_metrics_results.csv, including global and region-specific measures for 95 brain segments.

## Statistical Analysis

This final phase was carried out entirely in R as specified in the script statistical_analysis.rmd, combining and analyzing the datasets generated in the previous phases. The demographic and imaging datasets were merged to create a unified analysis dataset.

Descriptive statistics were computed for demographic variables, cognitive scores, and DTI metrics, with visual summaries including pie charts and boxplots.

Inferential statistical testing included:

- Normality check using the Shapiro-Wilk test.

- Homogeneity of variances assessed with Levene’s test.

- Between-group comparisons using:

    - ANOVA (when normality and homogeneity, parametric variables).

    - Kruskal-Wallis (when non-normality and/or non-homogeneity, non-parametric variables).

-  Post-hoc testing:

    - Tukey’s HSD for parametric variables.

    - Pairwise Wilcoxon tests for non-parametric variables.

Correlation analysis was conducted using Pearson’s correlation to examine associations between neurocognitive scores and DTI metrics. Only results with p < 0.05 and |r| ≥ 0.3 (moderate or stronger) were retained. Final outputs were compiled into statistical_analysis.html.

This work is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).
