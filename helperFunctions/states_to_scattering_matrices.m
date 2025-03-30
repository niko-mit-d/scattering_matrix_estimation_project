function Sk = states_to_scattering_matrices(xk, param)
%STATES_TO_SCATTERING_MATRICES Summary of this function goes here
%   Detailed explanation goes here
xk_real = xk(1:end/2,:);
xk_imag = xk(end/2+1:end,:);

Sk = zeros(param.sys.dim_S, param.sys.dim_S, size(xk,2));
idx = 1;
for k=1:param.sys.dim_S
    for j=k:param.sys.dim_S
        Sk(k,j,:) = xk(idx,:) + 1i*xk(idx+param.sys.n/2,:);
        Sk(j,k,:) = Sk(k,j,:);
        idx = idx + 1;
    end
end
end

