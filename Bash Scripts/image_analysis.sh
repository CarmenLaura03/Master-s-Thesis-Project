#!/bin/bash

# Path to the FastSurfer directory
fastsurfer_path="/home/carmen-laura/Downloads/FastSurfer"

# Path to the FreeSurfer license file
fs_license="/home/carmen-laura/Downloads/freesurfer/license.txt"

# Mapping region IDs to anatomical region names from DKTatlas+aseg.orig.mgz
declare -A region_names=([2]="Left-Cerebral-White-Matter" [4]="Left-Lateral-Ventricle" [5]="Left-Inf-Lat-Vent" [7]="Left-Cerebellum-White-Matter" [8]="Left-Cerebellum-Cortex" [10]="Left-Thalamus" [11]="Left-Caudate" [12]="Left-Putamen" [13]="Left-Pallidum" [14]="3rd-Ventricle" [15]="4th-Ventricle" [16]="Brain-Stem" [17]="Left-Hippocampus" [18]="Left-Amygdala" [24]="CSF" [26]="Left-Accumbens-area" [28]="Left-VentralDC" [31]="Left-choroid-plexus" [41]="Right-Cerebral-White-Matter" [43]="Right-Lateral-Ventricle" [44]="Right-Inf-Lat-Vent" [46]="Right-Cerebellum-White-Matter" [47]="Right-Cerebellum-Cortex" [49]="Right-Thalamus" [50]="Right-Caudate" [51]="Right-Putamen" [52]="Right-Pallidum" [53]="Right-Hippocampus" [54]="Right-Amygdala" [58]="Right-Accumbens-area" [60]="Right-VentralDC" [63]="Right-choroid-plexus"
[77]="WM-hypointensities" [1002]="ctx-lh-caudalanteriorcingulate" [1003]="ctx-lh-caudalmiddlefrontal" [1005]="ctx-lh-cuneus" [1006]="ctx-lh-entorhinal" [1007]="ctx-lh-fusiform" [1008]="ctx-lh-inferiorparietal" [1009]="ctx-lh-inferiortemporal" [1010]="ctx-lh-isthmuscingulate" [1011]="ctx-lh-lateraloccipital" [1012]="ctx-lh-lateralorbitofrontal" [1013]="ctx-lh-lingual" [1014]="ctx-lh-medialorbitofrontal" [1015]="ctx-lh-middletemporal" [1016]="ctx-lh-parahippocampal" [1017]="ctx-lh-paracentral" [1018]="ctx-lh-parsopercularis" [1019]="ctx-lh-parsorbitalis" [1020]="ctx-lh-parstriangularis" [1021]="ctx-lh-pericalcarine" [1022]="ctx-lh-postcentral" [1023]="ctx-lh-posteriorcingulate" [1024]="ctx-lh-precentral" [1025]="ctx-lh-precuneus" [1026]="ctx-lh-rostralanteriorcingulate" [1027]="ctx-lh-rostralmiddlefrontal" [1028]="ctx-lh-superiorfrontal" [1029]="ctx-lh-superiorparietal" [1030]="ctx-lh-superiortemporal" [1031]="ctx-lh-supramarginal" [1034]="ctx-lh-transversetemporal" [1035]="ctx-lh-insula" [2002]="ctx-rh-caudalanteriorcingulate" [2003]="ctx-rh-caudalmiddlefrontal" [2005]="ctx-rh-cuneus" [2006]="ctx-rh-entorhinal" [2007]="ctx-rh-fusiform" [2008]="ctx-rh-inferiorparietal" [2009]="ctx-rh-inferiortemporal" [2010]="ctx-rh-isthmuscingulate" [2011]="ctx-rh-lateraloccipital" [2012]="ctx-rh-lateralorbitofrontal"
[2013]="ctx-rh-lingual" [2014]="ctx-rh-medialorbitofrontal" [2015]="ctx-rh-middletemporal" [2016]="ctx-rh-parahippocampal" [2017]="ctx-rh-paracentral" [2018]="ctx-rh-parsopercularis" [2019]="ctx-rh-parsorbitalis" [2020]="ctx-rh-parstriangularis" [2021]="ctx-rh-pericalcarine" [2022]="ctx-rh-postcentral" [2023]="ctx-rh-posteriorcingulate" [2024]="ctx-rh-precentral" [2025]="ctx-rh-precuneus" [2026]="ctx-rh-rostralanteriorcingulate" [2027]="ctx-rh-rostralmiddlefrontal" [2028]="ctx-rh-superiorfrontal" [2029]="ctx-rh-superiorparietal" [2030]="ctx-rh-superiortemporal"
[2031]="ctx-rh-supramarginal" [2034]="ctx-rh-transversetemporal" [2035]="ctx-rh-insula"
)

# Region IDs selected from DKTatlas+aseg.orig.mgz
regions=(2 4 5 7 8 10 11 12 13 14 15 16 17 18 24 26 28 31 41 43 44 46 47 49 50 51 52 53 54 58 60 63 77 1002 1003 1005 1006 1007 1008 1009 1010 1011 1012 1013 1014 1015 1016 1017 1018 1019 1020 1021 1022 1023 1024 1025 1026 1027 1028 1029 1030 1031 1034 1035 2002 2003 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 2031 2034 2035)

# Path to the DSI Studio directory
dsi_studio="/home/carmen-laura/Downloads/dsi_studio_ubuntu2404/dsi-studio/dsi_studio"

# Path for the results CSV file where volume and DTI-metrics for each brain region are being stored for each subject
volume_metrics_results="/home/carmen-laura/volume_metrics_results.csv"
	# If this file does not exist, create it with these headers
	if [ ! -f "$volume_metrics_results" ]; then
                # Patient's ID
                header="ID"
                # Total volume and global DTI-metrics
                header+=";Vol_total;FA_global;MD_global;RD_global;AxD_global"
                # Loop to generate region-specific headers for the CSV file
                for region in "${regions[@]}"; do
                    name="${region_names[$region]}"
                    # Volume and DTI-metrics by brain region
                    header+=";Vol_$name;FA_$name;MD_$name;RD_$name;AxD_$name"
                done
                # Save the headers to the result CSV file
                echo "$header" > "$volume_metrics_results"
        fi

# Loop through each subject directory, which contains MRI data for processing
for dir in /home/carmen-laura/project/*; do

  # Brain segmentation

  	# Extract the subject ID from the directory name
	subject_id=$(basename "$dir")
  
  	# FastSurfer implementation

		# Run FastSurfer for automated brain segmentation
		$fastsurfer_path/run_fastsurfer.sh \
		  --t1 "$dir/anat/${subject_id}_T1w.nii.gz" \
		  --sid  "$subject_id" \
		  --sd "$dir/anat" \
		  --batch 4 \
		  --threads 4 \
		  --3T \
		  --fs_license "$fs_license"
  
  # DTI preprocessing

	# Perform brain skipping/extraction of DTI images 
	bet "$dir/dwi/${subject_id}_dwi.nii.gz" "$dir/dwi/${subject_id}_dwi_bet.nii" -m
     	
     	# Perform eddy current correction for motion and distortions in DTI images
     	
       		# Definition of inds.txt
       		
		# Extraction of the number of columns in bvec files
		cols=$(awk '{print NF}' "$dir/dwi/${subject_id}_dwi.bvec" | head -n 1)
		inds=()
		# Loop to generate indices according to the number of columns in bvec files
		for ((i=1; i<=$cols;i++)); do inds+=("$i"); done
		# Write the results in inds.txt
		echo "${inds[@]}" > "$dir/dwi/inds.txt"
	
		# Definition of acqparams.txt
		
        	# Extract total readout time from DTI.json files
		total_readout_time=$(jq -r .'TotalReadoutTime' "$dir/dwi/${subject_id}_dwi.json")
		# Loop to achieve the readout time for each DTI gradient direction
		for ((i=1; i<=$cols;i++)); do echo "0 1 0 ${total_readout_time}" >> "$dir/dwi/acqparams.txt"; done
		
		# Run eddy-current correction
		eddy --imain="$dir/dwi/${subject_id}_dwi.nii.gz" --mask="$dir/dwi/${subject_id}_dwi_bet_mask.nii.gz" --index="$dir/dwi/inds.txt" --acqp="$dir/dwi/acqparams.txt" --bvecs="$dir/dwi/${subject_id}_dwi.bvec" --bvals="$dir/dwi/${subject_id}_dwi.bval" --out="$dir/dwi/${subject_id}_dwi_eddy"
		
		# Rotate the bvec file to match the corrected DTI data
		xfmrot "$dir/dwi/${subject_id}_dwi_eddy.eddy_parameters" "$dir/dwi/${subject_id}_dwi.bvec" "$dir/dwi/${subject_id}_dwi_eddy_bvec_cor"
		# Replace commas with periods in bvec files
		sed -i 's/,/./g' "$dir/dwi/${subject_id}_dwi_eddy_bvec_cor"
  
  # Postprocessing
  	
  	# Tensor fitting
  
  		# Fit the DTI model on the corrected DTI data
		dtifit -k "$dir/dwi/${subject_id}_dwi_eddy.nii.gz" -o "$dir/dwi/${subject_id}_dwi_fit" -m "$dir/dwi/${subject_id}_dwi_bet_mask.nii.gz" -r "$dir/dwi/${subject_id}_dwi_eddy_bvec_cor" -b "$dir/dwi/${subject_id}_dwi.bval"

	# Calculate the Axial Diffusivity (AxD) from tensor fitting results
	fslmaths "$dir/dwi/${subject_id}_dwi_fit_L1.nii.gz" -mul 1 "$dir/dwi/${subject_id}_dwi_fit_AxD.nii.gz"
	# Calculate the Radial Diffusivity (RD) from tensor fitting results
	fslmaths "$dir/dwi/${subject_id}_dwi_fit_L2.nii.gz" -add "$dir/dwi/${subject_id}_dwi_fit_L3.nii.gz" -div 2 "$dir/dwi/${subject_id}_dwi_fit_RD.nii.gz"

  # Space transformation
  	# Create another directory to contain the transformed data
	mkdir "$dir/trans"

  	# Register the atlas with brain regions from T1-weighted images Sag IR-SPGR to the DTI images space
  	mri_vol2vol \
		--mov "$dir/anat/$subject_id/mri/aparc.DKTatlas+aseg.orig.mgz" \
		--o "$dir/trans/${subject_id}_T1w-to-dwi.nii" \
		--targ "$dir/dwi/${subject_id}_dwi.nii.gz" \
		--nearest --regheader
   
  # Extraction of volume and DTI-metrics by brain regions
   	
   	# Extract volume for the brain regions defined
	mri_segstats --seg "$dir/trans/${subject_id}_T1w-to-dwi.nii" --sum "$dir/trans/volume_results.txt"
	
	# Declare an array to the region volumes
	declare -A region_volume
	# Initialize the total volume
    	vol_total=0.0
	
	# Loop through each brain region
   	for r in "${regions[@]}"; do
		valid_regions["$r"]=1
   	done
	
	# Process the volume outputs for each regions 
   	while read -r index segid nvoxels volume_mm3 structname; do
   		# If the brain region exist, write the volume in the output file
        	if [[ "$index" =~ ^[0-9]+$ ]] && [[ -n "${valid_regions[$segid]}" ]]; then
        	region_volume["$segid"]="$volume_mm3"
        	# Replace commas with periods in volume data
            	clean_vol=$(echo "$volume_mm3" | tr -d '[:space:]' | sed 's/,/./g')
            	# Calculate the total volume
            	vol_total=$(echo "$vol_total + $clean_vol" | bc)
        	fi
    	done < "$dir/trans/volume_results.txt"
    
    	# Prepare the output line with subject ID and global DTI-metrics
    	output_line="$subject_id"
    
    	# Calculate the mean FA value for the whole brain
    	fa_global=$(fslstats "$dir/dwi/${subject_id}_dwi_fit_FA.nii.gz" -M)
    	# Calculate the mean MD value for the whole brain
    	md_global=$(fslstats "$dir/dwi/${subject_id}_dwi_fit_MD.nii.gz" -M)
    	# Calculate the mean RD value for the whole brain
    	rd_global=$(fslstats "$dir/dwi/${subject_id}_dwi_fit_RD.nii.gz" -M)
    	# Calculate the mean AxD value for the whole brain
    	axd_global=$(fslstats "$dir/dwi/${subject_id}_dwi_fit_AxD.nii.gz" -M)
    
    	# Write the results in the output 
    	output_line+=";$vol_total;$fa_global;$md_global;$rd_global;$axd_global"
    
	# Create another directory for masks
	mkdir "$dir/masks"

    	# Loop through each region to generate masks by brain region and extract region-specific DTI-metrics
    	for region in "${regions[@]}"; do
        	# Consider the region name
        	name="${region_names[$region]}"
        	# Create a binary mask for each brain region
        	mri_binarize --i "$dir/trans/${subject_id}_T1w-to-dwi.nii" --o "$dir/masks/${subject_id}_region_mask_$region.nii" --match $region
        	# Extract the volume by brain region according to region_volume declaration done before
        	vol_region="${region_volume[$region]:-0}"
		# Calculate the mean FA value for each brain region
		fa_region=$(fslstats "$dir/dwi/${subject_id}_dwi_fit_FA.nii.gz" -k "$dir/masks/${subject_id}_region_mask_$region.nii" -M)
		# Calculate the mean MD value for each brain region
        	md_region=$(fslstats "$dir/dwi/${subject_id}_dwi_fit_MD.nii.gz" -k "$dir/masks/${subject_id}_region_mask_$region.nii" -M)
        	# Calculate the mean RD value for each brain region
        	rd_region=$(fslstats "$dir/dwi/${subject_id}_dwi_fit_RD.nii.gz" -k "$dir/masks/${subject_id}_region_mask_$region.nii" -M)
        	# Calculate the mean AxD value for each brain region
        	axd_region=$(fslstats "$dir/dwi/${subject_id}_dwi_fit_AxD.nii.gz" -k "$dir/masks/${subject_id}_region_mask_$region.nii" -M)
        	# Write the results in the output 
        	output_line+=";$vol_region;$fa_region;$md_region;$rd_region;$axd_region"
    	done
    
    	# Introduce all the output results to the output file
     	echo "$output_line" >> "$volume_metrics_results"
     	
  # Tractography
	# Create another directory for tractografies
	mkdir "$dir/tracts"  

	# Perform tractography on preprocessed DTI images
 
 		# Convert the raw DTI data into src format
        	$dsi_studio --action=src --source="$dir/dwi/${subject_id}_dwi.nii.gz" --bval="$dir/dwi/${subject_id}_dwi.bval" --bvec="$dir/dwi/${subject_id}_dwi.bvec" --output="$dir/tracts/${subject_id}_dwi_conversion_pre_dsi"
        	# Perform DTI reconstruction with a threshold of 70 with the raw DTI data
		$dsi_studio --action=rec --source="$dir/tracts/${subject_id}_dwi_conversion_pre_dsi.sz" --method=1 --cmd="[Step T2a][Threshold]=70" --output="$dir/tracts/${subject_id}_dwi_reconstruction_pre_threshold_dsi"
 
 	# Perform tractography on posprocessed DTI images
 	
 		# Convert the eddy-corrected DTI data into src format
        	$dsi_studio --action=src --source="$dir/dwi/${subject_id}_dwi_eddy.nii.gz" --bval="$dir/dwi/${subject_id}_dwi.bval" --bvec="$dir/dwi/${subject_id}_dwi_eddy_bvec_cor" --output="$dir/tracts/${subject_id}_dwi_conversion_post_dsi"
        	# Perform DTI reconstruction with a threshold of 70 with the eddy-corrected DTI data
        	$dsi_studio --action=rec --source="$dir/tracts/${subject_id}_dwi_conversion_post_dsi.sz" --method=1 --cmd="[Step T2a][Threshold]=70" --output="$dir/tracts/${subject_id}_dwi_reconstruction_post_threshold_dsi"

done
