%% clear and add path
clc;
clear;
close all;
% kernel size
opts.kernel_size = 45;
opts.gamma_correct = 1;
% non-blind deblurring method, support 
% L0: L0 sparse image prior, use optimization proposed by Li Xu 
% http://www.cse.cuhk.edu.hk/~leojia/projects/l0deblur/
% L1: L1 sparse image prior, implemented by me
% L0_IRL1: L0 sparse image prior, implemented by me, use iterative
% reweighted L1 norm which discussed in class
opts.blind_method = 'L0';
% non-blind deblurring method, support TV-L2 and hyper-laplacian (only windows
% executable code is provided for hyper-laplacian method, thanks to Qi
% Shan, Jiaya Jia and Aseem Agarwala 
% http://www.cse.cuhk.edu.hk/~leojia/programs/deconvolution/deconvolution.htm)
opts.nonblind_method = 'hyper';
opts.output_intermediate = 1;
opts.filename = 'images/real/img_07.png';   
opts.outdir = ['results/real_07/', opts.blind_method, '/'];
% used for blind deblurring
opts.lambda_grad = 4e-3; 
opts.lambda_msf = 6e-2;
% used for nonblind deblurring
opts.lambda_l0 = 1e-3;
opts.lambda_tv = 0.001; 
opts.weight_ring = 1;
opts.draw_inter = 1;
opts.k_thresh = 20;
sparse_deblur(opts);