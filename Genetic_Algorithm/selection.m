function newpop = selection(pop, fitvalue)
% Roulette selection
[pop_size, chromo_size] = size(pop);
newpop = zeros(pop_size, chromo_size);
p_fitvalue = fitvalue / sum(fitvalue);
[value, pos] = max(p_fitvalue); % find the max one and elite selection straightly
p_fitsum = cumsum(p_fitvalue); % cumulative sum  of the fitness
ms = sort(rand(pop_size, 1)); % generate 0-1 randomly and sort

ms_init = 1;
fit_init = 1;
while ms_init <= pop_size
    if ms_init == pos  % Elite selection
        newpop(ms_init, :) = pop(pos, :);
        ms_init = ms_init + 1;
        continue;
    end

    if ms(ms_init) <= p_fitsum(fit_init)
        newpop(ms_init, :) = pop(fit_init, :);
        ms_init = ms_init + 1;
    else
        fit_init = fit_init + 1;
    end
end


end
