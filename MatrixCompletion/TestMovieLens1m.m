%% Description
% This script implements the matrix completion experiment with MovieLens 1m
% dataset. Make sure that you download the dataset by running DOWNLOADDATA
% script before this test. This file will save the results under the
% results folder. Run PLOTFIG5 to generate the plots in Figure 5 from
% [Ref].
%
% Note: The results of this experiment depends on the computational power
% of your system, and the figures might look slightly different than the
% ones in the paper. 
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Fix the seed for reproducability
rng(0,'twister');

%% Load data
data = dlmread('data/ml-1m/ratings.dat');
data = data(:,[1,3,5]);
d = size(data,1);

prc_train = 0.8;
d_train = round(d*prc_train); % number of ratings to be used in train
rp = randperm(d); 

Atrain = data(rp(1:d_train),:);
Atest = data(rp(d_train+1:end),:);
clearvars data

UserID = Atrain(:,1);
MovID = Atrain(:,2);
Rating = Atrain(:,3);
UserID_test = Atest(:,1);
MovID_test = Atest(:,2);
Rating_test = Atest(:,3);
clearvars Atest Atrain

nU = max(UserID);       % # Users (Careful: will be overwritten below!)
nM = max(MovID);        % # Movies (Careful: will be overwritten below!)
nR = length(UserID);    % # Ratings (Careful: will be overwritten below!)

%% A basic preprocessing 
% Clear movies and users without rating in the train dataset (Clear all zero rows and columns)
A = sparse(MovID,UserID,Rating,nM,nU);
rDel = ~any(A,2);
cDel = ~any(A,1);
A( rDel, : ) = [];  %rows
A( :, cDel ) = [];  %columns
[MovID,UserID] = find(A);
clearvars A
A = sparse(MovID_test,UserID_test,Rating_test,nM,nU);
A( rDel, : ) = [];  %rows
A( :, cDel ) = [];  %columns
[MovID_test,UserID_test,Rating_test] = find(A);
nU = max(UserID);   % # Users
nM = max(MovID);    % # Movies
clearvars A rDel cDel

%% Parameter choices

numberSample = 10000; % number of ratings to be used at each iteration
beta1 = 20000; % problem parameter for domain diamater
beta0 = 10; % algorithm parameter for smoothing
gamma = 1; % algorithm parameter (gamma < 2/Lf, where Lf is the smoothness parameter) - default is 1
x0 = zeros(nM,nU); % initial point for algorithms
stoptime = 60*60*2; % 2 hours of time limit for both methods

%% Construct oracles
% Generate oracles to be used in the algorithms
[ rmse_train, rmse_test, gradf, projBox, lmoX, projX ] = ...
    Oracles( numberSample,MovID,UserID,Rating,MovID_test,UserID_test,Rating_test,beta1 );

% Error measures to be used
errFncs = {};
errFncs{end+1} = 'rmse_train'; 
errFncs{end+1} = rmse_train; 
errFncs{end+1} = 'rmse_test';
errFncs{end+1} = rmse_test; 
errFncs{end+1} = 'feasGap'; 
errFncs{end+1} = @(x) norm(x - projBox(x),'fro');

%% Run SHCGM
[ ~, infoSHCGM ] = SHCGM( gradf, lmoX, projBox, beta0, x0, ...
    'maxitr', 1e5, 'errfncs', errFncs, 'printfrequency', 100, 'stoptime', stoptime );

%% Run S3CCM
[ ~, infoS3CCM ] = S3CCM( gradf, projBox, projX, gamma, x0, ...
    'maxitr', 1e5, 'errfncs', errFncs, 'printfrequency', 10, 'stoptime', stoptime );

%% Save results
if ~exist('results','dir'), mkdir results; end
save('results/1m-results.mat',...
    'infoSHCGM','infoS3CCM','-v7.3');

%% Last edit: 24 October 2019 - Alp Yurtsever