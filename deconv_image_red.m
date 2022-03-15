function [y,Jmse,Jred] = deconv_image_red(x,PSF,sigma,lambda,Niter)

%%% L1 regularized image deconvolution with ADMM algorithm
[M,N] = size(x);
X     = fft2(x);
y     = x;
OTF   = psf2otf(PSF,size(x));

yd = red(y);

fftHtH = (1/(sigma^2))*conj(OTF).*OTF;
fftHtX = (1/(sigma^2))*conj(OTF).*X;

Jmse = zeros(1,Niter);
Jred = zeros(1,Niter);

for ii = 1:Niter
    
    %%% Update image
    Y  = (fftHtX + lambda*fft2((yd)))./(fftHtH + lambda);
    y  = real(ifft2(Y));
    yd = red(y);
    
    E        = X - OTF.*Y;
    Jmse(ii) = 0.5*E(:)'*E(:)/(M*N);
    Jred(ii)  = sum(sum(y.*(y-yd)));
    
end

function y = red(y)

y = y - median(y(:));
y(y<0) = 0;
y(y>1) = 1;



