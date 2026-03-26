% % rise curves block delay 

figs =2 
path = ['Z:\Kori\immobile_code\BlockDelay\RiseDown\FR_Profiles\OverlapPAC\']
cd(path)
load('DataNormTogetherBlock_AllPAC.mat')
 
   cd(path)
      foldername = ['plotsNormTogether'];   
      mkdir(foldername)  
      savepath = [path foldername]
      cd(savepath)

% % %plot mean all 
if figs == 1
 figure
 hold on
    avg_data = mean(Block3sArrayNormTogether_PAC);
  x = 1:size(avg_data,2);
 std_data = std(Block3sArrayNormTogether_PAC, 0,1,'omitnan')
 std_data = std_data/ sqrt(5);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0.2 0.2 0.2], 'FaceAlpha',0.5)
plot(x, avg_data, 'k', 'LineWidth', 4)

  avg_data = mean(Block5sArrayNormTogether_PAC);;
  x = 1:size(avg_data,2);
 std_data = std(Block5sArrayNormTogether_PAC, 0,1,'omitnan')
std_data = std_data/ sqrt(5);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0 0.4470 0.7410], 'FaceAlpha',0.3)
 plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth', 4)

 % plot((Mean3sDelayNorm), 'LineWidth', 3, 'Color', 'k')
 % plot((Mean5sDelayNorm), 'LineWidth', 3, 'Color', [0 0.4470 0.7410]) 
 legend({'','3s delay', '', '5s delay',}, 'Location', 'best')
   set(gcf, 'Position', [100 100  550 522]);
 xlim([500 5000])
 xticklabels({'-2', '-1', '0', '1', '2', '3', '4', '5', '6', '7', '8'})
 xlabel('Time from last lick (s)')
 ylabel('dF/F ')
 ylim([0 1])
  set(gca, 'FontSize', 20)
  T = ['PAC Avg - Block Delay ' 'ylim'];
  savefig([T '.fig'])
   print('-painters','-dpdf', [T '.pdf'], '-r600')
  print('-painters','-dpng', [T '.png'], '-r600')
elseif figs ==2


   figure('Units', 'pixels', 'Position', [100, 100, 300, 400])
     subplot(2,1,1)
     
 hold on
    avg_data = mean(Block3sArrayNormTogether_PAC);
  x = 1:size(avg_data,2);
 std_data = std(Block3sArrayNormTogether_PAC, 0,1,'omitnan')
 std_data = std_data/ sqrt(5);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0.2 0.2 0.2], 'FaceAlpha',0.5)
plot(x, avg_data, 'k', 'LineWidth', 4)

  avg_data = mean(Block5sArrayNormTogether_PAC);;
  x = 1:size(avg_data,2);
 std_data = std(Block5sArrayNormTogether_PAC, 0,1,'omitnan')
std_data = std_data/ sqrt(5);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0 0.4470 0.7410], 'FaceAlpha',0.3)
 plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth', 4)
 
 % legend({'','3s delay', '', '5s delay',}, 'Location', 'best')
 xticks(0:500:5000)

 xticklabels({'-3' '-2', '-1', '0', '1', '2', '3', '4', '5', '6', '7', '8'})
  xlim([500 5000])
 
 xlabel('Time from last lick (s)')
 ylabel('dF/F ')
 ylim([0 1])
  set(gca, 'FontSize', 10)

 subplot(2,1,2)
 cd('Z:\Kori\immobile_code\BlockDelay\RiseDown\FR_Profiles\OverlapPAC\')
 load('TimewarpMatrixDelay3000.mat')
 hold on
 % title('Time warped')
    avg_data = mean(PrePost3s);
  x = 1:size(avg_data,2);
 std_data = std(PrePost3s, 0,1,'omitnan')
 std_data = std_data/ sqrt(5);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0.2 0.2 0.2], 'FaceAlpha',0.5)
plot(x, avg_data, 'k', 'LineWidth', 3)

  avg_data = mean(PrePost5s);;
  x = 1:size(avg_data,2);
 std_data = std(PrePost5s, 0,1,'omitnan')
std_data = std_data/ sqrt(5);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0 0.4470 0.7410], 'FaceAlpha',0.3)
 plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth', 3)
 
 xlim([1 5000])
 xticks([1000 4000])
 xticklabels({'Last Lick' 'First Lick'})
 xlabel('Norm. time')
 ylabel('dF/F ')
 ylim([0 1])
  set(gca, 'FontSize', 10)
  T = ['PAC Avg - Block Delay ' '2plots'];
    cd(savepath)

  savefig([T '.fig'])
   print('-painters','-dpdf', [T '.pdf'], '-r600')
  print('-painters','-dpng', [T '.png'], '-r600')
end