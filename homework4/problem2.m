%% clear
clear;
close all;
fclose all;

%% prepare data
randn('seed', 1);
beta = zeros(10, 1);
beta(3) = 1;
beta(5) = 7;
beta(10) = 3;
n = 100;
p = 10;
X = randn(n, p);
y = X * beta + 0.1 * randn(n, 1);
lambda = 0.2;

%% solve
[beta,status,history] = gauss_seidel_versus_jacobi(X, y, lambda);
[beta2,status2,history2] = jacobi(X, y, lambda);

%% show figures
hold on;
figure(1);
title('Problem2');
xlabel('iter');
ylabel('log(.)');
plot(history(:, 1), log(history(:, 2)), 'r-');
plot(history2(:, 1), log(history2(:, 2)), 'b--');
legend('gauss seidel versus jacobi', 'jacobi')
hold off;