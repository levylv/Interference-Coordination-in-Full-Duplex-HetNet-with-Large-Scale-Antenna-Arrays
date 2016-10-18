function  parameter(N, S, K)
% generate the formula parameter

% function channel
global h_b2mu;%BS-MUK
global h_b2s; %BS-SC
global h_b2su;%BS-SUE
global h_s2su;%SC-SUE
global h_s2mu;%SC-MUE
global h_s2s;%SC-SC

% function scene
global PL1 PL2 PL3 PL4 PL5 PL6;
global PBS PSC PN B;

% define final formula parameter
global al be c d d_hat g h h_hat;

% generate parameter
W = normal(pinv(h_b2mu)); % BS-MUE ZF precoding
G = normal(pinv(h_b2s)); % BS-SC ZF precoding

%Macro tier，alpha(k, i), beta(k)
al = zeros(K, S);
be = zeros(K, 1);
for i = 1:K
    for j = 1:S
        al(i, j) = K * PSC * PL4(j, i) * norm(h_s2mu(j, i))^2 / ( PBS * PL1(i) * norm(h_b2mu(i, :) * W)^2);
    end
    be(i) = B / 2 * PN * K / (PBS * PL1(i) * norm(h_b2mu(i, :) * W)^2);
end

%Small Cell tier，e, f, g, h_hat, h for OBFD
%e = zeros(S, S);
%f = zeros(S, 1);
g = zeros(S, S);
h_hat = zeros(S, 1);
h = zeros(S, 1);

for i = 1:S
    for j = 1:S
%        e(i, j) = PSC * PL6(j, i) * norm(h_s2s(j, i))^2 / (NF_SC * PBS / S * PL3(j) * norm(h_b2s(j, :) * G)^2);
%        f(j) = B / 2 * PN / (NF_SC * PBS / S * PL3(j) * norm(h_b2s(j, :) * G)^2);
        if j == i
            g(i, j) = 0;
        else
            g(i, j) = PL5(j, i) * norm(h_s2su(j, i))^2 / (PL5(i, i) * norm(h_s2su(i, i))^2);
        end
        h_hat(i) = (B / 2 * PN) / (PSC * PL5(i, i) * norm(h_s2su(i, i))^2);
        h(i)= (B / 2 * PN + PL2(i) * PBS / K * norm(h_b2su(i, :) * W)^2) / (PSC * PL5(i, i) * norm(h_s2su(i, i))^2);

    end
end

%Small Cell tier，a, b, c, d_hat, d for IBFD
%a = zeros(S, S);
%b = zeros(S, 1);
c = zeros(S, S);
d_hat = zeros(S, 1);
d = zeros(S, 1);
for i = 1:S
    for j = 1:S
        if j == i
%           a(i, j) = 0;
            c(i, j) = 0;
        else
%            a(i, j) = PSC * PL6(j, i) * norm(h_s2s(j, i))^2 / (NF_SC * PBS / S * PL3(j) * norm(h_b2s(j, :) * G)^2);
            c(i, j) = PL5(j, i) * norm(h_s2su(j, i))^2 / (PL5(i, i) * norm(h_s2su(i, i))^2);
        end
%        b(j) = (B / 2 * PN + PSC * SI) / (NF_SC * PBS / S * PL3(j) * norm(h_b2s(j, :) * G)^2);
        d_hat(i) = (B / 2 * PN ) / ( PSC * PL5(i, i) * norm(h_s2su(i, i))^2);
        d(i) = (B / 2 * PN + PL2(i) * PBS / S * norm(h_b2su(i, :) * G)^2) / (PSC * PL5(i, i) * norm(h_s2su(i, i))^2);

    end
end

end
