clc;
clear all;
addpath ./Genetic_Algorithm


Num_S = 10:10:30; % vary S

Num_iter = 10; % average scene
Num_h_iter = 10; % average channel

% Algorithms
GA_T = zeros(length(Num_S), 1);
GCA_T = zeros(length(Num_S), 1);
Greedy_T = zeros(length(Num_S), 1);
BCA_T = zeros(length(Num_S), 1);

for i = 1:length(Num_S)
    N = 200; % N antennas
    K = 20; % 20 MUEs
    S = Num_S(i); % S SC and SUE
    
    GA_T_sum = 0;
    GCA_T_sum = 0;
    Greedy_T_sum = 0;
    BCA_T_sum = 0;
    for iter = 1:Num_iter
        scene(N, S, K); % model the scene
        GA_T_h_sum = 0;
        GCA_T_h_sum = 0;
        Greedy_T_h_sum = 0;
        BCA_T_h_sum = 0;
        
        for h_iter = 1:Num_h_iter
            channel(N, S, K); % model the channel
            parameter(N, S, K); % model the parameter

            tic;
            [GCA_flag, GCA_fit] = GCA(); % Graph color Algorithm
            GCA_Time= toc;
            
            tic;
            [GA_flag, GA_fit] = GA(); % Genetic Algorithm
            GA_Time = toc;

            tic;
            [Greedy_flag, Greedy_fit] = Greedy(); % Greedy Algorithm
            Greedy_Time = toc;

            tic;
            [BC_flag, BC_fit] = Bicoloring(); % Bicoloring Algorithm
            BCA_Time = toc;

            BCA_T_h_sum = BCA_T_h_sum + BCA_Time;
            GA_T_h_sum = GA_T_h_sum + GA_Time;
            GCA_T_h_sum = GCA_T_h_sum + GCA_Time;
            Greedy_T_h_sum = Greedy_T_h_sum + Greedy_Time;
                        
        end

        GA_T_sum = GA_T_sum + GA_T_h_sum / Num_h_iter;
        GCA_T_sum = GCA_T_sum + GCA_T_h_sum / Num_h_iter;
        Greedy_T_sum = Greedy_T_sum + Greedy_T_h_sum / Num_h_iter;
        BCA_T_sum = BCA_T_sum + BCA_T_h_sum / Num_h_iter;
    end
    GA_T(i) = GA_T_sum / Num_iter;
    GCA_T(i) = GCA_T_sum / Num_iter;
    Greedy_T(i) = Greedy_T_sum / Num_iter;
    BCA_T(i) = BCA_T_sum / Num_iter;

end

%{
figure;
plot(Num_S(1:6), GA_T(1:6), '-r*'); % GEA
hold on;
plot(Num_S(1:6), BCA_T(1:6), '-r*');
hold on;
plot(Num_S(1:6), GCA_T(1:6), '-b*'); % DGCA
hold on;
plot(Num_S(1:6), Greedy_T(1:6), '-g*'); % GRA
grid on;
xlabel('number of SBSs', 'fontsize', 11);
ylabel('Run Time(s)', 'fontsize', 11);
legend('GEA','BCA','DGCA','GRA');
%}

y = [BCA_T';GCA_T';GA_T';Greedy_T'];
figure;
bar(y);
set(gca,'XTickLabel',{'BCA','DGCA','GEA','GRA'});
xlabel('Algorithms', 'fontsize', 11);
ylabel('CPU Time(s)', 'fontsize', 11);
legend('S = 10','S = 20','S = 30');


