%% Description
% This script downloads the source code for kmeans SDP experiments from 
% Soledad Villar's GitHub page: -https://github.com/solevillar/kmeans_sdp-
% Please read their README files carefully before proceeding. 
% Mixon, D., Villar, S., Ward, R.
% "Clustering subgaussian mixtures by semidefinite programming"
% http://arxiv.org/abs/1602.06612
%
% We use the dataset from this implementation in our experiments. Their
% source code will be saved into the "kmeans_sdp-master" folder. 
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Download the datasets and unzip (if the required files are missing)

fprintf(['You are about to download the source code for kmeans SDP experiments from Soledad Villars GitHub page. \n',... 
    '-https://github.com/solevillar/kmeans_sdp- \n',...
    'Our experiment uses the dataset from their implementation.\n',...
    'Please read their README files carefully before proceeding.\n']);

if ~exist('./kmeans_sdp-master','dir')
    websave('master.zip','https://github.com/solevillar/kmeans_sdp/archive/1cbb36bf40b3ed5b370dcab83ad04903ed1baa2a.zip');
    unzip('master.zip','./');
    delete('master.zip');
    movefile('kmeans_sdp-1cbb36bf40b3ed5b370dcab83ad04903ed1baa2a','kmeans_sdp');
end

fprintf('Data is downloaded and ready for use.\n');

%% Last edit: 24 October 2019 - Alp Yurtsever
