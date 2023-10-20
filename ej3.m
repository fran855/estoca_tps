clear all;
close all;
clc;

% Para cada audio dividir la señal con ventanas de 30 ms de duración
% suavizadas con una ventana de hamming, considerando un solapamiento del
% 50% entre segmentos
[audio, fs] = audioread('audios/audio_a.wav');
cantidad_muestras = length(audio);

fin = 0;
n = 1;
P = 5;
coeficientes = [];
ganancias = [];
fin_de_audio = false;

while fin_de_audio == false
    [segmento, fin_de_audio] = extraer_segmento_n(audio, fs, n);
    [a, G] = param_lpc(segmento, P);
    coeficientes = [coeficientes a];
    ganancias = [ganancias G];
    n = n + 1;
end
    
% Reconstrucción
% x(n) = \sum_{k=1}^P a_k x(n-k) + G u(n)
% Como el audio es 'a' -> tren de impulsos periódicos u(n) = sum_k
% delta(n-k N0) con f = 200 Hz