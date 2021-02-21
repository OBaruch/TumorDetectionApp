function ImfinalF=braintumordetector(Im)
% PROYECTO DE VISI�N ROB�TICA.
% DETECCI�N DE TUMORES CEREBRALES MEDIANTE PROCESAMIENTO DE IM�GENES.
% EQUIPO INTEGRADO POR:
% JOS� MANUEL BARAJAS RAM�REZ Y OMAR BARUCH MOR�N L�PEZ.

% Proceso de entrada de imagen de resonancia mang�tica.

% Conversi�n de la imagen a escala de grises.
Im1=Im

% Preprocesamiento de la imagen en escala de grises aplicando un filtro de
% mediana.
% Declaraci�n de la m�scara del filtro de mediana.
H=ones(3)*(1/9);
% Aplicaci�n del filtro de mediana a la imagen en escala de grises.
Im2=imfilter(Im1,H);

% Proceso de segmentaci�n de la imagen en escala de grises filtrada mediante el m�todo de Otsu.
% Establecimiento del umbral de la imagen.
umbral=0.7; 
% Binarizaci�n de la imagen a trav�s del umbral (lo que est� por encima del
% umbral ser� blanco y lo que est� por debajo ser� negro).
Im3=imbinarize(Im1,0.7);

% Obtenci�n de la imagen del �rea del tumor.
etiqueta=bwlabel(Im3);
superficie=regionprops(etiqueta,'Solidity','Area');
densidad=[superficie.Solidity];
area=[superficie.Area];
area_alta_densidad=densidad>0.5;
maxima_area=max(area(area_alta_densidad));
etiqueta_tumor=find(area==maxima_area);
tumor=ismember(etiqueta,etiqueta_tumor);

% Elemento estructurante morfol�gico del tumor.
om=strel('square',5);
tumor=imdilate(tumor,om);

% Obtenci�n del contorno del tumor para aplicarlo a la imagen original.
[B,L]=bwboundaries(tumor,'noholes');
imshow(label2rgb(L, @jet, [1,0,0]));
hold on;
imshow(Im1);
contorno=B{:};
plot(contorno(:,2),contorno(:,1),'r','LineWidth',2);

% % Obtenci�n de la imagen final.
ImfinalF=getframe(gca);
% imwrite(Imfinal.cdata,'braintumordetected.jpg');
% ruta=which('braintumordetected.jpg');
% ImfinalF=imread(ruta);
end