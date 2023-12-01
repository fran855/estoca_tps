clc;
close all;
clear all;

%Parametros del ruido blanco r(n)
media = 0;
varianza = 5e-4;
N = 20000;

%------------------- Implementacion del filtro ---------------------------% 

% Parámetros del filtro LMS
mu = 50; % Tasa de aprendizaje

% Señal de entrada (puede ser tu señal de entrada, por ejemplo, ruido + señal)

% Inicialización de los coeficientes del filtro
M = 5; % Número de coeficientes del filtro
X_hat = zeros(1,N);
err = zeros(1,N);

% Proceso de adaptación del filtro LMS
m = 1000;
v_err = zeros(1,M);
l = 19500; %Valor a partir del cual consideramos el estacionario

for k = 1: M 
    m_aux = zeros(m, N - k + 1);
    for j = (1:m)
        
        % --------------- Genero las señales a utilizar -----------------%

        %Genero el vector con ruido blanco
        r = normrnd(media, sqrt(varianza), [1, N + 100]);
        s = zeros(1, N);

        %Genero la señal de audio

        for n = 6: N + 5
            s(n - 5) = r(n) + 0.9 * r(n - 1) + 0.5 * r(n - 2) + 0.45 * r(n - 3) + 0.35 * r(n - 4) + 0.25 * r(n - 5);
        end

        %La varianza de s(n) es Var(s(n)) = 5e-4 * (1 + 0.9^2 + 0.5^2 + 0.45^2 + 0.35^2 + 0.25^2) 
        %var_teorica = 5e-4 * (1 + 0.9^2 + 0.5^2 + 0.45^2 + 0.35^2 + 0.25^2);
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
        w = 5 * ones(1,k);

        for n = 3:N + 2
           u(n - 2) = 0.8 *  v(n) + 0.2 * v(n - 1) - 0.1 * v(n - 2);
        end
       
       %Aplico el filtro adaptativo 
        for i = (1:N - k + 1)
            Y_win = flip(u(i : i + k - 1));        
            X_hat(i) = w * Y_win';
            err(i) = X(i + k - 1) -  X_hat(i);
            w = w + mu * Y_win * err(i);   
        end

        %Calculo el error --->s^ - s para cada realizacion
        m_aux(j, :) = err(1: N - k + 1) - s(k : N);
              
    end
    
    %Calculo el error E(n)
    E = zeros(1,N);

    for n = 1 : N - k + 1
        E(n) = mean(m_aux(:,n).^2);
    end
    
    v_err(k) =  mean(E(l:(N - k + 1))); %Obteno el E(inf)
      
    
end

figure(1);
stem(1:M, v_err);
xlabel('$M$', 'Interpreter', 'latex');
ylabel('$\hat{E}(\infty)$', 'Interpreter', 'latex');
saveas(gcf, 'puntoD.png');
