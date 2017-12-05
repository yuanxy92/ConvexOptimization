clear;
clc;

img_sharp = im2double(imread('groundtruth/img_16.png'));
img_blurry = im2double(imread('blurry/img_16_kernel_06.png'));

tl_row = 260;
tl_col = 370;
br_row = tl_row + 48;
br_col = tl_col + 48;

img_sharp_patch = img_sharp(tl_row:br_row, tl_col:br_col, :);
img_blurry_patch = img_blurry(tl_row:br_row, tl_col:br_col, :);

imwrite(img_sharp, 'sharp.png');
imwrite(img_blurry, 'blurry.png');
imwrite(img_sharp_patch, 'sharp_patch.png');
imwrite(img_blurry_patch, 'blurry_patch.png');

m_sharp = 10000;
m_blurry = 10000;

for i = 1:49
    for j = 1:49
        r = img_sharp_patch(i, j, 1);
        g = img_sharp_patch(i, j, 2);
        b = img_sharp_patch(i, j, 3);
        val_sharp = 3 * min(r, min(g, b)) / (r + g + b);
        r = img_blurry_patch(i, j, 1);
        g = img_blurry_patch(i, j, 2);
        b = img_blurry_patch(i, j, 3);
        val_blurry = 3 * min(r, min(g, b)) / (r + g + b);
        m_sharp= min(m_sharp, val_sharp);
        m_blurry= min(m_blurry, val_blurry);
    end
end
