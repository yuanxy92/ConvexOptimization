clear;
clc;
close all;

img_num = 20;
kernel_num = 8;

blind_method_list = {'L0', 'L1', 'L0_IRL1'};

img_path = 'images/synthetic/groundtruth';
kernel_path = 'images/synthetic/kernel';
blur_path = 'images/synthetic/blurry';
deblurred_path = 'images/synthetic/deblurred';

psnr_l0 = zeros(20, 8);
psnr_l1 = zeros(20, 8);
psnr_l0_irl1 = zeros(20, 8);

for i = 1:img_num
    for j = 1:kernel_num
        method = 1;
        fp = fopen(sprintf('%s/psnr_%02d_kernel_%02d_%s.txt', ...
            deblurred_path, i, j, blind_method_list{method}), 'r');
        psnr_l0(i, j) = fscanf(fp, '%f');
        fclose(fp);
        
        method = 2;
        fp = fopen(sprintf('%s/psnr_%02d_kernel_%02d_%s.txt', ...
            deblurred_path, i, j, blind_method_list{method}), 'r');
        psnr_l1(i, j) = fscanf(fp, '%f');
        fclose(fp);
        
        method = 3;
        fp = fopen(sprintf('%s/psnr_%02d_kernel_%02d_%s.txt', ...
            deblurred_path, i, j, blind_method_list{method}), 'r');
        psnr_l0_irl1(i, j) = fscanf(fp, '%f');
        fclose(fp);
    end
end

% draw curve
psnrs = 10:1:33;
rate_l0 = zeros(1, size(psnrs, 2));
rate_l1 = zeros(1, size(psnrs, 2));
rate_l0_irl1 = zeros(1, size(psnrs, 2));
ind = 1;
for val = psnrs
   list = find(psnr_l0 > val);
   rate_l0(ind) = size(list, 1) / 160;
   list = find(psnr_l1 > val);
   rate_l1(ind) = size(list, 1) / 160;
   list = find(psnr_l0_irl1 > val);
   rate_l0_irl1(ind) = size(list, 1) / 160;
   ind = ind + 1;
end

hold on;
plot(psnrs, rate_l0, 'ro-');
plot(psnrs, rate_l0_irl1, 'go-');
plot(psnrs, rate_l1, 'bo-');
title('Success rate')
xlabel('PNSR');
ylabel('percentage of images PNSR > x');
legend('L0','L0 IRL1', 'L1');
hold off;