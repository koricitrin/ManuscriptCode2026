function CatTables_3545(tablepath, path, neursel)
%IdentifyRiseDownImm_allWholePop('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\', SessionsPath4s)
         
    for cond = 2;
        if cond == 1
         CondStr = 'Cue';
        elseif cond == 2
            CondStr = 'LastLick';
        elseif cond == 3
          CondStr = 'Rew';
          elseif cond == 4
          CondStr = 'Lick';
        end  

    if neursel == 1
    namestr = 'PACThres';
    elseif neursel == 2
    namestr = 'PACShuff';
    elseif neursel == 3
    namestr = 'LickOn';
    end
        old_table_path{1} = tablepath;
        old_table_path{2}  = ['RiseDownID_' CondStr '_' namestr '_3545.mat'];

    RiseDownTable = [];
    
    for i = 1:size(path,1)
       % file_path_i = path(i,:);
       % sess = path(i,43:58) 
       file_path_i = path{i,:};
       sess = path{i}(1,43:58) 
       table_path_i = [old_table_path{1} sess '_' old_table_path{2}];


            if exist(table_path_i, 'file')              
                t = load(table_path_i, 'RiseDownTable');
                RiseDownTable_i = t.RiseDownTable;
           end

          RiseDownTable = [RiseDownTable ; RiseDownTable_i(:,1:3)];
  
       clear RiseDownTable_i 
       
    end
    
   
        save_path = tablepath
        save_path = [save_path 'All_Recs_RiseDownID_Align' CondStr '.mat'];


 save(save_path, 'RiseDownTable');

end
end