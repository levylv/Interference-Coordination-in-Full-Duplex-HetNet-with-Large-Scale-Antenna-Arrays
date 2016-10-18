clear all;
clc;
addpath ./Genetic_Algorithm

Num_S = 1:8:97; % vary S
Num_iter = 100; % average scene
Num_h_iter = 100; % average channel


% Three Algorithm
GA_Q = zeros(length(Num_S), 1); % proportion of IBFD
GA_capacity = zeros(length(Num_S), 1); % capacity

GCA_Q = zeros(length(Num_S), 1);
GCA_capacity = zeros(length(Num_S), 1);

Greedy_Q = zeros(length(Num_S), 1);
Greedy_capacity = zeros(length(Num_S), 1);

% Random selection of IBFD and OBFD
%Random_Q = zeros(length(Num_S), 1);
%Random_capacity = zeros(length(Num_S), 1);

% lowerbound
%AllI_Q = zeros(length(Num_S), 1); % All IBFD
%AllI_capacity = zeros(length(Num_S), 1);  

AllO_capacity = zeros(length(Num_S), 1); % ALl OBFD 
%AllO_ZF_capacity = zeros(length(Num_S), 1); % All OBFD without modified ZF 
for i = 1:length(Num_S)
    N = 200; % N antennas
    K = 20; % 20 MUEs
    S = Num_S(i); % S SC and SUE
    
    GA_flag_sum = 0;
    GA_fit_sum = 0;
    GCA_flag_sum = 0;
    GCA_fit_sum = 0;
    Greedy_flag_sum = 0;
    Greedy_fit_sum = 0;
    
    Random_flag_sum = 0;
    Random_fit_sum = 0;

%    AllI_fit_sum = 0;
    AllO_fit_sum = 0;
%    AllO_ZF_fit_sum = 0;
    for iter = 1:Num_iter
        scene(N, S, K); % model the scene
        GA_flag_h_sum = 0;
        GA_fit_h_sum = 0;
        GCA_flag_h_sum = 0;
        GCA_fit_h_sum = 0;
        Greedy_flag_h_sum = 0;
        Greedy_fit_h_sum = 0;
        
%        Random_flag_h_sum = 0;
%        Random_fit_h_sum = 0;

%        AllI_fit_h_sum = 0;
        AllO_fit_h_sum = 0;
%        AllO_ZF_fit_h_sum = 0;
        for h_iter = 1:Num_h_iter
            channel(N, S, K); % model the channel
            parameter(N, S, K); % model the parameter

            [GA_flag, GA_fit] = GA(); % Genetic Algorithm
            [GCA_flag, GCA_fit] = GCA(); % Graph color Algorithm
            [Greedy_flag, Greedy_fit] = Greedy(); % Greedy Algorithm
            
            % Random flag
%            Random_flag = randint(1, S);
%            Random_fit = dl_capacity(Random_flag);
            
%            fprintf('GA = %10d \nGR = %10d \nGC = %10d\n', GA_fit, Greedy_fit, GCA_fit);

            GA_flag_h_sum = GA_flag_h_sum + sum(GA_flag) / S;
            GA_fit_h_sum = GA_fit_h_sum + GA_fit;
            GCA_flag_h_sum = GCA_flag_h_sum + sum(GCA_flag) / S;
            GCA_fit_h_sum = GCA_fit_h_sum + GCA_fit;
            Greedy_flag_h_sum = Greedy_flag_h_sum + sum(Greedy_flag) / S;
            Greedy_fit_h_sum = Greedy_fit_h_sum + Greedy_fit;
            
%            Random_flag_h_sum = Random_flag_h_sum + sum(Random_flag) / S;
%            Random_fit_h_sum = Random_fit_h_sum + Random_fit;
            

%            AllI_fit_h_sum = AllI_fit_h_sum + dl_capacity(ones(1, S));    
            AllO_fit_h_sum = AllO_fit_h_sum + dl_capacity(zeros(1, S));
%            AllO_ZF_fit_h_sum = AllO_ZF_fit_h_sum + dl_capacity_ZF(zeros(1, S));
        end

        GA_flag_sum = GA_flag_sum + GA_flag_h_sum / Num_h_iter;
        GA_fit_sum = GA_fit_sum + GA_fit_h_sum / Num_h_iter;
        GCA_flag_sum = GCA_flag_sum + GCA_flag_h_sum / Num_h_iter;
        GCA_fit_sum = GCA_fit_sum + GCA_fit_h_sum / Num_h_iter;
        Greedy_flag_sum = Greedy_flag_sum + Greedy_flag_h_sum / Num_h_iter;
        Greedy_fit_sum = Greedy_fit_sum + Greedy_fit_h_sum / Num_h_iter;

%        Random_flag_sum = Random_flag_sum + Random_flag_h_sum / Num_h_iter;
%        Random_fit_sum = Random_fit_sum + Random_fit_h_sum / Num_h_iter;
        
%        AllI_fit_sum = AllI_fit_sum + AllI_fit_h_sum / Num_h_iter;
        AllO_fit_sum = AllO_fit_sum + AllO_fit_h_sum / Num_h_iter;
%        AllO_ZF_fit_sum = AllO_ZF_fit_sum + AllO_ZF_fit_h_sum / Num_h_iter;
        
    end
    GA_Q(i) = GA_flag_sum / Num_iter;
    GA_capacity(i) = GA_fit_sum / Num_iter;
    GCA_Q(i) = GCA_flag_sum / Num_iter;
    GCA_capacity(i) = GCA_fit_sum / Num_iter;
    Greedy_Q(i) = Greedy_flag_sum / Num_iter;
    Greedy_capacity(i) = Greedy_fit_sum / Num_iter;
    
%    Random_Q(i) = Random_flag_sum / Num_iter;
%    Random_capacity(i) = Random_fit_sum / Num_iter;

%    AllI_capacity(i) = AllI_fit_sum / Num_iter;
    AllO_capacity(i) = AllO_fit_sum / Num_iter;
%    AllO_ZF_capacity(i) = AllO_ZF_fit_sum / Num_iter;
end

% plot the capacity
figure;
plot(Num_S, GA_capacity, '-r*'); % GEA
hold on;
plot(Num_S, GCA_capacity, '-b*'); % DGCA
hold on;
plot(Num_S, Greedy_capacity, '-g*'); % GRA
hold on;
plot(Num_S, AllO_capacity, '-bo'); % All OBFD, lowerbound
grid on;
xlabel('number of SBSs', 'fontsize', 11);
ylabel('Downlink throughput(bit/s/Hz)', 'fontsize', 11);
legend('GEA','DGCA','GRA', 'LB');

% plot the proportion
figure;
plot(Num_S, GA_Q, '-ro');
hold on;
plot(Num_S, GCA_Q, '-bo');
hold on;
plot(Num_S, Greedy_Q, '-go');
grid on;
axis([0 100 0.5 1]);
xlabel('number of SBSs', 'fontsize', 11);
ylabel('Proportion of SBSs operating in IBFD', 'fontsize', 11);
legend('GEA','DGCA','GRA');

