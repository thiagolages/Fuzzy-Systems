function [] = plot_clusters(data, centroids)
   
    n = size(data,1);
    k = size(centroids,1);
    %hold on;
    dist = zeros(n,k);
    idx = zeros(n,1);
    colors = {'ro', 'go', 'mo', 'ko', 'yo'};
    for i = 1:n
        dist (i,:) = pdist2(data(i,:),centroids);
        c = colors{find(min(dist(i,:)) == dist(i,:))};
        plot(data(i,1),data(i,2),c);
        hold on;
    end
end