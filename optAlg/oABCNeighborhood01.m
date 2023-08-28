function vi = oABCNeighborhood01(Xi,Xk,Problem)

    th = 4;
    vi = Xi.Solution;
    bitOne = abs(Xi.Solution - Xk.Solution);
    [val, indx]=max(bitOne);
    probs = bitOne/val;
    bitOne = probs < 0.4;
    if sum(bitOne) < th
        [val,bitIndx] = find(bitOne==0);
        Param2Change=bitIndx(fix(rand*sum(val))+1);
    else
        [val, bitIndx] = find(bitOne==1);
        Param2Change=bitIndx(fix(rand*sum(val))+1);
    end

    vi(Param2Change)=Xi.Solution(Param2Change)+(Xi.Solution(Param2Change)-Xk.Solution(Param2Change))*(rand-0.5)*2;

end