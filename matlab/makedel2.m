clc
close all;
clear all;
image = ['/Users/zoocasso/Desktop/peplography/gray/445mm.jpg'];
    inputImage = im2double(imread(image));
%     inputImage = im2double(rgb2gray(imread(image)));
%     figure, imshow(inputImage);
[v,h,d]=size(inputImage);
for k= 0.01:0.005:0.2
    k
    if d==1     % grayImage
        del2Image = zeros(v,h);
        del2Image = del2(inputImage,k);
        imwrite(del2Image,['/Users/zoocasso/Desktop/data/',num2str(k),'.jpg']);
    else        % colorImage
        del2Image = zeros(v,h,d);
        del2Image(:,:,1) = del2(inputImage(:,:,1),k);
        del2Image(:,:,2) = del2(inputImage(:,:,2),k);
        del2Image(:,:,3) = del2(inputImage(:,:,3),k);
        imwrite(del2Image,['/Users/zoocasso/Desktop/data/',num2str(k),'.jpg']);
    end
end