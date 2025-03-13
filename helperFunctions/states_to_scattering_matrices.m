function Sk = states_to_scattering_matrices(xk)
%STATES_TO_SCATTERING_MATRICES Summary of this function goes here
%   Detailed explanation goes here
dim_S = sqrt(size(xk,1)/2);
if mod(dim_S,1)~=0
    fprintf("states_to_scattering_matrices >> xk is not of correct size!\n");
    return;
end

xk_real = xk(1:end/2,:);
xk_imag = xk(end/2+1:end,:);

Sk = reshape(xk_real + 1i*xk_imag, dim_S, dim_S,[]);

end

