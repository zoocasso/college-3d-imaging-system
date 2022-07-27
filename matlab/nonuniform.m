clc;
clear all;
close all;
% Integral Imaging system parameters settting

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nx = 696;
Ny = 464;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = 50;
p = 2;
cx = 36;
cy = 24;
Lx = 10;        % The number of elemental images in x direction
Ly = 10;        % The number of elemental images in y direction

% Reconstruction depth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for depth = 250:5:350 % grass_and_car = 200:5:500
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    depth
    % Shifting pixels for each elemental image
    shx = round(Nx*f*p/(cx*depth).*[0:Lx-1]);
    shy = round(Ny*f*p/(cy*depth).*[0:Lx-1]);
    % Reconstructed 3D image matrix
    recon = zeros(Ny + max(shy(:)), Nx + max(shx(:)),3);
    % Overlapping matrix
    recon_over = zeros(Ny + max(shy(:)), Nx + max(shx(:)), 3);
    % Superposition of elemental images at reconstruction depth
    for k1 = 1:Ly
        for k2 = 1:Lx

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            image = imread(['/Users/zoocasso/Desktop/DRPE_image/True/', num2str((k1-1)*Lx+k2), '.jpg']);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %image를 중첩하여 채움
            recon(shy(k1) + 1:shy(k1) + Ny, shx(k2) + 1:shx(k2) + Nx, :) = recon(shy(k1) + 1:shy(k1) + Ny, shx(k2) + 1:shx(k2) + Nx, :) + im2double(image);
            %같은 방식으로 1을 중첩하여 채움
            recon_over(shy(k1) + 1:shy(k1) + Ny, shx(k2) + 1:shx(k2) + Nx, :) = recon_over(shy(k1) + 1:shy(k1) + Ny, shx(k2) + 1:shx(k2) + Nx, :) + ones(Ny, Nx,3);
        end
    end
    % Averaging
    recon = recon./recon_over; %요소간의 나눗셈 ./
    % Save reconstructed 3D image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    imwrite(recon, ['/Users/zoocasso/Desktop/imageDepth/', num2str(depth), 'mm.jpg']);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end