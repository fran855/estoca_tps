clear all;
close all;
clc;

[audio, fs] = audioread('audios/audio_a.wav');
% Para cada audio, considerar un único segmento de 30 ms de duración
% centrado en la mitad de la señal y suavisado por una ventana de Hamming
duracion_segmento = 0.03;
[segmento_01, fs_01] = extraer_segmento(audio, fs, duracion_segmento);

% Para cada audio, estimar todos los parámetros LPC suponiendo órdenes P =
% {5, 10, 30}
P = 30;
[a_01, G_01] = param_lpc(segmento_01, P);

% Para cada audio, determinar la PSD modelada con los parámetros estimados,
% suponiendo w en (0, pi)
N = round(pi*fs_01);
[S_01, w_01] = modelar_psd(a_01, G_01, N);
periodograma = 1/N * abs(fft(segmento_01, 2*N)) .^ 2;
periodograma = periodograma(1:ceil(length(periodograma)/2));
periodograma = periodograma/max(periodograma);

%% Gráficos %%
% 1 - Respuesta Temporal Completa y Segmento %
figure(1);
subplot(2,1,1)
title('Rta Temporal - Audio Total');
t1 = linspace(0, length(audio)/fs_01, length(audio));
plot(t1, audio);
subplot(2,1,2)
title('Rta Temporal - Segmento Extraído con ventana de Hamming');
[inicio_01, fin_01] = extraer_limites(audio, fs_01, duracion_segmento);
t2 = linspace(inicio_01, fin_01, length(segmento_01));
plot(t2, segmento_01);


% 2- Graficar la estimación de su autocorrelación
figure(2);
subplot(2, 1, 1);
title('Autocorrelación audio completo');
t1 = linspace(0, length(audio)/fs_01, length(audio));
plot(xcorr(audio));
subplot(2, 1, 2);
title('Autocorrelación segmento extraído');
t2 = linspace(0, length(segmento_01)/fs_01, length(segmento_01));
plot(xcorr(segmento_01));

% 3- Graficar su PSD (dB) modelada superpuesta al periodograma
figure(3);
title('PSD');
plot(10*log10(S_01));
hold on;
plot(10*log10(periodograma), 'r');
legend('Modelada', 'Periodograma');

