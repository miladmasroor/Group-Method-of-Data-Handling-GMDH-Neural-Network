clc;
clear;
close all;

%% Load Data

[Inputs, Targets] = glass_dataset();
Targets = Targets(1,:);

nData = size(Inputs,2);
Perm = randperm(nData);

% Train Data
pTrain = 0.9;
nTrainData = round(pTrain*nData);
TrainInd = Perm(1:nTrainData);
TrainInputs = Inputs(:,TrainInd);
TrainTargets = Targets(:,TrainInd);

% Test Data
pTest = 1 - pTrain;
nTestData = nData - nTrainData;
TestInd = Perm(nTrainData+1:end);
TestInputs = Inputs(:,TestInd);
TestTargets = Targets(:,TestInd);

%% Create and Train GMDH Network

params.MaxLayerNeurons = 40;   % Maximum Number of Neurons in a Layer
params.MaxLayers = 10;          % Maximum Number of Layers
params.alpha = 0.6;            % Selection Pressure
params.pTrain = 0.7;           % Train Ratio
gmdh = GMDH(params, TrainInputs, TrainTargets);

%% Evaluate GMDH Network

Outputs = ApplyGMDH(gmdh, Inputs);
Outputs = double(Outputs>=0.5);

TrainOutputs = Outputs(:,TrainInd);
TestOutputs = Outputs(:,TestInd);

%% Show Results

figure;
plotconfusion(TrainTargets, TrainOutputs, 'Train Data', ...
              TestTargets, TestOutputs, 'TestData', ...
              Targets, Outputs, 'All Data');

