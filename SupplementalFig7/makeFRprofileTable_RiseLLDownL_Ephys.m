function makeFRprofileTable_RiseLLDownL_Ephys(paths, filename, save_path1, tablepath)
   % Recording_List_immKori;
     

for cond = 4;
   
if (cond == 1)
    CondStr = 'Cue'
elseif (cond == 2)
   CondStr = 'Rew'    
elseif (cond == 3)
   CondStr = 'Lick'    
elseif (cond == 4)
   CondStr = 'LastLick'
end 
% 
  
  % save_path = [save_path1  sess 'FRprofileTable_align' CondStr '.mat']; %%change here

   rec_name = [];
    neu_id = [];
    avgFR_profile_NotNorm = [];
    avgFR_profile_56 = [];
     avgFR_profile_4555 = [];
    avgFR_profile_34 = [];
     avgFR_profile_67 = [];
    avgFR_profile_12 = [];
    avgFR_profile_45 = []
    avgFR_profile_3545 = [];
    avgFR_profile = [];
    avgFR_profile_67_NotNorm =[];
     avgFR_profile_4555_NotNorm =[];
    avgFR_profile_Even = [];
  avgFR_profile_56_NotNorm = [];
      
    for i = 1:size(paths,1)

          cd(paths(i,:))

          load('FirstLick_LL.mat');
          % Ind_1to2 =  Ind_1to2(2:end);
          % Ind_3to4 =  Ind_3to4(2:end);
          % Ind_35to45 =  Ind_35to45(2:end);
          % Ind_4to5 =  Ind_4to5(2:end);
          % Ind_45to55 =  Ind_45to55(2:end);
          % Ind_5to6 = Ind_5to6(2:end)
          % Ind_6to7 = Ind_6to7(2:end)

          path_i = [paths(i,:) ] ;
  
        sess = [paths(i,52:67)];
        path_i = [paths(i,:) filename(i,:)] ;
        disp(sess)
     

           fsa_path = [path_i '_convSpikesAligned_msess1_Bef' CondStr '0.mat'];
            load(fsa_path);
           if cond == 3
            filteredSpikeArray = filteredSpikeArrayLickOnSet;
             fsa = filteredSpikeArray;
        elseif cond == 4
            filteredSpikeArray = filteredSpikeArrayLastLickOnSet;
             fsa = filteredSpikeArray;
              elseif cond == 1
            filteredSpikeArray = filteredSpikeArrayCueOnSet;
             fsa = filteredSpikeArray;
           end
  
          save_path = [save_path1  'FRprofileTable_align' CondStr  'PAC.mat']; %%change here
          

        info_path = ([sess '_DataStructure_mazeSection1_TrialType1_Info.mat']);
        load(info_path, 'beh');
        alltrials = beh.indTrCtrl -1;
        alltrials = alltrials(2:end);
        alltrialsEven = alltrials(2:2:end);
        alltrialsOdd = alltrials(1:2:end);

        load([sess 'PACmanual_NoInt.mat']) 
        Neurons = PACmanual_NoInt;
 

        smoothWindow = floor(0.1 * 1250);
        b_filt = ones(1, smoothWindow) / smoothWindow; % Numerator for moving average
        a_filt = 1;
         
        for j = 1:length(Neurons)
             k = Neurons(j);
            rec_name = [rec_name ; string(sess)];
            neu_id = [neu_id ; k];
            
            fsa_j  = fsa{k};
            
            mean_fsa_tempAll = mean(fsa_j(alltrials, :),1);
             y = filtfilt(b_filt, a_filt, mean_fsa_tempAll);
            mean_fsa_tempAll_filt = (y- min(y))/(max(y) - min(y));

            mean_fsa_j =  (mean_fsa_tempAll_filt - min(mean_fsa_tempAll_filt))/(max(mean_fsa_tempAll_filt) - min(mean_fsa_tempAll_filt));
         
            mean_fsa_j_NotNorm = mean(fsa_j(alltrials, :),1);
             
            mean_fsa_temp45 = mean(fsa_j(Ind_4to5, :),1);
            y = filtfilt(b_filt, a_filt, mean_fsa_temp45);
            mean_fsa_temp45_filt = (y- min(y))/(max(y) - min(y));
            mean_fsa_j45 =  (mean_fsa_temp45_filt - min(mean_fsa_temp45_filt))/(max(mean_fsa_temp45_filt) - min(mean_fsa_temp45_filt));
         
            % mean_fsa_temp67 = mean(fsa_j(Ind_6to7, :),1);
            % y = filtfilt(b_filt, a_filt, mean_fsa_temp67);
            % mean_fsa_temp67_filt = (y- min(y))/(max(y) - min(y));
            % mean_fsa_j67 =  (mean_fsa_temp67_filt - min(mean_fsa_temp67_filt))/(max(mean_fsa_temp67_filt) - min(mean_fsa_temp67_filt));
            % 
            mean_fsa_temp67 = mean(fsa_j(Ind_6to7, :),1);
            mean_fsa_j67 =  (mean_fsa_temp67 - min(mean_fsa_temp67))/(max(mean_fsa_temp67) - min(mean_fsa_temp67));
           


            mean_fsa_temp34 = mean(fsa_j(Ind_3to4, :),1);
            mean_fsa_j34 =  (mean_fsa_temp34 - min(mean_fsa_temp34))/(max(mean_fsa_temp34) - min(mean_fsa_temp34)); 
           
            mean_fsa_temp3545 = mean(fsa_j(Ind_35to45, :),1);
            mean_fsa_j3545 =  (mean_fsa_temp3545 - min(mean_fsa_temp3545))/(max(mean_fsa_temp3545) - min(mean_fsa_temp3545)); 
          
            mean_fsa_temp4555 = mean(fsa_j(Ind_45to55, :),1);
             mean_fsa_j4555 =  (mean_fsa_temp4555 - min(mean_fsa_temp4555))/(max(mean_fsa_temp4555) - min(mean_fsa_temp4555)); 
        

            mean_fsa_temp56 = mean(fsa_j(Ind_5to6, :),1);
             mean_fsa_j56 =  (mean_fsa_temp56 - min(mean_fsa_temp56))/(max(mean_fsa_temp56) - min(mean_fsa_temp56)); 
          
            % mean_fsa_temp12 = mean(fsa_j(Ind_1to2, :),1);
            % mean_fsa_j12 =  (mean_fsa_temp12 - min(mean_fsa_temp12))/(max(mean_fsa_temp12) - min(mean_fsa_temp12)); 
            
          
            avgFR_profile = [avgFR_profile; mean_fsa_j];
            avgFR_profile_NotNorm = [avgFR_profile_NotNorm; mean_fsa_j_NotNorm];
            avgFR_profile_45 = [avgFR_profile_45 ; mean_fsa_j45];
            avgFR_profile_3545 = [avgFR_profile_3545 ; mean_fsa_j3545];
            avgFR_profile_34 = [avgFR_profile_34 ; mean_fsa_j34];
            avgFR_profile_56 = [avgFR_profile_56 ; mean_fsa_j56];
           avgFR_profile_56_NotNorm = [avgFR_profile_56_NotNorm ; mean_fsa_temp56];
            avgFR_profile_4555_NotNorm = [avgFR_profile_4555_NotNorm ; mean_fsa_temp4555];
            avgFR_profile_4555 = [avgFR_profile_4555 ; mean_fsa_j4555];
            % avgFR_profile_12 = [avgFR_profile_12 ; mean_fsa_j12];
             avgFR_profile_67 = [avgFR_profile_67 ; mean_fsa_j67];
       avgFR_profile_67_NotNorm = [avgFR_profile_67_NotNorm ; mean_fsa_temp67];
 


        end
        clear Ind_3to4 Ind_5to6 Ind_35to45 Ind_1to2 Ind_6to7
end 

    save(save_path, 'rec_name', 'neu_id' , 'avgFR_profile_56_NotNorm', 'avgFR_profile_67_NotNorm', 'avgFR_profile_4555_NotNorm', 'avgFR_profile_NotNorm', 'avgFR_profile', 'avgFR_profile_45', 'avgFR_profile_67', 'avgFR_profile_12', 'avgFR_profile_3545', 'avgFR_profile_4555', 'avgFR_profile_34', 'avgFR_profile_56', 'avgFR_profile_Even', 'timeStepRun');
end   

