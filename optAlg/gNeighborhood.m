function solution = gNeighborhood(Xi,Xk,Xbest,Problem)
    D = size(Xi.Solution,2);
    Param2Change=fix(rand*D)+1;
    vi = Xi.Solution;
    vi(Param2Change)=Xi.Solution(Param2Change)...
                        +(Xbest.Solution(Param2Change)-Xi.Solution(Param2Change))*rand;
    solution = vi;
end