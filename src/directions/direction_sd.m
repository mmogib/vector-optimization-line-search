function [d, state] = direction_sd(x, grad, history, opts)
% direction_sd  Steepest‑descent search direction.
%   [d, state] = direction_sd(x, grad, history, opts)
%   Returns the negative gradient as the search direction.
%   Inputs are accepted for API compatibility but not used beyond grad.
%   Refactored by: Dr. Mohammed Alshahrani

if nargin < 2
    error('direction_sd:NotEnoughInputs', 'Requires at least x and grad.');
end

d = -grad;
state = struct('name','sd');
