function [GCA_flag, GCA_fit] = GCA()
% Distributed graph color algorithm based on price

global MUE SUE BS SC;
global al c; 

[K, S] = size(al);
Th_scale = -4:0.2:0;
Th = 10 .^ Th_scale; % For macroR = 1000m, set the threshold 
kScale = 0:0.2:5; % set the weight of inter-tier interference

% Define a graph
map = zeros(S, S, length(Th)); 
for t = 1:length(Th)
    for i = 1:S
        for j = 1:S
            if c(i, j) >= Th(t)
                map(i, j, t) = 1; % adjacent
                map(j, i, t) = 1; % undigraph
            end
        end
    end
end

% Get the selection factor of each node
flag = ones(1, S);
C_refer = dl_capacity(flag);
SelFactor = zeros(1, S);
for i =1:S
    flag(i) = 0;
    SelFactor(i) = dl_capacity(flag) - C_refer; 
    flag(i) = 1;
end

% color 
k_Th_fit = zeros(length(Th), length(kScale));
max_fit = 0;
max_kScale = 0;
max_Th = 0;
[SortValue_SelFactor, Sort_SelFactor] = sort(SelFactor); % sort the SelFactor as ascending
for t = 1:length(Th)
    for k = 1:length(kScale)
        flag = -ones(1, S); % tips: set -1 , the third status
        for i = 1:S
            minNodeValue = SortValue_SelFactor(i);
            minNode = Sort_SelFactor(i);
            IBFDNodeFactor = 0; % reset
            OBFDNodeFactor = 0; % reset
            for j = 1:S
                if map(minNode, j, t) == 1 % if adjacent
                    if flag(j) == 1
                        IBFDNodeFactor = IBFDNodeFactor + SelFactor(j);
                    end
                    if flag(j) == 0
                        OBFDNodeFactor = OBFDNodeFactor + SelFactor(j);
                    end
                end
            end
            if IBFDNodeFactor == 0  % if this minNode has no jacent IBFDnode, then color IBFD
                flag(minNode) = 1;
            elseif OBFDNodeFactor == 0 % if this minNode has jacent IBFDnode, but no jacent OBFDnode
                if IBFDNodeFactor + minNodeValue > kScale(k) * 2 ^ (-minNodeValue)
                    flag(minNode) = 0;
                else
                    flag(minNode) = 1;
                end
            else % if this minNode both have jacent IBFD and OBFD node
                if IBFDNodeFactor > OBFDNodeFactor + kScale(k) * 2 ^ (-minNodeValue)
                    flag(minNode) = 0;
                else
                    flag(minNode) = 1;
                end
            end

        end
        k_Th_fit(t, k) = dl_capacity(flag);

        if k_Th_fit(t, k) > max_fit
            max_fit = k_Th_fit(t, k);
            max_kScale = kScale(k);
            max_Th = Th(t);
            max_flag = flag;
        end
    end
end
GCA_flag = max_flag;
GCA_fit = dl_capacity(GCA_flag);

%{
figure;
plot(10 * log10(Th), k_Th_fit(:, 1), '--ro'); % k = 0
hold on;
plot(10 * log10(Th), k_Th_fit(:, 21), '-.bo'); % k = 2
hold on;
plot(10 * log10(Th), k_Th_fit(:, 41), '-go'); % k = 4
hold on;
plot(10 * log10(Th), k_Th_fit(:, 61), ':ko'); % k = 6
xlabel('\Gamma_{th}{(dB)}', 'fontsize', 11);
ylabel('Downlink capacity(bit/s/Hz)', 'fontsize', 11);
legend('\omega = 0', '\omega = 2', '\omega = 4', '\omega = 6'); % omega = k

%[Greedy_flag, Greedy_fit] = Greedy(); 
%[GA_flag, GA_fit] = GA(); 


figure;
scatter(BS(1), BS(2), 300, 'ok', 'fillled');
hold on;
scatter(MUE(:, 1), MUE(:, 2), 30, 'sk');
hold on;
scatter(SC(:, 1), SC(:, 2), 60, 'b^', 'filled');
hold on;
scatter(SUE(:, 1), SUE(:, 2), 30, 'bd');

for i = 1:S
    for j = 1:S
        if map(i, j) == 1
            hold on;
            plot([SC(i, 1), SC(j, 1)], [SC(i, 2), SC(j, 2)]);
        end
    end
    hold on;
    text(SC(i, 1) + 10, SC(i, 2) - 20, num2str(SelFactor(i)));
end


figure;
subplot(1, 2, 1);
scatter(BS(1), BS(2), 300, 'ok', 'fillled');
hold on;
scatter(MUE(:, 1), MUE(:, 2), 30, 'sk');
hold on;
scatter(SC(GCA_flag == 0, 1), SC(GCA_flag == 0, 2), 60, 'b^', 'filled');
hold on;
scatter(SC(GCA_flag == 1, 1), SC(GCA_flag == 1, 2), 60, 'ro', 'filled');

subplot(1, 2, 2);
scatter(BS(1), BS(2), 300, 'ok', 'fillled');
hold on;
scatter(MUE(:, 1), MUE(:, 2), 30, 'sk');
hold on;
scatter(SC(Greedy_flag == 0, 1), SC(Greedy_flag == 0, 2), 60, 'b^', 'filled');
hold on;
scatter(SC(Greedy_flag == 1, 1), SC(Greedy_flag == 1, 2), 60, 'ro', 'filled');
%}

end
