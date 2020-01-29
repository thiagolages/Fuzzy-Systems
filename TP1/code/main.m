clear all;
clc;
clf;

set(0,'DefaultFigureWindowStyle','docked') ;

%% Questao 2
% data = load('SyntheticDataset.mat');
data = load('fcm_dataset.mat');

data = data.x;
%plot(data(:,1), data(:,2),'b.');

k = 4;

N = 50;
for i = 1:N
    disp( strcat("execucao numero ",num2str(i)) );
    [centroid, U, iter_fuzzy(i), J_fuzzy(i)] = KMeansFuzzy(data,k);
    [iter_normal(i), J_normal(i)] = KMeans(data,k);
end

disp(strcat("iter Fuzzy  = ",num2str(iter_fuzzy)));
disp(strcat("iter Normal = ",num2str(iter_normal)));

disp(strcat("cost Fuzzy  = ",num2str(J_fuzzy)));
disp(strcat("cost Normal = ",num2str(J_normal)));

%% Questao 3

folder = 'ImagensTeste\';
prefix = 'photo';
extension = '.jpg';

k_clusters = [2,3,5,6,6,3,3,6,5,2,3];
imageNames = [];
for curr_img = 1:11
    if (curr_img<10)
        i_aux = strcat('0',num2str(curr_img));
    else
        i_aux = num2str(curr_img);
    end
    
    img_path = strcat(folder,prefix,'0',i_aux,extension);
    %disp(img_path);
    imageNames = [imageNames; img_path];
end



for curr_img=4:4 % select one or more images

    disp(strcat('Selected image: ',imageNames(curr_img,:)));
    imageNamesCell = cellstr(imageNames);
    currentImage = strtrim(imageNamesCell{curr_img});   
    rgbImage = im2double(imread(currentImage));
    
    k = k_clusters(curr_img)
    disp(strcat('k = ',num2str(k)));
    % get image array as normalized RGB values
    imageName = imageNames(curr_img,:);
    [arrayImage] = img_pre_processing(imageName);
    
    % plot original image and RGB space
    % plot_img_rgb_space(rgbImage, arrayImage);
    
    % get centroids and U matrix
    [centroids, U] = KMeansFuzzy(arrayImage,k);
    
    pixelImage = rgbImage;
    disp('Coloring image..');
    for i = 1:size(rgbImage,1)
        for j = 1:size(rgbImage,2)
            dists = pdist([rgbImage(i,j,1),rgbImage(i,j,2),rgbImage(i,j,3);centroids]);
            idx = find(min(dists(1:k)) == dists(1:k));
            idx = idx(1);
            % pixel on image receives the RGB of the closest centroid
            pixelImage(i,j,:) = centroids(idx,:);
        end
    end    
    disp('Now plotting..');
    plot_img_rgb_space(rgbImage,pixelImage,arrayImage, centroids);
    disp('Done !');
end
