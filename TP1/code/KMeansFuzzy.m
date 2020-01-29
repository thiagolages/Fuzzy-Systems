function [centroid, U, iter, J_aux] = KMeansFuzzy(data, k)
    % Fuzzy C-Means

    % data = matrix of n observations by p dimensions [n x p]
    % k = number of clusters

    % Step 1 - Randomly assign membership degrees to each of the
    % observations. This is equivalent to the Membership Matrix
    % U initialization step

    n = size(data,1);       % number of data rows
    p = size(data,2);       % number of data columns
    U = zeros(n, k);        % membership matrix, n samples by k centroids
    centroid = zeros(k, p); % k centroids, each one with p dimensions

    m = 2;

    for i = 1:n
        r = rand(1,k);      % generate k numbers [0,1]
        r(1) = r(3) + 0.5;
        U(i,:) = r/sum(r);  % make sure they sum to 1        
    end
    U(:,k+1) = sum(U,2);  % show sum on 4th column, just to check

    % Step 2 - Iterate until the cluster assignments stop changing:
    % a. for each one of the K clusters, compute the cluster
    % centroid:

    change = 1;
    
    h_ = 0; % handle to figures
    old_centroid = rand(k,p);
    iter = 0;
    while (true)
        for k_ = 1:k
            num = zeros(1,p);
            % num = sum in n of ([n x 1] x [1 x p]) = sum in n of ([n x p])
            % num = [1 x p]
            for i = 1:n 
                num(:,:) = num(:,:) + (U(i,k_)^m)*data(i,:);
            end
            den = sum(U(:,k_).^m);
            centroid(k_, :) = num/den;
        end
        
        % check if we should keep computing
        if sum(abs((centroid - old_centroid)) < 1e-6)
            hold off;
            %plot_clusters(data, centroid);
            break;
        else
            old_centroid = centroid;
        end
        
        if (h_ ~= 0)
            delete(h_(:,:)); % clear previos plot
        end

        hold on;
        colors = {'ro', 'go', 'mo', 'ko', 'yo'};
       %for i = 1:k
       %    h_(i) = plot(centroid(i,1), centroid(i,2), colors{i});
       %end
       % pause(0.2);
        
        % update U matrix
        for i = 1:n
            aux_den = 0;
            for k_ = 1:k
                aux_den = aux_den + (pdist([data(i,:);centroid(k_,:)]))^2;
            end
            for k_ = 1:k
                aux_num = (pdist([data(i,:); centroid(k_,:)]))^2;
                U(i,k_) = 1 / ((aux_num/aux_den).^(2/(m-1)));
                
            end
            U(i,1:k) = U(i,1:k)/sum(U(i,1:k));
            %U(:,k+1) = sum(U(:,1:k),2);  % show sum on (k+1)th column, just to check
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % assign each pattern to the cluster whose centroid is closest 
        U_aux = zeros(n,k);
        for i = 1:n,
            pattern = data(i,:);
            smallDistance = inf;
            for j = 1:k,
                gc = centroid(j,:);
                distance = sum((pattern-gc).^2);  % squared Euclidian distance from pattern to each centroid  
                if (distance < smallDistance),
                    smallDistance = distance;
                    smallIndex = j;
                end
            end
            U_aux(i,smallIndex) = 1;
            idx(i) = smallIndex;
        end

        % calculating the objective function 
        clus = unique(idx);
        c = length(clus);
        W = zeros(c,1);
        for j = 1:c,
           indexes = find(idx==clus(j));
           Clusj = data(indexes,:);
           W(j) = 1/length(indexes) * sum(pdist(Clusj)); % pdist calculates the n(n-1)/2 distances among all patterns in the Cluster k
        end
        iter = iter + 1
        J(iter) = sum(W);
        J_aux = min(nonzeros(J));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
          
    end
    %disp(strcat('Fuzzy K-Means executed for ', num2str(iter), ' iterations.'));
end

