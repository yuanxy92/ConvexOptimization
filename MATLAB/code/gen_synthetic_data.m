%% generate synthetic blurry image
% This code is written for ELEC5470 convex optimization project Fall 2017-2018
% @author: Shane Yuan
% @date: Dec 4, 2017
% I write this code basd on Jinshan Pan's open source code. Thanks to
% Jinshan Pan
% 
clear;
close all;
fclose all;

img_num = 20;
kernel_num = 8;

img_path = 'images/synthetic/groundtruth';
kernel_path = 'images/synthetic/kernel';
blur_path = 'images/synthetic/blurry';

for i = 1:img_num
    img = im2double(imread(sprintf('%s/img_%02d.png', img_path, i)));
    fprintf('Processing image %02d ...\n', i);
    for j = 1:kernel_num
        k = im2double(imread(sprintf('%s/k%d.png', kernel_path, j)));
        k = k ./ sum(k(:));
        blur = imfilter(img, k, 'replicate');
        blur = imnoise(blur, 'gaussian', 0, 0.0001);
        imwrite(blur, sprintf('%s/img_%02d_kernel_%02d.png', blur_path, i, j));
    end
end
