function PlotRiseDown_immAllWhole(delay, line, fields, paths)

     for cond =1:4
        if cond == 1
         CondStr = 'Cue';
         LineColor  = 'k';
         namex = 'Time from cue onset (s)';
        elseif cond == 2
         CondStr = 'LastLick';   
         namex = 'Time from last lick (s)';
            LineColor  = 'm';
        elseif cond == 3
          CondStr = 'Rew';
           namex = 'Time from reward (s)';
              LineColor  = 'b';
          elseif cond == 4
          CondStr = 'Lick';
         namex = 'Time from first lick (s)';
            LineColor  = 'm';
        end  

        LineColor =  ['b'];

          risedowntable_path = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\All_Recs_RiseDownID_Align' CondStr 'thres.mat'];
           fr_profile_path = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\FR_Prof\FRprofileTable_align' CondStr 'WholePop.mat'];

          save_path = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\'];
    
   
        cd(save_path)
       load(fr_profile_path, 'avgFR_profile', 'neu_id', 'rec_name', 'timeStepRun');
       load(risedowntable_path);

       NoFieldsIndex = [];
   
        if fields == 0
            for k = 1:size(paths,1)
            fieldpath = [paths{k,:} 'FieldDetectionShuffle'];
            sess = [paths{k}(1,43:58)]
            cd(fieldpath)
            filenamefields = ['FieldIndexShuffle' CondStr '99.mat'];
            load(filenamefields) 
            fieldsTemp = FieldID;
            FieldStr = ['NoFieldShuf'];
           
            tf = strcmp(sess,RiseDownTable.rec_name(:,1))
            NoFieldsIndexTemp = ~ismember(RiseDownTable.neu_id(tf,:), fieldsTemp);
            NoFieldsIndex = [NoFieldsIndex;NoFieldsIndexTemp];
            end
            noFieldsLogical =  logical(NoFieldsIndex);
            RiseDownTable = [RiseDownTable(noFieldsLogical,:)];
            avgFR_profile = avgFR_profile(noFieldsLogical,:);
            rec_name =  rec_name(noFieldsLogical,:);
            neu_id = neu_id(noFieldsLogical,:);
        else 
             FieldStr = [''];
        end
 
  

 [~,sorted_All_ind]  = sort(RiseDownTable.ratio0to1BefRun, 'descend'); 
   %[~,sorted_All_ind]  = sort(RiseDownTableEven.ratio0to1BefRun, 'descend'); 
% [~,sorted_All_ind]  = sort(RiseDownTableBad.ratio0to1BefRun, 'descend'); 


    % load("RewOrder.mat")
    FR_Array_sorted = [];
%     
    for i = 1:length(sorted_All_ind)
        ind_i = sorted_All_ind(i);
        FR_profile_ind = strcmp(RiseDownTable.rec_name(ind_i), rec_name) & RiseDownTable.neu_id(ind_i) == neu_id;
        fr_profile_i = avgFR_profile(FR_profile_ind,:);
        
        FR_Array_sorted = [fr_profile_i/max(fr_profile_i); FR_Array_sorted];
  
    end
    

    
  FR_Array_sorted(any(isnan(FR_Array_sorted), 2), :) = [];

 
RiseNeurons = FR_Array_sorted(sum(RiseDownTable.isRise):end,:);
RiseNeuronsMean = mean(RiseNeurons);
DownNeurons = FR_Array_sorted(1:sum(RiseDownTable.isDown),:);
DownNeuronsMean = mean(DownNeurons);
cd(save_path) 
dataname = ['RiseDownFRProf_avg' CondStr '.mat']
save(dataname, 'RiseNeurons', 'RiseNeuronsMean', 'DownNeurons', 'DownNeuronsMean');
   figure
   hold on
%   axis equal 
    ax = gca;
    ax.FontSize = 24;
    imagesc((FR_Array_sorted));
    colormap(flipud(gray))
       % colormap jet
   
%    plot(find(timeStepRun == 0)*[1 1], ylim, 'r--', 'LineWidth', 1.5);
      x_tick_pos = [find(timeStepRun == -2), find(timeStepRun == -1), find(timeStepRun == 0), find(timeStepRun == 1),...
                 find(timeStepRun == 2), find(timeStepRun == 3), find(timeStepRun == 4), find(timeStepRun == 5), find(timeStepRun == 6), find(timeStepRun == 7), find(timeStepRun == 8)];
     hold  on;
    xline(1500, '--',  'LineWidth', 3, 'Color', LineColor)
    xticks(x_tick_pos);
    xticklabels([-2 -1 0 1 2 3 4 5 6 7]);
     ax = gca;
    ax.FontSize = 21;
    set(gca, 'ytick', 0:1000:size(FR_Array_sorted,1));
    ylabel('Neuron No.');
    xlabel(namex);
    set(gcf, 'Position', [242 416 550 500])    

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
    
    if line == 0 
   ylim([0. size(FR_Array_sorted,1)])
    cd(save_path)
    save_path1  = ['RiseDown-' CondStr FieldStr];
    savefig([save_path1 '.fig'])
    print('-painters','-dpng', [save_path1 '.png'], '-r600')


    elseif line == 1
   ylim([0. size(FR_Array_sorted,1)])
       t = ylim;
      yline((t(1)+ sum(RiseDownTable.isDown)),'Color', 	LineColor, 'LineWidth', 1.5)
      yline((t(2)- sum(RiseDownTable.isRise)),'Color', LineColor, 'LineWidth', 1.5)
    
    cd(save_path)
    save_path1  = ['RiseDown-' CondStr 'line'];
    savefig([save_path1 '.fig'])
    print('-painters','-dpng', [save_path1 '.png'], '-r600')
    end

    end
   
end