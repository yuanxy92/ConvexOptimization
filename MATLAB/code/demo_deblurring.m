%% Motion Blurry Image Restoration
% This code is written for ELEC5470 convex optimization project Fall 2017-2018
% @author: Shane Yuan
% @date: Dec 4, 2017
% I write this code basd on Jinshan Pan's open source code, which helps me 
% a lot. Thanks to Jinshan Pan
%
%% clear and add path
clc;
clear;
close all;
addpath(genpath('image'));
addpath(genpath('utils'));
%% load image params
image_params;
%% set parameter
opts.prescale = 1; 
opts.xk_iter = 5; %% max iterations
opts.gamma_correct = 1;
opts.k_thresh = 20;
% non-blind deblurring method, support 
% L0: L0 sparse image prior, use optimization proposed by Li Xu 
% http://www.cse.cuhk.edu.hk/~leojia/projects/l0deblur/
% L1: L1 sparse image prior, implemented by me
% L0_IRL1: L0 sparse image prior, implemented by me, use iterative
% reweighted L1 norm which discussed in class
opts.blind_method = 'L0_IRL1';
% non-blind deblurring method, support TV-L2 and hyper-laplacian (only windows
% executable code is provided for hyper-laplacian method, thanks to Qi
% Shan, Jiaya Jia and Aseem Agarwala 
% http://www.cse.cuhk.edu.hk/~leojia/programs/deconvolution/deconvolution.htm)
opts.nonblind_method = 'hyper';
opts.outdir = 'results/flower/';
y = imread(filename);
% make out dir
mkdir(opts.outdir);
if size(y,3) == 3
    yg = im2double(rgb2gray(y));
else
    yg = im2double(y);
end
y = im2double(y);
%% blind deblurring step
tic;
[kernel, interim_latent] = blind_deconv(yg, lambda_dark, lambda_grad, opts);
toc
%% non blind deblurring step
% write k into file
k = kernel ./ max(kernel(:));
imwrite(k, [opts.outdir, 'kernel.png']);
if strcmp(opts.nonblind_method, 'TV-L2')
    % TV-L2 denoising method
    Latent = ringing_artifacts_removal(y, kernel, lambda_tv, lambda_l0, weight_ring);
    imwrite(Latent, [opts.outdir, 'deblurred.png']);
else if strcmp(opts.nonblind_method, 'hyper') % only windows executable code is provided
        % hyper laplacian method
        kernelname = [opts.outdir, 'kernel.png'];
        blurname = 'temp.png';
        imwrite(y, blurname);
        sharpname = [opts.outdir, 'deblurred.png'];
        command = sprintf('deconv.exe %s %s %s 3e-2 1 0.04 1', blurname, kernelname, sharpname);
        system(command);
        delete(blurname);
        Latent = imread(sharpname);
    else
        fprintf('Only hyper and TV-L2 are support for non blind deblur!');
        exit(-1);
    end
end
figure; imshow(Latent);

% imwrite(interim_latent, ['results\' filename(7:end-4) '_interim_result.png']);
