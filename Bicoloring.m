function [BC_flag, BC_fit] = Bicoloring(stepsize)
% Bicolor algorithm based on price

global MUE SUE BS SC;
global al c; 

[K, S] = size(al);


% Get the selection factor of each node
flag = ones(1, S);
C_refer = dl_capacity(flag);
SelFactor = zeros(1, S);
for i =1:S
    flag(i) = 0;
    SelFactor(i) = dl_capacity(flag) - C_refer; 
    flag(i) = 1;
end

% Bicoloring
IsTraversalFlag = 0;
Th_scale = -4;
Th = 10 .^ Th_scale; % For macroR = 1000m, set the threshold 
step = 10 ^ (stepsize / 10);

colored = -ones(S, 1); % set uncolored node -1
flag = -ones(1, S);

while IsTraversalFlag == 0
    % Define a graph
    map = zeros(S, S); 
    for i = 1:S
        for j = 1:S
            if c(i, j) >= Th
                map(i, j) = 1; % adjacent
                map(j, i) = 1; % undigraph
            end
        end
    end

    for initNode = 1:S
        if colored(initNode) == -1  % Search uncolored node
            subvertex = DFS(map, initNode); % Search the maximally connected subgraph from src node by DFS
            stack = []; % define a stack, DFS
            ConnectedFlag = true;
            pointer = 1;
            stack(pointer) = initNode;
            colored(initNode) = 1;

            while stack
                Node = stack(pointer);
                stack(pointer) = [];
                pointer = pointer - 1;
                for i = 1:S
                    if map(Node, i) == 1 && colored(i) == -1
                        colored(i) = 1 - colored(Node);
                        pointer = pointer + 1;
                        stack(pointer) = i;
                    elseif map(Node, i) == 1 && colored(i) == colored(Node)
                        ConnectedFlag = false;
                        break;
                    end
                end
            end

            if ConnectedFlag == true
                % Decide which class belong IBFD based on price   
                classOne = find(colored == 1);
                classTwo = find(colored == 0);
                colored(classOne) = 2; % set nodes have been processed 2
                colored(classTwo) = 2;
                if  length(classTwo) == 0
                    flag(classOne) = 1; % Set IBFD
                elseif (sum(SelFactor(classOne)) / length(classOne)) <= (sum(SelFactor(classTwo)) / length(classTwo))
                    flag(classOne) = 1;
                    flag(classTwo) = 0;
                else
                    flag(classOne) = 0;
                    flag(classTwo) = 1;
                end
            else
                colored(subvertex) = 3; % set unconnected subgraph 3
            end
        end
    end

    if length(find(colored == 3))
        Th = Th * step;
        colored(find(colored == 3)) = -1; % reset all unconnected subvertex -1
    else
        IsTraversalFlag = 1;
    end

end

BC_flag = flag;
BC_fit = dl_capacity(BC_flag);

%{
if length(find(flag == -1))
    fprintf('Wrong\n');
else 
    fprintf('True\n');
end

figure;
scatter(BS(1), BS(2), 300, 'ok', 'fillled');
hold on;
scatter(SC(:, 1), SC(:, 2), 60, 'b^', 'filled');

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
%}

%{
IsTraversalFlag = 0;
Th_scale = -4;
Th = 10 .^ Th_scale; % For macroR = 1000m, set the threshold 

while IsTraversalFlag == 0
    % Define a graph
    map = zeros(S, S); 
    for i = 1:S
        for j = 1:S
            if c(i, j) >= Th
                map(i, j) = 1; % adjacent
                map(j, i) = 1; % undigraph
            end
        end
    end
    [bool] = isbipartite(map);

    if bool == false
        Th = Th * 10^0.5;
    else
        IsTraversalFlag = 1;
    end

end

flag = -ones(1, S);
colored = -ones(S, 1); % set uncolored node -1
for initNode = 1:S
    stack = []; % define a stack, DFS
    if colored(initNode) == -1  % Search uncolored connected subgraph
        pointer = 1;
        stack(pointer) = initNode;
        colored(initNode) = 1;

        while stack
            Node = stack(pointer);
            stack(pointer) = [];
            pointer = pointer - 1;
            for i = 1:S
                if map(Node, i) == 1 && colored(i) == -1
                    colored(i) = 1 - colored(Node);
                    pointer = pointer + 1;
                    stack(pointer) = i;
                end
            end
        end
        % Decide which class belong IBFD based on price, Set Nodes have been processed 2
        classOne = find(colored == 1);
        classTwo = find(colored == 0);
        colored(classOne) = 2;
        colored(classTwo) = 2;
        if  length(classTwo) == 0
            flag(classOne) = 1; % Set IBFD
        elseif (sum(SelFactor(classOne)) / length(classOne)) <= (sum(SelFactor(classTwo)) / length(classTwo))
            flag(classOne) = 1;
            flag(classTwo) = 0;
        else
            flag(classOne) = 0;
            flag(classTwo) = 1;
        end

    end
end
BC_flag = flag;
BC_fit = dl_capacity(BC_flag);

%}

end
