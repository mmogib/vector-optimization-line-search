function Nd = nondominated_rows(P)
% nondominated_rows  Return nondominated subset of rows (assume minimization).
%   Refactored by: Dr. Mohammed Alshahrani
%   P: N x M matrix, rows are objective vectors.
%   Nd: K x M nondominated rows.

if (numel(P)==0)
    Nd = P; return;
end

% Keep unique rows first
P = unique(P, 'rows');
N = size(P,1);
keep = true(N,1);
for i = 1:N
    if ~keep(i), continue; end
    for j = 1:N
        if i==j || ~keep(j), continue; end
        % j dominates i if P(j,:) <= P(i,:) and strictly better in at least one
        if all(P(j,:) <= P(i,:)) && any(P(j,:) < P(i,:))
            keep(i) = false; break;
        end
    end
end
Nd = P(keep,:);

end
