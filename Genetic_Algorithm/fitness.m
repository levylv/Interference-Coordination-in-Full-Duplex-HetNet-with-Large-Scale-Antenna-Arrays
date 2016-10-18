function fitvalue = fitness(pop)

[pop_size, chromo_size] = size(pop);
fitvalue = zeros(pop_size, 1);

for i = 1:pop_size
    fitvalue(i) = dl_capacity(pop(i, :));
end


end
