function escala = generador_escala(frecuencias)
  
    sonoro = find(frecuencias > 0);
    escala = frecuencias;
    auxiliar = linspace(80, 400, length(sonoro));
    
    for i = 1 : length(sonoro)
        escala(sonoro(i)) = auxiliar(i);
    end

end

