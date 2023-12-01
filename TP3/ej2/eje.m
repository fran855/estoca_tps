clear all;
run ejb.m
clear A B C i j media_ruido phi r varianza_ruido entrada

[audio, fs] = audioread('audios/Pista_01.wav');

%%% Adapto la nueva señal
var_s_anterior = varianza_s;
clear varianza_s;

factor_escala = sqrt(var_s_anterior/var(audio));
s = factor_escala * audio;

% Generar la señal de interferencia g
N = length(s);
A = 0.1 + sqrt(0.003) * randn();
phi = rand() * 2 * pi;
t = (0:N-1) / fs;
omega0 = 2 * pi * 500;
g = A * sin(omega0 * t + phi);

x = s + g';

%%% Aplico LMS con mu = 1e-3

% Parámetros
mu = 1e-3;
M = 2;
w = [0 0]';
entrada = [sin(2*pi*f0*t); cos(2*pi*f0*t)];

for n = 1 : N
    x_hat(n) = w' * entrada(:, n);
    e(n) = x(n) - x_hat(n);
    w = w + mu * entrada(:, n) * e(n);
end

E1 = abs(s - e').^2;


%%% Aplico LMS con el mu elegido
% Parámetros
mu = 3e-3;
M = 2;
w = [0 0]';
entrada = [sin(2*pi*f0*t); cos(2*pi*f0*t)];

for n = 1 : N
    x_hat(n) = w' * entrada(:, n);
    e(n) = x(n) - x_hat(n);
    w = w + mu * entrada(:, n) * e(n);
end

E2 = abs(s - e').^2;

plot(E1(1:1e5));
hold on;
plot(E2(1:1e5));
legend("\mu = 1e-3", "\mu = 3e-3");