%audioread('audio.wav') %lee un archivo de audio
%y = filter(b, a, x) %salida de un sistema LTI de coeficientes $b$ y $a$
%r = xcorr(x) %estima la función de autocorrelación
%win = hann(N) %Genera una ventana de Hanning de largo $N$
%win = hamming(N) %Genera una ventana de Hamming de largo $N$
%max_bool = islocalmax(x) %encuentra máximos locales en la secuencia $x$. Retorna un vector booleano
%max_pos = find(maxbool) %retorna las posiciones de los elementos en True

[audio, Fs] = audioread('audios/audio_a.wav');
%%
duracion_audio = size(audio);
duracion_muestra = 241;
inicio_muestra = floor((duracion_audio(1) - duracion_muestra) / 2);
fin_muestra = inicio_muestra + duracion_muestra;
n = linspace(0,30,duracion_muestra);
plot(audio(inicio_muestra:fin_muestra));

%%
porcion_audio = audio(inicio_muestra:fin_muestra);
win = hamming(duracion_muestra+1);
porcion_audio_suavizado = porcion_audio.*win;
figure();
plot(porcion_audio);
figure()
plot(porcion_audio_suavizado);
%%
P = 5;
[a, G] = param_lpc(porcion_audio_suavizado,P);

%a
%G
cant_freq = 1000;
w = linspace(0, pi, cant_freq); 
Sx = zeros(cant_freq);

for i = 1:cant_freq
    sum_k = 0;
    for k = 1:P
        sum_k = sum_k + a(k) * exp(-1j * w(i) * k);
    end
    Sx(i) = G / abs(1 - sum_k)^2;
end

figure;
plot(w, 10 * log10(Sx));
xlabel('Frecuencia (ω)');
ylabel('Sx(ω)');
title('Espectro de Potencia Sx(ω)');

[Pxx, f] = periodogram(porcion_audio_suavizado, [], [], Fs);
f=2*pi*f/Fs;
hold on;
plot(f, 10 * log10(Pxx));
title('Periodograma (PSD)');
xlabel('Frecuencia (Hz)');
ylabel('Potencia Espectral (dB)');
hold off;

function [a, G] = param_lpc(xs, P)
    R_x = xcorr(xs);  % Autocorrelacion R_x
    P = P+1; % Por indices de matlab que arranca en 1
    
    vector_r = R_x(2:P);
    matriz_R = zeros(P-1, P-1);

    for i = 1:P-1
        for j = i:P-1
            matriz_R(i, j) = R_x(j-i+1);
            matriz_R(j, i) = R_x(j-i+1);
        end
    end
    
    %size(vector_r)
    %size(matriz_R)
    %cond(matriz_R)
    %vector_r
    %matriz_R
    a = inv(matriz_R)*vector_r;
    
    G = sqrt( R_x(1) + vector_r'*a );    
end

