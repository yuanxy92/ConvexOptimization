function [outImg] = calc_max_saturation_to_pixel(S, msf_refine, msf_index, patch_size)
%% assign dark channel value to image pixel
% The Code is created based on the method described in the following paper 
%   [1] Jinshan Pan, Deqing Sun, Hanspteter Pfister, and Ming-Hsuan Yang,
%        Blind Image Deblurring Using Dark Channel Prior, CVPR, 2016. 
% 
[M N C] = size(S);
%outImge = zeros(M, N); % 

I_msf = zeros(size(S, 1), size(S, 2));
for m = 1:M
    for n = 1:N
        I_msf(m, n) = min(S(m, n, :)) / sum(S(m, n, :));
    end
end

% pad original image
padsize = floor(patch_size./2);
S_padd = padarray(S, [padsize padsize], 'replicate');
I_msf = padarray(I_msf, [padsize padsize], 'replicate');

% assign dark channel to pixel
for m = 1:M
    for n = 1:N
        patch = I_msf(m:(m+patch_size-1), n:(n+patch_size-1), :);
        [tmp_val, tmp_idx] = min(patch(:));
        [row_ind, col_ind] = ind2sub([patch_size, patch_size], tmp_idx);
      
        patch2 = S_padd(m:(m+patch_size-1), n:(n+patch_size-1), :);
        
        if ~isequal(patch2(row_ind, col_ind, :), msf_refine(m, n, :))
            patch2(msf_index(m,n, 1), msf_index(m, n, 2), :) = msf_refine(m,n, :);
        end
        for cc = 1:C
            S_padd(m:(m+patch_size-1), n:(n+patch_size-1), cc) = patch2(:,:, cc);
        end
    end
end


outImg = S_padd(padsize + 1: end - padsize, padsize + 1: end - padsize,:);
%% boundary processing
outImg(1:padsize,:,:) = S(1:padsize,:,:);  outImg(end-padsize+1:end,:,:) = S(end-padsize+1:end,:,:);
outImg(:,1:padsize,:) = S(:,1:padsize,:);  outImg(:,end-padsize+1:end,:) = S(:,end-padsize+1:end,:);

%figure(2); imshow([S, outImg],[]);
end


