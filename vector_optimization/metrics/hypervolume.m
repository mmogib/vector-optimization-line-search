 
function Rloophv=hypervolume(P,F)
    % F: a solution set found by a solver on a problem, An M x N matrix where each of the N columns represents a vector of
    % M objective function values.

    % Approximation of Pareto set, P=paretofront(F);

    % samples: The number of samples used for the Monte -Carlo approximation
    PP=P';
    ub = (max(F,[],2));
    [M, l] = size(PP);
    samples = 10000; %100000
    lb = min(P)';
    F_samples = repmat(lb,1,samples) + rand(M,samples) .* repmat((ub - lb),1,samples);
    is_dominated_count = 0;
    for i = 1:samples
        for j = 1:l
            if (dominates(PP(:,j), F_samples(:,i)))
                is_dominated_count = is_dominated_count + 1;
                break;
            end
        end
    end
    Rloophv=(is_dominated_count / samples); 
end