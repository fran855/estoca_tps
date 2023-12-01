clear all;

% Parámetros
f0 = 500;
N = 2000;
mu = [1e-3 2e-3 3e-3 4e-3 5e-3];
M = 2;
omega0 = 2 * pi * f0;
fs = 44100;
t = (0:N-1) / fs;

varianza_ruido = 5e-4;

r = sqrt(varianza_ruido) * randn(1, N + 5);
s = zeros(1, N);
for i = 1 : N
    j = i + 5;
    s(i) = r(j) + 0.9 * r(j - 1) + 0.5 * r(j - 2) + 0.45 * r(j - 3) + 0.35 * r(j - 4) + 0.25 * r(j - 5);
end

entrada = [sin(2*pi*f0*t); cos(2*pi*f0*t)];


E = zeros(1, 5);

% Generar la señal de interferencia g
A = 0.1 + sqrt(0.003) * randn();
phi = rand() * 2 * pi;
g = A * sin(omega0 * t + phi);
x = s + g;
    
for m = 1 : 5 
    x_hat = [];
    e = [];
    w = [0 0]';

    for n = 1 : N
        x_hat(n) = w' * entrada(:, n);
        e(n) = x(n) - x_hat(n);
        w = w + mu(m) * entrada(:, n) * e(n);
    end
   
    E_aux = abs(s - e).^2;
    E(m) = mean(E_aux(800:N));
end

figure();
stem(mu, E, 'LineWidth', 1)
grid on;
title('Promedio de las últimas 200 iteraciones de E');
ylabel('E(\infty)');
xlabel('Paso (\mu)');
