%%% 

clc;
clear;
close all;

load('mascara.mat')

sample  = 1:20;
M       = 1460;
N       = 2360;
step    = [  0   1,  2,  3,  4,  5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19];
PSFsize = [  1,  4, 12, 18, 25, 37,  43,  49,  61,  66,  74,  85,  90,  96, 101, 107, 140, 160, 185, 200];
% sigma   = [0.1,0.1,1.0,1.0,0.5,0.5,0.25,0.25,0.25,0.15,0.15,0.15,0.10,0.10,0.10,0.10,0.08,0.06,0.04,0.04];
% lambda  = [2.0,2.0,4.0,4.0,4.0,4.0,4.00,4.00,4.00,6.00,6.00,6.00,6.00,6.00,6.00,6.00,6.00,6.00,6.00,6.00];
step    = [18,  19];
sigma   = [0.1,0.1,1.0,1.0,0.5,0.5,0.25,0.25,0.25,0.15,0.15,0.15,0.10,0.10,0.10,0.10,0.06,0.06,0.06,0.06];
lambda  = [2.0,2.0,4.0,4.0,4.0,4.0,4.00,4.00,4.00,6.00,6.00,6.00,6.00,6.00,6.00,6.00,6.00,6.00,6.00,6.00];

for ii = 1:length(step)
        
    L     = PSFsize(step(ii)+1);
    PSF   = fspecial('disk',L);
    OTF   = psf2otf(PSF,[M,N]);
    PSF   = otf2psf(OTF);
    
    for jj =1:length(sample)

        [step(ii) sample(jj)]
        
        namecam01 = strcat('Data/test/CAM01_focused/focusStep_',num2str(step(ii)),'_verdanaRef_size_30_sample_',num2str(sample(jj),'%04.0f'),'.tif');
        namecam02 = strcat('Data/test/CAM02_blurred/focusStep_',num2str(step(ii)),'_verdanaRef_size_30_sample_',num2str(sample(jj),'%04.0f'),'.tif');
        cam01   = 1-normalize(double(imread(namecam01)),2);
        cam02   = 1-normalize(double(imread(namecam02)),2);
        mtemp   = mask(:,:,step(ii)+1);
        cam02m  = cam02.*mtemp/max(mtemp(:));

                    
        %% Decon

        Niter  = 100;
        K      = 15;
        
        tic
        [d0,~,~]   = deconv_image_red(cam02,PSF,sigma(step(ii)+1),lambda(step(ii)+1),Niter);
        % figure, subplot(131),plot(Jmse), subplot(132),plot(Jl1), subplot(133),plot(Jmse+lambda*Jl1)

        [dm0,~,~]  = deconv_image_red(cam02m,PSF,sigma(step(ii)+1),lambda(step(ii)+1),Niter);
        % figure, subplot(131),plot(Jmse), subplot(132),plot(Jl1), subplot(133),plot(Jmse+lambda*Jl1)
        time1 = toc;
        d0  = normalize(d0,2);
        d1  = medfilt2(d0,[K K]);
        dh0 = histeq(1-d1+mean(d1(:))+std(d1(:)));
        dh1 = 1-imopen(1-dh0,ones(3));

        dm0  = normalize(dm0,2);
        dm1  = medfilt2(dm0,[K K]);
        dhm0 = histeq(1-dm1+mean(dm1(:))+std(dm1(:)));
        dhm1 = 1-imopen(1-dhm0,ones(3));
   
        named0   = strcat('results/d0/focusStep_',num2str(step(ii)),'_verdanaRef_size_30_sample_',num2str(sample(jj),'%04.0f'),'.png');
        named1   = strcat('results/d1/focusStep_',num2str(step(ii)),'_verdanaRef_size_30_sample_',num2str(sample(jj),'%04.0f'),'.png');
        namedh0  = strcat('results/dh0/focusStep_',num2str(step(ii)),'_verdanaRef_size_30_sample_',num2str(sample(jj),'%04.0f'),'.png');
        namedh1  = strcat('results/dh1/focusStep_',num2str(step(ii)),'_verdanaRef_size_30_sample_',num2str(sample(jj),'%04.0f'),'.png');
        
        namedm0  = strcat('results/dm0/focusStep_',num2str(step(ii)),'_verdanaRef_size_30_sample_',num2str(sample(jj),'%04.0f'),'.png');
        namedm1  = strcat('results/dm1/focusStep_',num2str(step(ii)),'_verdanaRef_size_30_sample_',num2str(sample(jj),'%04.0f'),'.png');
        namedhm0 = strcat('results/dhm0/focusStep_',num2str(step(ii)),'_verdanaRef_size_30_sample_',num2str(sample(jj),'%04.0f'),'.png');
        namedhm1 = strcat('results/dhm1/focusStep_',num2str(step(ii)),'_verdanaRef_size_30_sample_',num2str(sample(jj),'%04.0f'),'.png');
        tic
        imwrite(1-d0,named0)
        imwrite(1-d1,named1)
        imwrite(dh0,namedh0)
        imwrite(dh1,namedh1)
        imwrite(1-dm0,namedm0)
        imwrite(1-dm1,namedm1)
        imwrite(dhm0,namedhm0)
        imwrite(dhm1,namedhm1)
        time2 = toc;
        [time1 time2]
    end
end

% figure, colormap(gray)
% subplot(3,5,1), imagesc(1-cam01)
% subplot(3,5,2), imagesc(1-PSF)
% subplot(3,5,3), imagesc(1-real(ifft2(OTF.*fft2(cam01))))
% subplot(3,5,6), imagesc(1-cam02m)
% subplot(3,5,7), imagesc(1-d0)
% subplot(3,5,8), imagesc(1-d1)
% subplot(3,5,9), imagesc(dh0)
% subplot(3,5,10), imagesc(dh1)
% subplot(3,5,11), imagesc(1-cam02m)
% subplot(3,5,12), imagesc(1-dm0)
% subplot(3,5,13), imagesc(1-dm1)
% subplot(3,5,14), imagesc(dhm0)
% subplot(3,5,15), imagesc(dhm1)