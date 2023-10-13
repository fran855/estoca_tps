function [inicio, fin] = extraer_limites(senal, fs, duracion_deseada)
    muestras_deseadas = round(duracion_deseada * fs);
    punto_central = round(length(senal) / 2);
    inicio = max(punto_central - muestras_deseadas / 2, 1)/fs;
    fin = min(punto_central + muestras_deseadas / 2, length(senal))/fs;
end

