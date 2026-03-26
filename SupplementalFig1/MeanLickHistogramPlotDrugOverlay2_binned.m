function MeanLickHistogramPlotDrugOverlay2_binned(Paths, savepath, delay, line, musc)
sigma = 10; % pick sigma value for the gaussian
 gaussFilter = gausswin(6*sigma + 1)';
 gaussFilter = gaussFilter / sum(gaussFilter); % normalize
cd('Z:\Kori\immobile_code\Paths\')
ImmobileRecordingListNT
       figure
        hold on
   for pre = 0:1
     

    for k = 1:size(Paths,1)
        path = Paths(k,:);
        sess = path(1,40:52)
        cd(path)
         C = parula(10);
         if musc == 1
             savestr = 'Musc';
               if pre == 1
             filename = [sess recCtrlMusc(k,:)];
             condstr = 'Pre'
             col =  [0 0 0]
            elseif pre == 0 
              filename = [sess rec1hrMusc(k,:)];
             condstr = 'Musc'
             col =  (C(7,:))
             
            elseif pre == 2
            
             filename = [sess recRecoveryMusc(k,:)];
             condstr = 'Recov'
              col =  [0.5 0.5 0.5]
            end
         elseif musc == 0
             savestr = 'Saline';
               if pre == 1
             filename = [sess recCtrlSaline(k,:)];
             condstr = 'Pre'
             col =  [0 0 0]
            elseif pre == 0 
              filename = [sess rec1hrSaline(k,:)];
             condstr = 'Post'
             col =  (C(4,:))
             
           
            end
         end
    
             load(filename)
            namex = 'Time from cue onset (s)';
         
       
            if delay == 4
            bins1 = 7000
            elseif delay == 5
            bins1 = 4000
    
            elseif delay == 3
            bins1 = 3000
    
            elseif delay == 2
            bins1 = 2500
        
            end
    
            TrialsHistCountSum = zeros(1,70);
     
                for trials = 1:size(LickNoNAN,2)
                    trTemp =     LickNoNAN{trials};
                    trTempHistCount  =  histcounts(trTemp, bins1, 'BinLimits',[1,bins1]);
                       TrialsBinned = reshape(trTempHistCount, 100, 70);
                TrialsHistCountSum = [TrialsHistCountSum + mean(TrialsBinned)];
             
                end
    
               
                 TrialsHistCountMeanSesstemp =   TrialsHistCountSum/trials;
                  TrialsHistCountMeanSess(k,:) = TrialsHistCountMeanSesstemp;
                 % TrialsHistCountMeanSess(k,:) = conv(TrialsHistCountMeanSesstemp, gaussFilter, 'same');
                  clear trTemp
    end
    
          
    
        cd(savepath)
    
          TrialsHistCountMean1 = mean(TrialsHistCountMeanSess);
                 avg_data = TrialsHistCountMean1;
                  x = 1:size(TrialsHistCountMean1,2);
                 std_data = std(TrialsHistCountMeanSess, 0,1,'omitnan')
                 std_data = std_data/ sqrt(size(Paths,1));
                fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], col, 'FaceAlpha',0.6)
                plot(x, avg_data, 'Color', col, 'LineWidth', 3)
                 % plot(filteredY1_norm, 'LineWidth', 3, 'Color',  'k')   
    
     
    end
   
     set(gca, 'FontSize', 22)
 
    xlim([0 70])
    % xline(bins1-1000, 'LineWidth', 3.5)
    xticks(0:10:70)
    xticklabels({'0', '1', '2', '3', '4', '5', '6', '7'})
    xlabel(namex)
      ylabel('No. licks / (1/500 s)')

        if line == 1 
            xline(5000, 'LineWidth', 2)
            T = ['LickHist'  condstr 'Norm' 'line']
        else
              T = ['LickHist'  condstr 'Normx']
        end
 
 
    
    legend({'','Post', '','Pre'}, 'Location', 'best')
    
     ylim([0 0.06])
    T = ['LickHist' condstr  savestr 'binned']
    savefig([ T  '.fig'])
    print('-painters','-dpng',[ T],'-r600');
    print('-painters','-dpdf',[ T],'-r600');
   
end
    
