function hu = constraint_unitary(x,param)
%CONSTRAINT_UNITARY Implements the symmetry constraint hu
hu = zeros(param.sys.dim_S*(param.sys.dim_S+1)/2, size(x,2));

% The constraint is calculated after transformation to matrices. Easier to
% understand this way.
S = states_to_scattering_matrices(x);
S_hermetian = pagectranspose(S); % does conjugate tranpose on each S(:,:,i) matrix 
hu_mat = pagemtimes(S_hermetian,S) - eye(param.sys.dim_S);

index = 1;
for k=1:param.sys.dim_S
    for l=k:param.sys.dim_S
        % Take only differences from upper traingle matrix with main
        % diagonal.
        hu(index,:) = hu_mat(k,l);
        index = index + 1;
    end
end
end

