function MeanRunLickHistogramPlot2(Paths, FileNameBase, savepath, delay, cond)
     sigma = 10; % pick sigma value for the gaussian


    for k = 1:size(Paths,1)
        path = Paths(k,:);
        sess = FileNameBase(k,:);
        cd(path)
        if cond == 1
        AlignCuePath = [sess '_DataStructure_mazeSection1_TrialType1_alignCue_msess1.mat']; 
        load(AlignCuePath)
        trialsData = trialsCue;
        namex = 'Time from cue onset (s)';
        condstr = 'Cue'
        elseif cond == 2
         AlignRunPath = [sess '_DataStructure_mazeSection1_TrialType1_alignRun_msess1.mat']; 
         load(AlignRunPath)
         trialsData = trialsRun;
         namex = 'Time from run onset (s)'
          condstr = 'Run'
             elseif cond == 3
         AlignLLPath = [sess '_DataStructure_mazeSection1_TrialType1_alignLastLick_msess1.mat']; 
         load(AlignLLPath)
         trialsData = trialsLastLick;
      load([sess '_alignLastLickSpeed.mat'])
         trialsData.speed_MMsec =speed_MMsec_LastLick;
         namex = 'Time from last lick (s)'
          condstr = 'Last lick'
        end
        if delay == 4
        bins1 = 3500

        elseif delay == 5
        bins1 = 10000

        elseif delay == 3
        bins1 = 3000

        elseif delay == 2
        bins1 = 2500
    
        end

        TrialsHistCountSum = zeros(1,60);
        trSpeedSum = zeros(1,60)
            for trials = 2:size(trialsData.lickLfpInd,2)-1
                trTemp =     trialsData.lickLfpInd{trials} - trialsData.startLfpInd(trials);
                trTempHistCount  =  histcounts(trTemp, bins1, 'BinLimits',[1,bins1]);
                % TrialsHistCountSum = [TrialsHistCountSum + trTempHistCount];

               TrialsBinned = reshape(trTempHistCount, 50, 60);
               TrialsHistCountSum = [TrialsHistCountSum + mean(TrialsBinned)];
                   
                if size(trialsData.speed_MMsec{trials},1) < bins1
                    diff = bins1 - size(trialsData.speed_MMsec{trials},1);
                    trSpeedTemp =   [trialsData.speed_MMsec{trials}; zeros(diff,1)];
                else
                trSpeedTemp = trialsData.speed_MMsec{trials}(1:bins1);
                end
                  TrialsBinned = reshape(trSpeedTemp, 50, 60);
               trSpeedSum = [trSpeedSum + mean(TrialsBinned)];
                   
                % trSpeedSum = [trSpeedSum + trSpeedTemp];

            end

          TrialsHistCountMeanSessTemp =   TrialsHistCountSum/trials;  %lick
          % TrialsHistCountMeanSess(k,:) = conv(TrialsHistCountMeanSessTemp, gaussFilter, 'same');
            
           TrialsHistCountMeanSess(k,:) = (TrialsHistCountMeanSessTemp);

          TrialsRunMeanSessTemp =   trSpeedSum'/trials; %speed
          % TrialsRunMeanSess(k,:) = conv(TrialsRunMeanSessTemp, gaussFilter, 'same');
           TrialsRunMeanSess(k,:) = TrialsRunMeanSessTemp; 

    end
   
    cd(savepath)
    figure
    hold on

     TrialsHistCountMean = mean(TrialsHistCountMeanSess);
     TrialsRunMean = mean(TrialsRunMeanSess);
                yyaxis right
                avg_data = TrialsHistCountMean;
                x = 1:size(TrialsHistCountMean,2);
                std_data = std(TrialsHistCountMeanSess, 0,1,'omitnan')
                std_data = std_data/ sqrt(size(Paths,1));
                fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], 'm', 'FaceAlpha',0.6)
                plot(x, avg_data, 'Color', 'm', 'LineWidth', 3)
                 yyaxis left
                  avg_data = TrialsRunMean/10;
                x = 1:size(TrialsRunMean,2);
                std_data = std(TrialsRunMeanSess/10, 0,1,'omitnan')
                std_data = std_data/ sqrt(size(Paths,1));
                fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], 'k', 'FaceAlpha',0.6)
                plot(x, avg_data, 'Color', 'k', 'LineWidth', 3)

    set(gca, 'FontSize', 22)

    yyaxis  right
    ylabel('No licks / bin')
    yyaxis left 
    ylabel('Speed (cm/s)')
    ax = gca;
    ax.YAxis(1).Color = 'k';
    ax.YAxis(2).Color = 'm';
    xlim([0 3000])
    % xline(bins1-1000, 'LineWidth', 3.5)
    xticks(0:500:bins1)
    xticklabels({'0', '1', '2', '3', '4', '5', '6', '7'})
    xlabel(namex)

    T = ['RunLickHist' condstr]
    savefig([ T  '.fig'])
    print('-painters','-dpng',[ T],'-r600');


end