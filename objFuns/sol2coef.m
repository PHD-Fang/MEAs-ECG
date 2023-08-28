%% If it's not variable length, n is odd number, sol[1:round(n/2)] is b.
%% If it's variable length, n is even number, order = sol(1).
%% sol[2:order+2] is b, sol[n/2+2:n/2+order+2] is a.
function [b,a,order] = sol2coef(sol,isVariableLength)

if (0 == isVariableLength)
    n = size(sol,2);
    blen = round(n/2);
    b = sol(1:blen);
    a = [1,sol(blen+1:n)];
    order = blen - 1;
else
    n = size(sol,2);
    order = round(sol(1));
    if isnan(order) || order < 1
        sol
        error("order is nan or 1.\r\n");
    end
    p = round(n/2) + 2;
    b = sol(2:(order + 2));
    a = [1,sol(p:(p+order-1))];
end

if 0 == (length(a) + length(b))
    sol
    error("lenght of a or b is 0.\r\n");
end

end