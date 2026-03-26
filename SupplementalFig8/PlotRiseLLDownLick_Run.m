function PlotRiseLLDownLick_Run(delay, propscale)

    for cond = 2
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
           elseif cond == 5
          CondStr = 'Run';
         namex = 'Time from run onset (s)';
        end  

          tablepath = ['Z:\Kori\RunningTask2pCode\RiseDown\tables\ZY\'];
          fr_profile_path = ['Z:\Kori\RunningTask2pCode\RiseDown\FR_profiles\ZY\FRprofileTable_align' CondStr 'WholePop.mat'];
  
          save_path = tablepath;

          load(fr_profile_path, 'avgFR_profile', 'avgFR_profile_1525', 'avgFR_profile_23', 'avgFR_profile_3545', 'avgFR_profile_34', 'avgFR_profile_4555', 'neu_id', 'rec_name', 'timeStepRun');

           cd(tablepath)
          load('RiseLastLickDownLickNeurons.mat');



    [~,sorted_All_ind]  = sort(RiseLLDownLickRatio.RatioLastLick, 'descend'); 

     % save('LastLickOrder.mat', 'sorted_All_ind')
      % load('LastLickOrder.mat')
    FR_Array_sorted = [];
%     
    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(RiseLLDownLickNeuronID.rec_name(ind_i), rec_name) & RiseLLDownLickNeuronID.neu_id(ind_i) == neu_id;
        fr_profile_i = avgFR_profile(FR_profile_ind,:);
        
        FR_Array_sorted = [fr_profile_i/max(fr_profile_i); FR_Array_sorted];
  
    end

      FR_Array_sorted(any(isnan(FR_Array_sorted), 2), :) = [];

    FR_Array_sorted_1525 = [];
    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(RiseLLDownLickNeuronID.rec_name(ind_i), rec_name) & RiseLLDownLickNeuronID.neu_id(ind_i) == neu_id;
        fr_profile_i = avgFR_profile_1525(FR_profile_ind,:);
        
        FR_Array_sorted_1525 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_1525];
  
    end
   
   FR_Array_sorted_1525(any(isnan(FR_Array_sorted_1525), 2), :) = [];

    FR_Array_sorted_3545 = [];
    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(RiseLLDownLickNeuronID.rec_name(ind_i), rec_name) & RiseLLDownLickNeuronID.neu_id(ind_i) == neu_id;
        fr_profile_i = avgFR_profile_3545(FR_profile_ind,:);
        
        FR_Array_sorted_3545 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_3545];
  
    end
   
   FR_Array_sorted_3545(any(isnan(FR_Array_sorted_3545), 2), :) = [];
    
    
  FR_Array_sorted(any(isnan(FR_Array_sorted), 2), :) = [];

    FR_Array_sorted_23 = [];
    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(RiseLLDownLickNeuronID.rec_name(ind_i), rec_name) & RiseLLDownLickNeuronID.neu_id(ind_i) == neu_id;
        fr_profile_i = avgFR_profile_23(FR_profile_ind,:);
        
        FR_Array_sorted_23 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_23];
  
    end
   
   FR_Array_sorted_23(any(isnan(FR_Array_sorted_23), 2), :) = [];


    FR_Array_sorted_34 = [];
    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(RiseLLDownLickNeuronID.rec_name(ind_i), rec_name) & RiseLLDownLickNeuronID.neu_id(ind_i) == neu_id;
        fr_profile_i = avgFR_profile_34(FR_profile_ind,:);
        
        FR_Array_sorted_34 = [fr_profile_i/max(fr_profile_i); FR_Array_sorted_34];
  
    end
   
   FR_Array_sorted_34(any(isnan(FR_Array_sorted_34), 2), :) = [];

    figure
   hold on
    ax = gca;
    ax.FontSize = 18;
    imagesc((FR_Array_sorted));
     colormap gray
   cm = colormap;
   colormap(flipud(cm));
   axis square
      x_tick_pos = [find(timeStepRun == -2), find(timeStepRun == -1), find(timeStepRun == 0), find(timeStepRun == 1),...
                 find(timeStepRun == 2), find(timeStepRun == 3), find(timeStepRun == 4), find(timeStepRun == 5), find(timeStepRun == 6), find(timeStepRun == 7), find(timeStepRun == 8)];
     hold  on;
    plot(find(timeStepRun == 0)*[1 1], ylim, 'm--', 'LineWidth', 3);      
    xticks(x_tick_pos);
    xticklabels([-2 -1 0 1 2 3 4 5 6 7]);
     ax = gca;
    ax.FontSize = 18;
    set(gca, 'ytick', 0:100:size(FR_Array_sorted,1));
    ylabel('Neuron No.');
    xlabel(namex);
     
    if(delay == 2)
      xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
 
        elseif(delay == 22)
           xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
       
        elseif(delay == 3)
       xlim([find(timeStepRun == -2), find(timeStepRun == 6)]);
         
         
        elseif(delay == 4)
              xlim([find(timeStepRun == -2), find(timeStepRun == 6.996)]);
   
    end 
    
     ylim([0. size(FR_Array_sorted,1)])

    if propscale == 0
     set(gcf, 'Position', [242 416 500 400])
      propstr = ''
    elseif propscale == 1
    PropSigScale =  PropSig*0.8;
     set(gcf, 'Position', [242 416 500 1050*PropSigScale])    
     propstr = 'PropSigScale'
    end
    cd(save_path)
    save_path1  = ['PAC-' CondStr propstr ];
    savefig([save_path1 '.fig'])
    print('-painters','-dpng', [save_path1 '.png'], '-r600')


   figure
   hold on
    ax = gca;
    ax.FontSize = 18;
    imagesc((FR_Array_sorted_23));
     colormap gray
   cm = colormap;
   colormap(flipud(cm));
   axis square
   % set(gcf, 'Position', [100 100  550 522]);
%    plot(find(timeStepRun == 0)*[1 1], ylim, 'r--', 'LineWidth', 1.5);
      x_tick_pos = [find(timeStepRun == -2), find(timeStepRun == -1), find(timeStepRun == 0), find(timeStepRun == 1),...
                 find(timeStepRun == 2), find(timeStepRun == 3), find(timeStepRun == 4), find(timeStepRun == 5), find(timeStepRun == 6), find(timeStepRun == 7), find(timeStepRun == 8)];
     hold  on;
    plot(find(timeStepRun == 0)*[1 1], ylim, 'm--', 'LineWidth', 3);      
    xticks(x_tick_pos);
    xticklabels([-2 -1 0 1 2 3 4 5 6 7]);
     ax = gca;
    ax.FontSize = 18;
    set(gca, 'ytick', 0:100:size(FR_Array_sorted,1));
    ylabel('Neuron No.');
    xlabel(namex);
     
    if(delay == 2)
      xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
 
        elseif(delay == 22)
           xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
       
        elseif(delay == 3)
       xlim([find(timeStepRun == -2), find(timeStepRun == 6)]);
         
         
        elseif(delay == 4)
              xlim([find(timeStepRun == -2), find(timeStepRun == 6.996)]);
   
    end 
    
     ylim([0. size(FR_Array_sorted_23,1)])
 
     set(gcf, 'Position', [242 416 500 400])
      propstr = ''
    
    cd(save_path)
    save_path1  = ['PAC-' CondStr propstr '23'];
    savefig([save_path1 '.fig'])
     print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
    print('-painters','-dpng', [save_path1 '.png'], '-r600')

        %%%%%%%%%%%
 figure
   hold on
    ax = gca;
    ax.FontSize = 18;
    imagesc((FR_Array_sorted_3545));
     colormap gray
   cm = colormap;
   colormap(flipud(cm));
   axis square
   % set(gcf, 'Position', [100 100  550 522]);
%    plot(find(timeStepRun == 0)*[1 1], ylim, 'r--', 'LineWidth', 1.5);
      x_tick_pos = [find(timeStepRun == -2), find(timeStepRun == -1), find(timeStepRun == 0), find(timeStepRun == 1),...
                 find(timeStepRun == 2), find(timeStepRun == 3), find(timeStepRun == 4), find(timeStepRun == 5), find(timeStepRun == 6), find(timeStepRun == 7), find(timeStepRun == 8)];
     hold  on;
    plot(find(timeStepRun == 0)*[1 1], ylim, 'm--', 'LineWidth', 3);      
    xticks(x_tick_pos);
    xticklabels([-2 -1 0 1 2 3 4 5 6 7]);
     ax = gca;
    ax.FontSize = 18;
    set(gca, 'ytick', 0:100:size(FR_Array_sorted,1));
    ylabel('Neurons');
    xlabel(namex);
     
    if(delay == 2)
      xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
        elseif(delay == 22)
           xlim([find(timeStepRun == -2), find(timeStepRun == 5)]); 
        elseif(delay == 3)
       xlim([find(timeStepRun == -2), find(timeStepRun == 6)]);
        elseif(delay == 4)
              xlim([find(timeStepRun == -2), find(timeStepRun == 6.996)]);
    end 
    
     ylim([0. size(FR_Array_sorted_3545,1)])
 
     set(gcf, 'Position', [242 416 500 400])
      propstr = ''
    
    cd(save_path)
    save_path1  = ['PAC-' CondStr propstr '3545'];
    savefig([save_path1 '.fig'])
     print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
    print('-painters','-dpng', [save_path1 '.png'], '-r600')
        %%%
   figure
   hold on
    ax = gca;
    ax.FontSize = 18;
    imagesc((FR_Array_sorted_34));
     colormap gray
   cm = colormap;
   colormap(flipud(cm));
   axis square
      x_tick_pos = [find(timeStepRun == -2), find(timeStepRun == -1), find(timeStepRun == 0), find(timeStepRun == 1),...
                 find(timeStepRun == 2), find(timeStepRun == 3), find(timeStepRun == 4), find(timeStepRun == 5), find(timeStepRun == 6), find(timeStepRun == 7), find(timeStepRun == 8)];
     hold  on;
    plot(find(timeStepRun == 0)*[1 1], ylim, 'm--', 'LineWidth', 3);      
    xticks(x_tick_pos);
    xticklabels([-2 -1 0 1 2 3 4 5 6 7]);
     ax = gca;
    ax.FontSize = 18;
    set(gca, 'ytick', 0:100:size(FR_Array_sorted,1));
    ylabel('Neurons');
    xlabel(namex);
     
    if(delay == 2)
      xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
 
        elseif(delay == 22)
           xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
       
        elseif(delay == 3)
       xlim([find(timeStepRun == -2), find(timeStepRun == 6)]);
         
         
        elseif(delay == 4)
              xlim([find(timeStepRun == -2), find(timeStepRun == 6.996)]);
   
    end 
    
     ylim([0. size(FR_Array_sorted_23,1)])

    if propscale == 0
     set(gcf, 'Position', [242 416 500 400])
      propstr = ''
    elseif propscale == 1
    PropSigScale =  PropSig*0.8;
     set(gcf, 'Position', [242 416 500 1050*PropSigScale])    
     propstr = 'PropSigScale'
    end
    cd(save_path)
    save_path1  = ['PAC-' CondStr propstr '34'];
    savefig([save_path1 '.fig'])
    print('-painters','-dpng', [save_path1 '.png'], '-r600')

 
    end   

   save('PACRiseDownArray.mat', 'FR_Array_sorted_3545', 'FR_Array_sorted_1525', 'FR_Array_sorted_23', 'FR_Array_sorted_34', 'FR_Array_sorted')
end