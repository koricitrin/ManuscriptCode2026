%%plot overlap PACS block

cd('Z:\Kori\immobile_code\BlockDelay\RiseDown\FR_Profiles\OverlapPAC\')

load('FRprofileTable_alignLastLickOverlapPacs.mat')
load('Ratios3sOverlap.mat')

  [~,sorted_All_ind]  = sort(catRatios3s, 'ascend');

  figure
  hold on 
imagesc(avgFR_profile_5sDelay(sorted_All_ind,:))

colormap gray
   cm = colormap;
   colormap(flipud(cm));
   set(gcf, 'Position', [100 100  550 522]);
   x_tick_pos = [find(timeStepRun == -2), find(timeStepRun == -1), find(timeStepRun == 0), find(timeStepRun == 1),...
                 find(timeStepRun == 2), find(timeStepRun == 3), find(timeStepRun == 4), find(timeStepRun == 5), find(timeStepRun == 6), find(timeStepRun == 7), find(timeStepRun == 8)];     
   xticks(x_tick_pos);
   xticklabels([-2 -1 0 1 2 3 4 5 6 7 8]);
   plot(find(timeStepRun == 0)*[1 1], ylim, 'm--', 'LineWidth', 3); 
   ax = gca;
   ax.FontSize = 24;

        xlim([find(timeStepRun == -2), find(timeStepRun == 6.996)]);
    
   ylim([0. size(avgFR_profile_5sDelay,1)])
   set(gca, 'ytick', 0:50:size(avgFR_profile_5sDelay,1));
   ylabel('Neurons');
   xlabel('Time from last lick (s)');
 
   save_path1  = ['PAC-overlap5s'];
   savefig([save_path1 '.fig'])
     print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
   print('-painters','-dpng', [save_path1 '.png'], '-r600')
    %%%%%%%%%%%

  figure
  hold on 
imagesc(avgFR_profile_3sDelay(sorted_All_ind,:))

colormap gray
   cm = colormap;
   colormap(flipud(cm));
   set(gcf, 'Position', [100 100  550 522]);
   x_tick_pos = [find(timeStepRun == -2), find(timeStepRun == -1), find(timeStepRun == 0), find(timeStepRun == 1),...
                 find(timeStepRun == 2), find(timeStepRun == 3), find(timeStepRun == 4), find(timeStepRun == 5), find(timeStepRun == 6), find(timeStepRun == 7), find(timeStepRun == 8)];     
   xticks(x_tick_pos);
   xticklabels([-2 -1 0 1 2 3 4 5 6 7 8]);
   plot(find(timeStepRun == 0)*[1 1], ylim, 'm--', 'LineWidth', 3); 
   ax = gca;
   ax.FontSize = 24;

        xlim([find(timeStepRun == -2), find(timeStepRun == 6.996)]);
    
   ylim([0. size(avgFR_profile_3sDelay,1)])
   set(gca, 'ytick', 0:50:size(avgFR_profile_3sDelay,1));
   ylabel('Neurons');
   xlabel('Time from last lick (s)');
 
   save_path1  = ['PAC-overlap3s'];
   savefig([save_path1 '.fig'])
     print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
   print('-painters','-dpng', [save_path1 '.png'], '-r600')
    %%%%%%%%%%%


    