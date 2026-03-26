function IdentifyRiseDownImm_allBlock(tablepath, path)
%IdentifyRiseDownImm_allWholePop('Z:\Kori\immobile_code\RiseDown\tables\Path4sUnR\', path4sUnR100,  path4sUnRList, 1)
         
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
  
        old_table_path{1} = tablepath;
        % old_table_path{2}  = ['RiseDownID_' CondStr 'WholePop99.mat'];
         old_table_path{2}  = ['RiseDownID_' CondStr 'WholePopthres.mat'];

 
  RiseDownTable = [];
  RiseDownTable3s = [];
  RiseDownTable3s_1 = [];
  RiseDownTable3s_2 = [];
  RiseDownTable5s = [];
  RiseDownTable5s_1 = [];
  RiseDownTable5s_2 = [];


    
    for i = 1:size(path,1)
       file_path_i = path(i,:);
       sess = path(i,43:58) 

       table_path_i = [file_path_i sess '_' old_table_path{2}];
       


            if exist(table_path_i, 'file')              
                t = load(table_path_i);
                RiseDownTable_i = t.RiseDownTable;
                RiseDownTable3s_i = t.RiseDownTable3s;
                RiseDownTable3s_1_i = t.RiseDownTable3sBlock1;
                RiseDownTable3s_2_i = t.RiseDownTable3sBlock2;

                RiseDownTable5s_i = t.RiseDownTable5s;
                RiseDownTable5s_1_i = t.RiseDownTable5sBlock1;
                RiseDownTable5s_2_i = t.RiseDownTable5sBlock2;

           end

 
        RiseDownTable = [RiseDownTable ; RiseDownTable_i(:,1:5)];
        RiseDownTable3s = [RiseDownTable3s ; RiseDownTable3s_i(:,1:5)];
        RiseDownTable3s_1 = [RiseDownTable3s_1 ; RiseDownTable3s_1_i(:,1:5)];
        RiseDownTable3s_2 = [RiseDownTable3s_2 ; RiseDownTable3s_2_i(:,1:5)];

        RiseDownTable5s = [RiseDownTable5s ; RiseDownTable5s_i(:,1:5)];
        RiseDownTable5s_1 = [RiseDownTable5s_1 ; RiseDownTable5s_1_i(:,1:5)];
        RiseDownTable5s_2 = [RiseDownTable5s_2 ; RiseDownTable5s_2_i(:,1:5)];



       clear RiseDownTable_i RiseDownTable3s_i RiseDownTable3s_1_i RiseDownTable3s_2_i RiseDownTable5s_i RiseDownTable5s_1_i RiseDownTable5s_2_i
    end
    
   
        save_path = tablepath
        save_path = [save_path 'All_Recs_RiseDownID_Align' CondStr 'BlockDelay' 'thres.mat'];

   save(save_path, 'RiseDownTable', 'RiseDownTable3s', 'RiseDownTable3s_1', 'RiseDownTable3s_2', 'RiseDownTable5s', 'RiseDownTable5s_1', 'RiseDownTable5s_2');

end
end
