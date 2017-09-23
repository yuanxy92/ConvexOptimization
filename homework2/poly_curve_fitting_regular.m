clear;
close all;
fclose all;

% Generate data
rand('seed', 2);
randn('seed', 2);
n = 25;
x = rand(n, 1);
x = sort(x);
noise = 0.1 * randn(n, 1);
y = sin(2 * pi * x) + noise;

%% problem c) with regularization term
% set lambda
% lambda1 = 1e-1;
lambda1 = 1e-3;
lambda2 = 5e-3;
lambda3 = 1e-2;
lambda4 = 0;
% M = 9
M = 9;
m = M + 1;
X3 = zeros(n, m);
Y3 = zeros(n, 1);
for i = 1:n
    for j = 1:m
        X3(i, j) = x(i) ^ (j - 1);
    end
end
for i = 1:n
    Y3(i) = y(i);
end
% use CVX to solve
cvx_begin
    variable w1(m)
    minimize (norm(X3 * w1 - Y3, 2) + lambda1 * norm(w1, 2))
cvx_end

cvx_begin
    variable w2(m)
    minimize (norm(X3 * w2 - Y3, 2) + lambda2 * norm(w2, 2))
cvx_end

cvx_begin
    variable w3(m)
    minimize (norm(X3 * w3 - Y3, 2) + lambda3 * norm(w3, 2))
cvx_end

cvx_begin
    variable w4(m)
    minimize (norm(X3 * w4 - Y3, 2) + lambda4 * norm(w3, 2))
cvx_end

% plot
y_est1 = X3 * w1;
y_est2 = X3 * w2;
y_est3 = X3 * w3;
y_est4 = X3 * w4;
hold on;
axis on;
xlabel('x');ylabel('y');
plot( x(:), y(:), 'ro');
plot( x(:), y_est1(:), 'r-' );
% plot( x(:), y_est2(:), 'g--' );
% plot( x(:), y_est3(:), 'b-.' );
plot( x(:), y_est3(:), 'c-' );
legend('input', 'lambda=1e-3', 'lambda=5e-3', 'lambda=1e-2', 'lambda=0')
hold off;

    