%% clear and add path
clc;
clear;
close all;


opts.kernel_size = 35;
opts.gamma_correct = 1;
opts.blind_method = 'L0_MSF';
opts.nonblind_method = 'hyper';
opts.output_intermediate = 1;
opts.filename = 'images/real/img_03.png';   
opts.outdir = ['results/real_03/', opts.blind_method, '/'];
% used for blind deblurring
opts.lambda_l0 = 1e-3; 
% used for nonblind deblurring
opts.lambda_grad = 4e-3; 
opts.lambda_tv = 0.001; 
opts.weight_ring = 1;
opts.draw_inter = 1;
opts.k_thresh = 5;
sparse_deblur(opts);