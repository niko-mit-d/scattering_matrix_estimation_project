function Sk = generate_scattering_matrices(dim_S, n, options)
% generate_scattering_matrices Generates n random scattering matrices of
% dimensionality dim_S that satisfy both the symmetric and unitary
% properties.
%
% Sk is of size (dim_S, dim_S, n)
arguments
    dim_S double {mustBeInteger, mustBePositive};
    n double {mustBeInteger, mustBePositive};
    options.checkProperties logical = false;
end

Sk = zeros(dim_S, dim_S, n);
for i=1:n
    % generate a random complex symmetric matrix
    A = randn(dim_S) + 1i * randn(dim_S);
    A = (A + A.') / 2; % Make it symmetric (S = S^T)
    
    % ensure S is unitary (S^H * S = I)
    [U, ~, V] = svd(A);
    A = U * V'; % construct a unitary symmetric matrix

    Sk(:,:,i) = A;
end

if options.checkProperties
    % check if matrices are symmetric and unitary
    threshold = 1e-10;
    for i=1:n
        isSymmetric = norm(Sk(:,:,i) - Sk(:,:,i).') < threshold; % non-conjugate tranpose used here
        isUnitary = norm(Sk(:,:,i)'*Sk(:,:,i) - eye(dim_S)) < threshold;

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

