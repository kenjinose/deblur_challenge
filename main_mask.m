%%% 

clc;
clear;
close all;

%% Mask 

PSFsize = [1,4,12,18,25,37,43,49,61,66,74,85,90,96,101,107,140,160,185,200];
for step = 0:19

    M = 1460;
    N = 2360;

    L   = PSFsize(step+1);
    PSF = fspecial('disk',L);
    OTF = psf2otf(PSF,[M,N]);
    PSF = otf2psf(OTF);

    names{1} = strcat('Data/CAM01_focused/focusStep_',num2str(step),'_PSF.tif');
    namex{1} = strcat('Data/CAM02_blurred/focusStep_',num2str(step),'_PSF.tif');

    names{2} = strcat('Data/CAM01_focused/focusStep_',num2str(step),'_LSF_X.tif');
    namex{2} = strcat('Data/CAM02_blurred/focusStep_',num2str(step),'_LSF_X.tif');

    names{3} = strcat('Data/CAM01_focused/focusStep_',num2str(step),'_LSF_Y.tif');
    namex{3} = strcat('Data/CAM02_blurred/focusStep_',num2str(step),'_LSF_Y.tif');

    for ii = 1:3
        s(:,:,ii) = 1-normalize(double(imread(names{ii})),1);
        x(:,:,ii) = 1-normalize(double(imread(namex{ii})),1);
        y(:,:,ii) = normalize(real(ifft2(OTF.*fft2(s(:,:,ii)))),1);
    end

    m = y./x;
    m = mean(m,3); % Estimador de média
    m(m>median(m(:))) = median(m(:));
    mask(:,:,step+1)  = m;

end

save('mascara.mat','mask')
