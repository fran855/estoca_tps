clear all;
close all;
clc;

% Para cada audio dividir la señal con ventanas de 30 ms de duración
% suavizadas con una ventana de hamming, considerando un solapamiento del
% 50% entre segmentos
[audio, fs] = audioread('audios/audio_a.wav');
cantidad_muestras = length(audio);

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
T0 = 1/f0;
N = ceil(0.03*fs);
N0 = T0 * fs;

% Inicializar el tren de impulsos
u = zeros(1, N);
 
% Generar el tren de impulsos
for n = 1:N
    if mod(n, N0) == 0
        u(n) = 1;
    end
end
u(1) = 1;

% Inicializar el vector total
reconstruccion = zeros(1, cantidad_muestras);
longitud_segmento = N;
solapamiento = longitud_segmento / 2;
nro_segmento = 0;
[filas, columnas] = size(coeficientes);

for i = 1 : columnas
    % Inicializo el segmento reconstruido x(n)
    x = zeros(1, length(u));
    
    % Superponer y sumar los segmentos
    inicio = nro_segmento*solapamiento + 1;
    fin = inicio + longitud_segmento - 1;
    x(1:P) = audio(1:P);
    % Recorre el tiempo n para la reconstrucción
    for n = P+1:N % Comenzar en 1
        sumatoria = 0;
        for k = 1:P
            sumatoria = sumatoria + coeficientes(k, i) * x(n - k);
        end
        x(n) = sumatoria + ganancias(i) * u(n);
    end
    
    reconstruccion(inicio:fin) = reconstruccion(inicio:fin) + x;
    nro_segmento = nro_segmento + 1;
end

% Nombre del archivo de salida
nombreArchivo = 'miAudio.wav';
% Guardar el vector como archivo de audio
reconstruccion_2 = reconstruccion/(10*rms(reconstruccion));
audiowrite(nombreArchivo, reconstruccion_2, fs);

figure(1);
plot(audio);
hold on;
plot(reconstruccion);
