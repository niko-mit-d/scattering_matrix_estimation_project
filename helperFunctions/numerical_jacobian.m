function jac = numerical_jacobian(func,x)
%NUMERICAL_JACOBIAN Uses numeric gradient to calculate Jacobian of given
%function func around point x using the complex step method
h= 1e-4;
n = length(x);
fx = func(x);
jac = zeros(length(fx), n);

% basis vector function
e = @(k) double(1:n == k)';

for i=1:n
    % complex variable forward differencing 
    jac(:,i) = imag(func(x+1i*e(i)*h))/h;
end
end

