clear all;
close all;
clc;

% Para cada audio dividir la señal con ventanas de 30 ms de duración
% suavizadas con una ventana de hamming, considerando un solapamiento del
% 50% entre segmentos
[audio, fs] = audioread('audios/audio_04.wav');
cantidad_muestras = length(audio);

n = 1;
P = 100;
coeficientes = [];
ganancias = [];
frecuencias = [];
fin_de_audio = false;

while fin_de_audio == false
    [segmento, fin_de_audio] = extraer_segmento_n(audio, fs, n, 0.05);
    [a, G] = param_lpc(segmento, P);
    coeficientes = [coeficientes a];
    ganancias = [ganancias G];
    frecuencias = [frecuencias pitch_lpc(segmento, a, 0.2, fs)];
    n = n + 1;
end

% Reconstrucción
% x(n) = \sum_{k=1}^P a_k x(n-k) + G u(n)
% Como el audio es 'a' -> tren de impulsos periódicos u(n) = sum_k
% delta(n-k N0) con f = 200 Hz

N = ceil(0.05 * fs);

% Inicializar el vector total
reconstruccion = zeros(1, cantidad_muestras);
longitud_segmento = N;
solapamiento = longitud_segmento / 2;
nro_segmento = 0;
[filas, columnas] = size(coeficientes);

for i = 1 : columnas
    % Inicializo el segmento reconstruido x(n)
    x = zeros(1, N);
    
    % Superponer y sumar los segmentos
    inicio = nro_segmento * solapamiento + 1;
    fin = inicio + longitud_segmento - 1;
    
    x(1:P) = audio(1+(i-1)*P:i*P);
    
    % Recorre el tiempo n para la reconstrucción
    for n = P+1:N % Comenzar en 1
        sumatoria = 0;
        for k = 1:P
            if (n-k) > 0
                sumatoria = sumatoria + coeficientes(k, i) * x(n - k);
            end
        end
        u = entrada_u(frecuencias(i), N, fs);
        x(n) = sumatoria + ganancias(i) * u(n);
    end
    
    reconstruccion(inicio:fin) = reconstruccion(inicio:fin) + x;
    nro_segmento = nro_segmento + 1;
end

% Nombre del archivo de salida
nombreArchivo = 'pruebas/miAudio.wav';
% Guardar el vector como archivo de audio
reconstruccion2 = reconstruccion/(10*rms(reconstruccion));
audiowrite(nombreArchivo, reconstruccion2, fs);

t = linspace(0, length(audio)/fs, length(audio));
z = figure(1);
plot(t, audio/max(audio) + 1);
hold on;
plot(t, reconstruccion/max(reconstruccion) - 1);
title('Original vs reconstrucción - audio 04');
grid on;
xlabel('t [s]');
legend('Audio', 'Reconstrucción');
saveas(z, 'informe/ej4/audio04.png');
