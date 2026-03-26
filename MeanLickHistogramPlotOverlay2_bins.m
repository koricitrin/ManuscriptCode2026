function MeanLickHistogramPlotOverlay2_bins(Paths1, Paths2, savepath, delay1, delay2, run)

sigma = 10; % pick sigma value for the gaussian
                 gaussFilter = gausswin(6*sigma + 1)';
                 gaussFilter = gaussFilter / sum(gaussFilter); % normalize
    for k = 1:size(Paths1,1)
        path = Paths1(k,:);
        sess = path(43:58);
        cd(path)
                if run == 0
                 AlignCuePath = [sess '_DataStructure_mazeSection1_TrialType1_alignCue_msess1.mat']; 
                   if(exist(AlignCuePath) ~= 0)
                    load(AlignCuePath)
                    trialsData = trialsCue;
                   else
                    AlignCuePath = [sess '_lickavgSC.mat']
                   load(AlignCuePath)
                   TrialsData.AllLick = AllLick
                   end
                namex = 'Time from cue onset (s)';
                condstr = 'Cue'
        
                elseif run == 1
                sess = path(44:59);
                 AlignRunPath = [sess '_DataStructure_mazeSection1_TrialType1_alignRun_msess1.mat']; 
                 load(AlignRunPath)
                 trialsData = trialsRun;
                 namex = 'Time from run onset (s)'
                  condstr = 'Run'
                end
                if delay1 == 4
                bins1 = 3500
        
                elseif delay1 == 3
                bins1 = 3000
        
                elseif delay1 == 2
                bins1 = 2500
            
                end
        
                TrialsHistCountSum = zeros(1,70);
         
                    for trials = 1:size(trialsData.lickLfpInd,2)
                        trTemp =     trialsData.lickLfpInd{trials} - trialsData.startLfpInd(trials);
                        trTempHistCount  =  histcounts(trTemp, bins1, 'BinLimits',[1,bins1]);
                        TrialsBinned = reshape(trTempHistCount, 50, 70);
                        TrialsHistCountSum = [TrialsHistCountSum + mean(TrialsBinned)];
                   
                    end
                
                  TrialsHistCountMeanSesstemp =   TrialsHistCountSum/trials;
                   TrialsHistCountMeanSess1(k,:) = TrialsHistCountMeanSesstemp;
                 % TrialsHistCountMeanSess1(k,:) = conv(TrialsHistCountMeanSesstemp, gaussFilter, 'same');
                  clear trTemp
            end
            
           C = parula(10);
        
            cd(savepath)
            figure
            hold on
   
             TrialsHistCountMean1 = mean(TrialsHistCountMeanSess1);
                 avg_data = TrialsHistCountMean1;
                  x = 1:size(TrialsHistCountMean1,2);
                 std_data = std(TrialsHistCountMeanSess1, 0,1,'omitnan')
                 std_data = std_data/ sqrt(size(Paths1,1));
                fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0 0 0], 'FaceAlpha',0.6)
                plot(x, avg_data, 'k', 'LineWidth', 3)
                 % plot(filteredY1_norm, 'LineWidth', 3, 'Color',  'k')  
          
TrialsHistCountMeanSesstemp = [];

    for k = 1:size(Paths2,1)
        path = Paths2(k,:);
        sess = path(43:58);
        cd(path)
        if run == 0
         AlignCuePath = [sess '_DataStructure_mazeSection1_TrialType1_alignCue_msess1.mat']; 
           if(exist(AlignCuePath) ~= 0)
            load(AlignCuePath)
            trialsData = trialsCue;
           else
            AlignCuePath = [sess '_lickavgSC.mat']
           load(AlignCuePath)
           TrialsData.AllLick = AllLick
           end
        namex = 'Time from cue onset (s)';
        condstr = 'Cue'


        elseif run == 1
        sess = path(44:59);
         AlignRunPath = [sess '_DataStructure_mazeSection1_TrialType1_alignRun_msess1.mat']; 
         load(AlignRunPath)
         trialsData = trialsRun;
         namex = 'Time from run onset (s)'
          condstr = 'Run'
        end
        if delay2 == 4
        bins2 = 3500

        elseif delay2 == 3
        bins2 = 3000

        elseif delay2 == 2
        bins2 = 2500
    
        end

        TrialsHistCountSum = zeros(1,70);
 
            for trials = 1:size(trialsData.lickLfpInd,2)
                trTemp =     trialsData.lickLfpInd{trials} - trialsData.startLfpInd(trials);
                trTempHistCount  =  histcounts(trTemp, bins2, 'BinLimits',[1,bins2]);
                TrialsBinned = reshape(trTempHistCount, 50, 70);
                TrialsHistCountSum = [TrialsHistCountSum + mean(TrialsBinned)];
            end

            TrialsHistCountMeanSesstemp =   TrialsHistCountSum/trials;
            TrialsHistCountMeanSess2(k,:) = TrialsHistCountMeanSesstemp;
            % TrialsHistCountMeanSess2(k,:) = conv(TrialsHistCountMeanSesstemp, gaussFilter, 'same');
            

          clear trTemp
    end
    
   
    cd(savepath)
 
    
     TrialsHistCountMean2 = mean(TrialsHistCountMeanSess2);
         avg_data = TrialsHistCountMean2;
                  x = 1:size(TrialsHistCountMean2,2);
                 std_data = std(TrialsHistCountMeanSess2, 0,1,'omitnan')
                 std_data = std_data/ sqrt(size(Paths2,1));
                fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0.5 0.5 0.5], 'FaceAlpha',0.6)
                plot(x, avg_data, 'Color', [0.5 0.5 0.5], 'LineWidth', 3)
                 % plot(filteredY1_norm, 'LineWidth', 3, 'Color',  'k')  
           



    ylim([0 0.12])
    set(gca, 'FontSize', 22)
    xlim([0 70])
    % xline(bins1-1000, 'LineWidth', 3.5)
    xticks(0:10:70)
    xticklabels({'0', '1', '2', '3', '4', '5', '6', '7'})
    xlabel(namex)

    ylabel('Avg. No Licks')

    legend('', 'Cue', '', 'No Cue', 'Location', 'best')
    T = ['LickHist-Overlay' condstr 'binned']
    savefig([ T  '.fig'])
     print('-painters','-dpdf',[ T],'-r600');
    print('-painters','-dpng',[ T],'-r600');

end