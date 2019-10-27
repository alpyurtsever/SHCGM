%% Description
% This script generates the plots for Figure 5 in [Ref].
% You need to run the test file TESTMOVIELENS1M first, before this script.
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Close open figures and clear the workspace
close all;
clearvars;

%% Load the results and prepare the error vectors
load('results/1m-results.mat');

%% Open a figure
hfig = figure('Position',[100,100,800,230]);
set(hfig,'name','MatrixCompletion-MovieLens1m','NumberTitle','off');

%% Subfigure 1
subplot(121)

hold off;
hl1 = loglog(infoSHCGM.time/60,infoSHCGM.rmse_train,'k','LineWidth',2); % divide time by 60 to get minutes
hold on;
hl2 = loglog(infoS3CCM.time/60,infoS3CCM.rmse_train,'r','LineWidth',2); % divide time by 60 to get minutes

xlabel('time (min)','Interpreter','latex');
ylabel('Train RMSE','Interpreter','latex');
axis tight;

ax = gca;
ax.YTick = 10.^(-10:10);

%% Legend
hl = legend([hl2,hl1], 'S3CCM','SHCGM');
hl.Location = 'SouthWest';
hl.FontSize = 18;
hl.Interpreter = 'latex';

%% Subfigure 2
subplot(122)

hold off;
loglog(infoSHCGM.time/60,infoSHCGM.rmse_test,'k','LineWidth',2); % divide time by 60 to get minutes
hold on;
loglog(infoS3CCM.time/60,infoS3CCM.rmse_test,'r','LineWidth',2); % divide time by 60 to get minutes

xlabel('time (min)','Interpreter','latex');
ylabel('Test RMSE','Interpreter','latex');
axis tight;

%% General properties
for t = 1:2
    subplot(1,2,t)
    set(gca,'TickLabelInterpreter','latex',...
        'FontSize',18,...
        'TickDir','out',...
        'LineWidth',1,'TickLength',[0.02 0.02]);
    grid on; grid minor; grid minor;
    box on
    ax = gca;
    ax.XTick = 10.^(-10:10);
end

%% Final notes

fprintf('In the given time, S3CCM performs %d iterations, whereas SHCGM gets %d.\n',length(infoS3CCM.rmse_test),length(infoSHCGM.rmse_test));

%% Last edit: 24 October 2019 - Alp Yurtsever - alp.yurtsever@epfl.ch