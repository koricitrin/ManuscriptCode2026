function PlotPAC_COMstats_Run(Paths, savepath, numfigs)

 
COM_23_Cat= [];
COM_3545_Cat = [];
    for k = 1:size(Paths)
        path = Paths(k,:);
        cd([path '\PAC_COM_EarlyLate\'])
        load('COM_NormTogether.mat')
      
        COM_3545_Cat = [COM_3545_Cat; com_3545];
        COM_23_Cat = [COM_23_Cat; com_23];
    end
  std_data = std(COM_23_Cat, 0,1,'omitnan')
 sem_data_23 = std_data/ sqrt(size(Paths,1));
 mean23 = mean(COM_23_Cat);

  std_data = std(COM_3545_Cat, 0,1,'omitnan')
 sem_data_3545 = std_data/ sqrt(size(Paths,1));
 mean3545 = mean(COM_3545_Cat);

   data3545 = [mean3545/500, sem_data_3545/500]
 data23= [mean23/500, sem_data_23/500]

   [h,p] =  kstest2(COM_23_Cat, COM_3545_Cat)
    [h,p] =  ranksum(COM_23_Cat, COM_3545_Cat)
     [h,p] =  ttest(COM_23_Cat, COM_3545_Cat)
   EffectNonWarpCohen = meanEffectSize(COM_3545_Cat/500, COM_23_Cat/500, Effect = 'cohen')
    EffectNonWarpMeanDiff = meanEffectSize(COM_3545_Cat/500, COM_23_Cat/500)
     if numfigs == 1 
            % cd(savepath)
            figure
            hold on
            axis square
            histogram(COM_23_Cat, 'BinWidth', 50,  'FaceColor', 'k', 'Normalization', 'probability')
            histogram(COM_3545_Cat, 'BinWidth', 50, 'FaceColor',  [0 0.4470 0.7410],'Normalization', 'probability')
             xlim([0 2500])
            xticks([0:500:3500])
            ylim([0 0.12])
            set(gca, 'FontSize', 20)
            xticklabels({0:1:7})
            xlabel('Time from last lick (s)')
            ylabel('Probability')
            legend({'Early lick' 'Late lick'}, 'location', 'best')
            T = ['PAC-COM-3545_05']
            title('Center of mass')
            print('-painters','-dpng',[T],'-r600');
             print('-painters','-dpdf',[T],'-r600');
           savefig([T '.fig'])
     elseif numfigs ==2 

         T = ['PAC_EarlyLate_COM']
            figure('Units', 'pixels', 'Position', [100, 100, 300, 400])
     
    % axis square
     subplot(2,1,1)
    hold on
    histogram(COM_23_Cat, 'BinWidth', 50,  'FaceColor', 'k', 'Normalization', 'probability')
    histogram(COM_3545_Cat, 'BinWidth', 50, 'FaceColor',  [0 0.4470 0.7410], 'Normalization', 'probability')
    xlim([0 3000])
    xticks([0:500:3500])
    ylim([0 0.2])
    set(gca, 'FontSize', 12)
     xticklabels({0:1:7})
    title('Center of mass')
    xlabel('Time from last lick (s)')
    ylabel('Probability')
    legend({'Early lick' 'Late lick'}, 'location', 'northeast')
      subplot(2,1,2)
      hold on

        load('Z:\Kori\RunningTask2pCode\RiseDown\FR_profiles\ZY\PAC_COM_EarlyLate\COM_Warp.mat')

com_23 = com_23/3000;
com_3545 = com_3545/3000;
     histogram(com_23, 'BinWidth', 0.015,  'FaceColor', 'k', 'Normalization', 'probability')
    histogram(com_3545, 'BinWidth', 0.015, 'FaceColor',  [0 0.4470 0.7410], 'Normalization', 'probability')
    
    [p,h] = kstest2(com_3545, com_23)
 

     std_data = std(com_3545, 0,1,'omitnan')
     sem_data_3545 = std_data/ sqrt(size(Paths,1));
     mean3545 = mean(com_3545);

     std_data = std(com_23, 0,1,'omitnan')
     sem_data_23 = std_data/ sqrt(size(Paths,1));
     mean23= mean(com_23);
     data23 = [mean23, sem_data_23]
     data3545= [mean3545, sem_data_3545]

    EffectWarpCohen = meanEffectSize(com_3545, com_23, Effect = 'cohen')
    EffectWarpMeanDiff = meanEffectSize(com_3545, com_23)
    xlim([0 1])
    xticks([0 1])
     ylim([0 0.2])
    set(gca, 'FontSize', 12)
    xticklabels({'Last Lick' "First Lick"})
    xlabel('Norm. Time')
    ylabel('Probability')
    cd('Z:\Kori\RunningTask2pCode\RiseDown\FR_profiles\ZY\PAC_COM_EarlyLate\')
    TT = [T '2plotsRect']
    print('-painters','-dpng',[TT],'-r600');
    print('-painters','-dpdf',[TT],'-r600');
   savefig([TT '.fig'])

     end
end