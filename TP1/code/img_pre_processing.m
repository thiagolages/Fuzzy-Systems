function [arrayImage] = img_pre_processing(imageNames)

imageNamesCell = cellstr(imageNames);
 
 % obtem a imagem RGB, altera seu tamanho e mostra a imagem original (rows x cols x bands)
 currentImage = strtrim(imageNamesCell{1});   
 rgbImage = im2double(imread(currentImage));   % im2double() - converte pixels para double
 rgbImage = imresize(rgbImage,0.25,'box');
  
 % transforma a imagem (rows x cols x bands) em um array de pixels (rows*cols, bands)
 [rows cols bands] = size(rgbImage);
 arrayImage = zeros(rows*cols, bands);
 k = 1;
 for i = 1: rows;
     for j = 1: cols, 
        r = rgbImage(i,j,1);
        g = rgbImage(i,j,2);
        b = rgbImage(i,j,3);
        arrayImage(k,:) = [r,g,b];
        k = k+1;
     end
 end
