

cd('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\PAC_kmeans_folders\PAC_Kmeans_noPCA_start_2\')
load('KmeansResults3545s.mat')
 clusters_3545 = clusters;
 load('KmeansResults56s.mat')
 clusters_56 = clusters;
ClusterData = [clusters_3545.idx,  clusters_56.idx];
 SumClustData = sum(ClusterData,2);
 Remapped =  find(SumClustData == 3);
 RemappedPercent = (size(Remapped,1)/ size(SumClustData,1))*100

 Clust2Const =  find(SumClustData == 4);
Clust2ConstPercent = (size(Clust2Const,1)/ size(SumClustData,1))*100

Clust1Const =  find(SumClustData == 2);
Clust1ConstPercent = (size(Clust1Const,1)/ size(SumClustData,1))*100

percentdata = [Clust1ConstPercent Clust2ConstPercent RemappedPercent]
names = ['Cluster1' 'Cluster2' 'Remapped']
% piechart(percentdata)

 
%%
Clust2_56 = find(clusters_56.idx == 2);
Clust2_56Percent = (size(Clust2_56,1)/ size(SumClustData,1))*100
Clust2_56No = size(Clust2_56,1);

Clust1_56 = find(clusters_56.idx == 1);
Clust1_56Percent = (size(Clust1_56,1)/ size(SumClustData,1))*100
Clust1_56No = size(Clust1_56,1);

Clust2_3545 = find(clusters_3545.idx == 2);
Clust2_3545Percent = (size(Clust2_3545,1)/ size(SumClustData,1))*100
Clust2_3545No= size(Clust2_3545,1);

Clust1_3545 = find(clusters_3545.idx == 1);
Clust1_3545Percent = (size(Clust1_3545,1)/ size(SumClustData,1))*100
Clust1_3545No= size(Clust1_3545,1);