% Definir el proceso s(n) de largo N = 2000 de acuerdo a la ecuación dada,
% con r(n) ruido blanco gaussiano de media nula y varianza 5e-4

N = 20000;
media_ruido = 0;
varianza_ruido = 5e-4;

r = sqrt(varianza_ruido) * randn(1, N + 5);
s = zeros(1, N);
for i = 1 : N
    j = i + 5;
    s(i) = r(j) + 0.9 * r(j - 1) + 0.5 * r(j - 2) + 0.45 * r(j - 3) + 0.35 * r(j - 4) + 0.25 * r(j - 5);
end
varianza_s = var(s);

% ------------------------------------------------------------------------
% Definir la señal x(n) proveniente del MIC1 tal que SNR sea 20 dB

v_aux = randn(1, N + 2);
v = v_aux(1:N);
SNR = 20; %dB -> SNR = 10 log10 (varianza_s / varianza_v)
varianza_v = varianza_s/(10^(SNR/10));
v = sqrt(varianza_v) * v;

x = s + v;

% ------------------------------------------------------------------------
% Generar el proceso que represente a u(n), entrada de MIC2, según la
% ecuación dada

u = zeros(1, N);
for i = 1 : N
    j = i + 2;
    u(i) = 0.8 * v_aux(j) + 0.2 * v_aux(j - 1) - 0.1 * v_aux(j - 2);
end
