function KmeansClusterPAC_AllSessionsOverlap(FR_ArrayPath, savepath, doPCA, ephys, trType, timeStart, norm)

%KmeansClusterPAC_AllSessions('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\FR_Prof\','Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\', 0, 0, 3, -2)
    % ---------- USER INPUT ----------
    % data: N x T (neurons x time).
    % doPCA = true;        % reduce dimensionality before clustering


  
    nPC = 6;             % how many PCs to keep (if doPCA)
    kRange = 2:10;       % range of k to try
    replicates = 20;
    distMetric = 'correlation'; % 'sqeuclidean' or 'correlation' (correlation groups by shape)
            % --------------------------------

       if timeStart == 0
           starts = 1501;
            xMax = 3500;
       elseif timeStart ==-2
           starts =501;
           xMax = 4500;
       end
         
        cd(FR_ArrayPath) 
        avgFR_profile = [];

          load('FRprofileTable_alignLastLickOverlapPacs.mat')
      % load('PACRiseDownArray')
   % avgFR_profile_34 =   FR_Array_sorted_34;
            if trType == 1 && norm == 1
            data_norm =   avgFR_profile(:,starts:end);
            namestr = '';
            elseif trType == 2  && norm == 1
            data_norm =   avgFR_profile_3545(:,starts:end);
            namestr= '3545s';
            elseif trType == 3  && norm == 1
            data_norm =   avgFR_profile_56(:,starts:end);
            namestr= '56s';
            elseif trType == 4  && norm == 1
            data_norm =   avgFR_profile_3sDelay(:,starts:end);
            namestr= '3sBlock';
            elseif trType == 5  && norm == 1
            data_norm =   avgFR_profile_5sDelay(:,starts:end);
            namestr= '5sBlock';

            end
   
          cd(savepath)
          if doPCA == 1 && timeStart == 0 &&norm == 1
          foldername = ['PAC_Kmeans_PCA_start0_overlap\'];   
          elseif doPCA == 0 && timeStart == 0 &&norm == 1
           foldername = ['PAC_Kmeans_noPCA_start0_overlap\'];   
           elseif doPCA == 1 && timeStart == -2 &&norm == 1
           foldername = ['PAC_Kmeans_PCA_start_2_overlap\'];  
           elseif doPCA == 0 && timeStart == -2 &&norm == 1
           foldername = ['PAC_Kmeans_noPCA_start_2_overlap\'];
          elseif doPCA == 1 && timeStart == 0 &&norm == 0
          foldername = ['PAC_Kmeans_PCA_start0_notNorm_overlap\'];  

            elseif doPCA == 1 && timeStart == -2 && norm == 0
           foldername = ['PAC_Kmeans_PCA_start_2_normTogether_overlap\'];
            elseif doPCA == 0 && timeStart == -2 && norm == 0
           foldername = ['PAC_Kmeans_noPCA_start_2_normTogether_overlap\'];  
             elseif doPCA == 0 && timeStart == 0 && norm == 0
           foldername = ['PAC_Kmeans_noPCA_start0_normTogether_overlap\'];   
          end

          mkdir(foldername) 
          savepath1 = [savepath foldername]
          cd(savepath1)


            [N, t] = size(data_norm);
            
            % % Preprocess: baseline subtract and z-score across time (per neuron)
            % baselineWindow = 1:round(0.1*T);  % first 10% as baseline
            % data_bs = data - mean(data(:, baselineWindow), 2);   % subtract baseline per neuron
            % data_z = (data_bs - mean(data_bs,2)) ./ (std(data_bs,0,2) + eps);

            % Optional smoothing (uncomment if noisy)
            % data_z = movmean(data_z, 5, 2);
            
            % Dimensionality reduction
            if doPCA
                [coeff, score, ~, ~, explained] = pca(data_norm); % score: N x T -> but pca treats rows as observations -> N x PCs
                X = score(:,1:nPC);  % N x nPC
            else
                X = data_norm;          % N x T
            end
            
            % Find good k via elbow (wss) and silhouette
            wss = zeros(size(kRange));
            silh_mean = zeros(size(kRange));
            opts = statset('Display','final');
            
            for ii = 1:numel(kRange)
                k = kRange(ii);
                [idx_tmp, C, sumd] = kmeans(X, k, 'Replicates', replicates, 'Distance', distMetric, 'MaxIter', 500, 'Options', opts);
                wss(ii) = sum(sumd);             % within-cluster sum of distances
                s = silhouette(X, idx_tmp, distMetric);
                silh_mean(ii) = mean(s);
            end
            
            figure;
            subplot(1,2,1);
            plot(kRange, wss, '-o'); xlabel('k'); ylabel('Within-cluster sum'); title('Elbow');
            subplot(1,2,2);
            plot(kRange, silh_mean, '-o'); xlabel('k'); ylabel('Mean silhouette'); title('Silhouette');
            
            % Choose k (automatic pick: max silhouette)
            [~,bestIdx] = max(silh_mean);
            kBest = kRange(bestIdx);
            fprintf('Choosing k = %d (max silhouette = %.3f)\n', kBest, silh_mean(bestIdx));
            
            % Final clustering with chosen k
            [idx, C] = kmeans(X, kBest, 'Replicates', replicates, 'Distance', distMetric, 'MaxIter', 1000, 'Options', opts);
            
            % Plot cluster-averaged PSTHs
            figure('Name','Cluster averages','NumberTitle','off');
            colors = winter(kBest);
            if ephys == 1 
                 timeStepRun =   timeStepRun(1,Range(1):Range(2));
            end
            for c = 1:kBest
                subplot(kBest,1,c);
                members = find(idx==c);
                plot(1:t, data_norm(members,:)', 'Color',[0.8 0.8 0.8 0.5]); hold on; % individual neurons faint
                plot(1:t, mean(data_norm(members,:),1), 'LineWidth', 2, 'Color', colors(c,:));
                % xline(meanFirstLick, '--k')
                % xticks(0:500:xMax)
           
                if ephys == 0 
                    xticks(0:500:xMax)
                    if timeStart == 0
                     xticklabels(0:1:7)
                    
                    elseif timeStart == -2
                    xticklabels(-2:1:7)
                    end
                     xlim([0 xMax])
                elseif ephys == 1 
            
                 xlim([find(timeStepRun == -2000), find(timeStepRun == 9000)]);
                 x_tick_pos = [find(timeStepRun == -2000), find(timeStepRun == -1000), find(timeStepRun == 0), find(timeStepRun == 1000),...
                 find(timeStepRun == 2000), find(timeStepRun == 3000), find(timeStepRun == 4000), find(timeStepRun == 5000), find(timeStepRun == 6000),...
                 find(timeStepRun == 7000), find(timeStepRun == 8000), find(timeStepRun == 9000)];     
                 xticks(x_tick_pos);
                  xticklabels([-2 -1 0 1 2 3 4 5 6 7 8 9]);
                 xlim([0 find(timeStepRun == 9000)])
                end
                ylabel('dF/F norm')
             
                 set(gca, 'FontSize', 14)
                title(sprintf('Cluster %d: n=%d', c, numel(members)));
                if c==kBest, xlabel('Time from last lick (s)'); end
            end
         

            T = ['Kmeans Clusters' namestr]
            savefig([ T '.fig'])
            print('-painters','-dpng',[ T],'-r600');
             

                 % Plot cluster-averaged PSTHs
            figure('Name','Cluster averages','NumberTitle','off');
            colors = winter(kBest);
            if ephys == 1 
                 timeStepRun =   timeStepRun(1,Range(1):Range(2));
            end
            for c = 1:kBest
                subplot(kBest,1,c);
                members = find(idx==c);
                % plot(1:t, data_norm(members,:)', 'Color',[0.8 0.8 0.8 0.5]); hold on; % individual neurons faint
                plot(1:t, mean(data_norm(members,:),1), 'LineWidth', 2, 'Color', colors(c,:));
          
                savename = ['meancluster' num2str(c) namestr '.mat']
                MeanCluster = mean(data_norm(members,:),1);
                save(savename, 'MeanCluster')
                clear MeanCluster
                
                % xline(meanFirstLick, '--k')
                % xticks(0:500:xMax)
           
                if ephys == 0 
                    xticks(0:500:xMax)
                    if timeStart == 0
                     xticklabels(0:1:7)
                    
                    elseif timeStart == -2
                    xticklabels(-2:1:7)
                    end
                     xlim([0 xMax])
                elseif ephys == 1 
            
                 xlim([find(timeStepRun == -2000), find(timeStepRun == 9000)]);
                 x_tick_pos = [find(timeStepRun == -2000), find(timeStepRun == -1000), find(timeStepRun == 0), find(timeStepRun == 1000),...
                 find(timeStepRun == 2000), find(timeStepRun == 3000), find(timeStepRun == 4000), find(timeStepRun == 5000), find(timeStepRun == 6000),...
                 find(timeStepRun == 7000), find(timeStepRun == 8000), find(timeStepRun == 9000)];     
                 xticks(x_tick_pos);
                  xticklabels([-2 -1 0 1 2 3 4 5 6 7 8 9]);
                 xlim([0 find(timeStepRun == 9000)])
                end
                ylabel('dF/F norm')
             
                 set(gca, 'FontSize', 14)
                title(sprintf('Cluster %d: n=%d', c, numel(members)));
                if c==kBest, xlabel('Time from last lick (s)'); end
            end
         

            T = ['Kmeans Clusters' namestr 'avg']
            savefig([ T '.fig'])
            print('-painters','-dpng',[ T],'-r600');
             

            figure
            set(gcf, 'Position', [200 100  600 220]);
            subplot(1,2,1);
            
            R = corrcoef(data_norm');
            imagesc(R)
            colormap parula  
            xlabel('Neurons')
            ylabel('Neurons')
            axis square
            title('Corr Matrix -neurons unsorted')
            DataClusters = [];
            for c = 1:kBest
            DataClusterTemp = data_norm(idx == c, :);
            SizeClusters(c,:) = size(DataClusterTemp,1);
            SeparateClusters{c,:} = DataClusterTemp;
            DataClusters = [DataClusters; DataClusterTemp];
            end
             R_Clusters = corrcoef(DataClusters');
            subplot(1,2,2);  
            imagesc(R_Clusters)
            colormap parula  
            xlabel('Neurons')
            colorbar
            T = ['Corr Matrix -neurons clustered' namestr];
            title(T)
            savefig([ T '.fig'])
            print('-painters','-dpng',[ T],'-r600');
      
            R_IntraCluster1 = corr(SeparateClusters{1}');
            R_IntraCluster2 = corr(SeparateClusters{2}');

            [M,I] = min(SizeClusters) %I is the smaller cluster, M is it's size 
           
            R_InterCluster = corr((SeparateClusters{2}(1:M,:))', SeparateClusters{1}(1:M,:)');
            figure
            histogram(R_InterCluster, 'BinWidth', 0.2, 'Normalization', 'probability','FaceColor',  [0.5 0.5 0.5])
            hold on
            R_IntraCluster =   [R_IntraCluster1, R_IntraCluster1];
            histogram(R_IntraCluster, 'BinWidth', 0.2, 'Normalization', 'probability', 'FaceColor', [0 0.4470 0.7410])
            legend({'InterCluster', 'IntraCluster'}, 'location', 'best')
            % histogram(R_IntraCluster1, 'BinWidth', 0.2, 'Normalization', 'probability', 'FaceColor', colors(1,:))
            % histogram(R_IntraCluster1, 'BinWidth', 0.2, 'Normalization', 'probability', 'FaceColor', colors(2,:))
            % legend({'InterCluster', 'IntraCluster1', 'IntraCluster2'}, 'location', 'best')
            ylabel('Probability')
            xlabel('Correlation')
            axis square
            set(gca, 'FontSize', 16)
            
            T = ['Intra vs InterCluster correlations' namestr]
            title(T)
            savefig([ T '.fig'])
            print('-painters','-dpng',[ T],'-r600');
        
            % Show cluster centroids in PCA space (if did PCA)
            if doPCA
                figure('Name','Clusters in PC space'); hold on;
                for c = 1:kBest
                    scatter(C(c,1), C(c,2), 100, colors(c,:), 'filled');
                    text(C(c,1), C(c,2), sprintf(' %d',c));
                end
                xlabel('PC1'); ylabel('PC2'); title('Cluster centroids (first 2 PCs)');
            end
            
            % Optionally save cluster assignments
            clusters.idx = idx;
            clusters.k = kBest;
            clusters.centroids = C;
            clusters.X = X;
            savename = ['KmeansResults' namestr '.mat']
            save(savename, 'clusters')

            %%plot ind neurons and label with cluster type 

      
          foldername = ['IndNeurClusters' namestr];   
          mkdir(foldername) 
          savepath2 = [savepath1 foldername]
          cd(savepath2)
            % 
            % for n = 300:400
            % 
            %     figure
            %     if idx(n) == 1
            %     plot(data_norm(n,:), 'LineWidth', 2, 'Color',  colors(1,:))
            %     elseif idx(n) == 2
            %     plot(data_norm(n,:), 'LineWidth', 2, 'Color',  colors(2,:))
            %     end
            %      T  = ['Neuron ' num2str(n) '- Cluster' num2str(idx(n))]
            %     title(T)
            %     xticks(0:500:xMax)
            %     if timeStart == 0
            %     xticklabels(0:1:7)
            %     elseif timeStart == -2
            %     xticklabels(-2:1:7)
            %     end
            %     xlabel('Time from last lick (s)')
            %     ylabel('dF/F normalized')
            %     set(gca, 'FontSize', 18)
            %     axis square
            % title(T)
            % savefig([ T '.fig'])
            % print('-painters','-dpng',[ T],'-r600');
            % end
            % 

            clearvars -except Paths TablePath doPCA
            % close all
    end
