clear;
close all;
fclose all;

% Generate data
x = [ 0.55  0.0;
      0.25  0.35;
     -0.2   0.2;
     -0.25 -0.1;
     -0.0  -0.3;
      0.4  -0.2;
      -1, -1]';
[n,m] = size(x);
eyemat = eye(2, 2);

% Create and solve the model for question a
cvx_begin
    variable A1
    variable b1(n)
    maximize(A1)
    subject to
        norms( A1 * eyemat * x + b1 * ones( 1, m ), 2 ) <= 1;
cvx_end

% Create and solve the model for question b
cvx_begin
    variable A2(n, n)
    variable b2(n)
    maximize(det_rootn(A2))
    subject to
        norms( A2 * x + b2 * ones( 1, m ), 2 ) <= 1;
cvx_end

% Plot the results
clf;
figure(1);

noangles = 200;
angles   = linspace( 0, 2 * pi, noangles );
ellipse1  = A1 * eyemat \ [ cos(angles) - b1(1) ; sin(angles) - b1(2) ];
ellipse2  = A2 \ [ cos(angles) - b2(1) ; sin(angles) - b2(2) ];
hold on;
axis on;
axis([-1.5, 1, -1.5, 1]); xlabel('x1');ylabel('x2');pbaspect([1, 1, 1])
plot( x(1,:), x(2,:), 'ro', ellipse1(1,:), ellipse1(2,:), 'b-' );
plot(ellipse2(1,:), ellipse2(2,:), 'g-' );
hold off;


