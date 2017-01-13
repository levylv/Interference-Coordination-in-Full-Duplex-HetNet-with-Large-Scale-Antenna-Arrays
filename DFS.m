function [subvertex] = DFS(map, src)
% Search the maximally connected subgraph from src node by DFS

S = length(map);
stack = []; % define a stack, DFS
pointer = 1;
stack(pointer) = src;
used = zeros(1, S);
used(src) = 1;
subvertex = [];
subvertexPointer= 1;
subvertex(subvertexPointer) = src;

while stack
    Node = stack(pointer);
    stack(pointer) = [];
    pointer = pointer - 1;
    for i = 1:S
        if map(Node, i) == 1 && used(i) == 0
            used(i) = 1 ;
            pointer = pointer + 1;
            stack(pointer) = i;
            subvertexPointer = subvertexPointer + 1;
            subvertex(subvertexPointer) = i;
        end
    end
end


end
