% Script 1: main.m — Coleta de comandos de voz
clear; clc;

% Define o diretório onde os arquivos serão salvos
cd('C:\Users\Familia Guimarães\Documents\comandodevoz\bancodedados\audios');

labels = ["ligar", "desligar"];  % comandos
numGravacoes = 50;               % número de amostras por comando
fs = 44100;                      % taxa de amostragem
duracao = 2;                     % duração da gravação em segundos

for i = 1:numGravacoes
    for label = labels
        disp(['Fale o comando: ', label]);
        recObj = audiorecorder(fs, 16, 1);
        recordblocking(recObj, duracao);
        audioData = getaudiodata(recObj);
        filename = sprintf('%s_%d.wav', label, i);
        audiowrite(filename, audioData, fs);
        disp(['Salvo: ', filename]);
    end
end