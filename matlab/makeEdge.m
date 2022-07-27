clc
close all;
clear all;
for depth= 200:5:500
    depth
    image = ['/Users/zoocasso/Desktop/DRPE_3D_high/',num2str(depth),'mm.jpg'];
%     inputImage = im2double(imread(image));
    inputImage = im2double(rgb2gray(imread(image)));
    % figure, imshow(inputImage);
    [v,h,d]=size(inputImage);
    if d==1     % grayImage
        edgeImage = zeros(v,h);
        edgeImage = edge(inputImage,'canny');
        imwrite(edgeImage,['/Users/zoocasso/Desktop/edge/DRPE_gray/',num2str(depth),'mm.jpg']);
    else        % colorImage
        edgeImage = zeros(v,h,d);
        edgeImage(:,:,1) = edge(inputImage(:,:,1),'canny');
        edgeImage(:,:,2) = edge(inputImage(:,:,2),'canny');
        edgeImage(:,:,3) = edge(inputImage(:,:,3),'canny');
        imwrite(edgeImage,['/Users/zoocasso/Desktop/edge/DRPE_color/',num2str(depth),'mm.jpg']);
    end
end