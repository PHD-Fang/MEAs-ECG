function vi = oABCNeighborhood(Xi,Xk,Problem)

    th = fix(0.5*Problem.dim);
    vi = Xi.Solution;
    bitOne = abs(Xi.Solution - Xk.Solution) < 0.5;
    if sum(bitOne) < th
        [val,bitIndx] = find(bitOne==0);
        Param2Change=bitIndx(fix(rand*sum(val))+1);
    else
        [val,bitIndx] = find(bitOne==1);
        Param2Change=bitIndx(fix(rand*sum(val))+1);
    end

    vi(Param2Change)=Xi.Solution(Param2Change)+(Xi.Solution(Param2Change)-Xk.Solution(Param2Change))*(rand-0.5)*2;

end