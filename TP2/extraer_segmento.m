function [segmento_suavizado, fs] = extraer_segmento(senal, fs, duracion_segmento)
% Calcular la cantidad de muestras necesarias para duracion_segmento (0.03
% s)
muestras_deseadas = round(duracion_segmento * fs);

% Encontrar el punto central de la señal
punto_central = round(length(senal) / 2);

% Definir el rango de muestras para extraer el segmento
inicio = max(punto_central - muestras_deseadas / 2, 1);
fin = min(punto_central + muestras_deseadas / 2, length(senal));

% Extraer el segmento de 30 ms centrado en la mitad
segmento = senal(inicio:fin);

% Aplicar la ventana de Hamming para suavizar
ventana_hamming = hamming(length(segmento));
segmento_suavizado = segmento .* ventana_hamming;
end