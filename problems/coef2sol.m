function sol = coef2sol(b,a,Problem)

sol = zeros(1,Problem.dim);
n = Problem.dim;
order = Problem.order;

if (0 == Problem.isVariableLength)
    blen = round(n/2);
    sol(1:blen) = b;
    sol(blen+1:n) = a(2:end);
else
    p = round(n/2) + 2;
    sol(1) = order;
    sol(2:(order + 2)) = b;
    sol(p:(p+order-1)) = a(2:end);
end

end