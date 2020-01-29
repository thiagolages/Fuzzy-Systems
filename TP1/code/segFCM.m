function [U] = segFCM(file, n_cluster)
    % Carregando dados da imagem
    rgbImage = im2double(imread(file));
        
    % define constante de fuzzificação
    m = 2;

    % Transformando imagem em matriz unidimensional
    [rows, cols, bands] = size(rgbImage);
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
    
    % step 1: randomly assign membership degrees to each one of the patterns
    U = zeros(rows * cols, n_cluster);    % membership degree matrix
    idx = zeros(rows * cols, 1);
    for i = 1:rows * cols,
        rnd = rand(1, n_cluster);
        rnd = rnd / sum(rnd);
        U(i, :) = rnd;  
        idx(i) = find(rnd == max(rnd));
    end

    changes = true;
    oldIdx = idx;
    iter = 1;
    while (changes)    % iterate until the cluster assignments stop changing

        % computing the initial centroids
        centroids = zeros(n_cluster, bands);
        for j = 1:n_cluster,
            Gj = U(:, j);

            c_prob = zeros(rows * cols, bands);
            for it = 1:rows * cols,
                c_prob(it, :) = Gj(it).^m * arrayImage(it, :);
            end;

            centroids(j,:) = sum(c_prob)./sum(Gj.^m);
        end;
 
        % assign new membership degree matrix
        U = zeros(rows * cols, n_cluster);
        for i = 1:rows * cols,
            pattern = arrayImage(i, :);

            dt_centroids = 0;
            for it = 1:n_cluster,
                eucdist = [pattern; centroids(it,:)];
                dt_centroids = dt_centroids + pdist(eucdist);
            end;

            for it = 1:n_cluster,
                gc = centroids(it,:);
                eucdist = [pattern; gc];

                if pdist(eucdist) == 0
                    U(i, :) = 0;
                    U(i, it) = 1;
                    break;
                else
                    U(i, it) = 1/((pdist(eucdist)/dt_centroids).^(2/(m-1)));
                end
            end
            
            U(i, :) = U(i, :)/sum(U(i, :));
            idx(i) = find(U(i, :) == max(U(i, :)), 1);
        end

        iter = iter + 1

        % verifying the stop criteria 
        if isequal(idx,oldIdx),
            changes = false;
        else
            oldIdx = idx;
        end;
    end;
end