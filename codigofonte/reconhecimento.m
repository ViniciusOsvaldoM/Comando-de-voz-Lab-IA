% Script 3: reconhecimento.m — Menu interativo com MFCC
clear; clc;

% Carrega a rede treinada
modeloPath = 'C:\Users\Familia Guimarães\Documents\comandodevoz\bancodedados\audios\modelo\redeComandoVoz.mat';
load(modeloPath, 'trainedNet');

fs = 44100;  % taxa de amostragem
duracao = 2; % duração da gravação

while true
    disp('----------------------------------------');
    disp(' MENU DE COMANDO DE VOZ');
    disp('----------------------------------------');
    disp('Digite 1 para falar o comando');
    disp('Digite 0 para desligar o comando de voz');
    escolha = input('Escolha: ');

    if escolha == 1
        % Gravação do comando
        disp('🎙️ Fale agora o comando...');
        recObj = audiorecorder(fs, 16, 1);
        recordblocking(recObj, duracao);
        audioData = getaudiodata(recObj);
        audiowrite('teste.wav', audioData, fs);

        % Extração dos MFCCs
        [audioData, fs] = audioread('teste.wav');
        mfccTeste = mean(mfcc(audioData, fs));  % vetor 1x13

        % Classificação
        label = classify(trainedNet, mfccTeste);
        disp(['🔍 Comando reconhecido: ', char(label)]);

        % Simulação de ação
        switch char(label)
            case 'ligar'
                disp('💡 A lâmpada foi acesa.');
            case 'desligar'
                disp('💡 A lâmpada foi apagada.');
            otherwise
                disp('❓ Comando não reconhecido.');
        end

    elseif escolha == 0
        disp('🛑 Comando de voz desligado. Encerrando...');
        break;

    else
        disp('⚠️ Opção inválida. Digite 1 ou 0.');
    end
end