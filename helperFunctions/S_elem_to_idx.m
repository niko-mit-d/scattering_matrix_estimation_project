function [idx_re, idx_im] = S_elem_to_idx(i,j, param)
%S_ELEM_TO_IDX Returns index of real and imaginary part in state space 
% for scattering matrix element S_ij (i...row, j...column)
s = param.sys.dim_S;
n = param.sys.n;

if i > j
    % switch row and column such that (i,j) is in
    % upper triangle matrix
    temp = i;
    i = j;
    j = temp;
end

% index is now directly in x
row = (i-1)*(2*s-i+2)/2 + 1;
idx_re = row + j - i;

% imaginary index is offset by n/2
idx_im = idx_re + n/2;
end

