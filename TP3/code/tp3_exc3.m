%-----------------------------------------------------------------
% This script Illustrates the use of genfis1 and genfis3 for a
% binary classification problem

clear all;
close all;
clc;



%% Problema 1 - Breast Cancer
% load data
% load dataset_2d.mat;
load cancer_dataset.mat
%load iris_dataset.mat

X = cancerInputs';
Yd = cancerTargets';
idx0 = find(Yd(:,1)==1);
idx1 = find(Yd(:,2)==1);
Yd(idx0,1) = 0;
Yd(idx1,1) = 1;
Yd(:,2) = [];

clear cancerInputs;
clear cancerTargets;

% plot data per class (label)
figure;
hold on;
grid on;
idxC1 = find(Yd==1);
XC1 = X(idxC1,:);
YC1 = Yd(idxC1);
idxC2 = find(Yd==0);
XC2 = X(idxC2,:);
YC2 = Yd(idxC2);
plot(XC1(:,1),XC1(:,2),'bo','LineWidth',2);
plot(XC2(:,1),XC2(:,2),'ro','LineWidth',2);


%-----------------------------------------------------------------------
% fis = genfis1(data,numMFs,inmftype,outmftype)  
% genfis1 generates a single-output Sugeno-type fuzzy inference system 
% using a grid partition on the data.

% Specify the following input membership functions for the generated FIS:
% 4 Gaussian membership functions for the first input variable (x1)
% 4 Gaussian membership functions for the second input variable (x2)
for i=2:5
n = i;
type = 'gaussmf';
numMFs = repmat([n],1,9);
mfType = char(type,type,type,type,type,type,type,type,type);

% Generate the FIS
data = [X Yd];  % data = [X1 X2 Yd]
fis1 = genfis1(data, numMFs, mfType);

% Plot the input membership functions. Each input variable has the 
% specified number and type of input membership functions, evenly 
% distributed over their input range.
figure;
title('Before training');
[x1,mf1] = plotmf(fis1,'input',1);
subplot(2,1,1)
plot(x1,mf1)
xlabel('input 1 (gaussmf)')
[x2,mf2] = plotmf(fis1,'input',2);
subplot(2,1,2)
plot(x2,mf2)
xlabel('input 2 (gaussmf)')


%-----------------------------------------------------------------------
% fis = genfis3(Xin,Xout,type,cluster_n) 
% genfis3 generates an FIS using fuzzy c-means (FCM) 
% clustering by extracting a set of rules that models the data behavior. 

type = 'sugeno';
numClusters = n; % equal to number of rules

%Generate a Sugeno-type FIS with 3 rules.
% The input membership function type is 'gaussmf'. By default, 
% the output membership function type is 'linear'. 
fis2 = genfis3(X, Yd, type, numClusters);

% Plot the input membership functions.
figure;
title('After training');
[x1,mf1] = plotmf(fis2,'input',1);
subplot(2,1,1)
plot(x1,mf1)
xlabel('Membership Functions for Input 1')
[x2,mf2] = plotmf(fis2,'input',2);
subplot(2,1,2)
plot(x2,mf2)
xlabel('Membership Functions for Input 2')

% Evaluate FIS on Training data 
Ys = evalfis(X(1:489,:), fis2);
YsOut = Ys >= 0.5;
accuracy = length(find(Yd(1:489)==YsOut))/length(Yd(1:489)); % accuracy 

% [x1,x2] = meshgrid(-1:0.1:2, -0.6:0.1:1.4);
% aux = size(x1);
% SupDec = zeros(aux(1), aux(2));
% for i = 1 : aux(1),
%     for j = 1 : aux(2),
%         Xaux = [x1(i,j) x2(i,j)];
%         Ysaux = evalfis(Xaux, fis2); 
%         SupDec(i,j) = Ysaux; 
%     end;
% end;   

% Plot the decision boundary
% figure;
% hold on;
% grid on;
% idxC1 = find(Yd==1);
% XC1 = X(idxC1,:);
% YC1 = Yd(idxC1);
% idxC2 = find(Yd==0);
% XC2 = X(idxC2,:);
% YC2 = Yd(idxC2);
% plot(XC1(:,1),XC1(:,2),'bo','LineWidth',2);
% plot(XC2(:,1),XC2(:,2),'ro','LineWidth',2);
% mesh(x1, x2, SupDec);

%contour(x1, x2, SupDec, [0.5 0.5], 'LineWidth', 2);




%------------------------------------------------------------------------
% Training ANFIS 
% Training routine for Sugeno-type Fuzzy Inference System 
% [fis,error] = anfis(trnData,initFis,trnOpt)
% trnOpt: a vector of training options. When a training 
% option is entered as NaN, the default options is in force. 
% These options are as follows:
% trnOpt(1): training epoch number (default: 10)
% trnOpt(2): training error goal (default: 0)
% trnOpt(3): initial step size (default: 0.01)
% trnOpt(4): step size decrease rate (default: 0.9)
% trnOpt(5): step size increase rate (default: 1.1)

maxIter = 1000;
[fis2, trainError] = anfis([X(1:489,:) Yd(1:489)], fis2, maxIter);
disp("Terminei ANFIS");
% Evaluate FIS on Training data 
Ys = evalfis(X(1:489,:), fis2);
% YsOut = thfunc(Ys, 0.5); 
YsOut = Ys >= 0.5; 
accuracy = length(find(Yd(1:489)==YsOut))/length(Yd(1:489)) % accuracy
 disp(n); % numero de MFs
 out_acc(i) = accuracy;
 out_n(i) = n;
 
  % Evaluate FIS on TESTING data 
Ys = evalfis(X(490:end,:), fis2);
% YsOut = thfunc(Ys, 0.5); 
YsOut = Ys >= 0.5; 
accuracy = length(find(Yd(490:end)==YsOut))/length(Yd(490:end)); % accuracy
disp(strcat("Testing accuracy = ",num2str(accuracy)));
 
 
 
 figure(10);hold on;
 title(strcat("Train Error with ",num2str(n)," MFs"));
 plot(trainError);
 ylabel("Error");
 xlabel("Step");
end
figure(10);
legend('2 MFs','3 MFs','4 MFs','5 MFs')
% [x1,x2] = meshgrid(-1:0.1:2, -0.6:0.1:1.4);
% aux = size(x1);
% SupDec = zeros(aux(1), aux(2));
% for i = 1 : aux(1),
%     for j = 1 : aux(2),
%         Xaux = [x1(i,j) x2(i,j)];
%         Ysaux = evalfis(Xaux, fis2); 
%         SupDec(i,j) = Ysaux; 
%     end;
% end;   

% Plot the decision boundary
% figure;
% hold on;  
% grid on;
% idxC1 = find(Yd==1);
% XC1 = X(idxC1,:);
% YC1 = Yd(idxC1);
% idxC2 = find(Yd==0);
% XC2 = X(idxC2,:);
% YC2 = Yd(idxC2);
% plot(XC1(:,1),XC1(:,2),'bo','LineWidth',2);
% plot(XC2(:,1),XC2(:,2),'ro','LineWidth',2);
% %mesh(x1, x2, SupDec);
% contour(x1, x2, SupDec, [0.5 0.5], 'LineWidth', 2);


