clear all;
close all;
clc;

[audio, fs] = audioread('audios/audio_e.wav');
cantidad_muestras = length(audio);

segmento = extraer_segmento(audio, fs, 0.05);
P = 50;
[a, G] = param_lpc(segmento, P);
[frecuencia, r_norm] = pitch_lpc(segmento, a, 0.2, fs);
plot(r_norm)
