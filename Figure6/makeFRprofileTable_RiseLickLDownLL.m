function makeFRprofileTable_RiseLickLDownLL(paths, save_path1, tablepath, dff,thres)
   % Recording_List_immKori;
     

for cond = 3:4;
   
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
    avgFR_profile_good = [];
    avgFR_profile_bad = [];
    avgFR_profile_56 = [];
     avgFR_profile_4555 = [];
    avgFR_profile_34 = [];
    avgFR_profile_4555_NotNorm = [];
    avgFR_profile_34_NotNorm = [];
    avgFR_profile_56_NotNorm = [];
    avgFR_profile_3545_NotNorm = [];
    avgFR_profile_12 = [];
    avgFR_profile_3545 = [];
    avgFR_profile = [];
    avgFR_profile_Even = [];
    avgFR_profile_Odd = [];

      
    for i = 1:size(paths,1)

          cd(paths(i,:))
          % cd(paths{i})
          % sess = paths{i}(1,43:58);
           sess = paths(i,43:58);
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
    goodtrials = beh.indGoodTrCtrl - 1; % need to remove first tr bc the FSA bef does
    goodtrials = goodtrials(2:end);
    goodtrialsEven =  goodtrials(2:2:end);
    goodtrialsOdd = goodtrials(1:2:end);
    badtrials = beh.indBadTrCtrl -1;
    badtrials = badtrials(2:end);
    alltrials = beh.indTrCtrl -1;
    alltrials = alltrials(2:end);
    alltrialsEven = alltrials(2:2:end);
    alltrialsOdd = alltrials(1:2:end);

         cd(tablepath)
         if thres == 1
        load("RiseLickDownLLNeurons_thres.mat")  
             thresstr = 'thres'
         elseif thres == 2
        load("RiseLickDownLLNeurons_thres2.mat")  
        thresstr = 'thresValid'
         elseif thres == 0
         load("RiseLickDownLLNeurons.mat")  
        thresstr = ''

            end
       tf = strcmp(sess,RiseLickDownLLNeuronID.rec_name(:,1));
        Neurons = RiseLickDownLLNeuronID.neu_id(tf,:); 
    
          save_path = [save_path1  'FRprofileTable_align' CondStr  savestr thresstr '.mat']; %%change here
  
    
        for j = 1:length(Neurons)
             k = Neurons(j);
            rec_name = [rec_name ; string(sess)];
            neu_id = [neu_id ; k];
            
            fsa_j  = fsa{k};
            
            mean_fsa_tempAll = mean(fsa_j(alltrials, :),1);
            mean_fsa_j =  (mean_fsa_tempAll - min(mean_fsa_tempAll))/(max(mean_fsa_tempAll) - min(mean_fsa_tempAll));

            mean_fsa_j_NotNorm = mean(fsa_j(alltrials, :),1);
             

            mean_fsa_tempG = mean(fsa_j(goodtrials, :),1);
            mean_fsa_jG =  (mean_fsa_tempG - min(mean_fsa_tempG))/(max(mean_fsa_tempG) - min(mean_fsa_tempG)); 
            
            mean_fsa_tempB = mean(fsa_j(badtrials, :),1);
            mean_fsa_jB =  (mean_fsa_tempB - min(mean_fsa_tempB))/(max(mean_fsa_tempB) - min(mean_fsa_tempB)); 
            %%

             mean_fsa_temp_Even = mean(fsa_j(alltrialsEven, :),1);
             mean_fsa_j_Even =  (mean_fsa_temp_Even - min(mean_fsa_temp_Even))/(max(mean_fsa_temp_Even) - min(mean_fsa_temp_Even)); 

             mean_fsa_temp_Odd = mean(fsa_j(alltrialsOdd, :),1);
             mean_fsa_j_Odd =  (mean_fsa_temp_Odd - min(mean_fsa_temp_Odd))/(max(mean_fsa_temp_Odd) - min(mean_fsa_temp_Odd)); 
%           
            mean_fsa_temp34 = mean(fsa_j(Ind_3to4, :),1);
            mean_fsa_j34 =  (mean_fsa_temp34 - min(mean_fsa_temp34))/(max(mean_fsa_temp34) - min(mean_fsa_temp34)); 
            mean_fsa_j34_NotNorm = mean(fsa_j(Ind_3to4, :),1);
            
            mean_fsa_temp3545 = mean(fsa_j(Ind_35to45, :),1);
            mean_fsa_j3545 =  (mean_fsa_temp3545 - min(mean_fsa_temp3545))/(max(mean_fsa_temp3545) - min(mean_fsa_temp3545));
            mean_fsa_j3545_NotNorm = mean(fsa_j(Ind_35to45, :),1);

             mean_fsa_temp4555 = mean(fsa_j(Ind_45to55, :),1);
            mean_fsa_j4555 =  (mean_fsa_temp4555 - min(mean_fsa_temp4555))/(max(mean_fsa_temp4555) - min(mean_fsa_temp4555)); 
            mean_fsa_j4555_NotNorm = mean(fsa_j(Ind_45to55, :),1);

            mean_fsa_temp56 = mean(fsa_j(Ind_5to6, :),1);
            mean_fsa_j56 =  (mean_fsa_temp56 - min(mean_fsa_temp56))/(max(mean_fsa_temp56) - min(mean_fsa_temp56)); 
             mean_fsa_j56_NotNorm = mean(fsa_j(Ind_5to6, :),1);
            mean_fsa_temp12 = mean(fsa_j(Ind_1to2, :),1);
            mean_fsa_j12 =  (mean_fsa_temp12 - min(mean_fsa_temp12))/(max(mean_fsa_temp12) - min(mean_fsa_temp12)); 
            


            avgFR_profile = [avgFR_profile; mean_fsa_j];

            avgFR_profile_NotNorm = [avgFR_profile_NotNorm; mean_fsa_j_NotNorm];
            avgFR_profile_Even = [avgFR_profile_Even; mean_fsa_j_Even];
            avgFR_profile_Odd = [avgFR_profile_Odd; mean_fsa_j_Odd];
            avgFR_profile_good = [avgFR_profile_good ; mean_fsa_jG];
            avgFR_profile_bad = [avgFR_profile_bad ; mean_fsa_jB];
            avgFR_profile_3545 = [avgFR_profile_3545 ; mean_fsa_j3545];
            avgFR_profile_3545_NotNorm = [avgFR_profile_3545_NotNorm ; mean_fsa_j3545_NotNorm];
            avgFR_profile_34 = [avgFR_profile_34 ; mean_fsa_j34];
            avgFR_profile_56 = [avgFR_profile_56 ; mean_fsa_j56];
            avgFR_profile_56_NotNorm = [avgFR_profile_56_NotNorm ; mean_fsa_j56_NotNorm];
            avgFR_profile_4555 = [avgFR_profile_4555 ; mean_fsa_j4555];
            avgFR_profile_12 = [avgFR_profile_12 ; mean_fsa_j12];

             avgFR_profile_34_NotNorm = [avgFR_profile_34_NotNorm ; mean_fsa_j34_NotNorm];
             avgFR_profile_4555_NotNorm = [avgFR_profile_4555_NotNorm ; mean_fsa_j4555_NotNorm];
%            avgFR_profile_good_Even = [avgFR_profile_good_Even; mean_fsa_jG_Even];
%            avgFR_profile_good_Odd =  [avgFR_profile_good_Odd;
%            mean_fsa_jG_Odd];
%             avgFR_profile_unrew = [avgFR_profile_unrew ; mean_fsa_jU];

           'stp'
        end
        clear Ind_3to4 Ind_5to6 Ind_35to45 Ind_1to2
end 

    save(save_path, 'rec_name', 'neu_id' , 'avgFR_profile_56_NotNorm', 'avgFR_profile_3545_NotNorm', 'avgFR_profile_NotNorm', 'avgFR_profile_34_NotNorm', 'avgFR_profile_4555_NotNorm', 'avgFR_profile', 'avgFR_profile_12', 'avgFR_profile_3545', 'avgFR_profile_4555', 'avgFR_profile_34', 'avgFR_profile_56', 'avgFR_profile_Even' ,'avgFR_profile_good', 'avgFR_profile_bad', 'timeStepRun');
end   

