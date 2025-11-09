%Reconhecimento de voz com IA no MATLAB
%Controle de uma lâmpada (acender/apagar)
%Uso de técnicas de inteligência artificial

% Define o diretório onde os arquivos serão salvos
cd('C:\Users\Familia Guimarães\Documents\comandodevoz\bancodedados');

% Captura de áudio
labels = ["ligar", "desligar"];
for i = 1:5
    for label = labels
        disp(['Fale o comando: ', label]);
        recObj = audiorecorder(44100, 16, 1);       %44100 hz 16 bits 1 canal mono
        recordblocking(recObj, 2);                  %Grava por 2 segundos
        
        audioData = getaudiodata(recObj);           %Extrai os dados da gravação
        filename = sprintf('%s_%d.wav', label, i);  
        audiowrite(filename, audioData, 44100);     %Salva o áudio em um arquivo .wav
    end
end
%---------------------------------------------------------------------------------------
%Reconhecimento de Voz com IA
%Pre-processamento: Espectrogramas
files = dir('*.wav');
for k = 1:length(files)                                     %varre a pasta com audios gravados
    [audioData, fs] = audioread(files(k).name);             %Lê o arquivo atual na posição K
    [s, f, t] = spectrogram(audioData, 256, 250, 256, fs);  
    img = abs(s);                                                       
    %Matriz com energia de F: vetor de frequencia t:                                                        
    %vetor tempo 256 tamanho da janela FFT                                                        
    %250 sobreposição entre janelas                                                        
    %Fs: taxa de amostragem                                                                                                          
    % Exibe o espectrograma
    %figure;
    %imagesc(t, f, img);
    %axis xy;
    %colormap jet;
    %colorbar;
    %title(['Espectrograma de: ', files(k).name]);

    % Salva como imagem .png

    img = imresize(img, [227 227]); % tamanho para AlexNet ou similar
    imwrite(mat2gray(img), [files(k).name(1:end-4), '.png']);
end
%-------------------------------------------------------------------------------------------
