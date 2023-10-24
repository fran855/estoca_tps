function [a, G] = param_lpc(xs, P)
    r = xcorr(xs, 'coeff');
    
    % Seteo el 0 de la autocorrelación a la mitad
    cero = ceil(length(r)/2);
    b = r(cero+1:cero+P);
    R = zeros(P, P);
    for i = 1:P
        for j = 1:P
            R(i, j) = r(cero - i + j);
        end
    end
    
    a = R\b;

    G = sqrt(r(cero) - sum(a .* r(cero+1:cero+P)));
end