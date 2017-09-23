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

%% problem b) without regularization term
% M = 1
M = 1;
m = M + 1;
X1 = zeros(n, m);
Y1 = zeros(n, 1);
for i = 1:n
    for j = 1:m
        X1(i, j) = x(i) ^ (j - 1);
    end
end
for i = 1:n
    Y1(i) = y(i);
end
% use CVX to solve
cvx_begin
    variable w1(m)
    minimize (norm(X1 * w1 - Y1, 2))
cvx_end

% M = 3
M = 3;
m = M + 1;
X2 = zeros(n, m);
Y2 = zeros(n, 1);
for i = 1:n
    for j = 1:m
        X2(i, j) = x(i) ^ (j - 1);
    end
end
for i = 1:n
    Y2(i) = y(i);
end
% use CVX to solve
cvx_begin
    variable w2(m)
    minimize (norm(X2 * w2 - Y2, 2))
cvx_end

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
    variable w3(m)
    minimize (norm(X3 * w3 - Y3, 2))
cvx_end

% plot
y_est1 = X1 * w1;
y_est2 = X2 * w2;
y_est3 = X3 * w3;
hold on;
axis on;
xlabel('x');ylabel('y');
plot( x(:), y(:), 'ro');
plot( x(:), y_est1(:), 'r-' );
plot( x(:), y_est2(:), 'g--' );
plot( x(:), y_est3(:), 'b:' );
legend('input', 'M=1', 'M=3', 'M=9')
hold off;

    