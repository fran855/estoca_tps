clear all;
[s, fs] = audioread("Pista_01.wav");
N = length(s);

% Generar la señal de interferencia g
f0 = 500;
fs_g = 44100;
t = (0:N-1) / fs_g; % para que se escuche mejor el tono cuando reproduzco con fs

A = 0.1 + sqrt(0.003) * randn();
phi = rand() * 2 * pi;
g = A * sin(2 * pi * f0 * t + phi);

entrada = [sin(2*pi*f0*t); cos(2*pi*f0*t)];

% Generar el ruido blanco v
var_v = var(s)/10^(20/10); % SNR = 10 log10(sigma_s^2/sigma_v^2) = 20 dB
mu_v = 0;
v = normrnd(mu_v, sqrt(var_v), [1, N]);

% Generar la señal de entrada
x = s + v' + g';

% LMS I
mu = 3e-3;
x_hat = [];
e = [];
w = [0 0]';

for n = 1 : N
    x_hat(n) = w' * entrada(:, n);
    e(n) = x(n) - x_hat(n);
    w = w + mu * entrada(:, n) * e(n);
end
s_aux = e;

% LMS II
% En este punto e \approx s + v
u = zeros(1, N);
for n = 3 : N
    u(n - 2) = 0.8 *  v(n) + 0.2 * v(n - 1) - 0.1 * v(n - 2);
end
u(N - 1) = 0;
u(N) = 0;

mu = 50; % Tasa de aprendizaje
M = 3; % Número de coeficientes del filtro
x_hat = zeros(1,N);
e = zeros(1,N);
w = [5 5 5];

for i = (1:N - M + 1)
    y_win = flip(u(i : i + M - 1));        
    x_hat(i) = w * y_win';
    e(i) = s_aux(i + M - 1) -  x_hat(i);
    w = w + mu * y_win * e(i);   
end
s_final = e;

E = abs(s_final' - s).^2;

figure();
plot(t, x);
title("Señal de entrada x = s + g + v");
ylabel("x(t)");
xlabel("t");
grid on;

figure();
plot(t, s_aux);
title("Primera estimación de la señal deseada \hat{s}' \approx s + v");
ylabel("\hat{s}'(t)");
xlabel("t");
grid on;

figure();
plot(t, s_final);
title("Segunda estimación de la señal deseada \hat{s}");
ylabel("\hat{s}'(t)");
xlabel("t");
grid on;

figure();
plot(t, s);
title("Señal original");
ylabel("s(t)");
xlabel("t");
grid on;

figure();
plot(t, s);
hold on;
plot(t, s_final);
title("Señal original vs señal reconstruida");
ylabel("s(t), \hat{s}(t)");
xlabel("t");
legend("Señal original", "Señal reconstruida");
grid on;

figure();
plot(E);
title("Potencia del error total");
ylabel("E(n)");
xlabel("n");
grid on;
