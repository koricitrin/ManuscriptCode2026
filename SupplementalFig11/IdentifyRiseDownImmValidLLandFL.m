function RiseDownTable = IdentifyRiseDownImmValidLLandFL(path, delay, savepath, threshold)

    
    save_path = savepath;

   for i = 1:size(path,1)
       filename = [path(i,43:58) '_DataStructure_mazeSection1_TrialType1']
        path_i = [path(i,:) filename];
        cd(path(i,:))


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
     
       
        for cond = 1:2;
            
        if cond == 1
         CondStr = 'LastLick';   
        elseif cond == 2
          CondStr = 'Lick';
         end  
  
            % 
            fsa_path = [path_i '_convSpikesAlignedBef' CondStr '_msess1.mat'];
            load(fsa_path, 'paramC');
            timeStepRun = paramC.timeSteps(1:time);
            % timeStepRun = -3:0.002:6.998;
            dFFGFPath = ['dFFGF_bef' CondStr '.mat'];
              cd(path(i,:))
              load('ValidTr_FirstLastLick.mat')
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
    

    
      %%% changed on 2/20/2025  
    indFR0to1 = timeStepRun >= 0 & timeStepRun < 0.5;
    indFRBefRun = timeStepRun >= -0.5 & timeStepRun < 0; % different from cue!!

    indTime = time
    Neurons = 1:length(filteredSpikeArray);
    Trials =    1:size(filteredSpikeArray{1},1);    
    TrialsSel = ValidTrAll';
    
    for j = 1:length(Neurons)
        k = Neurons(j);
        fsa_j = filteredSpikeArray{k}(TrialsSel,1:indTime);
        mean_fsa_temp = mean(fsa_j,1);
        
        %normalize to get rid of neg dFF values
        mean_fsa_j =  (mean_fsa_temp - min(mean_fsa_temp))/(max(mean_fsa_temp) - min(mean_fsa_temp));     
        ratio0to1BefRun_j = mean(mean_fsa_j(indFR0to1))/mean(mean_fsa_j(indFRBefRun));     
        fsa_j_norm = [];
        rec_name = [rec_name ; string(filename(1,1:16))];
        neu_id = [neu_id ; k];
        ratio0to1BefRun = [ratio0to1BefRun ; ratio0to1BefRun_j];
        
    if threshold == 0
        ratioAftBefShuf = neuActivityShuffle_imm(fsa_j,indFR0to1,indFRBefRun,numShuffle);
        sigShuf = prctile(ratioAftBefShuf,[p 100-p]);
        
        isRise = [isRise ; ratio0to1BefRun_j > sigShuf(1) & ~isinf(ratio0to1BefRun_j)];
        isDown = [isDown ; ratio0to1BefRun_j < sigShuf(2) & ~isinf(ratio0to1BefRun_j)];
        thresStr = '';
        elseif threshold == 1 
            
        RiseThres = 3/2;
        DownThres = 2/3; 
        thresStr = 'thres';
        isRise = [isRise ; ratio0to1BefRun_j > RiseThres & ~isinf(ratio0to1BefRun_j)];
        isDown = [isDown ; ratio0to1BefRun_j < DownThres & ~isinf(ratio0to1BefRun_j)];
      
        end
    end
    
   % RiseDownTable = table(rec_name, neu_id, ratio0to1BefRun, isRise, isDown, mFR);
    RiseDownTable = table(rec_name, neu_id, ratio0to1BefRun, isRise, isDown);
    clear mean_fsa_j ratio0to1BefRun_i  neu_id ratio0to1BefRun isRise isDown  

    cd(save_path)
    save_path1 = [filename(1,1:16) '_RiseDownID_' CondStr 'ValidLLandFL' thresStr '2.mat'];
    save(save_path1, 'RiseDownTable');
    clear  Neurons filteredSpikeArray ValidTrAll
        end
   end    
end