%% Description
% This script generates the plots for Figure 3 in [Ref].
% You need to run the test file TESTCME first, before this script.
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Preamble
close all;
clearvars;

%% Load results
STO200 = load('results/StoCGM_N200');
HCGM200 = load('results/HCGM_N200');

%% Create figure
hfig = figure('Position',[100,100,800,300]);
set(hfig,'name','streaming-covariance-minibatch','NumberTitle','off');

%% Plot Subfigure 1
subplot(121)
hlc2 = semilogy(STO200.info.relDist.^2,'LineWidth',2,'color','k'); hold on
hlc3 = semilogy(HCGM200.info.relDist.^2,'LineWidth',2,'color','r'); hold on
axis tight
ylabel('$\| X - \Sigma \|^2_F / \|\Sigma\|^2_F$','Interpreter','latex');
xlabel('iteration','Interpreter','latex');
xlim([0,1e5]);
set(gca,'YTick',10.^(-100:100));
set(gca,'TickLabelInterpreter','latex',...
    'FontSize',20,...
    'XTick',0:1e4:1e5,...
    'TickDir','out',...
    'LineWidth',1,'TickLength',[0.02 0.02]);
grid on; grid minor; grid minor;

% Legend
hl = legend([hlc3,hlc2],'HCGM-$200$','SHCGM-$200$'); %,...
hl.Location = 'NorthEast';
hl.FontSize = 20;
hl.Interpreter = 'latex';

%% Plot Subfigure 2
subplot(122)
semilogy(STO200.info.feasGap,'LineWidth',2,'color',hlc2.Color); hold on;
loglog(HCGM200.info.feasGap,'LineWidth',2,'color',hlc3.Color);
axis tight
ylabel('$\max(\|X\|_1 - \beta_2, 0)/\beta_2$','Interpreter','latex');
xlabel('iteration','Interpreter','latex');
xlim([0,1e5]);
set(gca,'YTick',10.^(-100:2:100));
set(gca,'TickLabelInterpreter','latex',...
    'FontSize',20,...
    'XTick',0:1e4:1e5,...
    'TickDir','out',...
    'LineWidth',1,'TickLength',[0.02 0.02]);
grid on; grid minor; grid minor;

%% Last edit: 24 October 2019 - Alp Yurtsever