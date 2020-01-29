function [] = plot_img_rgb_space(rgbImage, pixelImage, arrayImage, centroids)
    figure();
    subplot(1,3,1);
    title('Original Image')
    imshow(rgbImage);    

    subplot(1,3,2);
    title('Pixelized Image');
    imshow(pixelImage);
    
    % mostra os pixels da imagem no espaço cartesiano R x G x B
    subplot(1,3,3); 
    title('Pixels in the RGB space')
    for i=1:size(arrayImage,1)
        plot3(arrayImage(i,1),arrayImage(i,2),arrayImage(i,3),'.','Color',[arrayImage(i,1),arrayImage(i,2),arrayImage(i,3)]);
        hold on;
    end
    
    h = plot3(centroids(:,1), centroids(:,2), centroids(:,3), 'ko', 'LineWidth', 2, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize', 10);
    
    
    axis([0 1 0 1 0 1]);
    hold on;
    axis square; grid on;
    drawnow;
end