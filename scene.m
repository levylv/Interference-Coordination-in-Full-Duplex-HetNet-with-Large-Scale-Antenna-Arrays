function scene(N, S, K)
% model the scene and large-scale fading

global PL1 PL2 PL3 PL4 PL5 PL6;
global PBS PSC PN B;
global MUE SUE BS SC;

R_macro = 1000; % radius of macro circle
R_small = 40 ; % radius of small circle

BS = [0 0];% BS locates the center, radius is R_macro
SC = zeros(S, 2);
r = 20 + (R_macro - 40) * rand(S, 1); % 20m guard interval
theta =  2 * pi * rand(S, 1);
SC(:, 1) = r .* cos(theta); % SCs uniformly distribute at macro circle
SC(:, 2) = r .* sin(theta);
SUE = zeros(S, 2);
r = R_small * rand(S, 1);
theta =  2 * pi * rand(S, 1);
SUE(:, 1) = SC(:, 1) + r .* cos(theta); % SUEs uniformly distribute at small circle
SUE(:, 2) = SC(:, 2) + r .* sin(theta); %

% MUEs uniformly distribute, but its distance with nearest SC is larger than R_small
MUE = zeros(K, 2);
for i = 1:K
    xxx = 0;
    aaa = zeros(1, 2);
    while (xxx <= R_small)
        r_aaa = R_macro * rand(1);
        theta_aaa = 2 * pi * rand(1);
        aaa(1) = r_aaa * cos(theta_aaa);
        aaa(2) = r_aaa * sin(theta_aaa);
        dis(:, 1) = SC(:, 1) - aaa(1);
        dis(:, 2) = SC(:, 2) - aaa(2);
        dis_fang = dis(:, 1).^2 + dis(:, 2).^2;
        xxx = min(sqrt(dis_fang));
    end
    MUE(i, :) = aaa; 
end

% large-scale fading include path loss and shadow fading 
d1 = zeros(1, K);
PL1 = zeros(1, K);
for x = 1:K
   d1(x) = norm(BS - MUE(x, :));
   PL1(x) = 10^(-(6 + 2.7 + 42.8 * log10(d1(x))) / 10);
end %BS-MUE, PL1

d2 = zeros(1, S);
PL2 = zeros(1, S);
for x = 1:S
    d2(x) = norm(BS - SUE(x, :));
    PL2(x) = 10^(-(6 + 2.7 + 42.8 * log10(d2(x))) / 10);  
end %BS-SUE, PL2

d3 = zeros(1, S);
PL3 = zeros(1, S);
for x = 1:S
    d3(x) = norm(BS - SC(x, :));
    PL3(x) = 10^(-(6 + 16.3 + 36.3 * log10(d3(x))) / 10);  
end %BS-SC, PL3

d4 = zeros(S, K);
PL4 = zeros(S, K);
for x = 1:S
    for y =1:K
        d4(x,y) = norm(SC(x, :) - MUE(y, :));
        PL4(x,y) = 10^(-(4 + 32.9 + 37.5 * log10(d4(x,y))) / 10);
    end
end %SC-MUE, PL4

d5 = zeros(S, S);
PL5 = zeros(S, S);
for x = 1:S
    for y = 1:S
        d5(x,y) = norm(SC(x, :) - SUE(y, :));
        PL5(x,y) = 10^(-(4 + 32.9 + 37.5 * log10(d5(x,y))) / 10);
    end
end %SC-SUE, PL5

d6 = zeros(S, S);
PL6 = zeros(S, S);
for x = 1:S
    for y = 1:S
        d6(x,y)=norm(SC(x,:)-SC(y,:));
        PL6(x,y) = 10^(-(6 + 49.36 + 40 * log10(d6(x,y))) / 10);
    end
end %SC-SC, PL6

% power and bandwidth
PBS = 10^(46/10) / 2; % BS power
PSC = 10^(24/10); % SC power
%PMUE = 10^(23/10);% MUE power
%PSUE = 10^(23/10);% SUE power
PN = 10^(-174/10); % noise power per HZ
B = 20 * 10^6; % total bandwidth 

% self-interference cancelation
%SI = 10^(-110 / 10);

end
