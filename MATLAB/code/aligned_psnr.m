%% calculate aligned PSNR of two images
% This code is written for ELEC5470 convex optimization project Fall 2017-2018
% @author: Shane Yuan
% @date: Dec 4, 2017
% I write this code basd on Jinshan Pan's open source code, which helps me 
% a lot. Thanks to Jinshan Pan
%
function [psnr_result] = aligned_psnr(ground, image)
[rows, cols, m] = size(ground);
if m == 3
    % Change the images to gray
    ground = rgb2gray(ground);
end
[~, ~, m] = size(image);
if m == 3
    % Change the images to gray
    image = rgb2gray(image);
end

% Get cutted groundtruth
row_cutted = 10;
col_cutted = 10;
psnr_mat = zeros(2 * row_cutted, 2 * col_cutted);
ground_cutted = ground((1 + row_cutted):(rows - row_cutted), (1 + col_cutted):(cols - col_cutted));

% Calculate
rows_cutted = rows - row_cutted * 2;
cols_cutted = cols - col_cutted * 2;
for i = 1:1:(row_cutted * 2)
    for j = 1:1:(col_cutted * 2)
        image_cutted = image(i:(i + rows_cutted - 1), j:(j + cols_cutted - 1));
%         % Calculate the mean square error
%         e = double(ground_cutted) - double(image_cutted);
%         [m, n] = size(e);
%         mse = sum(sum(e.^2))/(m*n);
%         % Calculate the PSNR
        psnr_mat(i, j) = psnr(ground_cutted, image_cutted);
    end
end
psnr_result = max(psnr_mat(:));
