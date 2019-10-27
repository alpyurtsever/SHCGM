function [ xk, info ] = SHCGM( gradf, lmoX, proxg, beta0, xk, varargin)
%SHCGM This function implements our Stochastic Homotopy Conditional
%Gradient Method from [Ref] for the matrix completion and covariance
%matrix estimation problems.
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Set parameters to user specified values

% Default choices
errFncs = {};
maxitr = 1000;
printfrequency = 0;
stoptime = inf;

if (rem(length(varargin),2)==1)
    error('Options should be given in pairs');
else
    for itr=1:2:(length(varargin)-1)
        switch lower(varargin{itr})
            case 'errfncs'
                errFncs = varargin{itr+1};
            case 'maxitr'
                maxitr = varargin{itr+1};
            case 'stoptime'
                stoptime = varargin{itr+1};
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
    beta = beta0/sqrt(itr+8);
    rho = 4/(itr+7)^(2/3);
    
    dk = (1 - rho)*dk + rho*gradf(xk);
    %     Axk = A*xk;
    %     vk = beta*dk + A'*(Axk - proxg(Axk,beta));
    vk = beta*dk + (xk - proxg(xk,beta)); % A = Identity;
    sXk = lmoX(vk);
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
    
    % check time and stop if the walltime is reached
    if clkTime >= stoptime
        info.time(itr+1:end) = [];
        for sIr = 1:2:length(errFncs)
            info.(errFncs{sIr})(itr+1:end) = [];
        end
        break;
    end
    
end

end

%% Last edit: 24 October 2019 - Alp Yurtsever