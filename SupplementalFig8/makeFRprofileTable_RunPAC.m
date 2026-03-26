function makeFRprofileTable_RunPAC(path, FileBase, save_path1,TablePath)
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
   elseif (cond == 5)
   CondStr = 'Run'
end 
% 
  
  % save_path = [save_path1  sess 'FRprofileTable_align' CondStr '.mat']; %%change here
  save_path = [save_path1  'FRprofileTable_align' CondStr '.mat']; %%change here
   rec_name = [];
    neu_id = [];

    avgFR_profile = [];
      avgFR_profile_Even = [];
      avgFR_profile_Odd = [];

           avgFR_profile_12 = [];
            avgFR_profile_1525 = [];
           avgFR_profile_23 = [];
           avgFR_profile_56 = [];
           avgFR_profile_34 = [];
           avgFR_profile_3545 = [];
           avgFR_profile_4555 = [];
           avgFR_profile_3545_NotNorm = [];
           avgFR_profile_23_NotNorm = [];

    for i = 1:size(path,1)
 
        cd(path(i,:))
         % sess = [path(i,44:59)];
     sess = [FileBase(i,:)];
        save_path = [save_path1  'FRprofileTable_align' CondStr 'PAC' '.mat']; %%change here
        disp(sess)

     
           
             paramC.timeSteps = -3:0.002:15;
            timeStepRun = paramC.timeSteps(1:5001);
           % load(alignpath, 'filteredSpikeArray', 'dFFArray');
           %load(alignpath,  'dFFArray');
            dFFPath = ['dFFGF_bef' CondStr '.mat']
            load(dFFPath)
            filteredSpikeArray = dFFGFArray;
            fsa = filteredSpikeArray;
      
  
    info_path = ([sess '_DataStructure_mazeSection1_TrialType1_Info.mat']);
    load(info_path, 'beh');
    
    
     alltrials = beh.indTrCtrl -1;
    alltrials = alltrials(2:end);
      alltrialsEven = alltrials(2:2:end);
      alltrialsOdd = alltrials(1:2:end);
    
    Trs = 1:alltrials(end);
    
   unrewtrials = beh.indUnRewTrCtrl -1;


            load('FirstLick_LL.mat');
          Ind_1to2 =  Ind_1to2(2:end);
           Ind_15to25 =  Ind_15to25(2:end);
          Ind_2to3 =  Ind_2to3(2:end);
          Ind_3to4 =  Ind_3to4(2:end);
          Ind_35to45 =  Ind_35to45(2:end);
          Ind_45to55 =  Ind_45to55(2:end);
          Ind_5to6 = Ind_5to6(2:end)


       cd(TablePath)
       load('RiseLastLickDownLickNeurons.mat')
       tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
      Neurons = RiseLLDownLickNeuronID.neu_id(tf,:); 
     
        for j = 1:length(Neurons)
             k = Neurons(j);
            rec_name = [rec_name ; string(sess)];
            neu_id = [neu_id ; k];
            
            fsa_j  = fsa{k};
            
            mean_fsa_tempAll = mean(fsa_j(alltrials, :),1);
            mean_fsa_j =  (mean_fsa_tempAll - min(mean_fsa_tempAll))/(max(mean_fsa_tempAll) - min(mean_fsa_tempAll)); 
            
%       

             mean_fsa_temp_Even = mean(fsa_j(alltrialsEven, :),1);
            mean_fsa_j_Even =  (mean_fsa_temp_Even - min(mean_fsa_temp_Even))/(max(mean_fsa_temp_Even) - min(mean_fsa_temp_Even)); 

             mean_fsa_temp_Odd = mean(fsa_j(alltrialsOdd, :),1);
            mean_fsa_j_Odd =  (mean_fsa_temp_Odd - min(mean_fsa_temp_Odd))/(max(mean_fsa_temp_Odd) - min(mean_fsa_temp_Odd)); 

             mean_fsa_temp23 = mean(fsa_j(Ind_2to3, :),1);
            mean_fsa_j23 =  (mean_fsa_temp23 - min(mean_fsa_temp23))/(max(mean_fsa_temp23) - min(mean_fsa_temp23));


             mean_fsa_temp1525 = mean(fsa_j(Ind_15to25, :),1);
            mean_fsa_j1525 =  (mean_fsa_temp1525 - min(mean_fsa_temp1525))/(max(mean_fsa_temp1525) - min(mean_fsa_temp1525));

                mean_fsa_temp3545 = mean(fsa_j(Ind_35to45, :),1);
            mean_fsa_j3545 =  (mean_fsa_temp3545 - min(mean_fsa_temp3545))/(max(mean_fsa_temp3545) - min(mean_fsa_temp3545));

             mean_fsa_temp12 = mean(fsa_j(Ind_1to2, :),1);
            mean_fsa_j12 =  (mean_fsa_temp12 - min(mean_fsa_temp12))/(max(mean_fsa_temp12) - min(mean_fsa_temp12));

            mean_fsa_temp34 = mean(fsa_j(Ind_3to4, :),1);
            mean_fsa_j34 =  (mean_fsa_temp34 - min(mean_fsa_temp34))/(max(mean_fsa_temp34) - min(mean_fsa_temp34)); 

            mean_fsa_temp56 = mean(fsa_j(Ind_5to6, :),1);
            mean_fsa_j56 =  (mean_fsa_temp56 - min(mean_fsa_temp56))/(max(mean_fsa_temp56) - min(mean_fsa_temp56)); 
            
           mean_fsa_temp4555 = mean(fsa_j(Ind_45to55, :),1);
            mean_fsa_j4555 =  (mean_fsa_temp4555 - min(mean_fsa_temp4555))/(max(mean_fsa_temp4555) - min(mean_fsa_temp4555)); 

 
            avgFR_profile = [avgFR_profile; mean_fsa_j];

            avgFR_profile_Even = [avgFR_profile_Even; mean_fsa_j_Even];

            avgFR_profile_Odd = [avgFR_profile_Odd; mean_fsa_j_Odd];

           avgFR_profile_12 = [avgFR_profile_12 ; mean_fsa_j12];
           avgFR_profile_23 = [avgFR_profile_23 ; mean_fsa_j23];
           avgFR_profile_23_NotNorm = [avgFR_profile_23_NotNorm ; mean_fsa_temp23];
           avgFR_profile_56 = [avgFR_profile_56 ; mean_fsa_j56];
           avgFR_profile_34 = [avgFR_profile_34 ; mean_fsa_j34];
           avgFR_profile_4555 = [avgFR_profile_4555 ; mean_fsa_j4555];    
          avgFR_profile_1525 = [avgFR_profile_1525 ; mean_fsa_j1525];    
        avgFR_profile_3545 = [avgFR_profile_3545 ; mean_fsa_j3545]; 
         avgFR_profile_3545_NotNorm = [avgFR_profile_3545_NotNorm ; mean_fsa_temp3545]; 
 

        end

  save(save_path, 'rec_name', 'neu_id' , 'avgFR_profile', 'avgFR_profile_3545_NotNorm', 'avgFR_profile_23_NotNorm',  'avgFR_profile_3545', 'avgFR_profile_1525', 'avgFR_profile_23', 'avgFR_profile_12', 'avgFR_profile_34', 'avgFR_profile_4555', 'avgFR_profile_56', 'timeStepRun', 'avgFR_profile_Even', 'avgFR_profile_Odd');
 
    end

    
    %save(save_path, 'rec_name', 'neu_id' , 'avgFR_profile_good_Even', 'avgFR_profile_good_Odd' ,'avgFR_profile_good', 'avgFR_profile_bad', 'timeStepRun');
end   
end
