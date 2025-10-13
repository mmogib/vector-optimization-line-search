function reg = registry()
% registry  Problem registry with IDs, names, and default dimensions.
%   Returns an array of structs with fields: id, name, n, m.

% Source note (Table XVI):
%   Huband, S., Hingston, P., Barone, L., & While, L. (2006).
%   A review of multiobjective test problems and a scalable test problem toolkit.
%   IEEE Transactions on Evolutionary Computation, 10(5), 477–506.
%   https://doi.org/10.1109/TEVC.2005.861417

% Notes: Present datasets from refs/problems.tex (Table XVI) and their sources
% - BK1   [BK1996]  Domain: x_i in [-5, 10]
% - DGO1  [DGO1999] Domain: x in [-10, 13]
% - DGO2  [DGO1999] Domain: x in [-9, 9]
% - IKK1  [IKK1999] Domain: x_i in [-50, 50]
% - JOS1  [JOS1995] Domain: (not specified)
% - MHHM1 [MHHM1999] Domain: x in [0, 1]
% - MHHM2 [MHHM1999] Domain: x_i in [0, 1]
% - MLF2  [MLF1994] Domain: (not specified)
% - SK1   [SK1998]  Domain: (not specified)
% - SK2   [SK1998]  Domain: (not specified)
% - SP1   [SP1997]  Domain: (not specified)
% - SSFYY2 [SSFYY1999] Domain: x_i in [-100, 100]
% - VU1   [VU2001]  Domain: x_i in [-3, 3]
% - ZLT1  [ZLT2003] Domain: x_i in [-1000, 1000]
% Additional datasets present (not in this list): ZDT1, ZDT4.

reg = struct( ...
    'id',  {1, 2, 5, 6, 10}, ...
    'name',{'P1','P2','P5','P6','P10'}, ...
    'n',   {2, 4, 2, 2, 10}, ...
    'm',   {2, 2, 2, 2, 2} ...
);

end
