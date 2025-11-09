% Script 2: rede_mfcc.m — Treinamento com MFCCs
clear; clc;

cd('C:\Users\Familia Guimarães\Documents\comandodevoz\bancodedados\audios');
mkdir('modelo');
files = dir('*.wav');

X = [];  % matriz de características
Y = [];  % vetor de rótulos

for k = 1:length(files)
    [audioData, fs] = audioread(files(k).name);
    
    % Extração dos MFCCs
    coeffs = mfcc(audioData, fs);  % matriz N x 13
    mfccMean = mean(coeffs);       % vetor 1 x 13
    
    X = [X; mfccMean];             % acumula os vetores
    nomeArquivo = files(k).name;
    comando = extractBefore(nomeArquivo, '_');
    Y = [Y; string(comando)];
end

% Conversão para tipos adequados
X = double(X);
Y = categorical(Y);

% Divisão em treino e validação
cv = cvpartition(Y, 'HoldOut', 0.2);
XTrain = X(training(cv), :);
YTrain = Y(training(cv));
XVal = X(test(cv), :);
YVal = Y(test(cv));

% Definição da rede densa
layers = [
    featureInputLayer(size(XTrain,2))
    fullyConnectedLayer(64)
    reluLayer
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer
];

% Opções de treinamento
options = trainingOptions('adam', ...
    'MaxEpochs', 30, ...
    'MiniBatchSize', 16, ...
    'InitialLearnRate', 1e-3, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', {XVal, YVal}, ...
    'Plots', 'training-progress', ...
    'Verbose', false);

% Treinamento
trainedNet = trainNetwork(XTrain, YTrain, layers, options);

% Salvando o modelo
save(fullfile('modelo', 'redeComandoVoz.mat'), 'trainedNet');

% Teste rápido com um dos áudios
testeAudio = 'ligar_1.wav';
[audioData, fs] = audioread(testeAudio);
mfccTeste = mean(mfcc(audioData, fs));
label = classify(trainedNet, mfccTeste);
disp(['Teste com "', testeAudio, '" → Comando reconhecido: ', char(label)]);