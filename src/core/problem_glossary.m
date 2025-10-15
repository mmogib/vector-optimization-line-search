function problem_glossary(filter)
% problem_glossary  Print available problems with short references.
%   problem_glossary() prints all; problem_glossary({'IKK1','TE8'}) filters.
%   Refactored by: Dr. Mohammed Alshahrani

if nargin < 1, filter = {}; end
[reg, meta] = local_registry_with_refs();

% Filter
if ~isempty(filter)
  mask = ismember(upper({reg.name}), upper(filter));
  reg = reg(mask);
end

% Print
fprintf('Available problems (%d):\n', numel(reg));
for i = 1:numel(reg)
  r = reg(i);
  ref = '';
  if isfield(meta, upper(r.name)), ref = meta.(upper(r.name)); end
  if ~isempty(ref)
    fprintf('  - %-8s n=%-3d  Ref: %s\n', r.name, r.n, ref);
  else
    fprintf('  - %-8s n=%-3d\n', r.name, r.n);
  end
end
fprintf('Tip: pass a cell array to filter, e.g., problem_glossary({''IKK1'',''TE8''}).\n');
fprintf('See refs/problems.tex for detailed formulations and sources.\n');

end

function [reg, refs] = local_registry_with_refs()
% Load current registry and attach basic reference keys
reg = registry();
refs = struct();
% Keys derived from refs/problems.tex (abbreviated)
refs.IKK1   = 'IKK1999 (see refs/problems.tex)';
refs.TE8    = 'TE family (see refs/problems.tex)';
refs.MOP5   = 'MOP test set (see refs/problems.tex)';
refs.MOP7   = 'MOP test set (see refs/problems.tex)';
refs.SLCDT2 = 'SLCDT test (see refs/problems.tex)';
refs.BK1    = 'BK1996';
refs.VU1    = 'VU2001';
refs.SP1    = 'SP1997';
refs.FDS    = 'FDS2000';
refs.DPAM1  = 'DPAM2000';
refs.DGO1   = 'DGO1999';
refs.DGO2   = 'DGO1999';
refs.FA1    = 'FA1998';
refs.FAR1   = 'FR2004';
refs.FES1   = 'FES1993';
refs.FES2   = 'FES1993';
refs.FES3   = 'FES1993';
refs.FF1    = 'FF1995';
refs.SK1    = 'SK??';
refs.SK2    = 'SK??';
refs.ZLT1   = 'ZLT??';
refs.TKLY1  = 'TKLY??';
refs.VFM1   = 'VFM??';
refs.VU2    = 'VU??';
% Add others from registry names as needed
end

