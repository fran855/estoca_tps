function [f0, r_norm] = pitch_lpc(xs, a, alpha, fs)
    aux = [1];
    P = length(a);
    for p = 1 : P
        aux = [aux -a(p)];
    end

    e = filter(aux, 1, xs);
    r = xcorr(e, 'biased');
    r_norm = r/max(r);

    centro = find(r_norm == 1);
    resultado_x = centro;

    % Busco el punto donde paso el pico principal
    while resultado_x < length(r_norm)
        if r_norm(resultado_x) < alpha
            break;
        end
        resultado_x = resultado_x + 1;
    end

    es_sonoro = false;
    % Busco el punto donde comienza el pico secundario
    while resultado_x < length(r_norm)
        if r_norm(resultado_x) > alpha
            es_sonoro = true;
            break;
        end
        resultado_x = resultado_x + 1;
    end

    if es_sonoro
        % Busco el pico secundario
        while resultado_x < length(r_norm)
            if r_norm(resultado_x + 1) < r_norm(resultado_x)
                break;
            end
            resultado_x = resultado_x + 1;
        end

        k_max = resultado_x - centro;
        f0 = fs/k_max;
        fprintf(">>>>Es señal sonora <<<<\n");
    else
        f0 = 0;
        fprintf("Es señal sorda\n");
    end
end

