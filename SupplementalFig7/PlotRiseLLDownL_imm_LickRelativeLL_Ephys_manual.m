function PlotRiseLLDownL_imm_LickRelativeLL_Ephys_manual(cond)

        
        if cond == 1
         CondStr = 'Cue';
         namex = 'Time from cue onset (s)';
        elseif cond == 2
         CondStr = 'LastLick';   
         namex = 'Time from last lick (s)';
        elseif cond == 3
          CondStr = 'Rew';
           namex = 'Time from reward (s)';
          elseif cond == 4
          CondStr = 'Lick';
         namex = 'Time from first lick (s)';
        end  

    fr_profile_path = ['Z:\Kori\immobile_code\Ephys\RiseDown\FRprofiles\FRprofileTable_align' CondStr 'PAC.mat'];
    PACPath = ['Z:\Kori\immobile_code\Ephys\RiseDown\tables\'];
     
    tablePath = ['Z:\Kori\immobile_code\Ephys\RiseDown\tables\'];
    save_path2 = tablePath;
    load(fr_profile_path, 'avgFR_profile', 'avgFR_profile_45_NotNorm',  'avgFR_profile_67_NotNorm', 'avgFR_profile_5565', 'avgFR_profile_45', 'avgFR_profile_23', 'avgFR_profile_67', 'avgFR_profile_4555', 'avgFR_profile_3545', 'avgFR_profile_34', 'avgFR_profile_56', 'neu_id', 'rec_name', 'timeStepRun');

    cd(PACPath)
     load('RiseLastLickDownLickNeurons_manual.mat')


    [~,sorted_All_ind]  = sort(PAC_Cat.ratio0to1BefRun, 'ascend'); 


     SortedIDTable = PAC_Cat(sorted_All_ind,:);
     save('SortedIDTable.mat', 'SortedIDTable')


    FR_Array_sorted = [];
     
    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(PAC_Cat.rec_name(ind_i), rec_name) & PAC_Cat.neu_id(ind_i) == neu_id;
       fr_profile_i = avgFR_profile(FR_profile_ind,:);
        
        FR_Array_sorted = [fr_profile_i/max(fr_profile_i); FR_Array_sorted];
  
    end

      FR_Array_sorted(any(isnan(FR_Array_sorted), 2), :) = [];
  
   
    FR_Array_sorted_56 = [];
     
    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(PAC_Cat.rec_name(ind_i), rec_name) & PAC_Cat.neu_id(ind_i) == neu_id;
       fr_profile_i = avgFR_profile_56(FR_profile_ind,:);
        
        FR_Array_sorted_56 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_56];
  
    end
    
     FR_Array_sorted_56(any(isnan(FR_Array_sorted_56), 2), :) = [];
  
       FR_Array_sorted_3545 = [];
   for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(PAC_Cat.rec_name(ind_i), rec_name) & PAC_Cat.neu_id(ind_i) == neu_id;
        fr_profile_i = avgFR_profile_3545(FR_profile_ind,:);
        
        FR_Array_sorted_3545 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_3545];
  
   end
   
     FR_Array_sorted_3545(any(isnan(FR_Array_sorted_3545), 2), :) = [];
% % % 
 
FR_Array_sorted_4555 = [];
   for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(PAC_Cat.rec_name(ind_i), rec_name) & PAC_Cat.neu_id(ind_i) == neu_id;
        fr_profile_i = avgFR_profile_4555(FR_profile_ind,:);
        
        FR_Array_sorted_4555 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_4555];
  
   end
   
 FR_Array_sorted_4555(any(isnan(FR_Array_sorted_4555), 2), :) = [];




FR_Array_sorted_67 = [];
   for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(PAC_Cat.rec_name(ind_i), rec_name) & PAC_Cat.neu_id(ind_i) == neu_id;
        fr_profile_i = avgFR_profile_67(FR_profile_ind,:);
        
        FR_Array_sorted_67 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_67];
  
   end
   
 FR_Array_sorted_67(any(isnan(FR_Array_sorted_67), 2), :) = [];

 FR_Array_sorted_67_NotNorm = [];
   for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(PAC_Cat.rec_name(ind_i), rec_name) & PAC_Cat.neu_id(ind_i) == neu_id;
        fr_profile_i = avgFR_profile_67_NotNorm(FR_profile_ind,:);
        
        FR_Array_sorted_67_NotNorm = [fr_profile_i; FR_Array_sorted_67_NotNorm];
  
   end
   
 FR_Array_sorted_67_NotNorm(any(isnan(FR_Array_sorted_67_NotNorm), 2), :) = [];

 %  FR_Array_sorted_45_NotNorm = [];
 %   for i = 1:length(sorted_All_ind)
 %        ind_i = sorted_All_ind(i);
 %        FR_profile_ind = strcmp(PAC_Cat.rec_name(ind_i), rec_name) & PAC_Cat.neu_id(ind_i) == neu_id;
 %        fr_profile_i = avgFR_profile_45_NotNorm(FR_profile_ind,:);
 % 
 %        FR_Array_sorted_45_NotNorm = [fr_profile_i; FR_Array_sorted_45_NotNorm];
 % 
 %   end
 % FR_Array_sorted_45_NotNorm(any(isnan(FR_Array_sorted_45_NotNorm), 2), :) = [];


   cd(save_path2)

   figure
   hold  on;
   % imagesc(flipud(FR_Array_sorted));
   imagesc((FR_Array_sorted));
   colormap gray
   cm = colormap;
   colormap(flipud(cm));
   set(gcf, 'Position', [100 100  550 522]);
    xlim([find(timeStepRun == -2000), find(timeStepRun == 9000)]);
   x_tick_pos = [find(timeStepRun == -2000), find(timeStepRun == -1000), find(timeStepRun == 0), find(timeStepRun == 1000),...
                 find(timeStepRun == 2000), find(timeStepRun == 3000), find(timeStepRun == 4000), find(timeStepRun == 5000), find(timeStepRun == 6000),...
                 find(timeStepRun == 7000), find(timeStepRun == 8000), find(timeStepRun == 9000)];     
   xticks(x_tick_pos);
   xticklabels([-2 -1 0 1 2 3 4 5 6 7 8 9]);
   plot(find(timeStepRun == 0)*[1 1], ylim, 'm--', 'LineWidth', 3); 
   ax = gca;
   ax.FontSize = 20;
 
   
   
    
   ylim([0. size(FR_Array_sorted,1)])
   set(gca, 'ytick', 0:20:size(FR_Array_sorted,1));
   ylabel('Neuron No.');
   xlabel(namex);
 
   save_path1  = ['RiseLLDownL-' CondStr  'manual'];
   savefig([save_path1 '.fig'])
   print('-painters','-dpng', [save_path1 '.png'], '-r600')
   print('-painters','-dpdf', [save_path1], '-r600')
    %%%%%%%%%%%

  
    figure
  hold on;
  % imagesc(flipud(FR_Array_sorted_3545));
  imagesc((FR_Array_sorted_4555));
  colormap(flipud(cm));
  % set(gcf,'Position', [242 416 500 400])    
  set(gcf, 'Position', [100 100  550 522]);
  xlim([find(timeStepRun == -2000), find(timeStepRun == 9000)]);
   x_tick_pos = [find(timeStepRun == -2000), find(timeStepRun == -1000), find(timeStepRun == 0), find(timeStepRun == 1000),...
                 find(timeStepRun == 2000), find(timeStepRun == 3000), find(timeStepRun == 4000), find(timeStepRun == 5000), find(timeStepRun == 6000),...
                 find(timeStepRun == 7000), find(timeStepRun == 8000), find(timeStepRun == 9000)];     
   xticks(x_tick_pos);
   xticklabels([-2 -1 0 1 2 3 4 5 6 7 8 9]);
    plot(find(timeStepRun == 0)*[1 1], ylim, 'm--', 'LineWidth', 3); 
  ax = gca;
  ax.FontSize = 16;
    
    ylim([0. size(FR_Array_sorted_4555,1)])
    set(gca, 'ytick', 0:20:size(FR_Array_sorted_4555,1));
    ylabel('Neurons');
    xlabel(namex);

    save_path1  = ['RiseLLDownL-' CondStr '4555' 'manual'];
    savefig([save_path1 '.fig'])
    print('-painters','-dpng', [save_path1 '.png'], '-r600')
 print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')

    figure
  hold on;
  imagesc((FR_Array_sorted_67));
  colormap(flipud(cm));  
  set(gcf, 'Position', [100 100  550 522]);
   xlim([find(timeStepRun == -2000), find(timeStepRun == 9000)]);
   x_tick_pos = [find(timeStepRun == -2000), find(timeStepRun == -1000), find(timeStepRun == 0), find(timeStepRun == 1000),...
                 find(timeStepRun == 2000), find(timeStepRun == 3000), find(timeStepRun == 4000), find(timeStepRun == 5000), find(timeStepRun == 6000),...
                 find(timeStepRun == 7000), find(timeStepRun == 8000), find(timeStepRun == 9000)];     
   xticks(x_tick_pos);
   xticklabels([-2 -1 0 1 2 3 4 5 6 7 8 9]);
    plot(find(timeStepRun == 0)*[1 1], ylim, 'm--', 'LineWidth', 3); 
  ax = gca;
  ax.FontSize = 17;
    ylim([0. size(FR_Array_sorted_67,1)])
    set(gca, 'ytick', 0:20:size(FR_Array_sorted_56,1));
    ylabel('Neurons');
    xlabel(namex);
    save_path1  = ['RiseLLDownL-' CondStr '67'  'manual'];
    savefig([save_path1 '.fig'])
    print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
    print('-painters','-dpng', [save_path1 '.png'], '-r600')



savename = ['RiseDownArray4555_67' CondStr 'manual' '.mat'];
  save(savename, 'FR_Array_sorted', 'FR_Array_sorted_45_NotNorm', 'FR_Array_sorted_67_NotNorm', 'FR_Array_sorted_45', 'FR_Array_sorted_67','FR_Array_sorted_23', 'FR_Array_sorted_34', 'FR_Array_sorted_4555', 'FR_Array_sorted_3545', 'FR_Array_sorted_56', 'timeStepRun')
 

end