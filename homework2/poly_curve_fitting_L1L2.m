clear;
close all;
fclose all;

% Generate data
rand('seed', 2);
randn('seed', 2);
n = 25;
x = rand(n, 1);
x = sort(x);
noise = 0.1 * randn(n, 1) + 3 * [zeros(15, 1); 1; zeros(9, 1)];
y = sin(2 * pi * x) + noise;

%% problem c) with regularization term
% set lambda
% M = 9
M = 3;
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
    minimize (norm(X3 * w1 - Y3, 2))
cvx_end

cvx_begin
    variable w2(m)
    minimize (norm(X3 * w2 - Y3, 1))
cvx_end

% plot
y_est1 = X3 * w1;
y_est2 = X3 * w2;
hold on;
axis on;
xlabel('x');ylabel('y');
plot( x(:), y(:), 'ro');
plot( x(:), y_est1(:), 'r-' );
plot( x(:), y_est2(:), 'g-' );
legend('input', 'L2 norm fitting', 'L1 norm fitting')
hold off;

    