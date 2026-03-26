%% plot rise curves
path = ['Z:\Kori\immobile_code\Ephys\RiseDown\FRprofiles\PAC\0217\']
cd(path)
for cond = 2

    if cond == 2
        condstr = 'LastLick';
        namex = ['Time from last lick (s)'];
    elseif cond ==3 
        condstr = 'Rew'
        namex = ['Time from reward (s)'];
    elseif cond == 4
        condstr = 'Lick'
         namex = ['Time from lick (s)'];
       elseif cond == 1
        condstr = 'Cue'
         namex = ['Time from cue onset (s)'];
    end
load('FR_ArrayNormTogether_-2-9.mat')

      cd(path)
      foldername = ['plots'];   
      mkdir(foldername)  
      savepath = [path foldername]
      cd(savepath)
 % %plot mean all 
 timeStepRunNew = timeStepRun/1250;
 figure
 hold on
 avg_data = mean(AvgFR_4555);
  x = 1:size(avg_data,2);
 std_data = std(AvgFR_4555, 0,1,'omitnan')
 std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0.2 0.2 0.2], 'FaceAlpha',0.5)
plot(x, avg_data, 'k', 'LineWidth', 4)

 avg_data = mean(AvgFR_67);
 x = 1:size(avg_data,2);
 std_data = std(AvgFR_67, 0,1,'omitnan')
std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0 0.4470 0.7410], 'FaceAlpha',0.3)

   plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth', 4)
 

 % legend({'','4.5-5.5s', '', '6-7s',}, 'Location', 'best')
 legend({'','Early lick', '', 'Late lick',}, 'Location', 'best')
  set(gcf, 'Position', [100 100  550 522]);

  xlim([find(timeStepRunNew == -2) find(timeStepRunNew == 7)]);
ylim([0 0.7])
yticks(0:0.2:0.8)
   xticks(1201:400:4801);
   xticklabels([-2 -1 0 1 2 3 4 5 6 7 8 9]);
   xlabel(namex)
   ylabel('Normalized firing rate ')
  set(gca, 'FontSize', 20)
  T = [condstr 'normTogether ' '4555'];
  savefig([T '.fig'])
  print('-painters','-dpng', [T '.png'], '-r600')
   print('-painters','-dpdf', [T '.pdf'], '-r600')






end