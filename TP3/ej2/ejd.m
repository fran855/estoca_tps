run ejb.m
clear A B C i j media_ruido phi r varianza_ruido varianza_s

% Parámetros
mu = [1e-3 2e-3 3e-3 4e-3 5e-3];
M = 2;
omega0 = 2 * pi * f0;

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

stem(E)