%% Description
% This script downloads MovieLens Datasets from GroupLens Research for the
% matrix completion experiments. Before using the datasets, please read 
% the ters of use of GroupLens Research, included in the README files. 
% If the README files are missing or corrupted, you can find it at 
% "https://grouplens.org/datasets/movielens/"
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Download the datasets and unzip (if the required files are missing)

fprintf(['You are about to download MovieLens datasets from GroupLens Research. \n',... 
    'Please read the terms of use in the README files first.\n']);

if ~exist('./data','dir'), mkdir data; end

if ~exist('./data/ml-1m/ratings.dat','file')
    websave('data/ml-1m.zip','http://files.grouplens.org/datasets/movielens/ml-1m.zip');
    unzip('data/ml-1m.zip','data/');
end

if ~exist('./data/ml-100k/ub.train','file') || ~exist('./data/ml-100k/ub.test','file') 
    websave('data/ml-100k.zip','http://files.grouplens.org/datasets/movielens/ml-100k.zip');
    unzip('data/ml-100k.zip','data/');
end

fprintf('Data is downloaded and ready for use.\n');

%% Last edit: 24 October 2019 - Alp Yurtsever