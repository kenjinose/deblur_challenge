function [y,Jmse,Jl1] = deconv_imagel1(x,PSF,sigma,lambda,Niter)

%%% L1 regularized image deconvolution with ADMM algorithm
[M,N] = size(x);
X     = fft2(x);
y     = x;
OTF   = psf2otf(PSF,size(x));

a = y;
w = y;
A = fft2(a);
W = fft2(w);

fftHtH = conj(OTF).*OTF;
fftHtX = conj(OTF).*X;

Jmse = zeros(1,Niter);
Jl1 = zeros(1,Niter);

for ii = 1:Niter
    
    %%% Update image
%     Y = (fftHtX + sigma*fft2((a - w)) )./(fftHtH + sigma);
%     y = real(ifft2(Y));
%     a = wthresh(y+w,'s',lambda/sigma);
%     w = w + y - a;
    Y = (fftHtX + sigma*(A-W) )./(fftHtH + sigma);
    y = real(ifft2(Y));
    a = wthresh(real(ifft2(Y+W)),'s',lambda/sigma);
    A = fft2(a);
    W = W + Y - A;
    
%     E = X - OTF.*Y;
%     Jmse(ii) = 0.5*E(:)'*E(:)/(M*N);
%     Jl1(ii)  = sum(abs(y(:)));
    
end
