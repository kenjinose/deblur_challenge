%%% 

clc;
clear;

%% Mask 
load('mask14.mat')

PSFsize = [   1,   4,  12,  18,  25,  37,  43,  49,  61,  66,  74,  85,  90,  96, 101, 107,  140, 160,   185,  200];
sigma   = [1.50,1.50,1.50,1.50,0.50,0.25,0.10,0.10,0.10,0.03,0.03,0.03,0.03,0.02,0.02,0.02,0.015,0.015,0.010,0.010];
lambda  = [0.12,0.12,0.12,0.12,0.12,0.08,0.08,0.06,0.03,0.03,0.03,0.03,0.03,0.02,0.02,0.02,0.005,0.005,0.005,0.005];
step    = 14; % test with 14
sample  = 1;  % test with 1

M = 1460;
N = 2360;

%% Test

namecam01 = strcat('./Data/test/CAM01_focused/focusStep_',num2str(step),'_timesR_size_30_sample_',num2str(sample,'%04.0f'),'.tif');
namecam02 = strcat('./Data/test/CAM02_blurred/focusStep_',num2str(step),'_timesR_size_30_sample_',num2str(sample,'%04.0f'),'.tif');

cam01  = 1-normalize(double(imread(namecam01)),1);
cam02  = 1-normalize(double(imread(namecam02)),1);
cam02m = cam02.*mask/max(mask(:));

scale  = 0.2; 

cam01  = imresize(cam01,scale);
cam02  = imresize(cam02,scale);
cam02m = imresize(cam02m,scale);

PSF    = fspecial('disk',PSFsize(step+1)*scale);
OTF    = psf2otf(PSF,size(cam01));

Niter  = 200;
K      = round(scale*15);

sigmat  = sigma(step+1);
lambdat = lambda(step+1);

[d0,Jmse,Jl1] = deconv_imagel1(cam02m,PSF,sigmat,lambdat,Niter);

d0  = normalize(d0,2);
d1  = medfilt2(d0,[K K]);
dh0 = histeq(1-d1+mean(d1(:))+std(d1(:)));
dh1 = 1-imopen(1-dh0,ones(3));

figure(1),
subplot(131), plot(Jmse)
subplot(132), plot(Jl1)
subplot(133), plot(Jmse+lambdat*Jl1)

figure(), colormap(gray)
subplot(3,3,1), imagesc(1-cam01)
subplot(3,3,2), imagesc(1-PSF)
subplot(3,3,3), imagesc(1-real(ifft2(OTF.*fft2(cam01))))
subplot(3,3,4), imagesc(1-cam02m)
subplot(3,3,5), imagesc(1-d0)
subplot(3,3,6), imagesc(dh0)
subplot(3,3,7), imagesc(1-cam02m)
subplot(3,3,8), imagesc(1-d1)
subplot(3,3,9), imagesc(dh1)

set(gcf,'Position',[100 100 1416 876])