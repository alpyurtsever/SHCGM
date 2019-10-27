%% Description
% This script implements the Clustering SDP experiment with SHCGM. Make 
% sure that you download the dataset by running DOWNLOADDATA script before 
% this test. This file will save the results under the results folder. 
% Run PLOTFIG1 to generate the plots in Figure from [Ref].
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Check whether data is downloaded
if exist('./kmeans_sdp','dir'), addpath('kmeans_sdp'); else, error('Please run DOWNLOADDATA script first.'); end

%% Fix the seed for reproducability
rng(0,'twister');

%% Load data and construct the problem
FILENAME='./kmeans_sdp/data/data_features.mat';
[digits,labels]=get_data(FILENAME);
digits = double(digits);
k=max(labels);
N=size(labels,1);
n = N/k;
m = k;
% Construct the low-rank matrix
Points = digits';
D = squareform(pdist(Points)).^2;

%% Apply SHCGM
b = ones(N,1);
norm_b = norm(b);
b2 = ones(1,N);
C = double(D);
A = @(x) sum(x,2);
At = @(y) repmat(y,[1,N]);
A2 = @(x) sum(x,1);
At2 = @(y) repmat(y,[N,1]);

T = 1e6;
beta0 = 10; % tune this
X = zeros(N,N); % initial point
X_bar = X;
AX1_b = zeros(size(b));

output.beta0 = beta0;
output.time = nan(T,1);
output.feasibility1 = nan(T,1);  % Infeasibility in "AX = b"
output.feasibility2 = nan(T,1);  % Infeasibility in "X >= 0"
output.objective = nan(T,1);     % f(X)

OPTS.isreal = 1;
OPTS.tol = 1e-9;
d = zeros(size(X_bar));
number_samples = 100; 

timeClk = 0;
for t = 1:T
    
    clkTimer = tic;
    
    eta = 9/(t+8);
    beta = beta0/sqrt(t+8);
    rho = 4/(t+7)^(2/3);
    
    ind = sort(randperm(size(C,1),number_samples));
    B = zeros(size(C));
    B(ind,ind) = C(ind,ind);
    
    d = (1-rho)*d + rho*B*size(C,1)/number_samples;

    eigsArg = (beta*d + At(A(X) - b) + At2(A2(X) - b2) + 1000*(min(X,0)));
    eigsArg = 0.5*(eigsArg + eigsArg');
    [u,z] = eigs(eigsArg,1,'SA',OPTS);
    OPTS.v0 = u;
    
    u = sqrt(k)*u;
    
    X = (1-eta)*X + eta*(u*u');
    
    timeClk = timeClk + toc(clkTimer);
    
    output.time(t,1) = timeClk;
    output.feasibility1(t,1) = norm(A(X)-b)/norm_b;
    output.feasibility2(t,1) = norm(min(X,0),'fro');
    output.objective(t,1) = C(:)'*X(:);
    
    if ~mod(t,100) || t == 1
        fprintf('\n%5d | %5.4e | %5.4e | %5.4e |\n', ...
            t, output.objective(t,1), output.feasibility1(t,1), ...
            output.feasibility2(t,1));
    end
    
end

%% Save the results
if ~exist('results','dir'), mkdir results; end
save('results/SHCGM.mat','output','-v7.3')

%% Last edit: 24 October 2019 - Alp Yurtsever
