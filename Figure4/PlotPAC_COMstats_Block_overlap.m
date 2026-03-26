function PlotPAC_COMstats_Block_overlap(savepath, Paths)
 

 cd(savepath)
       load('COM_Blocks_overlap_norm_0-6.mat')

        COM_3545_Valid = [com_3s];
        COM_56_Valid = [com_5s];
       


  xticklabelsVal = ({0:1:7})
 std_data = std(COM_56_Valid, 0,1,'omitnan')
 sem_data_56 = std_data/ sqrt(size(Paths,1));
 mean56 = mean(COM_56_Valid);

  std_data = std(COM_3545_Valid, 0,1,'omitnan')
 sem_data_3545 = std_data/ sqrt(size(Paths,1));
 mean3545 = mean(COM_3545_Valid);

   data3545 = [mean3545/500, sem_data_3545/500]
 data56= [mean56/500, sem_data_56/500]
    EffectNonWarpCohen = meanEffectSize(COM_56_Valid/500, COM_3545_Valid/500, Effect = 'cohen')
    EffectNonWarpMeanDiff = meanEffectSize(COM_56_Valid/500, COM_3545_Valid/500)

   figure('Units', 'pixels', 'Position', [100, 100, 300, 400])
    hold on
    % axis square
     [p,h] = kstest2(COM_3545_Valid, COM_56_Valid)
     [p,h] = ranksum(COM_3545_Valid, COM_56_Valid)
     [p,h] = ttest(COM_3545_Valid, COM_56_Valid)
     subplot(2,1,1)
     hold on
    histogram(COM_3545_Valid, 'BinWidth', 50,  'FaceColor', 'k', 'Normalization', 'probability')
    histogram(COM_56_Valid, 'BinWidth', 50, 'FaceColor',  [0 0.4470 0.7410], 'Normalization', 'probability')
      xlim([0 3000])
      ylim([0 0.2])
    xticks([0:500:3500])
    set(gca, 'FontSize', 12)
    xticklabels(xticklabelsVal)
    xlabel('Time from last lick (s)')
    ylabel('Probability')
    legend({'3s Blocks' '5s Blocks'}, 'location', 'northeast')
    title('Center of mass')
 subplot(2,1,2)
    hold on
 load('Z:\Kori\immobile_code\BlockDelay\RiseDown\FR_Profiles\OverlapPAC\PAC_COM_Warp_0-Warp_normTogetherOverlap\COM_Blocks_Norm_Warp_Lick3000.mat')
    
  com_3s = com_3s/3000;
    com_5s = com_5s/3000;
  

 histogram(com_3s, 'BinWidth', 0.015,  'FaceColor', 'k', 'Normalization', 'probability')
    histogram(com_5s, 'BinWidth', 0.015, 'FaceColor',  [0 0.4470 0.7410], 'Normalization', 'probability')
    xlim([0 1])
     ylim([0 0.2])
    xticks([0 1])
    set(gca, 'FontSize', 12)
    xticklabels({'Last Lick' "First Lick"})
    xlabel('Norm. time')
    ylabel('Probability')
   
T = ['COM_overlap_Pacs']
    print('-painters','-dpng',[T '2plots' 'sq'],'-r600');
       print('-painters','-dpdf',[T '2plots' 'sq'],'-r600');
   savefig([T '2plots' 'sq' '.fig'])

    std_data = std(com_5s, 0,1,'omitnan');
 sem_data_56 = std_data/ sqrt(size(Paths,1));
 mean56 = mean(com_5s);

  std_data = std(com_3s, 0,1,'omitnan');
 sem_data_3545 = std_data/ sqrt(size(Paths,1));
 mean3545 = mean(com_3s);

   data3545 = [mean3545, sem_data_3545]
 data56= [mean56, sem_data_56]
    [p,h] = kstest2(com_3s, com_5s)
    EffectWarpCohen = meanEffectSize(com_5s, com_3s, Effect = 'cohen')
    EffectWarpMeanDiff = meanEffectSize(com_5s, com_3s)
 'stop'


end