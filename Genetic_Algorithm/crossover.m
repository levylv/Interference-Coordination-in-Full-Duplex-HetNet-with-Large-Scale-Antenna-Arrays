function newpop = crossover(pop, cross_rate)
% Cross over
[pop_size, chromo_size] = size(pop);
for i = 1:2:(pop_size - 1)
    p = rand(1);
    if p <= cross_rate
        pos = round(chromo_size * rand(1));
        newpop(i, :) = [pop(i, 1:pos) pop(i + 1, (pos + 1):end)];
        newpop(i + 1, :) = [pop(i + 1, 1:pos) pop(i, (pos + 1):end)];
    end
    newpop(i, :) = pop(i, :);
    newpop(i + 1, :) = pop(i + 1, :);
end

end
