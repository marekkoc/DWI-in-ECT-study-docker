#!/usr/bin/env bash
# usage:
#    /input - input DICOM files
#    /output - output DICOM files will be placed here


# DICOM to nifti conversion
dcm2niix -f "%f_%p_%t_%s" -i y -p n -z n -o /output /input

# Planned functions
#
# TOPUP/EDDY
# Old RSI has phase-reversed image as a flipped up-side-down image in the main DWI series, so we need to extract it first
#
# fslroi AP_B0_images DTI_file 0 1
# fslroi PA_B0_images DTI_file 1 1
# fslswapdim AP_B0_images x -y z AP_B0_images
# fslmerge -t MERGED_B0_images AP_B0_images PA_B0_images
#
# remove the flipped image from the main acquisition file
#fslroi DTI_file DTI_file 1 -1 
#
# Timings for field-map and order of phase
# printf 0 -1 0 0.0588\n0 1 0 0.0588 > acqparams.txt
#
# Top-up field map calculation
#topup --imain=MERGED_B0_images --datain=acqparams.txt--config=b02b0_edit.cnf --out=topup --iout=corrected_B0
#
# Brain-mask creation
# fslmaths correctedB0 -Tmean correctedB0
# bet2 correctedB0 correctedB0_brain -m -f 0.4
#
# Run Eddy for distortion and movement correction using topup output
# eddy --imain=DTI_file--mask=mask_file --acqp=acqparams.txt --index=index.txt --bvecs=bvecs --bvals=bvals --topup=topup--out=eddy_corr_ --niter=8 --fwhm=10,8,4,2,0,0,0,0 --repol --ol_type=both --mporder=8 --s2v_niter=8 --slspec=my_slspec.txt

