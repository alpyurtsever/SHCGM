function [ x_g, info ] = S3CCM( sto_grad, prox_f, prox_g, gamma, x_f_0 , varargin)
%S3CCM This function implements Stochastic Three Composite Convex 
%Minimization method from [Ref2] for the matrix completion problem.
%
% [Ref2] Yurtsever, A., Vu, B.C., Cevher, V.
% "Stochastic Three-Composite Convex Minimization"
% Advances in Neural Information Processing Systems 29 (NeurIPS 2016).
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Set parameters to user specified values

% Default choices
errFncs = {};
maxitr = 10000;   % total iterations
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
info.gamma = gamma;
for sIr = 1:2:length(errFncs)
    info.(errFncs{sIr}) = nan(maxitr,1);
end

%% Initilization
x_f = x_f_0;
x_g = prox_g(x_f_0, gamma);
u_g = (1/gamma)*(x_f - x_g);%*0;

%% Algorithm
clkTime = 0;
for itr = 1:maxitr
    
    % Start itration timer
    clkTimer = tic;
    
    % Main algorithm
    x_g = prox_g(x_f + gamma*u_g, gamma);
    u_g = (1/gamma)*(x_f - x_g) + u_g;
    r_next = sto_grad(x_g);
    x_f = prox_f(x_g - gamma* (u_g + r_next), gamma);
    
    % Stop itration timer
    clkTime = clkTime + toc(clkTimer);
    
    % save progress
    info.time(itr,1) = clkTime;
    for sIr = 1:2:length(errFncs)
        info.(errFncs{sIr})(itr,1) = errFncs{sIr+1}(x_g);
    end
    
    % print progress
    if printfrequency && (mod(itr,printfrequency)==0)
        fprintf('itr = %d%4.2e', itr);
        for sIr = 1:2:min(length(errFncs),6)
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

%% Last edit: 24 October 2019 - Alp Yurtsever