load('Z:\Kori\RunningTask2pCode\RiseDown\tables\ZY\PACRiseDownArray.mat')
path = ['Z:\Kori\RunningTask2pCode\RiseDown\tables\ZY\']

Mean23 = mean(FR_Array_sorted_23);
 Mean23Norm =  (Mean23 - min(Mean23))/(max(Mean23) - min(Mean23));

Mean1525 = mean(FR_Array_sorted_1525);
 Mean1525Norm =  (Mean1525 - min(Mean1525))/(max(Mean1525) - min(Mean1525));

 Mean34 = mean(FR_Array_sorted_34);
 
 Mean34Norm =  (Mean34 - min(Mean34))/(max(Mean34) - min(Mean34));

  Mean3545 = mean(FR_Array_sorted_3545);

  
      foldername = ['plots'];   
      mkdir(foldername)  
      savepath = [path foldername]
      cd(savepath)
namex = 'Time from last lick (s)'
% % %plot mean all 
%  figure
%  hold on
%    avg_data = Mean23;
%   x = 1:size(Mean23,2);
%  std_data = std(FR_Array_sorted_23, 0,1,'omitnan')
%  std_data = std_data/ sqrt(7);
% fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0.2 0.2 0.2], 'FaceAlpha',0.5)
% plot(x, avg_data, 'k', 'LineWidth', 4)
% 
%   avg_data = Mean3545;
%   x = 1:size(Mean3545,2);
%  std_data = std(FR_Array_sorted_3545, 0,1,'omitnan')
% std_data = std_data/ sqrt(7);
% fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0 0.4470 0.7410], 'FaceAlpha',0.3)
% 
%    plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth', 4)
%  legend({'','2-3s', '','3.5-4.5s',}, 'Location', 'best')
%    set(gcf, 'Position', [100 100  550 522]);
%  xlim([500 4500])
%  xticklabels({'-2', '-1', '0', '1', '2', '3', '4', '5', '6'})
%  xlabel(namex)
%  ylabel('dF/F')
%  axis square
%  ylim([0 1])
%   set(gca, 'FontSize', 24)
%   T = [ 'All Neur Avg dFF norm -3545'];
%   savefig([T '.fig'])
%    print('-painters','-dpdf', [T '.pdf'], '-r600')
%   print('-painters','-dpng', [T '.png'], '-r600')
% 


 
   figure('Units', 'pixels', 'Position', [100, 100, 300, 400])
     subplot(2,1,1)   
 hold on

   avg_data = Mean23;
  x = 1:size(Mean23,2);
 std_data = std(FR_Array_sorted_23, 0,1,'omitnan')
 std_data = std_data/ sqrt(7);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0.2 0.2 0.2], 'FaceAlpha',0.5)
plot(x, avg_data, 'k', 'LineWidth', 3)

  avg_data = Mean3545;
  x = 1:size(Mean3545,2);
 std_data = std(FR_Array_sorted_3545, 0,1,'omitnan')
std_data = std_data/ sqrt(7);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0 0.4470 0.7410], 'FaceAlpha',0.3)

   plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth',3)
 legend({'','2-3s', '','3.5-4.5s',}, 'Location', 'best')
   % set(gcf, 'Position', [100 100  550 522]);
  xticks(0:500:5000)
 xticklabels({'-3' '-2', '-1', '0', '1', '2', '3', '4', '5', '6', '7', '8'})
  xlim([500 4500])
 xlabel(namex)
 ylabel('dF/F')

 ylim([0 1])
  set(gca, 'FontSize', 11)

subplot(2,1,2)
hold on

load('Z:\Kori\RunningTask2pCode\RiseDown\FR_profiles\ZY\TimewarpMatrix2250.mat')

   avg_data = mean(PrePostEarly(:,1:4500));
  x = 1:size(avg_data,2);
 std_data = std(PrePostEarly(:,1:4500), 0,1,'omitnan')
 std_data = std_data/ sqrt(7);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0.2 0.2 0.2], 'FaceAlpha',0.5)
plot(x, avg_data, 'k', 'LineWidth', 3)

  avg_data = mean(PrePostLate(:,1:4500));
  x = 1:size(avg_data,2);
 std_data = std(PrePostLate(:,1:4500), 0,1,'omitnan')
std_data = std_data/ sqrt(7);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0 0.4470 0.7410], 'FaceAlpha',0.3)
   plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth', 3)
 
   % set(gcf, 'Position', [100 100  550 522]);
 
 xticks(0:500:5000)
  
 xticks([1000 3250])
 xticklabels({'Last Lick' 'First Lick'})

  xlim([1 4500])
 xlabel(namex)
 ylabel('dF/F')

 ylim([0 1])
  set(gca, 'FontSize', 11)


  T = [ 'PAC_warpNonWarp'];
  savefig([T '.fig'])
   print('-painters','-dpdf', [T '.pdf'], '-r600')
  print('-painters','-dpng', [T '.png'], '-r600')
% 

  % % %plot mean all 

