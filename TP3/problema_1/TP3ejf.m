clc;
close all;
clear all;

%-------------------- Carga del Audio ----------------------------------%

ruta_audio = 'Pista_01.wav';

[y, fs] = audioread(ruta_audio);
y = y.';
L = length(y);

var_nueva = 0.0012;
var_actual = var(y); 
factor = sqrt(var_nueva / var_actual);
y = factor * y;

% Reproduce la señal de audio
%sound(y, fs);
%------------------------------------------------------------------------%

%Parametros del ruido blanco r(n)
media = 0;
varianza = 5e-4;
N = L;

%------------------- Implementacion del filtro ---------------------------% 

% Parámetros del filtro LMS
mu = 100; % Tasa de aprendizaje

% Señal de entrada (puede ser tu señal de entrada, por ejemplo, ruido + señal)

% Inicialización de los coeficientes del filtro
M = 50; % Número de coeficientes del filtro
X_hat = zeros(1,N);
err = zeros(1,N);

% Proceso de adaptación del filtro LMS
m = 1;
   
% -------------------- Genero las señales a utilizar ---------------------%
s = zeros(1, N);
s = y;     
var_s = var(s);

SNR = 20;

%Calculo la varianza del ruido para cumplir el SNR fijado
var_v = var_s * 10^(-SNR / 10);

v = normrnd(media, sqrt(var_v), [1, N + 100]); %Genero el ruido v(n)

%Defino la señal  x(n) proveniente del MIC-1
X = s + v(1:N);

%Genero el proceso de entrada del MIC-2
u = zeros(1, N);

%Inicializo vector de coeficientes
w = 5 * ones(1,M);

for n = 3:N + 2
   u(n - 2) = 0.8 *  v(n) + 0.2 * v(n - 1) - 0.1 * v(n - 2);
end


for i = (1:N - M + 1)
    Y_win = flip(u(i : i + M - 1));        
    X_hat(i) = w * Y_win';
    err(i) = X(i + M - 1) -  X_hat(i);
    w = w + mu * Y_win * err(i);   
end
       

%-------------------------------------------------------------------------%
