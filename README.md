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

## Authors

João Rabello Alvim, BSc - UNICAMP j.rabello.alvim@outlook.com
Kenji Nose Filho, PhD - UFABC kenji.nose@ufabc.edu.br
Mauro Luis Brandão Junior, MSc - UNICAMP mrbrjr@gmail.com
Renan Del Buono Brotto, MSc - UNICAMP renanbrotto@gmail.com
Renato da Rocha Lopes, PhD - UNICAMP rlopes@unicamp.br
Thomas Antônio Portugal Pereira Teixeira, BSc - UNICAMP thomasportugal5@gmail.com
Victor Carneiro Lima, BSc - UNICAMP v157460@dac.unicamp.br

## Documentation

See functions documentation and:

Nose-Filho, K.; Brandão Junior M. L; Lima, V. C.; Brotto, R. D. B.; Alvim, J. R.; Thomas, T. A. P. P.; Lopes, R. R.

Nose-Filho, K.; Lopes, R.; Brotto, R. D. B.; Senna, T. C.; Romano, J. M. T.; Improving Image Deblurring (To be published).
