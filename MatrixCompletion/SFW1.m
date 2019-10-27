function [ xk, info ] = SFW1( gradf, lmoX, xk, varargin)
%SFW1 This function implements Stochastic Frank Wolfe Method from [Ref3] 
%for matrix completion problem.
%
% [Ref3] Mokhtari, A., Hassani, H., Karbasi, A.
% "Stochastic Conditional gradient methods: From convex minimization to
% submodular maximization"
% arXiv:1804.09554v2, 2018
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Set parameters to user specified values

% Default choices
errFncs = {};
maxitr = 1000;   % total iterations
printfrequency = 0;

if (rem(length(varargin),2)==1)
    error('Options should be given in pairs');
else
    for itr=1:2:(length(varargin)-1)
        switch lower(varargin{itr})
            case 'errfncs'
                errFncs = varargin{itr+1};
            case 'maxitr'
                maxitr = varargin{itr+1};
            case 'printfrequency'
                printfrequency = varargin{itr+1};
            otherwise
                error(['Unrecognized option: ''' varargin{itr} '''']);
        end
    end
end

%% Preallocate data vectors
info.time = nan(maxitr,1);
for sIr = 1:2:length(errFncs)
    info.(errFncs{sIr}) = nan(maxitr,1);
end

%% Algorithm
dk = sparse(0);
clkTime = 0;
for itr = 1:maxitr
    
    % Start itration timer
    clkTimer = tic;
    
    % Main algorithm
    eta = 9/(itr+8);
    rho = 4/(itr+7)^(2/3);
    
    dk = (1 - rho)*dk + rho*gradf(xk);
    sXk = lmoX(dk);
    xk = xk + eta*(sXk - xk);
    
    % Stop itration timer
    clkTime = clkTime + toc(clkTimer);
    
    % save progress
    info.time(itr,1) = clkTime;
    for sIr = 1:2:length(errFncs)
        info.(errFncs{sIr})(itr,1) = errFncs{sIr+1}(xk);
    end
    
    % print progress
    if printfrequency && (mod(itr,printfrequency)==0)
        fprintf('itr = %d%4.2e', itr);
        for sIr = 1:2:min(length(errFncs),16)
            fprintf(['  \t',errFncs{sIr},' = %4.2e'],info.(errFncs{sIr})(itr,1));
        end
        fprintf('\n');
    end
    
end

end

%% Last edit: 24 October 2019 - Alp Yurtsever
