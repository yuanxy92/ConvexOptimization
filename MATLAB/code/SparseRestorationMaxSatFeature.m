function S = SparseRestorationMaxSatFeature(Im, kernel, lambda, wei_grad, kappa)
%% Image restoration with L1 prior
% The objective function: 
% S^* = argmin ||I*k - B||^2 + lambda |\nabla I|_0 or
% S^* = argmin ||I*k - B||^2 + lambda |\nabla I|_1
% This code is written for ELEC5470 convex optimization project Fall 2017-2018
% @author: Shane Yuan
% @date: Dec 4, 2017
% I write this code basd on Jinshan Pan's open source code. Thanks to
% Jinshan Pan
% 
%%
% Image restoration with L0 regularized intensity and gradient prior
% The objective function:
% S = argmin ||I*k - B||^2 + \lambda |M(I)|_0 + wei_grad |\nabla I|_0
%% Input:
% @Im: Blurred image
% @kernel: blur kernel
% @lambda: weight for the max saturation feature prior
% @wei_grad: weight for the L0 gradient prior
% @kappa: Update ratio in the ADM
%% Output:
% @S: Latent image
%

if ~exist('kappa','var')
    kappa = 2.0;
end
%% pad image
% H = size(Im,1);    W = size(Im,2);
% Im = wrap_boundary_liu(Im, opt_fft_size([H W]+size(kernel)-1));
%%
S = Im;
betamax = 1e5;
fx = [1, -1];
fy = [1; -1];
[N,M,D] = size(Im);
sizeI2D = [N,M];
otfFx = psf2otf(fx,sizeI2D);
otfFy = psf2otf(fy,sizeI2D);
%%
KER = psf2otf(kernel,sizeI2D);
Den_KER = abs(KER).^2;
%%
Denormin2 = abs(otfFx).^2 + abs(otfFy ).^2;
Normin1{1} = conj(KER).*fft2(S(:, :, 1));
Normin1{2} = conj(KER).*fft2(S(:, :, 2));
Normin1{3} = conj(KER).*fft2(S(:, :, 3));
% pixel sub-problem
%
patch_size_msf = 35; %% Fixed size
%mybeta_pixel = 2*lambda;
%[J, J_idx] = dark_channel(S, dark_r);
mybeta_pixel = lambda/(graythresh((S).^2));
maxbeta_pixel = 2^3;
while mybeta_pixel< maxbeta_pixel
    %% 
    [J, px_val_rgb, J_idx] = max_saturation_feature(S, patch_size_msf);
    u = px_val_rgb;
    if D==1
        t = u.^2<lambda/mybeta_pixel;
    else
        t = sum(u.^2,3)<lambda/mybeta_pixel;
        t = repmat(t,[1,1,D]);
    end
    u(t) = 0;
    %
    clear t;
    u = calc_max_saturation_to_pixel(S, u, J_idx, patch_size_msf);
    %% Gradient sub-problem
    beta = 2*wei_grad;
    %beta = 0.01;
    while beta < betamax
        for c = 1:3
            S_in = S(:, :, c);
            Denormin   = Den_KER + beta*Denormin2 + mybeta_pixel;
            %
            h = [diff(S_in,1,2), S_in(:,1,:) - S_in(:,end,:)];
            v = [diff(S_in,1,1); S_in(1,:,:) - S_in(end,:,:)];
            t = (h.^2+v.^2)<wei_grad/beta;
            h(t)=0; v(t)=0;
            clear t;
            %
            Normin2 = [h(:,end,:) - h(:, 1,:), -diff(h,1,2)];
            Normin2 = Normin2 + [v(end,:,:) - v(1, :,:); -diff(v,1,1)];
            %
            FS = (Normin1{c} + beta*fft2(Normin2) + mybeta_pixel*fft2(u(:, :, c)))./Denormin;
            S_in = real(ifft2(FS));
            S(:, :, c) = S_in;
            %%
        end
        beta = beta*kappa;
        if wei_grad==0
            break;
        end
    end
    mybeta_pixel = mybeta_pixel*kappa;
end
%
end
