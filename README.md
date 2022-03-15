# deblur_challenge

Scripts and codes for image deblurring of the Helsink Deblur Challenge.

More info abaout the competition: https://www.fips.fi/HDC2021.php

# deconv_image_red.m

Deblur algorithm based on the fixed-point regularization by denoise algorithm (FP-RED).

# deconv_imagel1.m

Deblur algorithm based on the ADMM LASSO algorithm.

# test_decon_l1.m

Script for test the ADMM LASSO algorithm with an image sample of the competition, available at the folder Data.

# test_decon_red.m

Script for test the FP-RED algorithm with an image sample of the competition, available at the folder Data.

# mask14.mat

Contrast map for the step 14 for running the test scripts

# main_mask.m

Script for estmating the contrast map (in a batch) with the PSF, and LSFs provided - note that it is necessary to download the files from the competation and change the folder names.

# othe main scripts

Scripts for deblurring the images with the selected algorithms and selected font types (in a batch)
