function [segmento_suavizado, fin_de_audio] = extraer_segmento_n(audio, fs, n, duracion_segmento)
    % N = 1 == primer segmento
    muestrasSegmento = ceil(duracion_segmento * fs);
    fin_de_audio = false;
    
    if n == 1
        segmento = audio(1:muestrasSegmento);
    else
        inicio = (n - 1) * muestrasSegmento/2 + 1;
        
        if inicio + 2 * muestrasSegmento - 1 > length(audio)
            fin_de_audio = true;
        end
        
        segmento = audio(inicio : inicio + muestrasSegmento - 1);
    end
    
    % Aplicar la ventana de Hamming para suavizar
    ventana_hamming = hamming(length(segmento));
    segmento_suavizado = segmento .* ventana_hamming;
end

