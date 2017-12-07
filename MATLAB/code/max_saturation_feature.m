function [J, px_val_rgb, J_index] = max_saturation_feature(I, patch_size)
% function J = dark_channel(I, patch_size);

% Computes the maximum saturation feature of corresponding RGB image.
% Finds from the input image the minimum value among all 
% pixels within the patch centered around the location of the 
% target pixel in the newly created dark channel image 'J'
% J is a 2-D image (grayscale).

% Example: J = dark_channel(I, 15); % computes using 15x15 patch

% Check to see that the input is a color image
% if ndims(I) == 3
%     [M N C] = size(I);
%     J = zeros(M, N); % Create empty matrix for J
%     J_index = zeros(M, N); % Create empty index matrix
% else
%     error('Sorry, dark_channel supports only RGB images');
% end

%
[M, N, C] = size(I);

I_msf = zeros(size(I, 1), size(I, 2));
for m = 1:M
    for n = 1:N
        I_msf(m, n) = min(I(m, n, :)) / sum(I(m, n, :));
%         I_msf(m, n) = min(I(m, n, :));
    end
end

J = zeros(M, N); % Create empty matrix for J
px_val_rgb = zeros(M, N, C);
J_index = zeros(M, N, 2); % Create empty index matrix

% Test if patch size has odd number
if ~mod(numel(patch_size),2) % if even number
    error('Invalid Patch Size: Only odd number sized patch supported.');
end

% pad original image
I = padarray(I, [floor(patch_size./2) floor(patch_size./2)], 'replicate');
I_msf = padarray(I_msf, [floor(patch_size./2) floor(patch_size./2)], 'replicate');

% Compute the dark channel 
for m = 1:M
    for n = 1:N  
        patch = I_msf(m:(m+patch_size-1), n:(n+patch_size-1),:);
        I_patch = I(m:(m+patch_size-1), n:(n+patch_size-1),:);
        [tmp_val, tmp_idx] = min(patch(:));
        J(m,n) = tmp_val;
        [row_ind, col_ind] = ind2sub([patch_size, patch_size], tmp_idx);
        px_val_rgb(m, n, :) = I_patch(row_ind, col_ind, :);
        J_index(m, n, 1) = row_ind;
        J_index(m, n, 2) = col_ind;
    end
end

end



