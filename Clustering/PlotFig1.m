%% Description
% This script generates the plots for Figure 1 in [Ref].
% You need to run the test files TESTSHCGM and TESTHCGM first, before this
% script.
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Preamble
close all;
clearvars;
if exist('./kmeans_sdp','dir'), addpath('kmeans_sdp'); else, error('Please run DOWNLOADDATA script first.'); end
rng(0,'twister');

%% The following code gives the ground truth XX
% FILENAME='./kmeans_sdp/data/data_features.mat';
% [digits,labels]=get_data(FILENAME);
% digits = double(digits);
% k=max(labels);
% N=size(labels,1);
% Points = digits';
% D = squareform(pdist(Points)).^2;
% XX=kmeans_sdp(digits, k);
% optval = trace(D*XX)
optval = 77.206632951040206; % Code above gives this value
% You need to install "SDPNAL+ v1.0" if you want to run the code above
% https://github.com/intellhave/SDRSAC/tree/master/solvers/SDPNAL%2Bv1.0

%% Load the saved results
SHCGM = load('results/SHCGM.mat');
HCGM = load('results/HCGM.mat');

%% Create Fig1
hfig1 = figure('Position',[0,400,1400,310]);
set(hfig1,'name','Clustering-iteration','NumberTitle','off');

%% Figure 1 Subplot 1
subplot(131)
h1 = loglog(abs(SHCGM.output.objective - optval)/optval,'k','LineWidth',2);
hold on;
h2 = loglog(abs(HCGM.output.objective - optval)/optval,'r','LineWidth',2);
axis tight
xlim([1,1e6])
ylim([2e-3,2e2])
grid on
ax = gca;
ax.XTick = 10.^(-10:10);
ax.YTick = 10.^(-10:10);
ax.FontSize = 18;
set(gca,'TickLabelInterpreter','latex')
grid minor; grid minor;

xlabel('iteration','Fontsize',20,'Interpreter','latex');
ylabel('$| \langle D, X - X^\star \rangle | / | \langle D, X^\star \rangle |$','Fontsize',20,'Interpreter','latex')

set(gca,'TickDir','out')
set(gca,'LineWidth',1,'TickLength',[0.02 0.02]);

% Legend
hl = legend([h2,h1], 'HCGM','SHCGM');
hl.Interpreter = 'latex';
hl.FontSize = 23;
hl.Location = 'SouthWest';

%% Figure 1 Subplot 2
subplot(132)
loglog(SHCGM.output.feasibility1 ,'LineWidth',2,'color','k');
hold on
loglog(HCGM.output.feasibility1 ,'LineWidth',2,'color','r');

axis tight
xlim([1,1e6])
grid on; grid minor; grid minor;
ax = gca;
ax.XTick = 10.^(-10:10);
ax.YTick = 10.^(-10:10);
ax.FontSize = 18;
set(gca,'TickLabelInterpreter','latex')

xlabel('iteration','Fontsize',20,'Interpreter','latex');
ylabel('$\| X 1_n - 1_n\|/\|1_n\|$','Fontsize',20,'Interpreter','latex')

set(gca,'TickDir','out')
set(gca,'LineWidth',1,'TickLength',[0.02 0.02]);

%% Figure 1 Subplot 3
subplot(133)

loglog(SHCGM.output.feasibility2 ,'LineWidth',2,'color','k');
hold on
loglog(HCGM.output.feasibility2 ,'LineWidth',2,'color','r');

axis tight
xlim([1,1e6])
grid on; grid minor; grid minor;
ax = gca;
ax.XTick = 10.^(-10:10);
ax.YTick = 10.^(-10:10);
ax.FontSize = 18;
set(gca,'TickLabelInterpreter','latex')

xlabel('iteration','Fontsize',20,'Interpreter','latex')
ylabel('$\|X - \mathrm{proj}_{X \geq 0}(X)\|_F$','Fontsize',20,'Interpreter','latex')

set(gca,'TickDir','out')
set(gca,'LineWidth',1,'TickLength',[0.02 0.02]);

%% Create Fig2
hfig1 = figure('Position',[0,0,1400,310]);
set(hfig1,'name','Clustering-epoch','NumberTitle','off');
epoch = (1:length(SHCGM.output.objective))'/100;

%% Figure 2 Subplot 1
subplot(131)
loglog(epoch,abs(SHCGM.output.objective - optval)/optval,'k','LineWidth',2);
hold on;
loglog(abs(HCGM.output.objective - optval)/optval,'r','LineWidth',2);
axis tight
xlim([1e-2,1e6])
ylim([2e-3,2e2])
grid on
ax = gca;
ax.XTick = 10.^(-10:10);
ax.YTick = 10.^(-10:10);
ax.FontSize = 18;
set(gca,'TickLabelInterpreter','latex')
grid minor; grid minor;

xlabel('epoch','Fontsize',20,'Interpreter','latex');
ylabel('$| \langle D, X - X^\star \rangle | / | \langle D, X^\star \rangle |$','Fontsize',20,'Interpreter','latex')

set(gca,'TickDir','out')
set(gca,'LineWidth',1,'TickLength',[0.02 0.02]);

%% Figure 2 Subplot 2
subplot(132)
loglog(epoch,SHCGM.output.feasibility1 ,'LineWidth',2,'color','k');
hold on
loglog(HCGM.output.feasibility1 ,'LineWidth',2,'color','r');

axis tight
xlim([1e-2,1e6])
grid on; grid minor; grid minor;
ax = gca;
ax.XTick = 10.^(-10:10);
ax.YTick = 10.^(-10:10);
ax.FontSize = 18;
set(gca,'TickLabelInterpreter','latex')

xlabel('epoch','Fontsize',20,'Interpreter','latex');
ylabel('$\| X 1_n - 1_n\|/\|1_n\|$','Fontsize',20,'Interpreter','latex')

set(gca,'TickDir','out')
set(gca,'LineWidth',1,'TickLength',[0.02 0.02]);

%% Figure 2 Subplot 3
subplot(133)

loglog(epoch,SHCGM.output.feasibility2 ,'LineWidth',2,'color','k');
hold on
loglog(HCGM.output.feasibility2 ,'LineWidth',2,'color','r');

axis tight
xlim([1e-2,1e6])
grid on; grid minor; grid minor;
ax = gca;
ax.XTick = 10.^(-10:10);
ax.YTick = 10.^(-10:10);
ax.FontSize = 18;
set(gca,'TickLabelInterpreter','latex')

xlabel('epoch','Fontsize',20,'Interpreter','latex')
ylabel('$\|X - \mathrm{proj}_{X \geq 0}(X)\|_F$','Fontsize',20,'Interpreter','latex')

set(gca,'TickDir','out')
set(gca,'LineWidth',1,'TickLength',[0.02 0.02]);

%% Last edit: 24 October 2019 - Alp Yurtsever
