function [kernel, interim_latent] = blind_deconv(y, lambda_grad, opts)
%% multiscale blind deblurring code
% This code is written for ELEC5470 convex optimization project Fall 2017-2018
% @author: Shane Yuan
% @date: Dec 4, 2017
% I write this code basd on Jinshan Pan's open source code. Thanks to
% Jinshan Pan
%% Input:
% @y: input blurred image (grayscale); 
% @lambda_grad: the weight for the L0/L1 regularization on gradient
% @opts: options
%% Output:
% @kernel: the estimated blur kernel
% @interim_latent: intermediate latent image
%
% The Code is created based on the method described in the following paper 
%   [1] Jinshan Pan, Deqing Sun, Hanspteter Pfister, and Ming-Hsuan Yang,
%        Blind Image Deblurring Using Dark Channel Prior, CVPR, 2016. 
%   [2] Jinshan Pan, Zhe Hu, Zhixun Su, and Ming-Hsuan Yang,
%        Deblurring Text Images via L0-Regularized Intensity and Gradient
%        Prior, CVPR, 2014. 

    % gamma correct
    if opts.gamma_correct~=1
        y = y .^ opts.gamma_correct;
    end
    b = zeros(opts.kernel_size);

    %%
    ret = sqrt(0.5);
    %%
    maxitr = max(floor(log(5/min(opts.kernel_size))/log(ret)),0);
    num_scales = maxitr + 1;
    fprintf('Maximum iteration level is %d\n', num_scales);
    %%
    retv = ret .^ [0 : maxitr];
    k1list = ceil(opts.kernel_size * retv);
    k1list = k1list+(mod(k1list, 2) == 0);
    k2list =ceil(opts.kernel_size * retv);
    k2list = k2list+(mod(k2list, 2) == 0);

    % derivative filters
    dx = [-1 1; 0 0];
    dy = [-1 0; 1 0];

    % blind deconvolution - multiscale processing
    for s = num_scales : (-1) : 1
        if (s == num_scales)
            %%
            % at coarsest level, initialize kernel
            ks = init_kernel(k1list(s));
            k1 = k1list(s);
            k2 = k1; % always square kernel assumed
        else
            % upsample kernel from previous level to next finer level
            k1 = k1list(s);
            k2 = k1; % always square kernel assumed
            % resize kernel from previous level
            ks = resizeKer(ks,1/ret,k1list(s),k2list(s));
        end;
        %
        cret = retv(s);
        ys = downSmpImC(y, cret);
        fprintf('Processing scale %d/%d; kernel size %dx%d; image size %dx%d\n', ...
                s, num_scales, k1, k2, size(ys,1), size(ys,2));
        % optimization in this scale
        [ks, lambda_grad, interim_latent] = blind_deconv_main(ys, ks,...
            lambda_grad, opts);
        % center the kernel
        ks = adjust_psf_center(ks);
        ks(ks(:)<0) = 0;
        sumk = sum(ks(:));
        ks = ks./sumk;
        % denoise kernel
        if (s == 1)
            kernel = ks;
            if opts.k_thresh > 0
                kernel(kernel(:) < max(kernel(:))/opts.k_thresh) = 0;
            else
                kernel(kernel(:) < 0) = 0;
            end
            kernel = kernel / sum(kernel(:));
        end
        % output intermediate
        if opts.output_intermediate == 1
            imwrite(interim_latent, [opts.outdir, sprintf('inter_image_%2d.png', s)]);
            kw = ks ./ max(ks(:));
            imwrite(kw, [opts.outdir, sprintf('inter_kernel_%2d.png', s)]);
        end
    end

end

%% kernel init funciton
function [k] = init_kernel(minsize)
  k = zeros(minsize, minsize);
  k((minsize - 1)/2, (minsize - 1)/2:(minsize - 1)/2+1) = 1/2;
end

%% image downsample function
function sI=downSmpImC(I,ret)
    % refer to Levin's code
    if (ret==1)
        sI=I;
        return
    end
    sig=1/pi*ret;
    g0=[-50:50]*2*pi;
    sf=exp(-0.5*g0.^2*sig^2);
    sf=sf/sum(sf);
    csf=cumsum(sf);
    csf=min(csf,csf(end:-1:1));
    ii=find(csf>0.05);
    sf=sf(ii);
    sum(sf);
    I=conv2(sf,sf',I,'valid');
    [gx,gy]=meshgrid([1:1/ret:size(I,2)],[1:1/ret:size(I,1)]);
    sI=interp2(I,gx,gy,'bilinear');
end

%% kernel resize function
function k=resizeKer(k,ret,k1,k2)
    % levin's code
    k=imresize(k,ret);
    k=max(k,0);
    k=fixsize(k,k1,k2);
    if max(k(:))>0
        k=k/sum(k(:));
    end
end
function nf = fixsize(f,nk1,nk2)
    [k1,k2]=size(f);
    while((k1 ~= nk1) || (k2 ~= nk2))
        if (k1>nk1)
            s=sum(f,2);
            if (s(1)<s(end))
                f=f(2:end,:);
            else
                f=f(1:end-1,:);
            end
        end
        if (k1<nk1)
            s=sum(f,2);
            if (s(1)<s(end))
                tf=zeros(k1+1,size(f,2));
                tf(1:k1,:)=f;
                f=tf;
            else
                tf=zeros(k1+1,size(f,2));
                tf(2:k1+1,:)=f;
                f=tf;
            end
        end
        if (k2>nk2)
            s=sum(f,1);
            if (s(1)<s(end))
                f=f(:,2:end);
            else
                f=f(:,1:end-1);
            end
        end
        if (k2<nk2)
            s=sum(f,1);
            if (s(1)<s(end))
                tf=zeros(size(f,1),k2+1);
                tf(:,1:k2)=f;
                f=tf;
            else
                tf=zeros(size(f,1),k2+1);
                tf(:,2:k2+1)=f;
                f=tf;
            end
        end
        [k1,k2]=size(f);
    end
    nf=f;
end