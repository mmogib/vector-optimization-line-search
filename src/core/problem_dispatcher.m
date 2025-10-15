function [Ffun, Gfun, meta] = problem_dispatcher(problemKey, m, params)
% problem_dispatcher  Return unified F/G API for a given problem name or ID.
%   Refactored by: Dr. Mohammed Alshahrani
%   [Ffun, Gfun, meta] = problem_dispatcher(problemKey, m, params)
%   - problemKey: string name (preferred, e.g., 'bk1','vu1','sp1','te8','fds')
%                 or a legacy numeric ID.
%   - Ffun(x) -> m x 1 vector of objective values
%   - Gfun(x) -> 1 x m cell array of gradients {g1, ..., gm}
%   Falls back to legacy f1/f2/f3 and g1/g2/g3 when no named wrapper exists.

if nargin < 2 || (numel(m)==0), m = 2; end
if nargin < 3, params = struct(); end

% Determine family/name from key
name = '';
if ischar(problemKey) || (isstring(problemKey) && strlength(problemKey) > 0)
  name = lower(char(problemKey));
else
  % Numeric legacy ID mapping to known families
  problemId = problemKey;
  switch problemId
    case {2,3,4}
      name = 'te8';
    case {7,8,9}
      name = 'fds';
    otherwise
      name = 'legacy';
  end
end

switch name
  case 'te8'
    Ffun = @(x) first_m(te8_f(x), m);
    Gfun = @(x) first_m_cell(te8_g(x), m);
  case 'fds'
    Ffun = @(x) first_m(fds_f(x), m);
    Gfun = @(x) first_m_cell(fds_g(x), m);
  case 'bk1'
    Ffun = @(x) first_m(bk1_f(x), m);
    Gfun = @(x) first_m_cell(bk1_g(x), m);
  case 'ikk1'
    Ffun = @(x) first_m(ikk1_f(x), m);
    Gfun = @(x) first_m_cell(ikk1_g(x), m);
  case 'vu1'
    Ffun = @(x) first_m(vu1_f(x), m);
    Gfun = @(x) first_m_cell(vu1_g(x), m);
  case 'sp1'
    Ffun = @(x) first_m(sp1_f(x), m);
    Gfun = @(x) first_m_cell(sp1_g(x), m);
  case 'mop5'
    Ffun = @(x) first_m(mop5_f(x), m);
    Gfun = @(x) first_m_cell(mop5_g(x), m);
  case 'mop7'
    Ffun = @(x) first_m(mop7_f(x), m);
    Gfun = @(x) first_m_cell(mop7_g(x), m);
  case 'slcdt2'
    Ffun = @(x) first_m(slcdt2_f(x), m);
    Gfun = @(x) first_m_cell(slcdt2_g(x), m);
  case 'dgo1'
    Ffun = @(x) first_m(dgo1_f(x), m);
    Gfun = @(x) first_m_cell(dgo1_g(x), m);
  case 'dgo2'
    Ffun = @(x) first_m(dgo2_f(x), m);
    Gfun = @(x) first_m_cell(dgo2_g(x), m);
  case 'ff1'
    Ffun = @(x) first_m(ff1_f(x), m);
    Gfun = @(x) first_m_cell(ff1_g(x), m);
  case 'ssfyy1'
    Ffun = @(x) first_m(ssfyy1_f(x), m);
    Gfun = @(x) first_m_cell(ssfyy1_g(x), m);
  case 'ssfyy2'
    Ffun = @(x) first_m(ssfyy2_f(x), m);
    Gfun = @(x) first_m_cell(ssfyy2_g(x), m);
  case 'vu2'
    Ffun = @(x) first_m(vu2_f(x), m);
    Gfun = @(x) first_m_cell(vu2_g(x), m);
  case 'vfm1'
    Ffun = @(x) first_m(vfm1_f(x), m);
    Gfun = @(x) first_m_cell(vfm1_g(x), m);
  case 'far1'
    Ffun = @(x) first_m(far1_f(x), m);
    Gfun = @(x) first_m_cell(far1_g(x), m);
  case 'fa1'
    Ffun = @(x) first_m(fa1_f(x), m);
    Gfun = @(x) first_m_cell(fa1_g(x), m);
  case 'fes1'
    Ffun = @(x) first_m(fes1_f(x), m);
    Gfun = @(x) first_m_cell(fes1_g(x), m);
  case 'zlt1'
    Ffun = @(x) first_m(zlt1_f(x, max(m,2)), m);
    Gfun = @(x) first_m_cell(zlt1_g(x, max(m,2)), m);
  case 'dpam1'
    Ffun = @(x) first_m(dpam1_f(x, params), m);
    Gfun = @(x) first_m_cell(dpam1_g(x, params), m);
  case 'fa1'
    Ffun = @(x) first_m(fa1_f(x), m);
    Gfun = @(x) first_m_cell(fa1_g(x), m);
  case 'fes1'
    Ffun = @(x) first_m(fes1_f(x), m);
    Gfun = @(x) first_m_cell(fes1_g(x), m);
  case 'zlt1'
    % honor problem.m when generating objectives
    Ffun = @(x) first_m(zlt1_f(x, max(m,2)), m);
    Gfun = @(x) first_m_cell(zlt1_g(x, max(m,2)), m);
  case 'fes2'
    Ffun = @(x) first_m(fes2_f(x), m);
    Gfun = @(x) first_m_cell(fes2_g(x), m);
  case 'fes3'
    Ffun = @(x) first_m(fes3_f(x), m);
    Gfun = @(x) first_m_cell(fes3_g(x), m);
  case 'tkly1'
    Ffun = @(x) first_m(tkly1_f(x), m);
    Gfun = @(x) first_m_cell(tkly1_g(x), m);
  case 'sk1'
    Ffun = @(x) first_m(sk1_f(x), m);
    Gfun = @(x) first_m_cell(sk1_g(x), m);
  case 'sk2'
    Ffun = @(x) first_m(sk2_f(x), m);
    Gfun = @(x) first_m_cell(sk2_g(x), m);
  otherwise % legacy by numeric ID or unknown name: fall back
    if isnumeric(problemKey)
      error('problem_dispatcher:LegacyRemoved', 'Legacy f1/f2/f3 and g1/g2/g3 have been removed. Use named problems.');
    else
      error('problem_dispatcher:UnknownName', 'Unknown problem name: %s', string(problemKey));
    end
end

meta = struct('name', name, 'key', problemKey, 'm', m);

end

function Fm = first_m(F, m)
Fm = F(1:min(m, numel(F)));
end
function Gm = first_m_cell(G, m)
Gm = G(1:min(m, numel(G)));
end

% legacy_F/legacy_G removed with legacy API
