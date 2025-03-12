function xk = scattering_matrices_to_states(Sk)
%SCATTERING_MATRICES_TO_STATES Converts a series of scattering matrices to
%state vectors. In xk time changes with the columns.

dimS = size(Sk,1);
n = size(Sk,3);
Sk = reshape(Sk, [dimS^2,n]);

xk = zeros(2*dimS^2, n);
xk(1:dimS^2,:) = real(Sk);
xk(dimS^2+1:end,:) = imag(Sk);
end

