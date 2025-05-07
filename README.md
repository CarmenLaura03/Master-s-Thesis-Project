# Diffusion Tensor Imaging and Cognition Analysis in Alzheimer’s Disease

This repository contains the code, data, and documentation for a Master’s Thesis project in Bioinformatics and Biostatistics. 

Through the integration of neuroimaging and clinical data, the project applies a reproducible and automated workflow to process DTI images, extract quantitative metrics (FA, MD, RD, AxD), and analyze their statistical associations with cognitive scores (MMSE, FAQ, CDR, ADAS) across three groups: Cognitively Normal (CN), Mild Cognitive Impairment (MCI), and Alzheimer’s Disease (AD).

## Objectives 

The general objectives of this project are outlined below, followed by their corresponding specific objectives and tasks: 

- General Objective 1: Understanding DTI analysis by brain regions in FreeSurfer.
    - Specific Objective 1.1: Studying different steps necessary for the analysis of DTI images by brain regions.
        - Task 1: Brain segmentation with T1-WI images.
        - Task 2: Preprocessing of DTI images.
        - Task 3: Tensor fitting for DTI images.
        - Task 4: Extraction of DTI-metrics (FA, MD, RD, AxD) according to the brain segmentation.
    - Specific Objective 1.2: Creating a pipeline for DTI analysis by brain regions.
        - Task 5: Development of automated script for DTI analysis by brain regions. 
- General Objective 2: Performing statistical data analysis of demographic data, neuropsychological outcomes, and DTI-metrics.
    - Specific Objective 2.1: Analyzing differences in demographic data, neuropsychological outcomes, and DTI-metrics across AD, MCI, and CN groups.
        - Task 6: Use statistical methods to study between-group differences for demographic data, neuropsychological outcomes, and DTI-metrics.
    - Specific Objective 2.2: Investigating associations between neuropsychological outcomes and DTI-metrics.
        - Task 7: Use statistical methods to assess correlations between neuropsychological outcomes and DTI-metrics.

## Data Source: ADNI

The data used in this project were obtained from the Alzheimer's Disease Neuroimaging Initiative (ADNI) database, a longitudinal, multicenter study launched in 2004 aimed at identifying biomarkers of Alzheimer's disease progression. ADNI provides access to high-quality imaging data (including T1-weighted MRI and DTI), clinical assessments, and neuropsychological evaluations across multiple diagnostic stages of Alzheimer's disease.

- Reference:
Jack CR Jr, Bernstein MA, Fox NC, et al. The Alzheimer's Disease Neuroimaging Initiative (ADNI): MRI methods. J Magn Reson Imaging. 2008;27(4):685–691. doi:10.1002/jmri.21049
Website: http://adni.loni.usc.edu

## Project Workflow

### Data Preparation

The first phase focused on building a comprehensive clinical-cognitive dataset from raw ADNI files. Subjects were selected based on the availability of both T1-weighted (IR-SPGR) and Axial-DTI sequences from the ADNI2 cohort. Demographic information was extracted, including age, gender, diagnostic group (CN, MCI, AD), and years of education.

Neurocognitive test scores were obtained for the following assessments:

- Mini-Mental State Examination (MMSE).

- Functional Activities Questionnaire (FAQ).

- Clinical Dementia Rating (CDR).

- Alzheimer’s Disease Assessment Scale (ADAS and ADAS-13).

The Bash script modify.sh was developed to automate the merging of variables and generate the final dataset: demographic_neurocognitive_tests.csv, comprising 185 subjects and 10 core variables.

## Image Processing and Metric Extraction

This phase involved the automated computation of volumetric and diffusion-based brain metrics using various neuroimaging tools. T1-weighted images were segmented using FastSurfer with the DKTatlas+aseg protocol to label cortical and subcortical brain regions.

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

This final phase was carried out entirely in R using the script statistical_analysis.rmd, combining and analyzing the datasets generated in the previous phases. The demographic and imaging datasets were merged to create a unified analysis framework.

Descriptive statistics were computed for demographic variables, cognitive scores, and DTI-metrics, with visual summaries including pie charts and boxplots.

Inferential statistical testing included:

- Normality check using the Shapiro-Wilk test.

- Homogeneity of variances assessed with Levene’s test.

- Between-group comparisons using:

    - ANOVA (when normality and homogeneity).

    - Kruskal-Wallis (when non-normality and/or non-homogeneity).

-  Post-hoc testing:

    - Tukey’s HSD for parametric results.

    - Pairwise Wilcoxon tests for non-parametric comparisons.

Correlation analysis was conducted using Pearson’s correlation to examine associations between neurocognitive scores and DTI metrics. Only results with p < 0.05 and |r| ≥ 0.3 (moderate or stronger) were retained. Final outputs were compiled into statistical_analysis.html, offering a complete descriptive and inferential summary of the results.

This work is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).
