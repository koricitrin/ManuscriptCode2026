function MeanLickHistogramPlotRewOmissOverlay2_binned(Paths, savepath, delay, cond)
sigma = 10; % pick sigma value for the gaussian
                 gaussFilter = gausswin(6*sigma + 1)';
                 gaussFilter = gaussFilter / sum(gaussFilter); % normalize
    for k = 1:size(Paths,1)
        path = Paths(k,:);
        sess = path(43:58);
        cd(path)
       
        load('RewardOmissionTrInd.mat')

        if cond == 1
        AlignCuePath = [sess '_DataStructure_mazeSection1_TrialType1_alignCue_msess1.mat']; 
        load(AlignCuePath)
        trialsData = trialsCue;
        namex = 'Time from cue onset (s)';
        condstr = 'Cue'

        elseif cond == 3
        sess = path(44:59);
         AlignRunPath = [sess '_DataStructure_mazeSection1_TrialType1_alignRun_msess1.mat']; 
         load(AlignRunPath)
         trialsData = trialsRun;
         namex = 'Time from run onset (s)'
          condstr = 'Run'


        elseif cond == 2
        sess = path(43:58);
         AlignLLPath = [sess '_DataStructure_mazeSection1_TrialType1_alignLastLick_msess1.mat']; 
         load(AlignLLPath)
         trialsData = trialsLastLick
         namex = 'Time from last lick (s)'
          condstr = 'LastLick'
        end
        if delay == 4
        bins1 = 3500
        elseif delay == 5
        bins1 = 4000

        elseif delay == 3
        bins1 = 3000

        elseif delay == 2
        bins1 = 2500
    
        end


        RewOmissionTr; 
        RewOmissionTrBef = RewOmissionTr - 1;
        RewOmissionTrAft = RewOmissionTr + 1;
        C = parula(10);
 
        TrialsHistCountSum_RewOmiss = zeros(1,70);
            for tr = 1:size(RewOmissionTr,2)
                trials = RewOmissionTr(tr);
                trTemp =     trialsData.lickLfpInd{trials} - trialsData.startLfpInd(trials);
                trTempHistCount  =  histcounts(trTemp, bins1, 'BinLimits',[1,bins1]);
                TrialsBinned = reshape(trTempHistCount, 50, 70);
                TrialsHistCountSum_RewOmiss = [TrialsHistCountSum_RewOmiss + mean(TrialsBinned)];
            end

          TrialsHistCountMeanSess_RewOmisstemp =   TrialsHistCountSum_RewOmiss/tr;
            % TrialsHistCountMeanSess_RewOmiss(k,:) =   conv(TrialsHistCountMeanSess_RewOmisstemp, gaussFilter, 'same');
             TrialsHistCountMeanSess_RewOmiss(k,:) =   TrialsHistCountMeanSess_RewOmisstemp;
          colRewOmiss  = [ 0.6350    0.0780    0.1840]
 
         TrialsHistCountSum_RewOmissAft = zeros(1,70);
         count = 0;
            for tr = 1:size(RewOmissionTrAft,2)
                trials = RewOmissionTrAft(tr);
                if trials > size(trialsData.lickLfpInd,2)
                    'excludetr'
                    continue
                end
                trTemp =   trialsData.lickLfpInd{trials} - trialsData.startLfpInd(trials);
                trTempHistCount  =  histcounts(trTemp, bins1, 'BinLimits',[1,bins1]);
                  TrialsBinned = reshape(trTempHistCount, 50, 70);
                TrialsHistCountSum_RewOmissAft = [TrialsHistCountSum_RewOmissAft + mean(TrialsBinned)];
                count = [count + 1]; 
            end
          TrialsHistCountMeanSess_Afttemp =   TrialsHistCountSum_RewOmissAft/count;
          TrialsHistCountMeanSess_Aft(k,:) =   TrialsHistCountMeanSess_Afttemp;
            % TrialsHistCountMeanSess_Aft(k,:) =   conv(TrialsHistCountMeanSess_Afttemp, gaussFilter, 'same');
          
          colAft  = [ 0.6350    0.0780    0.1840];
   end
   clear RewOmissionTr 
    
    
 
    cd(savepath)
    figure
    hold on
 for trtype = 1:2
     if trtype == 1 
     TrialsHistCountMean  = mean(TrialsHistCountMeanSess_RewOmiss);
     TrialsHistCountSess = TrialsHistCountMeanSess_RewOmiss
     col = [ 0.6350    0.0780    0.1840];
     elseif trtype == 2
     TrialsHistCountMean = mean(TrialsHistCountMeanSess_Aft);
     TrialsHistCountSess = TrialsHistCountMeanSess_Aft;
      col  = [ 0.6350    0.0780    0.1840  .5];
     end
         
        
              avg_data = TrialsHistCountMean;
                  x = 1:size(TrialsHistCountMean,2);
                 std_data = std(TrialsHistCountSess, 0,1,'omitnan')
                 std_data = std_data/ sqrt(size(Paths,1));
                 if trtype == 1
                fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)],  col, 'FaceAlpha',0.7);
                plot(x, avg_data, 'Color', col, 'LineWidth', 3);
                 elseif trtype == 2
                  col  = [ 0.6350    0.0780    0.1840];
                fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)],  col, 'FaceAlpha',0.4);
                 col  = [ 0.6350    0.0780    0.1840 0.5];
                plot(x, avg_data, 'Color', col, 'LineWidth', 3);
                 end
              
                 % plot(filteredY1_norm, 'LineWidth', 3, 'Color',  'k')  
            filtstr = '';
        end
    
 
       
         set(gca, 'FontSize', 24)
 
        
        ylabel('Avg. No Licks')
        T = ['LickHist' filtstr condstr 'overlay' 'sem' 'binned']
      
                 cd(savepath)
     
        legend({'', 'Rew omiss tr', '', 'Tr after rew omiss'})
        set(gca, 'FontSize', 24)
        xlim([0 67])
        % ylim([0 0.12])
        % xline(bins1-1000, 'LineWidth', 3.5)
        xticks(0:10:70)
        xticklabels(0:7)
        % xticklabels({'0', '1', '2', '3', '4', '5', '6', '7'})
        xlabel(namex)
        ylim([0 0.12])
        savefig([ T  '.fig'])
        print('-painters','-dpng',[ T],'-r600');
        print('-painters','-dpdf',[ T],'-r600');


end