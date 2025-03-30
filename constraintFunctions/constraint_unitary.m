function [hu, dhudx] = constraint_unitary(x,param)
%CONSTRAINT_UNITARY Implements the symmetry constraint hu
arguments
    x (:,1);
    param;
end
s = param.sys.dim_S;

hu = zeros(s*(s+1)/2, 1);
dhudx = zeros(size(hu,1), param.sys.n);

% The constraint is calculated after transformation to matrices. Easier to
% understand this way.
S = states_to_scattering_matrices(x, param);
S_hermetian = pagectranspose(S); % does conjugate tranpose on each S(:,:,i) matrix 
hu_mat = pagemtimes(S_hermetian,S) - eye(s);

% Each constraint element is added at this index, after which index is
% incremented. This omits dynamic resizing of the vector for performance.
idx = 1;

% diagonal elements (normalization constraints)
for i=1:s
    hu(idx) = abs(hu_mat(i,i));

    for k=1:s
        [idx_re, idx_im] = S_elem_to_idx(k,i,param);
        dhudx(idx, idx_re) = 2*x(idx_re);
        dhudx(idx, idx_im) = 2*x(idx_im);
    end
    idx = idx + 1;
end

% off-diagonal upper triangle elements (orthogonality constraints)
% The other off-diagonal elements are equivalent
for i=1:s
    for j=i+1:s
        % This constraint is equal to the i-th column of S being
        % orthonormal to the j-th column of S_hermitian
        hu(idx) = abs(hu_mat(i,j));

        for k=1:s
            [idx_re_i, idx_im_i] = S_elem_to_idx(k,i,param);
            [idx_re_j, idx_im_j] = S_elem_to_idx(k,j,param);

            dhudx(idx, idx_re_i) = dhudx(idx, idx_re_i) + x(idx_re_j);
            dhudx(idx, idx_im_i) = dhudx(idx, idx_im_i) + x(idx_im_j);
            dhudx(idx, idx_re_j) = dhudx(idx, idx_re_j) + x(idx_re_i);
            dhudx(idx, idx_im_j) = dhudx(idx, idx_im_j) + x(idx_im_i);
        end
    end
end
end

