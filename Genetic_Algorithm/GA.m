function  [best_individual, best_fit]= GA()
% Gegetic Algorithm
global al;

[K, S] = size(al);

generation_size = 200; % number of iteration
pop_size = S + 10; % number of pop size
chromo_size = S; % length of chromo
cross_rate = 0.6; % crossover rate
mutate_rate = 0.01; % mutation rate


%value = zeros(generation_size, length(pop_size_scale));
%for t = 1:length(pop_size_scale)
%pop_size = pop_size_scale(t);

% initial pop
pop = initpop(pop_size, chromo_size);

% genetic
for i = 1:generation_size
    fitvalue = fitness(pop); % calculate fitness of pop

    % the best one
    [best_individual, best_fit] = best(pop, fitvalue);
   % fprintf('%d', best_individual);
   % fprintf('  %f\n', best_fit);
    % renew pop
    newpop = selection(pop, fitvalue); % roulette selection
    newpop = crossover(newpop, cross_rate); % crossover
    newpop = mutation(newpop, mutate_rate); % mutation
    pop = newpop;
%    value(i, t) = best_fit;
end

%end

%{
figure;
plot(1:generation_size, value(:, 1), '--r'); % popsize = 10
hold on;
plot(1:generation_size, value(:, 2), '-.b'); % popsize = 20
hold on;
plot(1:generation_size, value(:, 3), '-g'); % popsize = 30
hold on;
plot(1:generation_size, value(:, 4), '-.k'); % popsize = 40
grid on;
xlabel('iteration', 'fontsize', 11);
ylabel('Downlink capacity(bit/s/Hz)', 'fontsize', 11);
legend('popsize = 10', 'popsize = 30', 'popsize = 50', 'popsize = 70'); 
%}
end
