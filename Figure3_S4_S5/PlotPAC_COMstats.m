function PlotPAC_COMstats(Paths, savepath, PAC, shuff, plotNum)


COM_3545_Cat = []
COM_56_Cat= [];
    for k = 1:size(Paths)
        path = Paths{k,:};
        if PAC == 1
               if shuff == 0 
             cd([path '\PAC_COM_0-6_normTogetherThres'])
             T = ['PAC-COM-normTogether06_thres']
               elseif shuff == 1 
             cd([path '\PAC_COM_0-6_normTogetherShuff\'])
                T = ['PAC-COM-normTogether06_shuff']
             
               end
   
        load('COM_3454_NormTogether.mat')
        COM_3545_Cat = [COM_3545_Cat; com_3545];
        COM_56_Cat = [COM_56_Cat; com_56];
     
          xticklabelsVal = ({0:1:7})
             % xticklabelsVal = ({-2:1:5})
        elseif PAC == 0 
        cd([path '\Field_EarlyLate-2-3\'])
        load('COM_3454_Norm_thres.mat')
        COM_3545_Cat = [COM_3545_Cat; com_3545];
        COM_56_Cat = [COM_56_Cat; com_56];
         T = ['Field-COM-norm']
            xticklabelsVal = ({-2:1:5})
        elseif PAC == 3
        cd([path '\LickON_COM_0-6_normTogether\'])
  load('COM_3454_NormTogether.mat')
        COM_3545_Cat = [COM_3545_Cat; com_3545];
        COM_56_Cat = [COM_56_Cat; com_56];
           T = ['Lickon-COM-normTogether_0-6']
          xticklabelsVal = ({0:1:6})
        end
    end

 %  %%kickout outliers
 %  Ind_3545 = (COM_3545_Cat > 0) & (COM_3545_Cat <3500);
 %  Ind_56 = (COM_56_Cat > 0) & (COM_56_Cat <3500);
 % Sum_Ind =    Ind_3545 + Ind_56;
 % ValidIndex =  Sum_Ind == 2; 
 % 
 % COM_3545_Valid = COM_3545_Cat(ValidIndex);
 % COM_56_Valid =  COM_56_Cat(ValidIndex);

  COM_3545_Valid = COM_3545_Cat;
 COM_56_Valid =  COM_56_Cat;

 std_data = std(COM_56_Valid, 0,1,'omitnan')
 sem_data_56 = std_data/ sqrt(size(Paths,1));
 mean56 = mean(COM_56_Valid);

 std_data = std(COM_3545_Valid, 0,1,'omitnan')
 sem_data_3545 = std_data/ sqrt(size(Paths,1));
 mean3545 = mean(COM_3545_Valid);
 data3545 = [mean3545/500, sem_data_3545/500]
 data56= [mean56/500, sem_data_56/500]
  [p,h] = kstest2(COM_3545_Valid, COM_56_Valid)
     % [p,h] = ranksum(COM_3545_Valid, COM_56_Valid)
     % [p,h] = ttest(COM_3545_Valid, COM_56_Valid)
       EffectNonWarpCohen = meanEffectSize(COM_56_Valid/500, COM_3545_Valid/500, Effect = 'cohen')
    EffectNonWarpMeanDiff = meanEffectSize(COM_56_Valid/500, COM_3545_Valid/500)
  cd(savepath)
  if plotNum ==1
    figure
    hold on
    axis square
   
    histogram(COM_3545_Valid, 'BinWidth', 50,  'FaceColor', 'k', 'Normalization', 'probability')
    histogram(COM_56_Valid, 'BinWidth', 50, 'FaceColor',  [0 0.4470 0.7410], 'Normalization', 'probability')
    xlim([0 3000])
    xticks([0:500:3500])
    ylim([0 0.13])
    set(gca, 'FontSize', 21)
    xticklabels(xticklabelsVal)
    title('Center of mass')
    xlabel('Time from last lick (s)')
    ylabel('Probability')
    legend({'Early lick' 'Late lick'}, 'location', 'northeast')
     
    print('-painters','-dpng',[T],'-r600');
       print('-painters','-dpdf',[T],'-r600');
   savefig([T '.fig'])

  elseif plotNum == 2
  
    figure('Units', 'pixels', 'Position', [100, 100, 400, 400])
     
    % axis square
     subplot(2,1,1)
    hold on
    histogram(COM_3545_Valid, 'BinWidth', 50,  'FaceColor', 'k', 'Normalization', 'probability')
    histogram(COM_56_Valid, 'BinWidth', 50, 'FaceColor',  [0 0.4470 0.7410], 'Normalization', 'probability')
    xlim([0 3000])
    xticks([0:500:3500])
    ylim([0 0.2])
    set(gca, 'FontSize', 12)
    xticklabels(xticklabelsVal)
    title('Center of mass')
    xlabel('Time from last lick (s)')
    ylabel('Probability')
    legend({'Early lick' 'Late lick'}, 'location', 'northeast')
      subplot(2,1,2)
    hold on
    if PAC == 1 
        if shuff == 0
        load('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\FR_Prof\PAC\COM_Norm_Warp3000.mat')
        elseif shuff == 1   
           load('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\Shuff\FR_Prof\COM_Norm_Warp3000.mat')  
           com_56 = com_56/3000;
           com_3545 = com_3545/3000;
        end
    elseif PAC == 3
         load('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\LickOn\PAC_COM_Warp_0-Warp_normTogether\COM_Norm_Warp3000.mat')
         com_56 = com_56/3000;
           com_3545 = com_3545/3000;
    end

     histogram(com_3545, 'BinWidth', 0.015 ,  'FaceColor', 'k', 'Normalization', 'probability')
    histogram(com_56, 'BinWidth', 0.015, 'FaceColor',  [0 0.4470 0.7410], 'Normalization', 'probability')
    
    [p,h] = kstest2(com_3545, com_56)
     % [p,h] = ranksum(com_3545, com_56)
     % [p,h] = ttest(com_3545, com_56)

     std_data = std(com_56, 0,1,'omitnan')
 sem_data_56 = std_data/ sqrt(size(Paths,1));
 mean56 = mean(com_56);

 std_data = std(com_3545, 0,1,'omitnan')
 sem_data_3545 = std_data/ sqrt(size(Paths,1));
 mean3545 = mean(com_3545);
 data3545 = [mean3545, sem_data_3545]
 data56= [mean56, sem_data_56]

    EffectWarpCohen = meanEffectSize(com_56, com_3545, Effect = 'cohen')
    EffectWarpMeanDiff = meanEffectSize(com_56, com_3545)
    xlim([0 1])
    xticks([0 1])
     ylim([0 0.2])
    set(gca, 'FontSize', 12)
    xticklabels({'Last Lick' "First Lick"})
    xlabel('Norm. time')
    ylabel('Probability')
    TT = [T '2plots' '3000' '0-1']
    print('-painters','-dpng',[TT],'-r600');
    print('-painters','-dpdf',[TT],'-r600');
   savefig([TT '.fig'])
  end
end