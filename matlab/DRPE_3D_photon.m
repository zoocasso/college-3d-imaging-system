% Initialization
clc;
clear all;
close all;
f = 105;        % Focal length of lens
p = 2;          % pitch between elemental images
cx = 36;        % Sensor size in x direction
cy = 24;        % Sensor size in y direction

Nx = 3072;    % The number of pixel in x direction for each elemental image_high
Ny = 2048;    % The number of pixel in y direction for each elemental image_high
% Nx = 1536;      % The number of pixel in x direction for each elemental image_medium
% Ny = 1024;      % The number of pixel in y direction for each elemental image_medium

Lx = 10;        % The number of elemental images in x direction
Ly = 10;        % The number of elemental images in y direction
k=0.3;          % Photon rate
Np=k*Nx*Ny;     % the number of photons
% Random phase masks
rand1 = rand(Ny, Nx); % Uniform distribution
rand2 = rand(Ny, Nx); % Uniform distribution
mask1 = exp(i.*2.*pi.*rand1); % zoocasso phase mask
mask2 = exp(i.*2.*pi.*rand2); % zoocasso phase mask
for depth = 200:5:500
    depth
    shx = round((Nx*f*p/(cx*depth)).*[0:Lx-1]);
    shy = round((Ny*f*p/(cy*depth)).*[0:Ly-1]);
    recon = zeros(Ny + max(shy(:)), Nx + max(shx(:)), 3);
    recon_over = zeros(Ny + max(shy(:)), Nx + max(shx(:)), 3);
    for k1 = Ly:-1:1
        k1
        for k2 = Lx:-1:1
            inputImage = im2double(imread(['/Users/zoocasso/Desktop/high_EIs/high_', num2str((k1-1)*Lx+k2), '.jpg']));            
            [v h d] = size(inputImage); % Image size
            % Encryption
            se(:,:,1)=ifft2(fft2(inputImage(:,:,1).*mask1).*mask2);
            se(:,:,2)=ifft2(fft2(inputImage(:,:,2).*mask1).*mask2);
            se(:,:,3)=ifft2(fft2(inputImage(:,:,3).*mask1).*mask2);
            se_am=abs(se); % Amplitude of the encrypted image
            % Normalization
            se_am(:,:,1)=se_am(:,:,1)./sum(sum(se_am(:,:,1)));
            se_am(:,:,2)=se_am(:,:,2)./sum(sum(se_am(:,:,2)));
            se_am(:,:,3)=se_am(:,:,3)./sum(sum(se_am(:,:,3)));
            se_ph=angle(se); % Phase of the encrypted image
            % Accumulated decrypted image
            % Photon counting process
            sep_a(:,:,1)=poissrnd(Np.*se_am(:,:,1));
            sep_a(:,:,2)=poissrnd(Np.*se_am(:,:,2));
            sep_a(:,:,3)=poissrnd(Np.*se_am(:,:,3));
            %sep_a=sep_a./max(sep_a(:));
            sep=sep_a.*exp(i.*se_ph); %Photon-limited encrypted image
            % Decryption
            sd(:,:,1)=abs(ifft2(fft2(sep(:,:,1)).*conj(mask2)));
            sd(:,:,2)=abs(ifft2(fft2(sep(:,:,2)).*conj(mask2)));
            sd(:,:,3)=abs(ifft2(fft2(sep(:,:,3)).*conj(mask2)));
            recon(shy(k1)+1:shy(k1)+Ny,shx(k2)+1:shx(k2)+Nx, :) = recon(shy(k1)+1:shy(k1)+Ny, shx(k2)+1:shx(k2)+Nx, :) +sd;
            recon_over(shy(k1)+1:shy(k1)+Ny, shx(k2)+1:shx(k2)+Nx, :) =recon_over(shy(k1)+1:shy(k1)+Ny, shx(k2)+1:shx(k2)+Nx, :) + ones(Ny, Nx, 3);
        end
    end
    recon = recon./recon_over;
    imwrite(recon,['/Users/zoocasso/Desktop/DRPE_3d_high/',num2str(depth),'mm.jpg']);
end

% Output
figure, imshow(inputImage);
title('Original Image');
figure, imshow(abs(sep));
title('Encrypted Image');
figure, imshow(sd);
title('Decrypted Image');
figure, imshow(recon);
title('3D Decrypted Image');