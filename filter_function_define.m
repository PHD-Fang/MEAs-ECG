%objFunc1: Mse of Filter Freqz
%objFunc2: Rapple in passband
%objFunc3: Rapple in Stopband
%objFunc4: Pole out of unit circle
%objFunc5: The order of filter.
%objFunc6: Signal mse in time domain.
%objFunc7: Signal mse in frequency domain.
%objFunc8: Signal person correlation coefficient.
function Problem = filter_function_define(Filter_Function_ID,Parameters)

Problem.Filter_Function_ID = Filter_Function_ID;Problem.fs=360;
Problem.isPreDesign = 0;
Problem.isVariableLength = 0;
Problem.wcoef = [1,1,1,1,1,1,1,1]';
Problem.doSquare=0;
switch Filter_Function_ID
    case 1
        Problem.w = [1, 0,  0,  0,  0,  0,  0,  0];
        Problem = towardFilter(Problem,Parameters);        
    case 2
        %w = [1,0.0,0,0.0,1]';
        Problem.w =  [0.02, 1,  1,  1,  0,  0,  0,  0];%[1, 0,  0,  1,  0,  0,  0,  0];
        %1 a variable length problem, vice versa 0.
        Problem.isVariableLength = 0;
        %1 stands for introduce prior design, vice versa 0.
        Problem.isPreDesign = 1;
        %Maximum order of filter
        Problem.order = 4;
        %Rapple in passband and stopband
        Problem.rp = 0.1;Problem.rs=0.1;
        %set filter coef
        Problem.filterType = 'low';
        Problem.wp = [0,0.48];%[0,50/(Problem.fs/2)];%

        Problem = designFilter(Problem,Parameters);       
    case 3
        %w = [1,0.0,0,0.0,1]';
        Problem.w = [1, 0,  0,  1,  0,  0,  0,  0];%[0.2, 1,  1,  1,  0,  0,  0,  0];
        %1 a variable length problem, vice versa 0.
        Problem.isVariableLength = 0;
        %1 stands for introduce prior design, vice versa 0.
        Problem.isPreDesign = 0;
        %Maximum order of filter
        Problem.order = 4;
        %Rapple in passband and stopband
        Problem.rp = 0.1;Problem.rs=0.1;
        %set filter coef
        Problem.filterType = 'low';
        Problem.wp = [0,0.28];%[0,50/(Problem.fs/2)];%

        Problem = designFilter(Problem,Parameters);   
    case 4
        %w = [1,0.0,0,0.0,1]';
        Problem.w = [0, 1,  1,  1,  0,  0,  0,  0];
        %1 a variable length problem, vice versa 0.
        Problem.isVariableLength = 0;
        %1 stands for introduce prior design, vice versa 0.
        Problem.isPreDesign = 1;
        %Maximum order of filter
        Problem.order = 4;
        %Rapple in passband and stopband
        rp=0.1; rs=0.1;
        %set filter coef
        Problem.filterType = 'low';
        Problem.wp = [0,0.48];%[0,50/(Problem.fs/2)];%
        Problem.doSquare=1;
        Problem.wcoef = [1,rp,rs,1,1,1,1,1]';

        Problem = designFilter(Problem,Parameters);    
%     case 5
%         Problem.w = [1, 1,  1,  0,  1,  0,  0,  0];
%         %Select train data
%         Problem = adaptiveFilter(Problem,Parameters);
% 
%         %Set filter coefficient as the initial solution
% 
%         %1 a variable length problem, vice versa 0.
%         Problem.isVariableLength = 1;
%         %1 stands for introduce prior design, vice versa 0.
%         Problem.isPreDesign = 1;
%         %Maximum order of filter
%         Problem.order = 6;
%         %Rapple in passband and stopband
%         Problem.rp = 0.1;Problem.rs=0.1;
%         %set filter coef
%         Problem.filterType = 'low';
%         Problem.wp = [0,0.48];%[0,50/(Problem.fs/2)];%
% 
%         Problem = designFilter(Problem,Parameters);        
     otherwise
        error('Unkonwn filter id: %d.\r\n',Filter_Function_ID);
end

fprintf("The problem id is %d.\r\n",Filter_Function_ID);
end