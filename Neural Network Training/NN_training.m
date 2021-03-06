%% 
%% Funtion name : NN_traing
%% Description  : Conduct training to generate apropriate Neural Network 
%% Input        : Dataset matrix
%%                row: no. of pixcel | column: no. of images
%% Output       : Network variable <net>
%% Compiler     : MATLAB
%% 
%%  
%% Reference    : MathWorks NPRTOOL | MATLAB
%% Modified by  : Bobbi W. Yogatama
%% Date Created : 3 December 2017
%% Institution  : Bandung Institute of Technology
%% 
%% Revision     : 1
%% Note         : 3-hidden-layer Neural Network with 100 neuron for each hidden unit
%%                Using scaled conjugate gradient backpropagation method
%%                Performance parameter is mean squared error(mse)
%% 

% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by NPRTOOL
% Created Tue Nov 21 09:20:50 WIT 2017
%
% This script assumes these variables are defined:
%
%   input - input data.
%   target - target data.

%% dataset input matrix assignment
inputs = input_4545;
targets = target;

%% Create a Pattern Recognition Network
hiddenLayerSize = [100 100 100];
net = patternnet(hiddenLayerSize);

%% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


%% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

%% For help on training function 'trainscg' type: help trainscg
% For a list of all training functions type: help nntrain
net.trainFcn = 'trainscg';  % Scaled conjugate gradient
net.trainParam.lr=0.005;

%% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean squared error

%% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit','plotconfusion'};

%% Train the Network
[net,tr] = train(net,inputs,targets,'useParallel','yes','useGPU','yes','showResources','yes');

%% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)

%% Recalculate Training, Validation and Test Performance
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs)
valPerformance = perform(net,valTargets,outputs)
testPerformance = perform(net,testTargets,outputs)

%% View the Network
view(net)

%% Save the Network
net14classes_3layer100neuron_newdataset = net;
save net14classes_3layer100neuron_newdataset

%% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, plotconfusion(targets,outputs)
%figure, plotroc(targets,outputs)
%figure, ploterrhist(errors)
