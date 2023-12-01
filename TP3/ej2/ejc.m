run ejb.m
clear A B C i j media_ruido phi r varianza_ruido varianza_s

% Parámetros
mu = 1e-3;
M = 2;
omega0 = 2 * pi * f0;

J = zeros(1, N);
E = zeros(1, N);

for m = 1 : 500
    % Generar la señal de interferencia g
    A = 0.1 + sqrt(0.003) * randn();
    phi = rand() * 2 * pi;
    g = A * sin(omega0 * t + phi);

    x = s + g;
    x_hat = [];
    e = [];
    w = [0 0]';

    for n = 1 : N
        x_hat(n) = w' * entrada(:, n);
        e(n) = x(n) - x_hat(n);
        w = w + mu * entrada(:, n) * e(n);
        
        if m == 500
            W(:, n) = w;
        end
    end
   
    E = E + abs(s - e).^2;
    J = J + abs(x_hat - g).^2;
    m
end
E = E/500;
J = J/500;