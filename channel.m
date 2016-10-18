function  channel(N, S, K) 
% model the small-scale fading

global h_b2mu h_b2s h_b2su h_s2su h_s2mu h_s2s;

% set the channel matrix
h_b2mu = (randn(K, N) + randn(K, N) * 1i) / sqrt(2); % BS-MUK
h_b2s = (randn(S, N) + randn(S, N) * 1i) / sqrt(2); % BS-SC
h_b2su = (randn(S, N) + randn(S, N) * 1i) / sqrt(2); % BS-SUE
h_s2su = (randn(S, S) + randn(S, S) * 1i) / sqrt(2); % SC-SUE
h_s2mu = (randn(S, K) + randn(S, K) * 1i) / sqrt(2); % SC-MUE
h_s2s = (randn(S, S) + randn(S, S) * 1i) / sqrt(2); % SC-SC


end
