function A = normal(B)
% normalized the column vector as 1
[a, b] = size(B);
A = zeros(a, b);
for x = 1:b
    if norm(B(:, x))~=0
        A(:, x) = B(:, x) / norm(B(:, x));
    else 
        A(:, x) = B(:, x);
    end
end
