function [GD_flag, GD_fit] = GradientDescent()
%梯度下降法求次优解

global al be c d d_hat g h h_hat;
[K, S] = size(al);

%{
[GA_flag, GA_fit] = GA(S);
fprintf('GA_fit = %d \n', GA_fit);
fprintf('GA_flag = %10d \n', GA_flag);
fprintf('\n')
%}
GDTOL = 1e-2; %梯度下降法精度
Maxiter = 1000;%最大迭代次数
stepsize = 0.03; % 步长

%步长参数
%BETA = 0.5;

%{
x1 = 0:0.01:1;
x2 = 0:0.01:1;
for i = 1:length(x1)
    for j = 1:length(x2)
        CCC(i, j) = dl_capacity([x1(i), x2(j)]);
    end
end
figure;
mesh(x1, x2 ,CCC);
%hold on;
%}

%初始一组自变量
flag = rand(1, S);
%fprintf('initflag %d\n', flag);
%fprintf('\n');

for iter = 1:Maxiter
    C_current =  dl_capacity(flag); %求max
%    fprintf('iteration is %d \n', iter);
%    fprintf('C = %d \n', C_current);
    grad = zeros(1, S);
    for i = 1:S
        grad_k = [];
        grad_I = [];
        grad_O = [];
        for k = 1:K
            grad_k(k) = al(k, i) / (log(2) * (al(k, :) * (1 - flag)' + be(k) + 1) * (al(k, :) * (1 - flag)' + be(k)));
        end
        for j = 1:S
            grad_I(j) = flag(j) * c(j, i) / (log(2) * (c(j, :) * flag' + d_hat(j) + 1) * (c(j, :) * flag' + d_hat(j)));
            grad_O(j) = (1 - flag(j)) * g(j, i) / (log(2) * (g(j, :) * (1 - flag)' + h_hat(j) + 1) * (g(j, :) * (1 - flag)' + h_hat(j))); 
        end
        grad(i) = sum(grad_k) - sum(grad_I) + log2(1 + 1 / (c(i, :) * flag' + d_hat(i))) + sum(grad_O) - log2(1 + 1 / (g(i, :) * (1 - flag)' + h_hat(i))) ;
    end
    %步径为梯度方向
    step = grad;

%    fprintf('梯度%d \n', step);
%    fprintf('\n');
    count = 0;

    %边界约束
    for i = 1:S
        if (flag(i) + stepsize * step(i)) > 1   
            flag(i) = 1;
        elseif (flag(i) + stepsize * step(i)) < 0
            flag(i) = 0;
        else
            flag(i) = flag(i) + stepsize * step(i);
        end
        if flag(i) == 1 || flag(i) == 0
            count = count + 1;
        end
    end
%    fprintf('Next_flag %d \n', flag);
%    fprintf('\n');

    %所有值都到达边界则停止
    if count == S
        break;
    end

    %梯度接近0则停止
    if norm(step) <= GDTOL
        break;
        
    end
%    while (t * dl_capacity(flag + stepsize * step)) >= (C_current + ALPHA * stepsize * grad * step')
%        a = -t * dl_capacity(flag + stepsize * step) - sum(log(flag + stepsize * step)) - sum(log(1 - (flag + stepsize * step)));
%        b = C_current + ALPHA * stepsize * grad * step';
%        stepsize = BETA * stepsize;
%    end

end
GD_flag = flag;
GD_fit = dl_capacity(GD_flag);

end
