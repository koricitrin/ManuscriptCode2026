function GetRiseDownRatios_3545_PAC(path, delay, savepath, TablePath, neursel)

    
        if delay == 4
        time = 5000;
        elseif delay == 44
        time = 4750;
        elseif  delay == 3
        time = 4500;
       elseif  delay == 33
        time = 4250;
        elseif  delay == 2
        time = 4000;
        elseif delay == 22
        time = 3750;
        end  

    save_path = savepath;

   for i = 1:size(path,1)
       filename = [path{i}(1,43:58) '_DataStructure_mazeSection1_TrialType1']
        path_i = [path{i,:} filename];
        cd(path{i,:})

     sess = path{i}(43:58);

       
        for cond = 3;
            
        if cond == 1
         CondStr = 'Cue';
        elseif cond == 3
            CondStr = 'LastLick';
        elseif cond == 2
          CondStr = 'Rew';
          elseif cond == 4
          CondStr = 'Lick';
        end  
          cd(path{i,:})
 
            timeStepRun = -3:0.002:6.998;
            dFFGFPath = ['dFFGF_bef' CondStr '.mat'];
             load(dFFGFPath)
            filteredSpikeArray = dFFGFArray;
          

      
    info_path = ([path_i '_Info.mat']);
    load(info_path, 'beh');

 
       
 

    p = 95; % overwrite GlobalConstFq to just use p value of 95
    numShuffle = 1000;
    rec_name = [];
    neu_id = [];
    ratio0to1BefRun = [];
    isRise = [];
    isDown = [];
    mFR = [];
    % 
    %   %%% changed on 2/20/2025  
    indFR0to1 = timeStepRun >= 0 & timeStepRun < 0.5;
    indFRBefRun = timeStepRun >= -0.5 & timeStepRun < 0; % different from cue!!

    
          load('FirstLick_LL.mat');
          Ind_1to2 =  Ind_1to2(2:end);
          Ind_3to4 =  Ind_3to4(2:end);
          Ind_35to45 =  Ind_35to45(2:end);
          Ind_45to55 =  Ind_45to55(2:end);
          Ind_5to6 = Ind_5to6(2:end)
 
 
    indTime = time


    cd(TablePath)
    if neursel == 1
    load("RiseLastLickDownLickNeurons_thres.mat") 
    tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1))
    Neurons = RiseLLDownLickNeuronID.neu_id(tf,:);
    namestr = 'PACThres'
    elseif neursel == 2
    load("RiseLastLickDownLickNeurons.mat") 
    tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1))
    Neurons = RiseLLDownLickNeuronID.neu_id(tf,:);
    namestr = 'PACShuff'
    elseif neursel == 3
     load("RiseLickDownLLNeurons_thres.mat") 
    tf = strcmp(sess,RiseLickDownLLNeuronID.rec_name(:,1));
    Neurons = RiseLickDownLLNeuronID.neu_id(tf,:);
    namestr = 'LickOn'
    end

    Trials =   Ind_35to45;    
  
    
    for j = 1:length(Neurons)
        k = Neurons(j);
        fsa_j_early = filteredSpikeArray{k}(Ind_35to45,1:indTime);
        fsa_j_late = filteredSpikeArray{k}(Ind_5to6,1:indTime);

        dataCat = [mean(fsa_j_early), mean(fsa_j_late)];

   
        
        %normalize to get rid of neg dFF values
        mean_fsa_j_cat =  (dataCat - min(dataCat))/(max(dataCat) - min(dataCat));  

        mean_fsa_j = mean_fsa_j_cat(1,1:length(fsa_j_early));

        ratio0to1BefRun_j = mean(mean_fsa_j(indFR0to1))/mean(mean_fsa_j(indFRBefRun));     
        fsa_j_norm = [];
        rec_name = [rec_name ; string(filename(1,1:16))];
        neu_id = [neu_id ; k];
        ratio0to1BefRun = [ratio0to1BefRun ; ratio0to1BefRun_j];
        
    
    end
    
   RiseDownTable = table(rec_name, neu_id, ratio0to1BefRun);
    clear mean_fsa_j ratio0to1BefRun_i  neu_id ratio0to1BefRun isRise isDown  
    
   cd(save_path)
    save_path1 = [filename(1,1:16) '_RiseDownID_' CondStr '_' namestr '_3545' '.mat'];
    save(save_path1, 'RiseDownTable');
    clear  Neurons filteredSpikeArray
        end
   end    
end