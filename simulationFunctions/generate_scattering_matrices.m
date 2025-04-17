function [Sk,Sk_true] = generate_scattering_matrices(param, options)
% generate_scattering_matrices Generates n random scattering matrices of
% dimensionality param.sys.dim_S that satisfy both the symmetric and unitary
% properties.
%
% Sk is of size (dim_S, dim_S, n) and has added random noise.
% Sk_true returns the "reine" scattering matrices which satisfy the
% constraints.
arguments
    param struct;
    options.checkProperties logical = false;
end
S0 = param.sys.S0;
dim_S = param.sys.dim_S;
n = param.sim.dim_t;

Sk_true = zeros(dim_S, dim_S, n);
Sk = zeros(size(Sk_true));
Sk_true(:,:,1) = S0;
Sk(:,:,1) = S0 + param.sys.sigma_y*randn(dim_S);
for i=2:n
    A = param.sys.sigma_S*(randn(dim_S) + 1i * randn(dim_S)) + Sk(:,:,i-1);
    A = (A + A.') / 2; % make it symmetric (S = S^T)
    
    [U, ~, V] = svd(A);
    A = U * V'; % construct a unitary symmetric matrix

    Sk_true(:,:,i) = A;
    Sk(:,:,i) = Sk_true(:,:,i) + param.sys.sigma_y*(randn(dim_S)+1i*randn(dim_S));
end

if options.checkProperties
    % check if matrices are symmetric and unitary
    threshold = 1e-10;
    for i=1:n
        isSymmetric = norm(Sk_true(:,:,i) - Sk_true(:,:,i).') < threshold; % non-conjugate tranpose used here
        isUnitary = norm(Sk_true(:,:,i)'*Sk_true(:,:,i) - eye(dim_S)) < threshold;

        if(isSymmetric && isUnitary)
            if i==n
                fprintf("generate_scattering_matrices >> Matrix properties are fulfilled!\n");
            end
            continue;
        else
            fprintf("generate_scattering_matrices >> Error: Problem with matrix properties at index %d!\n", i);
            break;
        end
    end
end

end