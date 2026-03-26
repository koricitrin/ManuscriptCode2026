%% plot rise curves

 path = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\FR_Prof\PAC\']
cd(path)
for cond =2

    if cond == 2
        condstr = 'LastLick';
        namex = ['Time from last lick (s)'];
load('FR_Prof_3545_56_normTogether.mat')
   load('FRprofileTable_alignLastLickdffgfthres.mat')
 % load('FRprofileTable_alignLastLickdffgf.mat')
    elseif cond ==3 
        condstr = 'Rew'
        namex = ['Time from reward (s)'];
    elseif cond == 4
        condstr = 'Lick'
         namex = ['Time from lick (s)'];

  load('FRprofileTable_alignLickdffgfthres.mat')

    end


 
 
Mean3545 = mean(avgFR_profile_3545);
Mean3545Norm =  (Mean3545 - min(Mean3545))/(max(Mean3545) - min(Mean3545));
Mean56 = mean(avgFR_profile_56);
Mean56Norm =  (Mean56 - min(Mean56))/(max(Mean56) - min(Mean56));
Mean34 = mean(avgFR_profile_34_NotNorm);
Mean4555 = mean(avgFR_profile_4555_NotNorm);
 
 
 
      cd(path)
      foldername = ['plots'];   
      mkdir(foldername)  
      savepath = [path foldername]
      cd(savepath)

% % %plot mean all 
 figure
 hold on
 % plot((Mean3545), 'LineWidth', 3, 'Color', 'k')
 avg_data = mean(Avg3545);
  x = 1:size(avg_data,2);
 std_data = std(Avg3545, 0,1,'omitnan')
 std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0.2 0.2 0.2], 'FaceAlpha',0.5)
plot(x, avg_data, 'k', 'LineWidth', 4)

 avg_data = mean(Avg56);
  x = 1:size(avg_data,2);
 std_data = std(Avg56, 0,1,'omitnan')
std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0 0.4470 0.7410], 'FaceAlpha',0.3)

   plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth', 4)
 
  legend({'','3.5 to 4.5s', '', '5 to 6s'}, 'Location', 'best')
  % legend({'3 to 4', '4.5 to 5.5s',}, 'Location', 'best')
   set(gcf, 'Position', [100 100  550 522]);
 xlim([500 5000])
 xticklabels({'-2', '-1', '0', '1', '2', '3', '4', '5', '6', '7'})
 xlabel(namex)
 ylabel('dF/F')
  set(gca, 'FontSize', 20)
   ylim([0.1 0.8])

  T = [condstr 'All Neur Avg dFF' 'SEM' 'normTogether' '0-1'];
  savefig([T '.fig'])
  print('-painters','-dpng', [T '.png'], '-r600')
  print('-painters','-dpdf', [T '.pdf'], '-r600')


 % figure
 % hold on
 % plot((Mean34), 'LineWidth', 3, 'Color', 'k')
 % plot((Mean4555), 'LineWidth', 3, 'Color', [0 0.4470 0.7410]) 
 %  % legend({'3.5 to 4.5s', '5 to 6s',}, 'Location', 'best')
 %  legend({'3 to 4', '4.5 to 5.5s',}, 'Location', 'best')
 %   set(gcf, 'Position', [100 100  550 522]);
 % xlim([500 5000])
 % xticklabels({'-2', '-1', '0', '1', '2', '3', '4', '5', '6', '7'})
 % xlabel(namex)
 % ylabel('dF/F')
 %  set(gca, 'FontSize', 24)
 %  T = [condstr 'All Neur Avg dFF - not norm2'];
 %  savefig([T '.fig'])
 %  print('-painters','-dpng', [T '.png'], '-r600')

end