%% clear and add path
clc;
clear;
close all;


opts.kernel_size = 45;
opts.gamma_correct = 2.2;
opts.blind_method = 'L0_IRL1';
opts.nonblind_method = 'hyper';
opts.output_intermediate = 1;
opts.filename = 'image/IMG_1240_blur.png';   
opts.outdir = ['results/car1/', opts.blind_method, '/'];
% used for blind deblurring
opts.lambda_l0 = 1e-3; 
% used for nonblind deblurring
opts.lambda_grad = 4e-3; 
opts.lambda_tv = 0.001; 
opts.weight_ring = 1;
sparse_deblur(opts);