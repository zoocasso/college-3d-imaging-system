clc;
clear all;
close all;

targetImage = im2double(imread('/Users/zoocasso/Desktop/target/high_Els/target_high.jpg'));   % Target Image
inputImage = im2double(imread('/Users/zoocasso/Desktop/DRPE_3D/445mm.jpg'));   % Input Image
[v, h, d] = size(targetImage);
[v1, h1, d1] = size(inputImage);

if(d~=1)
    targetImage = targetImage(:,:,1);
end

if(d1~=1)
    inputImage = inputImage(:,:,1);
end

if(rem(v,2) == 1)
    v = v - 1;
end
if(rem(h,2) == 1)
    h = h - 1;
end

targetImage = imresize(targetImage,[v,h]);

if(rem(v1,2) == 1)
    v1 = v1 - 1;
end
if(rem(h1,2) == 1)
    h1 = h1 - 1;
end

inputImage = imresize(inputImage,[v1,h1]);

% Zero-Padding
referenceImageZeroPadding = padarray(targetImage,[floor((v1-v)/2),floor((h1-h)/2)],0,'both');

% Fourier Transform
fourierReferenceImage = fft2(referenceImageZeroPadding);
fourierInputImage = fft2(inputImage);

% Linear Correlation Filter
LCF_referenceImage = abs(fftshift(ifft2(fourierReferenceImage.*conj(fourierReferenceImage))));       % autocorrelation
LCF_inputImage = abs(fftshift(ifft2(fourierInputImage.*conj(fourierReferenceImage))));       % cross-correlation
max_LCF = max(LCF_referenceImage(:));   % Maximum of autocorrelation
figure, mesh(LCF_inputImage./max_LCF);
axis([300 h1-300 300 v1-300]);  % Axis (IMPORTANT)

% Phase Only Filter
POF_referenceImage = abs(fftshift(ifft2(exp(1i.*(angle(fourierReferenceImage) - angle(fourierReferenceImage))))));       % autocorrelation
POF_inputImage = abs(fftshift(ifft2(exp(1i.*(angle(fourierInputImage) - angle(fourierReferenceImage))))));       % cross-correlation
max_POF = max(POF_referenceImage(:));   % Maximum of autocorrelation
figure, mesh(POF_inputImage./max_POF);
axis([300 h1-300 300 v1-300]);  % Axis (IMPORTANT)

% Nonlinear Correlation Filter
k = 0.3;
NLF_referenceImage = abs(fftshift(ifft2(((abs(fourierReferenceImage).*abs(fourierReferenceImage)).^k).*exp(1i.*(angle(fourierReferenceImage) - angle(fourierReferenceImage))))));
NLF_inputImage = abs(fftshift(ifft2(((abs(fourierInputImage).*abs(fourierReferenceImage)).^k).*exp(1i.*(angle(fourierInputImage) - angle(fourierReferenceImage))))));
max_NLF = max(NLF_referenceImage(:));   % Maximum of autocorrelation
figure, mesh(NLF_inputImage./max_NLF);
axis([300 h1-300 300 v1-300]);  % Axis (IMPORTANT)

%Find Position
max_value = max(max(NLF_inputImage(300:v1-300,300:h1-300)./max_NLF))
position = find(NLF_inputImage(:)./max_NLF == max_value)
xposition = floor(position./v1)
yposition = rem(position,v1)