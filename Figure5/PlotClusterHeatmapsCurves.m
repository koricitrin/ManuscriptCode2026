% 
function PlotClusterHeatmapsCurves(FRProfPath, KmeansPath, TablePath, trType,delay)
% % PlotClusterHeatmapsCurves('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\FR_Prof\', 'Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\PAC_Kmeans_noPCA_start_2\',
     cd(FRProfPath)
     load('FRprofileTable_alignLastLickdffgfthres.mat')
     cd(TablePath)
     load('RiseLastLickDownLickNeurons_thres.mat')
     cd(KmeansPath)

     if trType == 1
     load('KmeansResults3545s.mat')
    [~,sorted_All_ind]  = sort(RiseLLDownLickRatio.RatioLastLick, 'descend'); 
    data = [clusters.idx, avgFR_profile_3545];
    savestr = '3545';
     elseif trType == 2
     load('KmeansResults56s.mat')
    [~,sorted_All_ind]  = sort(RiseLLDownLickRatio.RatioLastLick, 'descend'); 
    data = [clusters.idx, avgFR_profile_56];
     savestr = '56';
     end

    SortedData = data(sorted_All_ind,:);
    Cluster1_ind = SortedData(:,1) == 1;
    Cluster2_ind = SortedData(:,1) == 2;
    
    SortedCluster1 = SortedData(Cluster1_ind, 2:end);
    SortedCluster2 = SortedData(Cluster2_ind, 2:end);
    
    cd(KmeansPath)
    
    figure
    subplot(1,2,1)
    imagesc(SortedCluster1)
       colormap(flipud(gray))
         xline(1500, '--m', 'LineWidth', 1.5)
     % colormap(jet)
     axis square
     xticks(0:500:5000)
     xticklabels(-3:7)
         if delay == 4
            xlim([500 5000])
     elseif delay == 2
          xlim([500 4000])
     end
     ylabel('Neurons')
     set(gca, 'FontSize', 9)
     title('Cluster 1')
       xlabel('Time from last lick (s)')
    subplot(1,2,2)
    imagesc(SortedCluster2)
      xline(1500, '--m', 'LineWidth', 1.5)
     % colormap(flipud(gray))
      xticks(0:500:5000)
       axis square
     xticklabels(-3:7)
     if delay == 4
     xlim([500 5000])
     elseif delay == 2
          xlim([500 4000])
     end
    title('Cluster 2')
      xlabel('Time from last lick (s)')
    set(gca, 'FontSize', 9)
      T = ['Heatmap clusters_ratioLastLick' savestr]
       savefig([T '.fig'])
    print('-painters','-dpdf',[T],'-r600');
    print('-painters','-dpng',[T],'-r600');
    
    figure
     hold on
      avg_data = mean(SortedCluster1);
      x = 1:size(avg_data,2);
     std_data = std(SortedCluster1, 0,1,'omitnan')
     std_data = std_data/ sqrt(15);
    fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], 'g', 'FaceAlpha',0.3)
    plot(x, avg_data, 'g', 'LineWidth', 4)
    
     avg_data = mean(SortedCluster2);
      x = 1:size(avg_data,2);
     std_data = std(SortedCluster2, 0,1,'omitnan')
     std_data = std_data/ sqrt(15);
    fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], 'b', 'FaceAlpha',0.3)
    plot(x, avg_data, 'b', 'LineWidth', 4)
     xticks(0:500:5000)
     xticklabels(-3:7)
      if delay == 4
            xlim([500 5000])
     elseif delay == 2
          xlim([500 4000])
      end
    
            ylim([0 1])
            xticklabels(-3:7)
            xlabel('Time from last lick (s)')
            ylabel('dF/F')
            axis square
            set(gca, 'FontSize', 16)
            title('Mean cluster activity')
      T = ['Curves_clusters' savestr]
      legend({'','Cluster 1', '', 'Cluster 2',}, 'Location', 'best')
      
       savefig([T '.fig'])
    print('-painters','-dpdf',[T],'-r600');
    print('-painters','-dpng',[T],'-r600');
    % figure
    % imagesc(SortedData(:,2:end))
    %   colormap(flipud(gray))
    %  % colormap(jet)
    %  axis square
    %  xticks(0:500:5000)
    %  xticklabels(-3:7)
    %  xlim([501 5000])
    %  ylabel('Neurons')
    %    xlabel('Time from last lick (s)')
    % set(gca, 'FontSize', 15)
    %   T = ['Heatmap allCluster 56s _ratioLastLick']
    %    savefig([T '.fig'])
    % print('-painters','-dpdf',[T],'-r600');
    % print('-painters','-dpng',[T],'-r600');
end