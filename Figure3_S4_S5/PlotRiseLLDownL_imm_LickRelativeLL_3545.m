function PlotRiseLLDownL_imm_LickRelativeLL_3545(delay, cond)

        ytickValue = 100; 

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

     fr_profile_path = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\FR_Prof\FRprofileTable_align' CondStr 'dffgfthres.mat'];
     % fr_profile_path =  ['Z:\Kori\immobile_2p\anmc213\A213-20250914\A213-20250914-02\FRprofileTable_align' CondStr 'dffgfthres.mat']
   save_path = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\'];
  
    
    save_path2 = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\3545\'];

    load(fr_profile_path, 'avgFR_profile', 'avgFR_profile_34_NotNorm', 'avgFR_profile_4555_NotNorm', 'avgFR_profile_RewOmissNext', 'avgFR_profile_RewOmiss', 'avgFR_profile_12', 'avgFR_profile_4555', 'avgFR_profile_3545', 'avgFR_profile_34', 'avgFR_profile_56', 'neu_id', 'rec_name', 'timeStepRun');
    cd(save_path)
    load('RiseLastLickDownLickNeurons_thres.mat')
    cd(save_path2)
    load('All_Recs_RiseDownID_AlignLastLickthres.mat')
    Table3545_Pac = [];
           for i = 1:length(RiseLLDownLickNeuronID.rec_name)
           Ind  =  strcmp(RiseLLDownLickNeuronID.rec_name(i), RiseDownTable.rec_name) & RiseLLDownLickNeuronID.neu_id(i) ==  RiseDownTable.neu_id;
           Table3545_Pac_temp =  [RiseDownTable.rec_name(Ind), RiseDownTable.neu_id(Ind),RiseDownTable.ratio0to1BefRun(Ind)];
             Table3545_Pac = [Table3545_Pac; Table3545_Pac_temp];
           end
      
    [~,sorted_All_ind]  = sort(Table3545_Pac(:,3), 'descend');

 

     
    FR_Array_sorted = [];
     
    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(RiseLLDownLickNeuronID.rec_name(ind_i), rec_name) & RiseLLDownLickNeuronID.neu_id(ind_i) == neu_id;
       fr_profile_i = avgFR_profile(FR_profile_ind,:);
        
        FR_Array_sorted = [fr_profile_i/max(fr_profile_i); FR_Array_sorted];
  
    end

      FR_Array_sorted(any(isnan(FR_Array_sorted), 2), :) = [];
  
 
  
   
    FR_Array_sorted_56 = [];

    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(RiseLLDownLickNeuronID.rec_name(ind_i), rec_name) & RiseLLDownLickNeuronID.neu_id(ind_i) == neu_id;
       fr_profile_i = avgFR_profile_56(FR_profile_ind,:);

        FR_Array_sorted_56 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_56];

    end

     FR_Array_sorted_56(any(isnan(FR_Array_sorted_56), 2), :) = [];

%      % FR_Array_sorted_34 = [];
       FR_Array_sorted_3545 = [];
   for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(RiseLLDownLickNeuronID.rec_name(ind_i), rec_name) & RiseLLDownLickNeuronID.neu_id(ind_i) == neu_id;
        fr_profile_i = avgFR_profile_3545(FR_profile_ind,:);

        FR_Array_sorted_3545 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_3545];

   end

     FR_Array_sorted_3545(any(isnan(FR_Array_sorted_3545), 2), :) = [];
% % % 

 
   cd(save_path2)

    %%%%%%%%%%%

   figure
   hold  on; 
  imagesc((FR_Array_sorted_56));
   colormap(flipud(gray));
   set(gcf, 'Position', [100 100  550 522]);
   % set(gcf,  'Position', [242 416 500 400])    
   x_tick_pos = [find(timeStepRun == -2), find(timeStepRun == -1), find(timeStepRun == 0), find(timeStepRun == 1),...
                 find(timeStepRun == 2), find(timeStepRun == 3), find(timeStepRun == 4), find(timeStepRun == 5), find(timeStepRun == 6), find(timeStepRun == 7), find(timeStepRun == 8)];
    plot(find(timeStepRun == 0)*[1 1], ylim, 'm--', 'LineWidth', 3);      
    xticks(x_tick_pos);
    xticklabels([-2 -1 0 1 2 3 4 5 6 7]);
    ax = gca;
    ax.FontSize = 24;

    if(delay == 2)
      xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
      delayStr = '2s';
      Sess = 'Day 2'; 
    elseif(delay == 22)
       xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
       delayStr = '2s';
       Sess = 'Day 4';
     elseif(delay == 3)
       xlim([find(timeStepRun == -2), find(timeStepRun == 6)]);
       delayStr = '3s';
       Sess = 'Day 6';         
     elseif(delay == 4)
        xlim([find(timeStepRun == -2), find(timeStepRun == 6.996)]);
        delayStr = '4s';
        Sess = '4s';
    end 
    
   ylim([0. size(FR_Array_sorted_56,1)])
   set(gca, 'ytick', 0:ytickValue:size(FR_Array_sorted_56,1));
   ylabel('Neuron No.');
   xlabel(namex);

   save_path1  = ['RiseLLDownL-' CondStr '56_order3545'];
   savefig([save_path1 '.fig']) 
   print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
   print('-painters','-dpng', [save_path1 '.png'], '-r600')
    %%%%%%%%%%%


  figure
  hold on;
  imagesc((FR_Array_sorted_3545));
  colormap(flipud(gray));
  % set(gcf,'Position', [242 416 500 400])    
  set(gcf, 'Position', [100 100  550 522]);
  x_tick_pos = [find(timeStepRun == -2), find(timeStepRun == -1), find(timeStepRun == 0), find(timeStepRun == 1),...
                find(timeStepRun == 2), find(timeStepRun == 3), find(timeStepRun == 4), find(timeStepRun == 5), find(timeStepRun == 6), find(timeStepRun == 7), find(timeStepRun == 8)];
  plot(find(timeStepRun == 0)*[1 1], ylim, 'm--', 'LineWidth', 3);      
  xticks(x_tick_pos);
  xticklabels([-2 -1 0 1 2 3 4 5 6 7]);
  ax = gca;
  ax.FontSize = 24;
    if(delay == 2)
      xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
      delayStr = '2s';
      Sess = 'Day 2';
    elseif(delay == 22)
      xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
      delayStr = '2s';
      Sess = 'Day 4';
     elseif(delay == 3)
       xlim([find(timeStepRun == -2), find(timeStepRun == 6)]);
       delayStr = '3s';
       Sess = 'Day 6';
     elseif(delay == 4)
        xlim([find(timeStepRun == -2), find(timeStepRun == 6.996)]);
        delayStr = '4s';
        Sess = '4s';
    end 
    
    ylim([0. size(FR_Array_sorted_3545,1)])
    set(gca, 'ytick', 0:ytickValue:size(FR_Array_sorted_3545,1));
    ylabel('Neuron No.');
    xlabel(namex);

    save_path1  = ['RiseLLDownL-' CondStr '3545_order3545'];
    savefig([save_path1 '.fig'])
    print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
    print('-painters','-dpng', [save_path1 '.png'], '-r600')
    %%%%%%%%%%%

  save('RiseDownArray3545_56_order3545.mat',  'FR_Array_sorted', 'FR_Array_sorted_3545', 'FR_Array_sorted_56')
end

