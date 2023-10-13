clear all;
close all;
clc;

% Para cada audio, considerar un único segmento de 30 ms de duración
% centrado en la mitad de la señal y suavisado por una ventana de Hamming
duracion_segmento = 0.03;
[segmento_01, fs_01] = extraer_segmento('audios/audio_01.wav', duracion_segmento);
[segmento_02, fs_02] = extraer_segmento('audios/audio_02.wav', duracion_segmento);
[segmento_03, fs_03] = extraer_segmento('audios/audio_03.wav', duracion_segmento);
[segmento_04, fs_04] = extraer_segmento('audios/audio_04.wav', duracion_segmento);
[segmento_a, fs_a] = extraer_segmento('audios/audio_a.wav', duracion_segmento);
[segmento_e, fs_e] = extraer_segmento('audios/audio_e.wav', duracion_segmento);
[segmento_s, fs_s] = extraer_segmento('audios/audio_s.wav', duracion_segmento);
[segmento_sh, fs_sh] = extraer_segmento('audios/audio_sh.wav', duracion_segmento);

% Para cada audio, estimar todos los parámetros LPC suponiendo órdenes P =
% {5, 10, 30}

P = 5;
[a_01, G_01] = param_lpc(segmento_01, P);
[a_02, G_02] = param_lpc(segmento_02, P);
[a_03, G_03] = param_lpc(segmento_03, P);
[a_04, G_04] = param_lpc(segmento_04, P);
[a_a, G_a] = param_lpc(segmento_a, P);
[a_e, G_e] = param_lpc(segmento_e, P);
[a_s, G_s] = param_lpc(segmento_s, P);
[a_sh, G_sh] = param_lpc(segmento_sh, P);

% Para cada audio, determinar la PSD modelada con los parámetros estimados,
% suponiendo w en (0, pi)
[S_01, w_01] = modelar_psd(a_01, G_01, round(2*pi*fs_01));
[S_02, w_02] = modelar_psd(a_02, G_02, round(2*pi*fs_02));
[S_03, w_03] = modelar_psd(a_03, G_03, round(2*pi*fs_03));
[S_04, w_04] = modelar_psd(a_04, G_04, round(2*pi*fs_04));
[S_a, w_a] = modelar_psd(a_a, G_a, round(2*pi*fs_a));
[S_e, w_e] = modelar_psd(a_e, G_e, round(2*pi*fs_e));
[S_s, w_s] = modelar_psd(a_s, G_s, round(2*pi*fs_s));
[S_sh, w_sh] = modelar_psd(a_sh, G_sh, round(2*pi*fs_sh));

% Graficar la respuesta temporal de los audio utilizados
figure();

subplot(2,1,1)
audio_01 = audioread('audios/audio_01.wav');
t1 = linspace(0, length(audio_01)/fs_01, length(audio_01));
plot(t1, audio_01);

[inicio_01, fin_01] = extraer_limites(audio_01, fs_01, duracion_segmento);
t2 = linspace(inicio_01, fin_01, length(segmento_01));
subplot(2,1,2)
plot(t2, segmento_02);

% Graficar la estimación de su autocorrelación
% ??????

% Graficar su PSD (dB) modelada superpuesta al periodograma
figure();

plot(w_01, 20*log10(S_01));
%hold on;

figure();
N = length(w_01);
Pxx = 1/N * abs(fft(audio_01, N)) .^ 2;
Pxx = Pxx(1:ceil(length(Pxx)/2));
plot(20*log10(Pxx));

%legend('Modelada', 'Periodograma');