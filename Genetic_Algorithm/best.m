function [best_individual, best_fit] = best(pop, fitvalue)

[best_fit, pos] = max(fitvalue);
best_individual = pop(pos, :);

end
