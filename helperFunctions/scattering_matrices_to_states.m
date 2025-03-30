function xk = scattering_matrices_to_states(Sk, param)
%SCATTERING_MATRICES_TO_STATES Converts a series of scattering matrices to
%state vectors. In xk time changes with the columns.
n = size(Sk,3);
xk = zeros(param.sys.n, n);

idx = 1;
for k=1:param.sys.dim_S
    for j=k:param.sys.dim_S
        xk(idx,:) = real(Sk(k,j,:));
        xk(idx+param.sys.n/2,:) = imag(Sk(k,j,:));
        idx = idx + 1;
    end
end
end

