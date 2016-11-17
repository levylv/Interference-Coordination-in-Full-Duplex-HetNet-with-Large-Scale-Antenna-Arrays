function [Greedy_flag, Greedy_fit] = Greedy()
% Greedy Algorithm

global al be c d d_hat g h h_hat;
[K, S] = size(al);
C_max = 0;
flag = randint(1, S);
while 1
    delta_max = 0;
    for i = 1:S
       flag_test = flag;
       flag_test(i) = 1 - flag_test(i);
       delta = dl_capacity(flag_test) - dl_capacity(flag);
       if delta > delta_max
           delta_max = delta;
           index = i;
       end
    end
    if delta_max > 0 
        flag(index) = 1 - flag(index);
    else
        break;
    end
end
C = dl_capacity(flag);
if C > C_max
    C_max = C;
    Greedy_flag = flag;
    Greedy_fit = dl_capacity(flag);
end

end
