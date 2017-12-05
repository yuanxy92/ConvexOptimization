clear;
close all;
fclose all;

for i = 1:8
    k = imread(sprintf('k%d.png', i));
    k = imresize(k, 11, 'nearest');
    imwrite(k, sprintf('k%d_large.png', i));
end