function ImfinalF=braintumordetector(Im)
% PROYECTO DE VISIÓN ROBÓTICA.
% DETECCIÓN DE TUMORES CEREBRALES MEDIANTE PROCESAMIENTO DE IMÁGENES.
% EQUIPO INTEGRADO POR:
% JOSÉ MANUEL BARAJAS RAMÍREZ Y OMAR BARUCH MORÓN LÓPEZ.

% Proceso de entrada de imagen de resonancia mangética.

% Conversión de la imagen a escala de grises.
Im1=Im

% Preprocesamiento de la imagen en escala de grises aplicando un filtro de
% mediana.
% Declaración de la máscara del filtro de mediana.
H=ones(3)*(1/9);
% Aplicación del filtro de mediana a la imagen en escala de grises.
Im2=imfilter(Im1,H);

% Proceso de segmentación de la imagen en escala de grises filtrada mediante el método de Otsu.
% Establecimiento del umbral de la imagen.
umbral=0.7; 
% Binarización de la imagen a través del umbral (lo que esté por encima del
% umbral será blanco y lo que esté por debajo será negro).
Im3=imbinarize(Im1,0.7);

% Obtención de la imagen del área del tumor.
etiqueta=bwlabel(Im3);
superficie=regionprops(etiqueta,'Solidity','Area');
densidad=[superficie.Solidity];
area=[superficie.Area];
area_alta_densidad=densidad>0.5;
maxima_area=max(area(area_alta_densidad));
etiqueta_tumor=find(area==maxima_area);
tumor=ismember(etiqueta,etiqueta_tumor);

% Elemento estructurante morfológico del tumor.
om=strel('square',5);
tumor=imdilate(tumor,om);

% Obtención del contorno del tumor para aplicarlo a la imagen original.
[B,L]=bwboundaries(tumor,'noholes');
imshow(label2rgb(L, @jet, [1,0,0]));
hold on;
imshow(Im1);
contorno=B{:};
plot(contorno(:,2),contorno(:,1),'r','LineWidth',2);

% % Obtención de la imagen final.
ImfinalF=getframe(gca);
% imwrite(Imfinal.cdata,'braintumordetected.jpg');
% ruta=which('braintumordetected.jpg');
% ImfinalF=imread(ruta);
end