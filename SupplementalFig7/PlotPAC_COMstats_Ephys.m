function PlotPAC_COMstats_Ephys(Paths, savepath, plotnum)


COM_45_Cat = [];
COM_67_Cat= [];
COM_3545_Cat = [];
COM_4555_Cat = [];
COM_56_Cat= [];

    for k = 1:size(Paths)
        path = Paths(k,:);
        cd([path '\PAC_COM_EarlyLate\'])
        load('COM_NormTogether_07.mat')
        % COM_45_Cat = [com_45; COM_45_Cat];
        COM_67_Cat = [COM_67_Cat; com_67];
        % COM_3545_Cat = [com_3545; COM_3545_Cat];
        COM_4555_Cat = [com_4555; COM_4555_Cat];
        % COM_56_Cat = [COM_56_Cat; com_56];
    end
    COM_67_Cat_Sec = COM_67_Cat/400;
    COM_4555_Cat_Sec = COM_4555_Cat/400;
   

 %  %%kickout outliers
 %  Ind_3545 = (COM_3545_Cat > 0) & (COM_3545_Cat <3500);
 %  Ind_56 = (COM_56_Cat > 0) & (COM_56_Cat <3500);
 % Sum_Ind =    Ind_3545 + Ind_56;
 % ValidIndex =  Sum_Ind == 2; 
 % 
 % COM_3545_Valid = COM_3545_Cat(ValidIndex);
 % COM_56_Valid =  COM_56_Cat(ValidIndex);
% [h,p] = ranksum(COM_3545_Cat_Sec, COM_56_Cat_Sec)
[h,p] = kstest2(COM_4555_Cat_Sec, COM_67_Cat_Sec)

 std_data = std(COM_4555_Cat_Sec, 0,1,'omitnan');
 sem_data_4555 = std_data/ sqrt(size((Paths),1));
  data4555 = [mean(COM_4555_Cat_Sec), sem_data_4555]

  std_data = std(COM_67_Cat_Sec, 0,1,'omitnan');
 sem_data_67 = std_data/ sqrt(size((Paths),1));
data67 = [mean(COM_67_Cat_Sec), sem_data_67]

   EffectNonWarpCohen = meanEffectSize(COM_67_Cat_Sec, COM_4555_Cat_Sec, Effect = 'cohen')
    EffectNonWarpMeanDiff = meanEffectSize(COM_67_Cat_Sec,  COM_4555_Cat_Sec)

  cd(savepath)
  if plotnum == 1
    figure
    hold on
    axis square

    histogram(COM_4555_Cat_Sec, 'BinWidth', 0.1,  'FaceColor', 'k', 'Normalization', 'probability')
    histogram(COM_67_Cat_Sec, 'BinWidth', 0.1, 'FaceColor',  [0 0.4470 0.7410], 'Normalization', 'probability')
    ylim([0 0.28])
    xlim([0 7])
    xticks([0:7])
    % xticks([0:500:3500])
    set(gca, 'FontSize', 20)
    % xticklabels({0:1:7})
    xlabel('Time from last lick (s)')
    ylabel('Probability')
    legend({'Early lick' 'Late lick'}, 'location', 'northwest')
    T = ['PAC-COM-normTogether-07']
    title(T)
    print('-painters','-dpdf',[T],'-r600');
    print('-painters','-dpng',[T],'-r600');
    savefig([T '.fig'])
  else
  
      figure('Units', 'pixels', 'Position', [100, 100, 400, 400])
     subplot(2,1,1)
    hold on
    histogram(COM_4555_Cat_Sec, 'BinWidth', 0.1,  'FaceColor', 'k', 'Normalization', 'probability')
    histogram(COM_67_Cat_Sec, 'BinWidth', 0.1, 'FaceColor',  [0 0.4470 0.7410], 'Normalization', 'probability')
    ylim([0 0.28])
    xlim([0 7])
    xticks([0:7])
    % xticks([0:500:3500])
    set(gca, 'FontSize', 14)
    % xticklabels({0:1:7})
    xlabel('Time from last lick (s)')
    ylabel('Probability')
    % legend({'Early lick' 'Late lick'}, 'location', 'northwest')
    title('Center of mass')
        subplot(2,1,2)
        hold on
        load('Z:\Kori\immobile_code\Ephys\RiseDown\FRprofiles\PAC\COM_Norm_Warp.mat')
    histogram(com_4555/2800, 'BinWidth', 0.015,  'FaceColor', 'k', 'Normalization', 'probability')
    histogram(com_67/2800, 'BinWidth', 0.015, 'FaceColor',  [0 0.4470 0.7410], 'Normalization', 'probability')
   
      ylim([0 0.28])
      ylabel('Probability')
    xlim([0 1])
    xticks([0 1])
    xticklabels({'Last Lick' 'First Lick'})
    xlabel('Norm. time')
    set(gca, 'FontSize', 14)
        T = ['PAC-COM-normTogether-07' '2plots']
    print('-painters','-dpdf',[T],'-r600');
    print('-painters','-dpng',[T],'-r600');
    savefig([T '.fig'])

    [h,p] = kstest2(com_4555/2800, com_67/2800)

 std_data = std(com_4555/2800, 0,1,'omitnan');
 sem_data_4555 = std_data/ sqrt(size((Paths),1));
  data4555 = [mean(com_4555/2800), sem_data_4555];

  std_data = std(com_67/2800, 0,1,'omitnan');
 sem_data_67 = std_data/ sqrt(size((Paths),1));
data67 = [mean(com_67/2800), sem_data_67];

   EffectWarpCohen = meanEffectSize(com_67/2800, com_4555/2800, Effect = 'cohen')
    EffectWarpMeanDiff = meanEffectSize(com_67/2800,  com_4555/2800)
  end

end