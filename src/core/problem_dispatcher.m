function [Ffun, Gfun, meta] = problem_dispatcher(problemId, m)
% problem_dispatcher  Return unified F/G API for a given problemId.
%   [Ffun, Gfun, meta] = problem_dispatcher(problemId, m)
%   - Ffun(x) -> m x 1 vector of objective values
%   - Gfun(x) -> 1 x m cell array of gradients {g1, ..., gm}
%   Falls back to legacy f1/f2/f3 and g1/g2/g3 when no family wrapper exists.

if nargin < 2 || isempty(m), m = 2; end

family = '';
switch problemId
  case {2,3,4}
    family = 'te8';
  case {7,8,9}
    family = 'fds';
  otherwise
    family = 'legacy';
end

switch family
  case 'te8'
    Ffun = @(x) te8_F_slice(x, m);
    Gfun = @(x) te8_G_slice(x, m);
  case 'fds'
    Ffun = @(x) fds_F_slice(x, m);
    Gfun = @(x) fds_G_slice(x, m);
  otherwise % 'legacy'
    Ffun = @(x) legacy_F(x, problemId, m);
    Gfun = @(x) legacy_G(x, problemId, m);
end

meta = struct('family', family, 'problemId', problemId, 'm', m);

end

function Fm = te8_F_slice(x, m)
F = te8_f(x); Fm = F(1:min(m, numel(F)));
end
function Gm = te8_G_slice(x, m)
G = te8_g(x); Gm = G(1:min(m, numel(G)));
end

function Fm = fds_F_slice(x, m)
F = fds_f(x); Fm = F(1:min(m, numel(F)));
end
function Gm = fds_G_slice(x, m)
G = fds_g(x); Gm = G(1:min(m, numel(G)));
end

function Fm = legacy_F(x, dId, m)
F = zeros(m,1);
F(1) = f1(x, dId);
if m >= 2, F(2) = f2(x, dId); end
if m >= 3, F(3) = f3(x, dId); end
Fm = F;
end

function Gm = legacy_G(x, dId, m)
G = cell(1,m);
G{1} = g1(x, dId);
if m >= 2, G{2} = g2(x, dId); end
if m >= 3, G{3} = g3(x, dId); end
Gm = G;
end

