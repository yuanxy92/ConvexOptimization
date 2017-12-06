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

blind_method_list = {'L0', 'L1', 'L0_IRL1'};

img_path = 'images/synthetic/groundtruth';
kernel_path = 'images/synthetic/kernel';
blur_path = 'images/synthetic/blurry';
deblurred_path = 'images/synthetic/deblurred';

for i = 1:img_num
    img_gt = im2double(imread(sprintf('%s/img_%02d.png', img_path, i)));
    for j = 1:kernel_num
        k_gt = im2double(imread(sprintf('%s/k%d.png', kernel_path, j)));
        k_gt = k_gt ./ sum(k_gt(:));
        for method = 1:3
            fprintf('Processing image %02d, kernel %02d, method: %s ...\n' ...
                , i, j, blind_method_list{method});
            opts.kernel_size = size(k_gt, 1) + 4;
            opts.gamma_correct = 1;
            opts.blind_method = blind_method_list{method};
            opts.nonblind_method = 'hyper';
            opts.output_intermediate = 0;
            opts.filename = sprintf('%s/img_%02d_kernel_%02d.png', blur_path, i, j);   
            opts.outdir = '';
            opts.draw_inter = 0;
            % used for blind deblurring
            opts.lambda_l0 = 1e-3; 
            % used for nonblind deblurring
            opts.lambda_grad = 4e-3; 
            opts.lambda_tv = 0.001; 
            opts.k_thresh = 20;
            opts.weight_ring = 1;
            [img_deblurred, k_deblurred] = sparse_deblur(opts);
            imwrite(img_deblurred, sprintf('%s/deblurred_%02d_kernel_%02d_%s.png', ...
                deblurred_path, i, j, opts.blind_method));
            imwrite(k_deblurred ./ max(k_deblurred(:)), sprintf('%s/kernel_%02d_kernel_%02d_%s.png', ...
                deblurred_path, i, j, opts.blind_method));
            % calculate psnr
            psnr_val = aligned_psnr(img_gt, img_deblurred);
            fp = fopen(sprintf('%s/psnr_%02d_kernel_%02d_%s.txt', ...
                deblurred_path, i, j, opts.blind_method), 'w');
            fprintf(fp, '%f', psnr_val);
            fclose(fp);
        end
    end
end
