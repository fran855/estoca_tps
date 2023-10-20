function [segmento, fin_de_audio] = extraer_segmento_n(audio, fs, n)
    % N = 1 == primer segmento
    muestrasSegmento = ceil(0.03 * fs);
    segmento = zeros(muestrasSegmento, 1);
    fin_de_audio = false;
    
    if n == 1
        segmento = audio(1:muestrasSegmento);
    else
        inicio = (n - 1) * muestrasSegmento + 1 - round(0.5 * muestrasSegmento);
        
        if inicio + 2 * muestrasSegmento - 1 > length(audio)
            fin_de_audio = true;
        end
        
        segmento = audio(inicio : inicio + muestrasSegmento - 1);
    end
end

