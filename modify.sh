#!/bin/bash

# Define file names for the different datasets
DTI="Axial_DTI.csv"
SPGR="Sag_IR-SPGR.csv"
DEMOG="PTDEMOG.csv"
MMSE="MMSE.csv"
FAQ="FAQ.csv"
CDR="CDR.csv"
ADAS="ADAS.csv"

# Function to extract coincidences between DTI and SPGR csv files
extract_coincidences() {
	file=$1
	output=$2
	# Extract unique patient IDs
	awk -F',' 'NR > 1 {
	  gsub(/"/, "", $2); # Remove quotes from the second column
	  if (!seen[$2]++) { # Only print unique patient IDs
		print $2", "$3", "$4", "$5", "$6 # Output columns 2-6
	  }
	}' "$file" | sort > "$output"
}

# Call the function for DTI and SPGR files
extract_coincidences "$DTI" DTI_2.txt
extract_coincidences "$SPGR" IR-SPGR_2.txt

# Find the common patients between DTI and SPGR
comm -12 DTI_2.txt IR-SPGR_2.txt > patients.csv

# Process demographic file to obtain Education values per each patient
awk -F',' 'NR > 1 {
	# Clean up the input data removing quotes
	gsub(/"/, "", $1); gsub(/"/, "", $2); gsub(/"/, "", $13);
	# Only process rows with "ADNI2" phase and a non-empty education value
	if ($1 == "ADNI2" && $13 != "") {
		# Write the education level for each patient ID
		if(!( $2 in educ))  {
			educ[$2] = $13;
	}
   }
}
END {
	# Print out if for each patient
	for (id in educ) {
		print id","educ[id];
    }
}' "$DEMOG" | sort > education.csv

# Merge education data into the patient.csv document previously created 
awk -F',' 'NR==FNR {
	# Clean up removing quotes
	gsub(/"/, "", $1); gsub(/"/, "", $2);
	educ[$1] = $2;
	next
}
NR==1 {
	# Skip header in the second file, patients.csv
	next
}
{
	# Clean up removing quotes
	gsub(/"/, "", $1);
	# Cut any extra spaces from the columns
	for (i = 2; i <=  NF; i++) gsub(/^ +| +$/, "", $i);
	sid = $1;
	# Add education information for each patient, using "NA" if not found
	print $1","$2","$3","$4","$5","(sid in educ ? educ[sid]: "NA");
}' education.csv patients.csv > demographic.csv

# Process MMSE scores
awk -F',' '
    BEGIN {
        OFS = ","  # Specify the output field separator
    }

    NR == FNR {
        # Process MMSE.csv 
        phase = $1
        id = $2
        visit = $4
        score = $50

	# Remove quotes from the MMSE data
        gsub(/"/, "", phase)
        gsub(/"/, "", id)
        gsub(/"/, "", visit)
        gsub(/"/, "", score)
	
	# Create a unique key for patient ID and visit
        key_exact = id "," visit

	# Write the MMSE score for patients with "ADNI2" phase
        if (phase == "ADNI2") {
            exact_adni2[key_exact] = score
            if (!(any_adni2[id])) {
                any_adni2[id] = score
            }
        } else {
            # For other phases, write the first available score
            if (!(any_other[id])) {
                any_other[id] = score
            }
        }

        next
    }

    # Process demographic.csv and merge with MMSE data
    {
        id = $1
        visit = $5
        gsub(/"/, "", id)
        gsub(/"/, "", visit)

        key = id "," visit

	# Extract MMSE score based on the patient ID and visit
        if (key in exact_adni2) {
            mmse = exact_adni2[key]
        } else if (id in any_adni2) {
            mmse = any_adni2[id]
        } else if (id in any_other) {
            mmse = any_other[id]
        } else {
            # If no MMSE score available, write "NA"
            mmse = "NA"
        }
	
        print $0, mmse
    }
' MMSE.csv demographic.csv > demographic_MMSE.csv

# Process FAQ scores
awk -F',' '
    BEGIN {
        OFS = ","  # Specify the output field separator
    }

    NR == FNR {
        # Process FAQ.csv 
        phase = $1
        id = $2
        visit = $4
        score = $18

	# Remove quotes from the FAQ data
        gsub(/"/, "", phase)
        gsub(/"/, "", id)
        gsub(/"/, "", visit)
        gsub(/"/, "", score)

	# Create a unique key for patient ID and visit
        key_exact = id "," visit

	# Write the FAQ score for patients with "ADNI2" phase
        if (phase == "ADNI2") {
            exact_adni2[key_exact] = score
            if (!(any_adni2[id])) {
                any_adni2[id] = score
            }
        } else {
            # For other phases, write the first available score
            if (!(any_other[id])) {
                any_other[id] = score
            }
        }

        next
    }

    # Process demographic_MMSE.csv and merge with FAQ data
    {
        id = $1
        visit = $5
        gsub(/"/, "", id)
        gsub(/"/, "", visit)

        key = id "," visit
	# Extract FAQ score based on the patient ID and visit
        if (key in exact_adni2) {
            faq = exact_adni2[key]
        } else if (id in any_adni2) {
            faq = any_adni2[id]
        } else if (id in any_other) {
            faq = any_other[id]
        } else {
            # If no FAQ score available, write "NA"
            faq = "NA"
        }

        print $0, faq
    }
' FAQ.csv demographic_MMSE.csv > demographic_MMSE_FAQ.csv

# Process CDR scores
awk -F',' '
    BEGIN {
        OFS = ","  # Specify the output field separator
    }

    NR == FNR {
        # Process CDR.csv 
        phase = $1
        id = $2
        visit = $4
        score = $16

	# Remove quotes from the CDR data
        gsub(/"/, "", phase)
        gsub(/"/, "", id)
        gsub(/"/, "", visit)
        gsub(/"/, "", score)

	# Create a unique key for patient ID and visit
        key_exact = id "," visit

	# Write the CDR score for patients with "ADNI2" phase
        if (phase == "ADNI2") {
            exact_adni2[key_exact] = score
            if (!(any_adni2[id])) {
                any_adni2[id] = score
            }
        } else {
            # For other phases, write the first available score
            if (!(any_other[id])) {
                any_other[id] = score
            }
        }

        next
    }

    # Process demographic_MMSE_FAQ.csv and marge with CDR data
    {
        id = $1
        visit = $5
        gsub(/"/, "", id)
        gsub(/"/, "", visit)

        key = id "," visit
	# Extract CDR score based on the patient ID and visit
        if (key in exact_adni2) {
            cdr = exact_adni2[key]
        } else if (id in any_adni2) {
            cdr = any_adni2[id]
        } else if (id in any_other) {
            cdr = any_other[id]
        } else {
            # If no CDR score available, write "NA"
            cdr = "NA"
        }

        print $0, cdr
    }
' CDR.csv demographic_MMSE_FAQ.csv > demographic_MMSE_FAQ_CDR.csv

# Process ADAS scores
awk -F',' '
    BEGIN {
        OFS = ","  # Specify the output field separator
    }

    NR == FNR {
        # Process ADAS.csv 
        phase = $1
        id = $2
        visit = $4
        score = $111
	# Remote quotes from the ADAS data
        gsub(/"/, "", phase)
        gsub(/"/, "", id)
        gsub(/"/, "", visit)
        gsub(/"/, "", score)
	# Create a unique key for patient ID and visit
        key_exact = id "," visit
	# Write the ADAS score for patients with "ADNI2" phase
        if (phase == "ADNI2") {
            exact_adni2[key_exact] = score
            if (!(any_adni2[id])) {
                any_adni2[id] = score
            }
        } else {
            # For other phases, write the first available score
            if (!(any_other[id])) {
                any_other[id] = score
            }
        }

        next
    }

    # Process demographic_MMSE_FAQ_CDR.csv and merge with ADAS data
    {
        id = $1
        visit = $5
        gsub(/"/, "", id)
        gsub(/"/, "", visit)

        key = id "," visit
	# Extract ADAS score based on the patient ID and visit
        if (key in exact_adni2) {
            adas = exact_adni2[key]
        } else if (id in any_adni2) {
            adas = any_adni2[id]
        } else if (id in any_other) {
            adas = any_other[id]
        } else {
            # IF no ADAS score available, write "NA"
            adas = "NA"
        }

        print $0, adas
    }
' ADAS.csv demographic_MMSE_FAQ_CDR.csv > demographic_MMSE_FAQ_CDR_ADAS.csv

# Process ADAS_13 scores
awk -F',' '
    BEGIN {
        OFS = ","  # Specify the output field separator
    }

    NR == FNR {
        # Process ADAS.csv
        phase = $1
        id = $2
        visit = $4
        score = $117
	# Remove quotes from the ADAS data
        gsub(/"/, "", phase)
        gsub(/"/, "", id)
        gsub(/"/, "", visit)
        gsub(/"/, "", score)

	# Create a unique key for patient ID and visit
        key_exact = id "," visit
	# Write the ADAS_13 score for patients with "ADNI2" phase
        if (phase == "ADNI2") {
            exact_adni2[key_exact] = score
            if (!(any_adni2[id])) {
                any_adni2[id] = score
            }
        } else {
            # For other phases, write the first available score
            if (!(any_other[id])) {
                any_other[id] = score
            }
        }

        next
    }

    # Process demographic_MMSE_FAQ_CDR_ADAS.csv and merge with ADAS_13 data
    {
        id = $1
        visit = $5
        gsub(/"/, "", id)
        gsub(/"/, "", visit)

        key = id "," visit
	# Extract ADAS_13 score based on the patient ID and visit
        if (key in exact_adni2) {
            adas13 = exact_adni2[key]
        } else if (id in any_adni2) {
            adas13 = any_adni2[id]
        } else if (id in any_other) {
            adas13 = any_other[id]
        } else {
            # If no ADAS_13 score available, write "NA"
            adas13 = "NA"
        }

        print $0, adas13
    }
' ADAS.csv demographic_MMSE_FAQ_CDR_ADAS.csv > demographic_neurocognitive_tests.csv

# Add the header row to the final output CSV file
sed -i '1iID,Group,Sex,Age,Visit,Education,MMSE_Score,FAQ_Score,CDR_Score,ADAS_Score,ADAS_13_Score' demographic_neurocognitive_tests.csv

# Remove all intermediate files
rm -f patients.csv demographic.csv demographic_MMSE.csv demographic_MMSE_FAQ.csv demographic_MMSE_FAQ_CDR.csv demographic_MMSE_FAQ_CDR_ADAS.csv


