%% Description
% This script implements the coveriance matrix estimation experiment. It
% will save the results under the results folder. Run PLOTFIG2 and PLOTFIG3
% to generate the plots for Figures 1 and 2 from [Ref], once the tests are 
% completed. 
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Fix the seed for reproducability
rng(0,'twister'); % To make sure we use the same data for all tests

%% Generate data
dataSize = 1000;
num_blocks = 10;
indBlocks = [0,sort(randperm(dataSize,num_blocks-1)),dataSize];
for t = 1:num_blocks
    v(indBlocks(t)+1:indBlocks(t+1),t) = 2*(rand(indBlocks(t+1)-indBlocks(t),1)-0.5); %#ok
end

%% Construct oracles
% Generate oracles to be used in the algorithms
[ relDist , stogradf, stogradfBatch, gradf, proxg, lmoX, projX ] = Oracles( v, [10,50,100,200] );
Sigma = v*v';
beta2 = norm(Sigma(:),1);
clearvars Sigma

% Error measures to be used
errFncs = {};
errFncs{end+1} = 'relDist';
errFncs{end+1} = relDist;
errFncs{end+1} = 'feasGap';
errFncs{end+1} = @(x) max(norm(x(:),1)-beta2,0)/beta2;

%% Parameter choices

x0 = zeros(dataSize); % initial point for algorithms
maxit = 1e5; % maximum number of iterations
beta0 = 1; % algorithm parameter for smoothing

%% Create te results folder if missing
if ~exist('results','dir'), mkdir results; end

%% HCGM with 10 samples
[~,info] = HCGM( gradf{1}, lmoX, proxg, beta0, x0, ...
    'maxitr', maxit, 'errfncs', errFncs, 'printfrequency', 100); %#ok
save('results/HCGM_N10','info','-v7.3');

%% HCGM with 50 samples
[~,info] = HCGM( gradf{2}, lmoX, proxg, beta0, x0, ...
    'maxitr', maxit, 'errfncs', errFncs, 'printfrequency', 100); %#ok
save('results/HCGM_N50','info','-v7.3');

%% HCGM with 100 samples
[~,info] = HCGM( gradf{3}, lmoX, proxg, beta0, x0, ...
    'maxitr', maxit, 'errfncs', errFncs, 'printfrequency', 100); %#ok
save('results/HCGM_N100','info','-v7.3');

%% HCGM with 200 samples
[~,info] = HCGM( gradf{4}, lmoX, proxg, beta0, x0, ...
    'maxitr', maxit, 'errfncs', errFncs, 'printfrequency', 100); %#ok
save('results/HCGM_N200','info','-v7.3');

%% SHCGM with 1 sample at each iteration
[~,info] = SHCGM( stogradf, lmoX, proxg, beta0, x0, ...
    'maxitr', maxit, 'errfncs', errFncs, 'printfrequency', 100); %#ok
save('results/StoCGM','info','-v7.3');

%% SHCGM with 200 samples at each iteration
[~,info] = SHCGM( stogradfBatch{4}, lmoX, proxg, beta0, x0, ...
    'maxitr', maxit, 'errfncs', errFncs, 'printfrequency', 100);
save('results/StoCGM_N200','info','-v7.3');

%% Last edit: 24 October 2019 - Alp Yurtsever