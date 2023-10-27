function u = entrada_u(frecuencia, N, fs)
    if frecuencia > 0
        f0 = frecuencia;
        T0 = 1/f0;
        N0 = T0 * fs;

        % Inicializar el tren de impulsos
        u = zeros(1, N);
 
        % Generar el tren de impulsos
        for n = 1:N
            if mod(n, N0) == 0
                u(n) = 1;
            end
        end
        u(1) = 1;
    else
        u = randn(1, N);
    end
end

