function setup_if_needed()
% utils.setup_if_needed  Ensure repo paths are on MATLAB path when called directly.
%   Calls setup.m in the repository root if core functions are missing.

if exist('vop_solve','file') ~= 2
  if exist('setup.m','file') == 2
    try
      run('setup.m');
    catch ME %#ok<NASGU>
    end
  end
end

end

