clc
close all;
clear all;
% Fourier Peplography : fog removal technique using Fourier domain
% in_img: input image with fog noise
% out_img: restored image after removing fog noise
% Input image using GUI
for depth = 200 : 5 : 500
    depth
    image=['/Users/zoocasso/Desktop/DRPE_3D_high/',num2str(depth),'mm.jpg'];
    in_img=im2double(rgb2gray(imread(image)));
%     in_img=im2double(imread(image));
    [v, h, d]=size(in_img);
%     figure, imshow(in_img);
    %figure, imshow(in_img(:,:,1), []);
    %figure, imshow(in_img(:,:,2), []);
    %figure, imshow(in_img(:,:,3), []);
    if d==1 % Gray image
        f_in_img=zeros(v,h);
        out_img1=zeros(v,h);
        out_img=zeros(v,h);
%         ----- FFT stage -----
        f_in_img=fft2(in_img);
%         ----- Mask generation stage -----
        mask = (v + h).*ones(v, h);ㅌ    
        mask(1,1) = 2*v*h;
        mask(1,2:end) = (v*h + v);
        mask(2:end,1) = (v*h + h);
        mask1 = mask(1,1)./mask;
%         ----- Restoration stage -----
        f_in_img = f_in_img.*mask1;
        out_img1=ifft2(f_in_img);
        if min(out_img1(:))<0
            out_img = out_img1 - min(out_img1(:));
        else
            out_img = out_img1;
        end
        out_img = out_img./max(out_img(:));
        out_img = adapthisteq(out_img);
%         figure, imshow(out_img);
        imwrite(out_img, ['/Users/zoocasso/Desktop/Peplography_high/gray/',num2str(depth),'mm.jpg']);
    else % Color image
        f_in_img=zeros(v,h,d);
        out_img1=zeros(v,h,d);
        out_img=zeros(v,h,d);
%         ----- Mask generation stage -----
        mask = (v + h).*ones(v, h);
        mask(1,1) = 2*v*h;
        mask(1,2:end) = (v*h + v);
        mask(2:end,1) = (v*h + h);
        mask1 = mask(1,1)./mask;
%         ----- FFT stage -----
        f_in_img(:,:,1)=fft2(in_img(:,:,1)).*mask1;
        f_in_img(:,:,2)=fft2(in_img(:,:,2)).*mask1;
        f_in_img(:,:,3)=fft2(in_img(:,:,3)).*mask1;
%         ----- Restoration stage -----
        out_img1(:,:,1)=ifft2(f_in_img(:,:,1));
        out_img1(:,:,2)=ifft2(f_in_img(:,:,2));
        out_img1(:,:,3)=ifft2(f_in_img(:,:,3));
        if min(out_img1(:))<0
            out_img = out_img1 - min(out_img1(:));
        else
            out_img = out_img1;
        end
        out_img = out_img./max(out_img(:));
        out_img(:,:,1) = adapthisteq(out_img(:,:,1));
        out_img(:,:,2) = adapthisteq(out_img(:,:,2));
        out_img(:,:,3) = adapthisteq(out_img(:,:,3));
%         figure, imshow(out_img);
        imwrite(out_img, ['/Users/zoocasso/Desktop/Peplography_high/color/',num2str(depth),'mm.jpg']);
    end
end