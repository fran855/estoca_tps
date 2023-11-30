%% Definir el proceso s(n) de largo N = 2000 de acuerdo a la ecuación dada, con r(n) ruido blanco gaussiano de media nula y varianza 5e-4

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

%% Definir g(t) = A sin(2 pi f0 t + phi)
f0 = 500;
fs = 44100;
t = (0:N-1) / fs;
% Variables aleatorias
A = 0.1 + 0.003 * randn();
phi = 2*pi*rand();

g = A * sin(2*pi*f0*t + phi);

%% Definir la señal x = s + g
x = s + g;

%% Defina una secuencia vectorial que utilice sin(ω0n) y cos(ω0n) como entradas del filtro.

% A sen(wt + phi)= B sen(wt) + C cos(wt) con B = A cos(phi) y C = A sen(phi)
B = A * cos(phi);
C = A * sin(phi);

entrada = [sin(2*pi*f0*t); cos(2*pi*f0*t)];
% g = B * u(1, :) + C * u(2, :);