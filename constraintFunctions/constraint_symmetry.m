function [hs, dhsdx] = constraint_symmetry(x, param)
%CONSTRAINT_SYMMETRY Implements the symmetry constraint hs = [hsr; hsi]
hsr = zeros(param.sys.dim_S*(param.sys.dim_S-1)/2, size(x,2));
hsi = zeros(size(hsr));
dhsrdx = zeros(size(hsr,1), param.sys.n);

% The constraint is calculated after transformation to matrices. Easier to
% understand this way.
S = states_to_scattering_matrices(x);
S_trans = pagetranspose(S); % does non-conjugate tranpose on each S(:,:,i) matrix 
diff_S = S - S_trans;

index = 1;
for k=1:param.sys.dim_S
    for l=k+1:param.sys.dim_S
        % Take only differences from upper traingle matrix withouth main
        % diagonal.
        hsr(index,:) = real(diff_S(k,l));
        hsi(index,:) = imag(diff_S(k,l));

        dhsrdx(index, (k-1)*param.sys.dim_S+l) = -1;
        dhsrdx(index, (l-1)*param.sys.dim_S+k) = 1;

        index = index + 1;
    end
end

dhsdx = [dhsrdx;
         zeros(size(dhsrdx,1), param.sys.n/2) dhsrdx(:,1:end/2)];
hs = [hsr;hsi];
end

