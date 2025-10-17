function v = getfield_def(S, fieldName, default)
% utils.getfield_def  Get struct field with a default fallback.
%   v = utils.getfield_def(S, fieldName, default)
%   Returns default if field is missing or empty.

if isstruct(S) && isfield(S, fieldName) && ~(numel(S.(fieldName))==0)
  v = S.(fieldName);
else
  v = default;
end

end

