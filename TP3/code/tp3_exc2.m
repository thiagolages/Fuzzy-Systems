clear all;
close all;
clc;
 
data = load('mg.mat');
data = data.x;
N = size(data,1);

%XX = repmat(1:1:N,4,1)';
Y = data(:,1);

% parar (19+6) numeros antes. 19 por conta do primeiro item (i-18), e
% 6 por conta da previsao em y(i+6);
X = zeros(N-(19+6),1);
for i=(1+18):(N-6)
    X(i-18,1) = data(i-18,1);
    X(i-18,2) = data(i-12,1);
    X(i-18,3) = data(i-6, 1);
    X(i-18,4) = data(i-0, 1);
    Yd(i-18,1)= data(i+6, 1);
end

% separate data into training and test sets

numTrain = round(0.8*(N-18-6));
XTrain = X(1:numTrain,:);
YdTrain = Yd(1:numTrain);
XTest = X(numTrain+1:end,:);
YdTest = Yd(numTrain+1:end);

% 1A FIG
figure(1); clf;
hold on;
plot(YdTrain,'r:','LineWidth',4);
plot(size(YdTrain,1):1:size(Y,1)-25,YdTest,'g:','LineWidth',4);
legend('Training Data', 'Test Data')
 
%-----------------------------------------------------------------------
% defining the FIS structure
 
% using genfis1 (grid partition) to generate FIS structure
numMFs = 2;
mfType = char('gbellmf');
fis = genfis1([XTrain YdTrain], numMFs, mfType);

% using FCMeans partition to generate FIS structure
%type = 'sugeno';
%numClusters = 4; % equal to number of rules
%fis = genfis3(XTrain, YdTrain, type, numClusters);
% fis3 = genfis3([XTrain YdTrain], YdTrain, type, numClusters);
%  

% 2A FIG
% Plot the input membership functions before training
figure(2);
[x1,mf1] = plotmf(fis,'input',1);
plot(x1,mf1)
xlabel('input 1 (gaussmf)')

% 3A FIG
% Plot anfis output before training
Ys = evalfis(X,fis);
figure(3);clf;
hold on;
plot(Y(25:end),'g-','LineWidth',2);
%plot(YdTrain,'ro','LineWidth',2);
plot(Ys,'r--','LineWidth',2);
%legend('Real Function', 'Training Data', 'ANFIS Approximation before training');
legend('Real Function', 'ANFIS Approximation before training');

% NOPE
% figure;
% [x1,mf1] = plotmf(fis3,'input',1);
% plot(x1,mf1)
% xlabel('input 1 (gaussmf)')

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

maxIter = 100;
fis = anfis([XTrain YdTrain], fis, maxIter);

%------------------------------------------------------------------------
% Evaluate FIS on Training data 
YsTrain = evalfis(XTrain, fis);
trainErr = immse(YdTrain,YsTrain) % mean squared error
 
%------------------------------------------------------------------------
% Evaluate FIS on Test data 
YsTest = evalfis(XTest, fis);
testErr = immse(YdTest,YsTest) % mean squared error

% Plot anfis output after training
Ys = evalfis(X,fis);
figure(4);
hold on;
XX = size(Y,1);
plot(Y(25:end),'g-','LineWidth',2);
%plot(YdTrain,'ro','LineWidth',2);
%plot((size(YdTrain,1):1:size(Y,1)-25),YdTest','go','LineWidth',2);
plot(Ys,'r--','LineWidth',2);
%legend('Real Function', 'Training Data', 'Test Data', 'ANFIS Approximation');
legend('Real Function', 'ANFIS Approximation');

% PLOT CORRETO
% plot(Ys,'b','LineWidth',2);
% plot(Y(25:end),'r--','LineWidth',2);
% legend('Real Function', 'ANFIS Approximation');

% 4A FIG
% Plot the input membership functions after training
figure(5);
[x1,mf1] = plotmf(fis,'input',1);
plot(x1,mf1)
xlabel('input 1 (gaussmf)')
