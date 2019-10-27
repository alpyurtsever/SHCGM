function [ relDist, stogradf, stogradfBatch, gradf, proxg, lmoX, projX ] = Oracles( v, N )
%This function returns the Oracles to be used in the Covariance Matrix 
%Estimation experiment.
%
% [Ref] Locatello, F., Yurtsever, A., Fercoq, O., Cevher, V.
% "Stochastic Conditional Gradient Method for Composite Convex Minimization"
% Advances in Neural Information Processing Systems 32 (NeurIPS 2019).
%
% contact: Alp Yurtsever - alp.yurtsever@epfl.ch

%% Process data
d = size(v,1);
[uu,zz,~] = svd(v);
zz = sparse(zz);
zz = sqrt(zz*zz');
% [U,S]=svd(Sigma);
% sqrtSU=sqrt(S)*U';
sqrtSU = zz*sparse(uu');
clearvars zz uu

Sigma = v*v';
kappa = trace(Sigma);
beta2 = norm(Sigma(:),1);
normSigma = norm(Sigma,'fro');

%% relative Distance to solution
relDist = @(x) norm(x-Sigma,'fro')/normSigma;

%% gradient - stochastic gradient
stogradf = @(x,j) evalStoGradient(x);
function xout = evalStoGradient(x)
    X = randn(1,d)*sqrtSU;
    xout = x - (X'*X);
end

for t = 1:length(N)
    stogradfBatch{t} = @(x,j) evalStoGradientBatch(x,N(t)); %#ok
end
function xout = evalStoGradientBatch(x,Nn)
    X = randn(Nn,d)*sqrtSU;
    xout = x - (X'*X)./Nn;
end

for tt = 1:length(N)
    XN = randn(N(tt),d)*sqrtSU;
    SigmaHatN = (XN'*XN)./N(tt);
    gradf{tt} = @(x) x - SigmaHatN; %#ok
end

%% proximal operator
proxg = @(x,gamma) reshape(projL1norm(x(:),beta2),size(x));

%% linear minimization oracle
% A simple implementation of LMO with the built-in EIGS command. 
% This can be implemented more efficiently.
optsEigs.p = 5;
optsEigs.tol = 1e-6;
lmoX = @(x) evalLmo(x);
function xout = evalLmo(x)
    if d <= 500
        [uLnczs,dLnczs] = eig(x);
        dLnczs = diag(dLnczs);
        [vaMin,inMin] = min(dLnczs);
        if vaMin < 0
            uLnczs = uLnczs(:,inMin);
            uLnczs = sqrt(kappa)*uLnczs;
            xout = uLnczs*uLnczs';
        else
            xout = zeros(d);
        end
    else
        [uLnczs,vaMin] = eigs(x,1,'SA',optsEigs);
        if vaMin < 0
            uLnczs = sqrt(kappa)*uLnczs;
            xout = uLnczs*uLnczs';
        else
            xout = zeros(d);
        end
    end
end

%% projection
projX = @(x,gamma) evalProj(x);
function xout = evalProj(x)
    [USDP,SigmaSDP] = eig((x+x')/2,'vector');
    SigmaSDP = projL1norm(SigmaSDP,kappa);
    SigmaSDP = max(SigmaSDP,0);
    xout = USDP*diag(SigmaSDP)*USDP';
end

end

function xout = projL1norm(x, delta)

    if nargin < 2,     delta = 1; end
    if isempty(delta), delta = 1; end
    
    sx   = sort(abs(nonzeros(x)), 'descend');
    csx  = cumsum(sx);
    nidx = find( csx - (1:numel(sx))'.*[sx(2:end); 0] >= delta ...
         + 2*eps(delta),1);
    if ~isempty(nidx)
        dx   = ( csx(nidx) - delta ) /nidx;
        xout = x.*( 1 - dx./ max(abs(x), dx) );
    else
        xout = x;
    end
    
end

%% Last edit: 24 October 2019 - Alp Yurtsever