function makeFRprofileTable_RiseLLDownL2(paths, save_path1, tablepath, rewomission, ch2, dff,thres,pac)
   % Recording_List_immKori;
     

for cond = 4;
   
if (cond == 1)
    CondStr = 'Cue'
elseif (cond == 4)
   CondStr = 'LastLick'
  
elseif (cond == 2)
   CondStr = 'Rew'    
elseif (cond == 3)
   CondStr = 'Lick'    
end


   rec_name = [];
   neu_id = [];

avgFR_profile =[];
    avgFR_profile_56 = [];
    avgFR_profile_4555 = [];
    
    avgFR_profile_34 = [];
    avgFR_profile_3545_NotNorm = [];
    avgFR_profile_4555_NotNorm = [];
    avgFR_profile_34_NotNorm = [];
    avgFR_profile_NotNorm =[];
    avgFR_profile_56_NotNorm = [];


    avgFR_profile_12 = [];
    avgFR_profile_3545 = [];
    avgFR_profile = [];
    avgFR_profile_unrew = [];
    avgFR_profile_good_Even = [];
    avgFR_profile_good_Odd = [];
    avgFR_profile_Even = [];
    avgFR_profile_Odd = [];
    avgFR_profile_RewOmiss = [];
    avgFR_profile_RewOmissNext =[];
      
    for i = 1:size(paths,1)


        if ch2 == 1
            path = [paths(i,:) 'Ch2\'];
        else
           % path = [paths{i,:}];
             path = [paths(i,:)];
        end
        cd(path)
        sess = [path(1,43:58)];
        disp(sess)
    

          load('FirstLick_LL.mat');
          Ind_1to2 =  Ind_1to2(2:end);
          Ind_3to4 =  Ind_3to4(2:end);
          Ind_35to45 =  Ind_35to45(2:end);
          Ind_45to55 =  Ind_45to55(2:end);
          Ind_5to6 = Ind_5to6(2:end)
     
           timeStepRun = -3:0.002:6.998;
            
          % load(alignpath, 'dFFGFArray',  'paramC');
      if dff == 1
            dFFPath = ['dFFGF_bef' CondStr '.mat']
            load(dFFPath)
           filteredSpikeArray = dFFGFArray;
           fsa = filteredSpikeArray;
             savestr = 'dffgf';
      elseif dff == 2
           dFFPath = ['dFFSM_bef' CondStr '.mat']
           load(dFFPath)
           filteredSpikeArray = dFFSMArray;
           fsa = filteredSpikeArray;
           savestr = 'dffsm';
      end
    
        info_path = ([sess '_DataStructure_mazeSection1_TrialType1_Info.mat']);
        load(info_path, 'beh');
    
        alltrials = beh.indTrCtrl -1;
        alltrials = alltrials(2:end);
        alltrialsEven = alltrials(2:2:end);
        alltrialsOdd = alltrials(1:2:end);
    
        if rewomission == 1
        load('RewardOmissionTrInd.mat', 'RewOmissionTr')
        RewOmissionTrials = RewOmissionTr - 1; 
       RewOmissionTrialsNext = RewOmissionTrials + 1;
       RewOmissionTrialsNext = RewOmissionTrialsNext(1:end-1);
        end

    
       
         if pac == 1
             cd(tablepath(i,:))
         if thres == 0
             load("RiseLastLickDownLickNeurons.mat")  
             thresstr = ''
         elseif thres == 1
            load("RiseLastLickDownLickNeurons_thres.mat")  
            thresstr = 'thres'
            end
       tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
      Neurons = RiseLLDownLickNeuronID.neu_id(tf,:); 
         elseif pac == 0
      
          fieldpath = [path 'FieldDetectionShuffle\'];
          cd(fieldpath)
            fieldfilename = ['FieldIndexShuffle' 'LastLick' '99.mat'];
            load(fieldfilename)
            Neurons =  FieldID;
         thresstr = ['']

         end
    
          save_path = [save_path1  'FRprofileTable_align' CondStr  savestr thresstr '.mat']; %%change here
         
  
    
        for j = 1:length(Neurons)
             k = Neurons(j);
            rec_name = [rec_name ; string(sess)];
            neu_id = [neu_id ; k];
            
            fsa_j  = fsa{k};
            
            mean_fsa_tempAll = mean(fsa_j(alltrials, :),1);
            mean_fsa_j =  (mean_fsa_tempAll - min(mean_fsa_tempAll))/(max(mean_fsa_tempAll) - min(mean_fsa_tempAll));

            mean_fsa_j_NotNorm = mean(fsa_j(alltrials, :),1);
             

             mean_fsa_temp_Even = mean(fsa_j(alltrialsEven, :),1);
             mean_fsa_j_Even =  (mean_fsa_temp_Even - min(mean_fsa_temp_Even))/(max(mean_fsa_temp_Even) - min(mean_fsa_temp_Even)); 

             mean_fsa_temp_Odd = mean(fsa_j(alltrialsOdd, :),1);
             mean_fsa_j_Odd =  (mean_fsa_temp_Odd - min(mean_fsa_temp_Odd))/(max(mean_fsa_temp_Odd) - min(mean_fsa_temp_Odd)); 
%           
            mean_fsa_temp34 = mean(fsa_j(Ind_3to4, :),1);
            mean_fsa_j34 =  (mean_fsa_temp34 - min(mean_fsa_temp34))/(max(mean_fsa_temp34) - min(mean_fsa_temp34)); 
            mean_fsa_j34_NotNorm = mean(fsa_j(Ind_3to4, :),1);
            
            mean_fsa_temp3545 = mean(fsa_j(Ind_35to45, :),1);
            mean_fsa_j3545_NotNorm = mean(fsa_j(Ind_35to45, :),1);
            mean_fsa_j3545 =  (mean_fsa_temp3545 - min(mean_fsa_temp3545))/(max(mean_fsa_temp3545) - min(mean_fsa_temp3545));

            mean_fsa_temp4555 = mean(fsa_j(Ind_45to55, :),1);
            mean_fsa_j4555 =  (mean_fsa_temp4555 - min(mean_fsa_temp4555))/(max(mean_fsa_temp4555) - min(mean_fsa_temp4555)); 
            mean_fsa_j4555_NotNorm = mean(fsa_j(Ind_45to55, :),1);

            mean_fsa_temp56 = mean(fsa_j(Ind_5to6, :),1);
            mean_fsa_j56_NotNorm = mean(fsa_j(Ind_5to6, :),1);
            mean_fsa_j56 =  (mean_fsa_temp56 - min(mean_fsa_temp56))/(max(mean_fsa_temp56) - min(mean_fsa_temp56)); 
            
            mean_fsa_temp12 = mean(fsa_j(Ind_1to2, :),1);
            mean_fsa_j12 =  (mean_fsa_temp12 - min(mean_fsa_temp12))/(max(mean_fsa_temp12) - min(mean_fsa_temp12)); 
            
            if rewomission ==1
            mean_fsa_tempRewOmiss = mean(fsa_j(RewOmissionTrials, :),1);
            mean_fsa_jRewOmiss =  (mean_fsa_tempRewOmiss - min(mean_fsa_tempRewOmiss))/(max(mean_fsa_tempRewOmiss) - min(mean_fsa_tempRewOmiss)); 
          
            mean_fsa_tempRewOmissNext = mean(fsa_j(RewOmissionTrialsNext, :),1);
            mean_fsa_jRewOmissNext =  (mean_fsa_tempRewOmissNext - min(mean_fsa_tempRewOmissNext))/(max(mean_fsa_tempRewOmissNext) - min(mean_fsa_tempRewOmissNext)); 
           
            avgFR_profile_RewOmiss = [avgFR_profile_RewOmiss ; mean_fsa_jRewOmiss];
           avgFR_profile_RewOmissNext = [avgFR_profile_RewOmissNext; mean_fsa_jRewOmissNext];
            end


            avgFR_profile = [avgFR_profile; mean_fsa_j];

            avgFR_profile_NotNorm = [avgFR_profile_NotNorm; mean_fsa_j_NotNorm];
            avgFR_profile_Even = [avgFR_profile_Even; mean_fsa_j_Even];
            avgFR_profile_Odd = [avgFR_profile_Odd; mean_fsa_j_Odd];
            avgFR_profile_3545 = [avgFR_profile_3545 ; mean_fsa_j3545];
            avgFR_profile_34 = [avgFR_profile_34 ; mean_fsa_j34];
            avgFR_profile_56 = [avgFR_profile_56 ; mean_fsa_j56];
            avgFR_profile_4555 = [avgFR_profile_4555 ; mean_fsa_j4555];
            avgFR_profile_12 = [avgFR_profile_12 ; mean_fsa_j12];

            avgFR_profile_3545_NotNorm = [avgFR_profile_3545_NotNorm ; mean_fsa_j3545_NotNorm];
            avgFR_profile_56_NotNorm = [avgFR_profile_56_NotNorm ; mean_fsa_j56_NotNorm];

             avgFR_profile_34_NotNorm = [avgFR_profile_34_NotNorm ; mean_fsa_j34_NotNorm];
             avgFR_profile_4555_NotNorm = [avgFR_profile_4555_NotNorm ; mean_fsa_j4555_NotNorm];

%             avgFR_profile_unrew = [avgFR_profile_unrew ; mean_fsa_jU];


        end
        clear Ind_3to4 Ind_5to6 Ind_35to45 Ind_1to2
end 

    save(save_path, 'rec_name', 'neu_id' , 'avgFR_profile_NotNorm', 'avgFR_profile_3545_NotNorm', 'avgFR_profile_56_NotNorm', 'avgFR_profile_34_NotNorm', 'avgFR_profile_4555_NotNorm', 'avgFR_profile','avgFR_profile_RewOmissNext', 'avgFR_profile_RewOmiss', 'avgFR_profile_12', 'avgFR_profile_3545', 'avgFR_profile_4555', 'avgFR_profile_34', 'avgFR_profile_56', 'avgFR_profile_Even', 'timeStepRun');
end   

