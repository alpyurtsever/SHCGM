%% Description
% This script generates the plots for Figure 2 in [Ref].
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
STO = load('results/StoCGM');
HCGM10 = load('results/HCGM_N10');
HCGM50 = load('results/HCGM_N50');
HCGM100 = load('results/HCGM_N100');
HCGM200 = load('results/HCGM_N200');

%% Create figure
hfig = figure('Position',[100,100,1450,350]);
set(hfig,'name','streaming-covariance','NumberTitle','off');

%% Plot Subfigure 1
subplot(141)
loglog(STO.info.relDist.^2,'color',[0.1,0.1,0.1],'LineWidth',2); hold on;
loglog(HCGM10.info.relDist.^2,'LineWidth',3);
loglog(HCGM50.info.relDist.^2,'LineWidth',3);
loglog(HCGM100.info.relDist.^2,'LineWidth',3);
loglog(HCGM200.info.relDist.^2,'LineWidth',3);
axis tight
ylabel('$\| X - \Sigma \|^2_F / \|\Sigma\|^2_F$','Interpreter','latex');
xlabel('iteration','Interpreter','latex');

%% Plot Subfigure 2
subplot(142)
loglog(STO.info.feasGap,'color',[0.1,0.1,0.1],'LineWidth',2); hold on;
loglog(HCGM10.info.feasGap,'LineWidth',3);
loglog(HCGM50.info.feasGap,'LineWidth',3);
loglog(HCGM100.info.feasGap,'LineWidth',3);
loglog(HCGM200.info.feasGap,'LineWidth',3);
axis tight
ylabel('$\max(\|X\|_1 - \beta_2, 0)/\beta_2$','Interpreter','latex');
xlabel('iteration','Interpreter','latex');

%% Plot Subfigure 3
subplot(143)
loglog(STO.info.time,STO.info.relDist.^2,'color',[0.1,0.1,0.1],'LineWidth',2); hold on;
loglog(HCGM10.info.time,HCGM10.info.relDist.^2,'LineWidth',3);
loglog(HCGM50.info.time,HCGM50.info.relDist.^2,'LineWidth',3);
loglog(HCGM100.info.time,HCGM100.info.relDist.^2,'LineWidth',3);
loglog(HCGM200.info.time,HCGM200.info.relDist.^2,'LineWidth',3);
axis tight
ylabel('$\| X - \Sigma \|^2_F / \|\Sigma\|^2_F$','Interpreter','latex');
xlabel('time (sec)','Interpreter','latex');

%% Plot Subfigure 4
subplot(144)
loglog(STO.info.time,STO.info.feasGap,'color',[0.1,0.1,0.1],'LineWidth',2); hold on;
loglog(HCGM10.info.time,HCGM10.info.feasGap,'LineWidth',3);
loglog(HCGM50.info.time,HCGM50.info.feasGap,'LineWidth',3);
loglog(HCGM100.info.time,HCGM100.info.feasGap,'LineWidth',3);
loglog(HCGM200.info.time,HCGM200.info.feasGap,'LineWidth',3);
axis tight
ylabel('$\max(\|X\|_1 - \beta_2, 0)/\beta_2$','Interpreter','latex');
xlabel('time (sec)','Interpreter','latex');

% Legend
hl = legend('SHCGM',...
    'HCGM-$10$',...
    'HCGM-$50$',...
    'HCGM-$100$',...
    'HCGM-$200$'); 
hl.Location = 'SouthWest';
hl.FontSize = 20;
hl.Interpreter = 'latex';

%% General properties
for t = 1:4
    subplot(1,4,t)
    set(gca,'TickLabelInterpreter','latex',...
        'FontSize',20,...
        'XTick',10.^(-100:100),...
        'YTick',10.^(-100:100),...
        'TickDir','out',...
        'LineWidth',1,'TickLength',[0.02 0.02]);
    grid on; grid minor; grid minor;
end

%% Last edit: 24 October 2019 - Alp Yurtsever