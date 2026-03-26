function makeFRprofileTable_immWholePop(path, save_path1, NoFields, rewomission)
   % Recording_List_immKori;
     
   
if NoFields == 1
   neuStr = 'NoFields'
elseif NoFields == 2 
    neuStr = 'WholePop';
    elseif NoFields == 3 
    neuStr = 'NoFieldsShuf';
end    

for cond = 2;
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
  save_path = [save_path1  'FRprofileTable_align' CondStr '.mat']; %%change here
   rec_name = [];
    neu_id = [];
    avgFR_profile_good = [];
    avgFR_profile_bad = [];
    avgFR_profile = [];
    avgFR_profile_unrew = [];
      avgFR_profile_good_Even = [];
      avgFR_profile_good_Odd = [];
      avgFR_profile_Even = [];
      avgFR_profile_Odd = [];
      avgFR_profile_RewOmiss = [];
      avgFR_profile_RewOmissNext = [];
    for i = 1:size(path,1)
 
        cd(path{i,:})
        sess = [path{i}(1,43:58)];
      
        save_path = [save_path1  'FRprofileTable_align' CondStr neuStr '.mat']; %%change here
        disp(sess)
     

           timeStepRun = -3:0.002:6.998;
           % load(alignpath, 'filteredSpikeArray', 'dFFArray');
           %load(alignpath,  'dFFArray');
            dFFPath = ['dFFGF_bef' CondStr '.mat']
            load(dFFPath)
            filteredSpikeArray = dFFGFArray;
            fsa = filteredSpikeArray;
    
    info_path = ([sess '_DataStructure_mazeSection1_TrialType1_Info.mat']);
    load(info_path, 'beh');
    
%     goodtrials = beh.indGoodTrCtrl;
%     badtrials = beh.indBadTrCtrl;
%     unrewardedTr = beh.indUnRewTrCtrl;
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


    if rewomission == 1
    load('RewardOmissionTrInd.mat', 'RewOmissionTr')
    RewOmissionTrials = RewOmissionTr - 1; 
   RewOmissionTrialsNext = RewOmissionTrials + 1;
   RewOmissionTrialsNext = RewOmissionTrialsNext(1:end-1);
    end
    
    Trs = 1:alltrials(end);
    
   unrewtrials = beh.indUnRewTrCtrl -1;
    
       if NoFields == 1
       
        Files = dir('catFieldsGood*.*');
        F = Files.name;
        Field = load(F); 
        FieldG = struct2cell(Field) ;
        GoodFields = cell2mat(FieldG);
        Files = dir('catFieldsBad*.*');
        F = Files.name;
        Field = load(F); 
        FieldB = struct2cell(Field) ;
        BadFields = cell2mat(FieldB);
        Files = dir('catFieldsAll*.*');
        F = Files.name;
        Field = load(F); 
        FieldA = struct2cell(Field) ;
        AllFields = cell2mat(FieldA);
        FieldsCat = [GoodFields, BadFields, AllFields];
        Fields = unique(FieldsCat);  
      
        Neurons = setxor(1:length(filteredSpikeArray), (Fields));
       elseif   NoFields == 3
            cd([path{i,:} 'FieldDetectionShuffle\'])
            load('FieldIndexShuffleLastLick99.mat')
            Fields = FieldID;
             Neurons = setxor(1:length(filteredSpikeArray), (Fields));
       else 
           
            Neurons = 1:length(fsa);
       end 

        for j = 1:length(Neurons)
             k = Neurons(j);
            rec_name = [rec_name ; string(sess)];
            neu_id = [neu_id ; k];
            
            fsa_j  = fsa{k};
            
            mean_fsa_tempAll = mean(fsa_j(alltrials, :),1);
            mean_fsa_j =  (mean_fsa_tempAll - min(mean_fsa_tempAll))/(max(mean_fsa_tempAll) - min(mean_fsa_tempAll)); 
            
 
             mean_fsa_temp_Even = mean(fsa_j(alltrialsEven, :),1);
            mean_fsa_j_Even =  (mean_fsa_temp_Even - min(mean_fsa_temp_Even))/(max(mean_fsa_temp_Even) - min(mean_fsa_temp_Even)); 

             mean_fsa_temp_Odd = mean(fsa_j(alltrialsOdd, :),1);
            mean_fsa_j_Odd =  (mean_fsa_temp_Odd - min(mean_fsa_temp_Odd))/(max(mean_fsa_temp_Odd) - min(mean_fsa_temp_Odd)); 
 
            avgFR_profile = [avgFR_profile; mean_fsa_j];

            avgFR_profile_Even = [avgFR_profile_Even; mean_fsa_j_Even];

            avgFR_profile_Odd = [avgFR_profile_Odd; mean_fsa_j_Odd];
   

            if rewomission ==1
            mean_fsa_tempRewOmiss = mean(fsa_j(RewOmissionTrials, :),1);
            mean_fsa_jRewOmiss =  (mean_fsa_tempRewOmiss - min(mean_fsa_tempRewOmiss))/(max(mean_fsa_tempRewOmiss) - min(mean_fsa_tempRewOmiss)); 
          
            mean_fsa_tempRewOmissNext = mean(fsa_j(RewOmissionTrialsNext, :),1);
            mean_fsa_jRewOmissNext =  (mean_fsa_tempRewOmissNext - min(mean_fsa_tempRewOmissNext))/(max(mean_fsa_tempRewOmissNext) - min(mean_fsa_tempRewOmissNext)); 
           
            avgFR_profile_RewOmiss = [avgFR_profile_RewOmiss ; mean_fsa_jRewOmiss];
           avgFR_profile_RewOmissNext = [avgFR_profile_RewOmissNext; mean_fsa_jRewOmissNext];
            end

        end

  save(save_path, 'rec_name', 'neu_id' , 'avgFR_profile_RewOmiss', 'avgFR_profile_RewOmissNext', 'avgFR_profile', 'timeStepRun', 'avgFR_profile_Even', 'avgFR_profile_Odd');
 
    end

    
    %save(save_path, 'rec_name', 'neu_id' , 'avgFR_profile_good_Even', 'avgFR_profile_good_Odd' ,'avgFR_profile_good', 'avgFR_profile_bad', 'timeStepRun');
end   
end



