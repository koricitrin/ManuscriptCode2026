function PlotRiseLLDownL_imm(delay, cond)

        
    BasePath = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\']
    cd(BasePath)
    save_path = [BasePath];
    save_path2 = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\PAC_plot\'];
 

        if cond == 1
         CondStr = 'Cue';
         namex = 'Time from cue onset (s)';
        load('RiseCueDownLickNeurons_thres.mat')
        [~,sorted_All_ind]  = sort(RiseCueDownLickRatio.RatioCue, 'descend'); 
         NeuronSel =  RiseCueDownLickNeuronID;
         name = ['RiseCueDownLickThres']
         col = 'k'
        elseif cond == 2
         CondStr = 'LastLick';   
         namex = 'Time from last lick (s)';
        load('RiseLastLickDownLickNeurons_thres.mat')
        [~,sorted_All_ind]  = sort(RiseLLDownLickRatio.RatioLastLick, 'descend'); 
        NeuronSel =  RiseLLDownLickNeuronID;
           name = ['RiseLLDownLickThres']
            col = 'm'
        elseif cond == 3
          CondStr = 'Rew';
           namex = 'Time from reward (s)';
           load('RiseRewDownLickNeurons_thres.mat') 
          [~,sorted_All_ind]  = sort(RiseRewDownLickRatio.RatioRew, 'descend'); 
 
         NeuronSel =  RiseRewDownLickNeuronID;
       
          name = ['RiseRewDownLickThres']
          col = 'b'
          elseif cond == 4
          CondStr = 'Lick';
         namex = 'Time from first lick (s)';
         %  load('RiseLickDownLLNeurons_thres.mat') 
         %  [~,sorted_All_ind]  = sort(RiseLickDownLLRatio.RatioLick, 'descend'); 
         %    col = 'm'
         % NeuronSel =  RiseLickDownLLNeuronID;
           % name = ['RiseLickLDownLastLickThres']
           load('RiseLastLickDownLickNeurons_thres.mat')
        [~,sorted_All_ind]  = sort(RiseLLDownLickRatio.RatioLastLick, 'descend'); 
        NeuronSel =  RiseLLDownLickNeuronID;
           name = ['RiseLLDownLickThres']
            col = 'm'
        end  
    fr_profile_path = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\FR_Prof\PAC\FRprofileTable_align' CondStr 'dffgfthres.mat'];
    load(fr_profile_path, 'avgFR_profile', 'neu_id', 'rec_name', 'timeStepRun');
 
    cd('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\PAC_plot\')    
 load('LastLickOrder.mat', 'sorted_All_ind')
    FR_Array_sorted = [];
      % load('OrderLL.mat')
    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        % FR_profile_ind = strcmp(RiseLLDownLickNeuronID.rec_name(ind_i), rec_name) & RiseLLDownLickNeuronID.neu_id(ind_i) == neu_id;
        FR_profile_ind = strcmp(NeuronSel.rec_name(ind_i), rec_name) & NeuronSel.neu_id(ind_i) == neu_id;
       fr_profile_i = avgFR_profile(FR_profile_ind,:);
        
        FR_Array_sorted = [fr_profile_i/max(fr_profile_i); FR_Array_sorted];
  
    end

      FR_Array_sorted(any(isnan(FR_Array_sorted), 2), :) = [];
  

 cd(save_path2)

   figure
  axis equal 
      imagesc((FR_Array_sorted));
  
      colormap gray 
      cm = colormap;
      colormap(flipud(cm));
    
      x_tick_pos = [find(timeStepRun == -2), find(timeStepRun == -1), find(timeStepRun == 0), find(timeStepRun == 1),...
                 find(timeStepRun == 2), find(timeStepRun == 3), find(timeStepRun == 4), find(timeStepRun == 5), find(timeStepRun == 6), find(timeStepRun == 7), find(timeStepRun == 8)];
     
      hold  on;

    plot(find(timeStepRun == 0)*[1 1], ylim, '--', 'Color', col, 'LineWidth', 3);      
    xticks(x_tick_pos);
    xticklabels([-2 -1 0 1 2 3 4 5 6 7]);
         if(delay == 2)
           xlim([find(timeStepRun == -2), find(timeStepRun == 5)]);
        elseif(delay == 22)
           xlim([find(timeStepRun == -2), find(timeStepRun == 5)]); 
        elseif(delay == 3)
           xlim([find(timeStepRun == -2), find(timeStepRun == 6)]);
        elseif(delay == 4)
           xlim([find(timeStepRun == -2), find(timeStepRun == 6.996)]);
       end 
  
       % title(T)
           ax = gca;
    ax.FontSize = 24;
    ax.YDir = 'normal'
        % set(gca, 'Ydir', 'reverse')
   ylim([0. size(FR_Array_sorted,1)])
    set(gca, 'ytick', 0:100:size(FR_Array_sorted,1));
    ylabel('Neuron No.');
   
        xlabel(namex);
% title('OrderLL')
        

    set(gcf, 'Position', [100 100  540 490]);
 
    save_path1  = [name '-' CondStr 'orderLL'];
    savefig([save_path1 '.fig'])
    print('-painters','-dpdf', [save_path1 '.pdf'], '-r600')
    print('-painters','-dpng', [save_path1 '.png'], '-r600')
    %%%%%%%%%%%
% sortedDataID = RiseLLDownLickNeuronID(sorted_All_ind,:);
% dataname = ['RiseLLDownLArrayAllTr' cond '.mat']
%  save(dataname, 'FR_Array_sorted', 'sortedDataID')
end