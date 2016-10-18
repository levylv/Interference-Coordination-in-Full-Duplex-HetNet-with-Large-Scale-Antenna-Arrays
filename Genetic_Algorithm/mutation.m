function newpop = mutation(pop, mutate_rate)
% Mutation at single node
[pop_size, chromo_size] = size(pop);
newpop = pop;
for i = 1:pop_size
    p = rand(1);
    if p <= mutate_rate
        pos = round(chromo_size * rand(1));
        if pos ~= 0
            newpop(i, pos) = 1 - pop(i, pos);
        end
    end
end


end
