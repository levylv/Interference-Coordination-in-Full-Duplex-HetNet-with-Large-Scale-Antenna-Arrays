clc;
clear all;

Num_S = 10:10:100; % vary S

Num_iter = 100; % average scene
Num_h_iter = 100; % average channel

BestTh = zeros(length(Num_S), 1);
Bestk = zeros(length(Num_S), 1);

for i = 1:length(Num_S)
    N = 200; % N antennas
    K = 20; % 20 MUEs
    S = Num_S(i); % S SC and SUE

    Th_fit_sum = 0;
    k_fit_sum = 0;
    for iter = 1:Num_iter
        scene(N, S, K); % model the scene

        Th_fit_h_sum = 0;
        k_fit_h_sum = 0;
        for h_iter = 1:Num_h_iter
            channel(N, S, K); % model the channel
            parameter(N, S, K); % model the parameter

            [GCA_flag, GCA_fit, Th_fit, k_fit] = GCA(); % GCA Algorithm
            Th_fit_h_sum = Th_fit_h_sum + Th_fit;
            k_h_sum = k_fit_h_sum + k_fit;
        end
        Th_fit_sum = Th_fit_sum + Th_fit_h_sum / Num_h_iter;
        k_fit_sum = k_fit_sum + k_fit_h_sum / Num_h_iter;

    end
    BestTh(i) = 10 * log10(Th_fit_sum / Num_iter);
    Bestk(i) = k_fit_sum / Num_iter;

end

% plot GRA
figure;
plot(Num_S, BestTh);
grid on;
xlabel('number of SBSs', 'fontsize', 11);
ylabel('Best \Gamma_{th}{(dB)}', 'fontsize', 11);
figure;
plot(Num_S, Bestk);
grid on;
xlabel('number of SBSs', 'fontsize', 11);
ylabel('Best \omega', 'fontsize', 11);
