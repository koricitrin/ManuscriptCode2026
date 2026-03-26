function makeFRprofileTable_RiseLLDownBlockDelay(paths, save_path1, tablepath, dff, PAC, BlockTypePAC)
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
    avgFR_profile_3sDelay = [];
    avgFR_profile_5sDelay = [];
    avgFR_profile_3sDelay_NotNorm = [];
     avgFR_profile_5sDelay_NotNorm = [];
       avgFR_profile_3sDelay_NotNorm_3545 = [];
     avgFR_profile_5sDelay_NotNorm_56 = [];
    avgFR_profile_56 = [];
     avgFR_profile_4555 = [];
    avgFR_profile_34 = [];
    avgFR_profile_4555_NotNorm = [];
    avgFR_profile_34_NotNorm = [];
   avgFR_profile_56_NotNorm = [];
    avgFR_profile_3545_NotNorm = [];

    avgFR_profile_3545 = [];
    avgFR_profile = [];
    avgFR_profile_Even = [];
    avgFR_profile_Odd = [];

     avgFR_profile_3sDelay_1 = [];
     avgFR_profile_3sDelay_2 = [];
     avgFR_profile_5sDelay_1 = [];
     avgFR_profile_5sDelay_2 = [];

    for i = 1:size(paths,1)

          cd(paths(i,:))

          load('FirstLick_LL.mat');
          Ind_1to2 =  Ind_1to2(2:end);
          Ind_3to4 =  Ind_3to4(2:end);
           Ind_4to5 =  Ind_4to5(2:end);
          Ind_35to45 =  Ind_35to45(2:end);
          Ind_45to55 =  Ind_45to55(2:end);
          Ind_5to6 = Ind_5to6(2:end);

      
        sess = [paths(i,43:58)];
     
        disp(sess)
    
     
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
     Delay5s = (beh.delayLen/1000000) > 4.9;
     Delay5s = Delay5s(2:end); %remove first tr
     Delay3s = (beh.delayLen/1000000) < 3.1;
     Delay3s = Delay3s(2:end); %remove first tr

AllTr = 1:length(Delay3s);
 Delay3s_3545_temp = [Delay3s'+ Ind_35to45];
Delay3s_3545_Ind = find(Delay3s_3545_temp == 2);
Delay5s_56_temp = [Delay5s'+ Ind_5to6];
Delay5s_56_Ind = find(Delay5s_56_temp == 2);

     Delay5sTr = AllTr(Delay5s);
     Delay3sTr = AllTr(Delay3s);

     for tr = 1:length(Delay3sTr)-1
         Diff =    Delay3sTr(tr+1) -Delay3sTr(tr);
         if abs(Diff) > 1
             SwitchPoint3(tr,:) = tr+1;
         end
     end
     SwitchPoint3(SwitchPoint3 == 0) = [];
     Delay3sBlock1 =  Delay3sTr(1:SwitchPoint3-1);
     Delay3sBlock2 =  Delay3sTr(SwitchPoint3:end);


          for tr = 1:length(Delay5sTr)-1
         Diff =    Delay5sTr(tr+1) -Delay5sTr(tr);
         if abs(Diff) > 1
             SwitchPoint5(tr,:) = tr+1;
         end
     end
     SwitchPoint5(SwitchPoint5 == 0) = [];

    Delay5sBlock1 =  Delay5sTr(1:SwitchPoint5-1);
    Delay5sBlock2 =  Delay5sTr(SwitchPoint5:end);

    if PAC == 1 

         cd(tablepath)
         if BlockTypePAC == 1
                load("RiseLastLickDownLickNeurons_thresAllTr.mat")  
                    namesave = 'AllTrPAC';
                               thresstr = 'thres'   
           tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
           Neurons = RiseLLDownLickNeuronID.neu_id(tf,:); 
         elseif  BlockTypePAC == 2
               load("RiseLastLickDownLickNeurons_thres3sTr.mat")  
                  namesave = '3sTrPAC';
                             thresstr = 'thres'   
           tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
           Neurons = RiseLLDownLickNeuronID.neu_id(tf,:); 
         elseif  BlockTypePAC == 3
               load("RiseLastLickDownLickNeurons_thres5sTr.mat")  
                 namesave = '5sTrPAC';
                            thresstr = 'thres'   
           tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
           Neurons = RiseLLDownLickNeuronID.neu_id(tf,:); 
         elseif  BlockTypePAC == 4
               load("RiseLastLickDownLickNeurons_thres3sBlock1.mat")  
                namesave = '3sTr_1_PAC';
                           thresstr = 'thres'   
           tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
           Neurons = RiseLLDownLickNeuronID.neu_id(tf,:); 
         elseif  BlockTypePAC == 5
               load("RiseLastLickDownLickNeurons_thres3sBlock2.mat")  
                namesave = '3sTr_2_PAC';
                           thresstr = 'thres'   
           tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
           Neurons = RiseLLDownLickNeuronID.neu_id(tf,:); 
         elseif  BlockTypePAC == 6
               load("RiseLastLickDownLickNeurons_thres5sBlock1.mat")  
                namesave = '5sTr_1_PAC';
                           thresstr = 'thres'   
           tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
           Neurons = RiseLLDownLickNeuronID.neu_id(tf,:); 
         elseif  BlockTypePAC == 7
             load("RiseLastLickDownLickNeurons_thres5sBlock2.mat")  
                namesave = '5sTr_2_PAC';
            thresstr = 'thres'   
           tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
           Neurons = RiseLLDownLickNeuronID.neu_id(tf,:); 
        elseif  BlockTypePAC == 8
          cd(paths(i,:))
            load('OverlapPACs.mat')
           Neurons = Intersection
              thresstr = 'thres' 
               namesave = 'OverlapPacs';
        else
            Neurons = 1:size(fsa,2);
            namesave = 'WholePop';
             thresstr = '';
         end
    end
          save_path = [save_path1  'FRprofileTable_align' CondStr  namesave '.mat']; %%change here
  
    
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

             mean_fsa_temp_5s = mean(fsa_j(Delay5s, :),1);
             mean_fsa_j_5s =  (mean_fsa_temp_5s - min(mean_fsa_temp_5s))/(max(mean_fsa_temp_5s) - min(mean_fsa_temp_5s)); 
            
             mean_fsa_temp_3s = mean(fsa_j(Delay3s, :),1);
             mean_fsa_j_3s =  (mean_fsa_temp_3s - min(mean_fsa_temp_3s))/(max(mean_fsa_temp_3s) - min(mean_fsa_temp_3s));

             mean_fsa_temp_Odd = mean(fsa_j(alltrialsOdd, :),1);
             mean_fsa_j_Odd =  (mean_fsa_temp_Odd - min(mean_fsa_temp_Odd))/(max(mean_fsa_temp_Odd) - min(mean_fsa_temp_Odd)); 
%           
            mean_fsa_temp34 = mean(fsa_j(Ind_3to4, :),1);
            mean_fsa_j34 =  (mean_fsa_temp34 - min(mean_fsa_temp34))/(max(mean_fsa_temp34) - min(mean_fsa_temp34)); 
            mean_fsa_j34_NotNorm = mean(fsa_j(Ind_3to4, :),1);
            
            mean_fsa_temp3545 = mean(fsa_j(Ind_35to45, :),1);
            mean_fsa_j3545 =  (mean_fsa_temp3545 - min(mean_fsa_temp3545))/(max(mean_fsa_temp3545) - min(mean_fsa_temp3545));

             mean_fsa_temp4555 = mean(fsa_j(Ind_45to55, :),1);
            mean_fsa_j4555 =  (mean_fsa_temp4555 - min(mean_fsa_temp4555))/(max(mean_fsa_temp4555) - min(mean_fsa_temp4555)); 
            mean_fsa_j4555_NotNorm = mean(fsa_j(Ind_45to55, :),1);

            mean_fsa_temp56 = mean(fsa_j(Ind_5to6, :),1);
            mean_fsa_j56 =  (mean_fsa_temp56 - min(mean_fsa_temp56))/(max(mean_fsa_temp56) - min(mean_fsa_temp56)); 

            mean_fsa_temp3s_1 = mean(fsa_j(Delay3sBlock1, :),1);
            mean_fsa_j3s_1 =  (mean_fsa_temp3s_1 - min(mean_fsa_temp3s_1))/(max(mean_fsa_temp3s_1) - min(mean_fsa_temp3s_1));

            mean_fsa_temp3s_2 = mean(fsa_j(Delay3sBlock2, :),1);
            mean_fsa_j3s_2 =  (mean_fsa_temp3s_2 - min(mean_fsa_temp3s_2))/(max(mean_fsa_temp3s_2) - min(mean_fsa_temp3s_2));

            mean_fsa_temp5s_1 = mean(fsa_j(Delay5sBlock1, :),1);
            mean_fsa_j5s_1 =  (mean_fsa_temp5s_1 - min(mean_fsa_temp5s_1))/(max(mean_fsa_temp5s_1) - min(mean_fsa_temp5s_1));

            mean_fsa_temp5s_2 = mean(fsa_j(Delay5sBlock2, :),1);
            mean_fsa_j5s_2 =  (mean_fsa_temp5s_2 - min(mean_fsa_temp5s_2))/(max(mean_fsa_temp5s_2) - min(mean_fsa_temp5s_2));


             mean_fsa_temp_3s_3545 = mean(fsa_j(Delay3s_3545_Ind, :),1);
             mean_fsa_temp_5s_56 = mean(fsa_j(Delay5s_56_Ind, :),1);


            avgFR_profile = [avgFR_profile; mean_fsa_j];

            avgFR_profile_NotNorm = [avgFR_profile_NotNorm; mean_fsa_j_NotNorm];
            avgFR_profile_Even = [avgFR_profile_Even; mean_fsa_j_Even];
            avgFR_profile_Odd = [avgFR_profile_Odd; mean_fsa_j_Odd];
            avgFR_profile_3545 = [avgFR_profile_3545 ; mean_fsa_j3545];
            avgFR_profile_3545_NotNorm = [avgFR_profile_3545 ; mean_fsa_temp3545];
            avgFR_profile_34 = [avgFR_profile_34 ; mean_fsa_j34];
            avgFR_profile_56 = [avgFR_profile_56 ; mean_fsa_j56];
              avgFR_profile_56_NotNorm = [avgFR_profile_56 ; mean_fsa_temp56];
            avgFR_profile_4555 = [avgFR_profile_4555 ; mean_fsa_j4555];
            avgFR_profile_3sDelay = [avgFR_profile_3sDelay ; mean_fsa_j_3s];
            avgFR_profile_5sDelay = [avgFR_profile_5sDelay ; mean_fsa_j_5s];
             avgFR_profile_3sDelay_NotNorm = [avgFR_profile_3sDelay_NotNorm ; mean_fsa_temp_3s];
            avgFR_profile_5sDelay_NotNorm = [avgFR_profile_5sDelay_NotNorm ; mean_fsa_temp_5s];

            avgFR_profile_3sDelay_NotNorm_3545 = [avgFR_profile_3sDelay_NotNorm_3545 ; mean_fsa_temp_3s_3545];
            avgFR_profile_5sDelay_NotNorm_56 = [avgFR_profile_5sDelay_NotNorm_56 ; mean_fsa_temp_5s_56];

            avgFR_profile_3sDelay_1 = [avgFR_profile_3sDelay_1 ; mean_fsa_j3s_1];
            avgFR_profile_3sDelay_2 = [avgFR_profile_3sDelay_2 ; mean_fsa_j3s_2];
            avgFR_profile_5sDelay_1 = [avgFR_profile_5sDelay_1 ; mean_fsa_j5s_1];
            avgFR_profile_5sDelay_2 = [avgFR_profile_5sDelay_2 ; mean_fsa_j5s_2];

             avgFR_profile_34_NotNorm = [avgFR_profile_34_NotNorm ; mean_fsa_j34_NotNorm];
             avgFR_profile_4555_NotNorm = [avgFR_profile_4555_NotNorm ; mean_fsa_j4555_NotNorm];



        end
        clear Ind_3to4 Ind_5to6 Ind_35to45 Ind_1to2
end 

    save(save_path, 'rec_name', 'neu_id' , 'avgFR_profile_5sDelay_NotNorm_56', 'avgFR_profile_3sDelay_NotNorm_3545', 'avgFR_profile_5sDelay_1', 'avgFR_profile_5sDelay_2', 'avgFR_profile_3sDelay_1', 'avgFR_profile_3sDelay_2', 'avgFR_profile_56_NotNorm', 'avgFR_profile_3545_NotNorm', 'avgFR_profile_3sDelay_NotNorm', 'avgFR_profile_5sDelay_NotNorm', 'avgFR_profile_5sDelay', 'avgFR_profile_3sDelay', 'avgFR_profile_NotNorm', 'avgFR_profile_34_NotNorm', 'avgFR_profile_4555_NotNorm', 'avgFR_profile', 'avgFR_profile_3545', 'avgFR_profile_4555', 'avgFR_profile_34', 'avgFR_profile_56', 'avgFR_profile_Even' , 'timeStepRun');
end   

end