clear all;
%close all;
clc;

addpath ImagensTeste/

% string vector containing image names
imageNames = [ 'photo001.jpg';
               'photo002.jpg';
               'photo003.jpg';
               'photo004.jpg';
               'photo005.jpg';
               'photo006.jpg';
               'photo007.jpg';
               'photo008.jpg';
               'photo009.jpg';
               'photo010.jpg';
               'photo011.jpg';
               ];
 imageNamesCell = cellstr(imageNames);
 
 % obtem a imagem RGB, altera seu tamanho e mostra a imagem original (rows x cols x bands)
 currentImage = strtrim(imageNamesCell{1});   
 rgbImage = im2double(imread(currentImage));   % im2double() - converte pixels para double
 rgbImage = imresize(rgbImage,0.25,'box');
 subplot(1,2,1);
 title('Original Image')
 imshow(rgbImage);
 
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

 % mostra os pixels da imagem no espaço cartesiano R x G x B
subplot(1,2,2); 
title('Pixels in the RGB space')
for i=1:size(arrayImage,1)
    plot3(arrayImage(i,1),arrayImage(i,2),arrayImage(i,3),'.','Color',[arrayImage(i,1),arrayImage(i,2),arrayImage(i,3)]);
    hold on;
end

%plot3(arrayImage(:,1),arrayImage(:,2),arrayImage(:,3),'b.');
axis([0 1 0 1 0 1]);
hold on;
axis square; grid on;