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
f0 = 200;

t = 0:1/fs:0.03-1/fs; % Tiempo de 0.03 segundo
u = square(2*pi*f0*t); % Tren de pulsos

segmentos = [];
for i = 1 : length(coeficientes)
    % Inicializo el segmento reconstruido x(n)
    x = zeros(1, length(u));

    % Recorre el tiempo n para la reconstrucción
    for n = 1:length(u) % Comenzar en 1
        for k = 1:P
            if n - k > 0
                x(n) = x(n) + coeficientes(k, i) * x(n - k);
            end
        end
        x(n) = x(n) + G * u(n);
    end

    segmentos = [segmentos x];
end

reconstruccion = [];
for i = 1 : length(segmentos)
    reconstruccion = [reconstruccion segmentos(i)];
end

