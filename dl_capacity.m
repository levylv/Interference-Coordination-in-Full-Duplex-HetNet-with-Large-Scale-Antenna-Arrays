function [C]= dl_capacity(flag) 
% calculate the dl capacity, flag = 1 denote IBFD, flag = 0 denote OBFD

global al be c d d_hat g h h_hat;

[K, S] = size(al);

C_M_k = [];
for i = 1:K
    C_M_k(i) = log2(1 + 1 / ( al(i, :) * (1 - flag)' + be(i)));
end
C_M = 0.5 * sum(C_M_k);

C_I_i = [];
for i = 1:S
    C_I_i(i) = flag(i) * log2(1 + 1 / (c(i, :) * flag' + d_hat(i)));
end
C_I = 0.5 * sum(C_I_i);

C_O_i = [];
for i = 1:S
    C_O_i(i) = (1 - flag(i)) * log2(1 + 1 / (g(i, :) * (1 - flag)' + h_hat(i)));
end
C_O = 0.5 * sum(C_O_i);

C =  C_M + C_I + C_O ;

end
