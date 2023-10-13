function [S, w] = modelar_psd(a, G, N)
    P = length(a);
    w = linspace(0, pi, N);
    S = zeros(N, 1);
    
    for j = 1 : N
        aux = 0;
        for k = 1 : P
            aux = aux + a(k) * exp(-k * w(j) * k);
        end
        S(j) = (G/abs(1 - aux))^2;
    end
end