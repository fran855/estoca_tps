run ejb.m
clear i j media_ruido N r SNR v_aux varianza_ruido varianza_s varianza_v

M = 3;
mu = 50;

% Inicialización de coeficientes del filtro
w = [5 5 5];

% Implementación del Filtro LMS
for n = M:length(x)
    x_n = x(n:-1:n-M+1); % Ventana de la señal de observación
    u_n = u(n:-1:n-M+1); % Ventana de la señal de ruido correlacionado
    
    % Estimación de la señal
    x_hat = w * x_n.';
    
    % Error de estimación
    e = x(n) - x_hat;
    
    % Adaptación de los coeficientes del filtro LMS
    w = w + mu * conj(u_n) * e;
end

% Aplicación del Filtro LMS para Estimar la Señal s
s_estimada = zeros(size(s)); % Inicializar la señal estimada

for n = M:length(x)
    x_n = x(n:-1:n-M+1); % Ventana de la señal observada
    
    % Estimación de la señal
    s_estimada(n) = w * x_n.';
end
