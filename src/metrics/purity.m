function Rloopps = purity(P1, P2, P3, tol_or_atol, rtol)
% purity  Purity vs. reference front using absolute+relative tolerances.
%   R = purity(P1, P2, P3, tol_or_atol, rtol)
%   - P1, P2: approximation sets (rows = points, cols = objectives)
%   - P3: reference front (rows = points, cols = objectives)
%   - tol_or_atol (optional): if scalar and rtol omitted, treated as absolute tol
%                             if scalar with rtol provided: absolute tol (atol)
%   - rtol (optional): relative tolerance multiplier on per-objective range
%
%   Matching rule per objective j:
%     |p_j - q_j| <= atol + rtol * (max(P3(:,j)) - min(P3(:,j)))
%
%   Returns 1x2 vector R where:
%     R(1) = 1 / (|match(P1,P3)| / |P3|)
%     R(2) = 1 / (|match(P2,P3)| / |P3|)
%   Smaller is better under this historical definition (kept for compatibility).
%
%   Notes
%   - Inputs are deduplicated by rows to avoid double counting.
%   - If P3 is empty, returns [NaN NaN]. If no matches, the component is Inf.

  % Defaults
  default_atol = 1e-6;   % absolute floor
  default_rtol = 1e-3;   % scales with objective range

  if nargin < 4 || isempty(tol_or_atol)
    atol = default_atol; rtol = default_rtol;
  elseif nargin < 5 || isempty(rtol)
    atol = tol_or_atol;  rtol = 0; % pure absolute tolerance
  else
    atol = tol_or_atol;
    % rtol provided explicitly
  end

  % Normalize inputs and deduplicate rows
  if isempty(P3)
    Rloopps = [NaN NaN];
    return
  end
  if isempty(P1), P1 = zeros(0, size(P3,2)); end
  if isempty(P2), P2 = zeros(0, size(P3,2)); end

  P1 = unique(P1, 'rows');
  P2 = unique(P2, 'rows');
  P3 = unique(P3, 'rows');

  SS3 = size(P3, 1);

  % Per-objective tolerances from reference front spread
  mins = min(P3, [], 1);
  maxs = max(P3, [], 1);
  ranges = maxs - mins;
  tol_vec = atol + rtol .* ranges; % 1 x M

  % Count how many reference rows are matched by P1 and P2 within tol_vec
  a = rows_matched_count(P1, P3, tol_vec);
  b = rows_matched_count(P2, P3, tol_vec);

  % Fractions of reference covered; keep historical reciprocal form
  tps1 = a / SS3;
  tps2 = b / SS3;

  % Protect against division by zero without changing semantics: Inf is OK
  Rloopps = [1 / tps1, 1 / tps2];
end

function c = rows_matched_count(A, B, tol_vec)
% rows_matched_count  Count rows in B with at least one match in A within tol_vec.
%   Match if all per-dimension absolute diffs <= tol_j.
  if isempty(A) || isempty(B)
    c = 0; return
  end
  c = 0;
  % Ensure tol_vec is 1 x M
  if isscalar(tol_vec)
    tol_vec = repmat(tol_vec, 1, size(B,2));
  end
  for i = 1:size(B,1)
    p = B(i,:);
    % Vectorized check across all rows of A with per-dimension tolerances
    matched = all(abs(A - p) <= tol_vec, 2);
    if any(matched)
      c = c + 1;
    end
  end
end
