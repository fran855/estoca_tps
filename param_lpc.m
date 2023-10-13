function [a, G] = param_lpc(xs, P)
    a = zeros(P,1);
    r = xcorr(xs, 'biased');
    
    % Seteo el 0 de la autocorrelación a la mitad
    cero = ceil(length(r)/2);
    
    A = zeros(P, P);
    b = zeros(P, 1);
    for i = 0 : P - 1
        b(i + 1) = r(cero + i);
        for j = 1 : P
            A(i + 1, j) = r(cero + i - j);
        end
    end
    
    a = A\b;
    
    aux = 0;
    for i = 1 : P
        aux = aux + a(i) * r(cero + i);
    end
    
    G = sqrt(r(cero)/aux);
end