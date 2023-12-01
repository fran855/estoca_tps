clear all;
run ejb.m
clear A B C i j media_ruido phi r varianza_ruido varianza_s

% Parámetros
N = 2000;
mu = 1e-3;
M = 2;
omega0 = 2 * pi * f0;

J = zeros(1, N);
E = zeros(1, N);
n_realizaciones = 1000;
for m = 1 : n_realizaciones
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
        
        if m == n_realizaciones
            W(:, n) = w;
        end
    end
   
    E = E + abs(s - e).^2;
    J = J + abs(x_hat - g).^2;
    m
end
E = E/n_realizaciones;
J = J/n_realizaciones;
n = linspace(1, N, N);

figure;
plot(n, J, 'LineWidth', 2);
title(['Curva de aprendizaje J para ', num2str(n_realizaciones), ' realizaciones']);
xlabel('n');
ylabel('J(n)');
grid on;

figure;
plot(n, E, 'LineWidth', 2);
title(['Curva del error E para ', num2str(n_realizaciones), ' realizaciones']);
xlabel('n');
ylabel('E(n)');
grid on;

figure;
plot(n, W(1,:), 'LineWidth', 2);
hold on;
plot(n, W(2,:), 'LineWidth', 2);
title('Coeficientes W del filtro en la última realización');
xlabel('iteración');
ylabel('W(n)');
grid on;
