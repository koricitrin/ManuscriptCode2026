function PlotRiseLickDownLL_imm(delay, cond)

        
        if cond == 1
         CondStr = 'Cue';
         namex = 'Time from cue onset (s)';
              linecolor = [0.25 0.25 0.25];
        elseif cond == 2
         CondStr = 'LastLick';   
         namex = 'Time from last lick (s)';
         linecolor = 'm'
          linecolor = [0.6 0.15 0.6];
        elseif cond == 3
          CondStr = 'Rew';
           namex = 'Time from reward (s)';
           linecolor = 'b';
          elseif cond == 4
          CondStr = 'Lick';
         namex = 'Time from first lick (s)';
         linecolor =  'm'
        end  

    BasePath = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\D2\']
    

      fr_profile_path = ['Z:\Kori\immobile_code\RiseDown\FR_profiles\RiseLickDownLL\D2\FRprofileTable_align' CondStr 'dffgfthres.mat'];

    
    save_path = [BasePath];
    
    % save_path = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\LickOn\'];
       load(fr_profile_path, 'avgFR_profile', 'neu_id', 'rec_name', 'timeStepRun');
    % load(fr_profile_path, 'avgFR_profile', 'avgFR_profile_56', 'avgFR_profile_3545','neu_id', 'rec_name', 'timeStepRun');
    cd(BasePath)
    load('RiseLickDownLLNeurons_thres.mat')



  [~,sorted_All_ind]  = sort(RiseLickDownLLRatio.RatioLick, 'descend'); 
 
      
cd(BasePath)
    FR_Array_sorted = [];
     % load('OrderLick.mat')
    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(RiseLickDownLLNeuronID.rec_name(ind_i), rec_name) & RiseLickDownLLNeuronID.neu_id(ind_i) == neu_id;
       fr_profile_i = avgFR_profile(FR_profile_ind,:);
        
        FR_Array_sorted = [fr_profile_i/max(fr_profile_i); FR_Array_sorted];
  
    end

      FR_Array_sorted(any(isnan(FR_Array_sorted), 2), :) = [];
  
    %       FR_Array_sorted_56 = [];
    % 
    % for i = 1:length(sorted_All_ind)
    %     ind_i = sorted_All_ind(i);
    %     FR_profile_ind = strcmp(RiseLickDownLLNeuronID.rec_name(ind_i), rec_name) & RiseLickDownLLNeuronID.neu_id(ind_i) == neu_id;
    %    fr_profile_i = avgFR_profile_56(FR_profile_ind,:);
    % 
    %     FR_Array_sorted_56 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_56];
    % 
    % end
    % 
    %  FR_Array_sorted_56(any(isnan(FR_Array_sorted_56), 2), :) = [];

     % FR_Array_sorted_34 = [];
   %     FR_Array_sorted_3545 = [];
   % for i = 1:length(sorted_All_ind)
   %      ind_i = sorted_All_ind(i);
   %      FR_profile_ind = strcmp(RiseLickDownLLNeuronID.rec_name(ind_i), rec_name) & RiseLickDownLLNeuronID.neu_id(ind_i) == neu_id;
   %      fr_profile_i = avgFR_profile_3545(FR_profile_ind,:);
   % 
   %      FR_Array_sorted_3545 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_3545];
   % 
   % end
   % 
   %   FR_Array_sorted_3545(any(isnan(FR_Array_sorted_3545), 2), :) = [];
% % % 

 cd(save_path)

   figure
  axis equal 

    % imagesc(flipud(FR_Array_sorted));
      imagesc((FR_Array_sorted));
      colormap gray 
      cm = colormap;
      colormap(flipud(cm));
    
      x_tick_pos = [find(timeStepRun == -2), find(timeStepRun == -1), find(timeStepRun == 0), find(timeStepRun == 1),...
                 find(timeStepRun == 2), find(timeStepRun == 3), find(timeStepRun == 4), find(timeStepRun == 5), find(timeStepRun == 6), find(timeStepRun == 7), find(timeStepRun == 8)];
     hold  on;

     xline(1500, '--', 'Color', 'm', 'LineWidth', 3);  

    xticks(x_tick_pos);
    xticklabels([-2 -1 0 1 2 3 4 5 6 7]);
      ax = gca;
    ax.FontSize = 19;
    if(delay == 2)
      xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
  
        elseif(delay == 22)
           xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
     
        elseif(delay == 3)
       xlim([find(timeStepRun == -2), find(timeStepRun == 6)]);
          
        elseif(delay == 4)
              xlim([find(timeStepRun == -2), find(timeStepRun == 6.996)]);
       
    end 
     set(gcf, 'Position', [200 200 540 500])
       % title(T)

   ylim([0 size(FR_Array_sorted,1)])
    set(gca, 'ytick', 0:20:size(FR_Array_sorted,1));
   set(gca,'YDir','normal')
    ylabel('Neurons');
    axis square
        xlabel(namex);
% title('OrderLL')
        
   % set(gcf, 'Position', [242 416 1.5*381 1.5*591]);
    set(gcf, 'Position', [100 100  550 420]);

    cd(save_path)
    
      save_path1  = ['RiseLickDownLL-' CondStr 'thres' 'orderLL'];
   
    savefig([save_path1 '.fig'])
    save_path_png = [save_path1 '.png'];
    print('-painters','-dpng', [save_path1 '.png'], '-r600')

    print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
    %%%%%%%%%%%

       figure
   hold  on; 
   % imagesc(flipud(FR_Array_sorted_56));
  imagesc((FR_Array_sorted_56));
   colormap(flipud(cm));
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
   set(gca, 'ytick', 0:100:size(FR_Array_sorted_56,1));
   ylabel('Neuron No.');
   xlabel(namex);

   save_path1  = ['RiseLickDownLL-' CondStr '56'];
   savefig([save_path1 '.fig']) 
   print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
   print('-painters','-dpng', [save_path1 '.png'], '-r600')
    %%%%%%%%%%%


  figure
  hold on;
  % imagesc(flipud(FR_Array_sorted_3545));
  imagesc((FR_Array_sorted_3545));
  colormap(flipud(cm));
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
    set(gca, 'ytick', 0:100:size(FR_Array_sorted_3545,1));
    ylabel('Neuron No.');
    xlabel(namex);

    save_path1  = ['RiseLickDownLL-' CondStr '3545'];
    savefig([save_path1 '.fig'])
    print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
    print('-painters','-dpng', [save_path1 '.png'], '-r600')
    %%%%%%%%%%%   figure
   hold  on; 
   % imagesc(flipud(FR_Array_sorted_56));
  imagesc((FR_Array_sorted_56));
   colormap(flipud(cm));
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
   set(gca, 'ytick', 0:100:size(FR_Array_sorted_56,1));
   ylabel('Neuron No.');
   xlabel(namex);

   save_path1  = ['RiseLickDownLL-' CondStr '56'];
   savefig([save_path1 '.fig']) 
   print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
   print('-painters','-dpng', [save_path1 '.png'], '-r600')
    %%%%%%%%%%%


  figure
  hold on;
  % imagesc(flipud(FR_Array_sorted_3545));
  imagesc((FR_Array_sorted_3545));
  colormap(flipud(cm));
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
    set(gca, 'ytick', 0:100:size(FR_Array_sorted_3545,1));
    ylabel('Neuron No.');
    xlabel(namex);

    save_path1  = ['RiseLickDownLL-' CondStr '3545'];
    savefig([save_path1 '.fig'])
    print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
    print('-painters','-dpng', [save_path1 '.png'], '-r600')
    %%%%%%%%%%%

end