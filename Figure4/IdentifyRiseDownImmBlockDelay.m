function RiseDownTable = IdentifyRiseDownImmBlockDelay(path, delay, savepath, threshold)

    
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
     
       
        for cond = 3:4;
            
        if cond == 1
         CondStr = 'Cue';
        elseif cond == 3
            CondStr = 'LastLick';
        elseif cond == 2
          CondStr = 'Rew';
          elseif cond == 4
          CondStr = 'Lick';
        end  
  
            % 
            % fsa_path = [path_i '_convSpikesAlignedBef' CondStr '_msess1.mat'];
            % load(fsa_path, 'paramC');
            % timeStepRun = paramC.timeSteps(1:time);
            timeStepRun = -3:0.002:6.998;
            dFFGFPath = ['dFFGF_bef' CondStr '.mat'];
              cd(path(i,:))
             load(dFFGFPath)
            filteredSpikeArray = dFFGFArray;
            %   mFR_path = ([path_i '_FRAligned' CondStr '_msess1.mat']);
            %  load(mFR_path,'mFRStructNonStim'); 
            % 
            % mFRStructNonStim.mFRArr =  mFRStructNonStim.mFRArr(:, 2:end); %need to remove 1st tr

      
    info_path = ([path_i '_Info.mat']);
    load(info_path, 'beh');

     Delay5s = (beh.delayLen/1000000) > 4.9;
     Delay5s = Delay5s(2:end); %remove first tr
     Delay3s = (beh.delayLen/1000000) < 3.1;
     Delay3s = Delay3s(2:end); %remove first tr

     AllTr = 1:length(Delay3s);

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

    
 
    indTime = time
    Neurons = 1:length(filteredSpikeArray);
    Trials =    1:size(filteredSpikeArray{1},1);    
    TrialsEven = Trials(2:2:end);
    
    for j = 1:length(Neurons)
        k = Neurons(j);
        fsa_j = filteredSpikeArray{k}(:,1:indTime);
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
    
     rec_name = [];
    neu_id = [];
    ratio0to1BefRun = [];
    isRise = [];
    isDown = [];
    mFR = [];
     

     for j = 1:length(Neurons)
        k = Neurons(j);
        fsa_j = filteredSpikeArray{k}(Delay5s,1:indTime);
        mean_fsa_temp = mean(fsa_j,1);
        
        %normalize to get rid of neg dFF values
        mean_fsa_j =  (mean_fsa_temp - min(mean_fsa_temp))/(max(mean_fsa_temp) - min(mean_fsa_temp));     
        ratio0to1BefRun_j = mean(mean_fsa_j(indFR0to1))/mean(mean_fsa_j(indFRBefRun));     
        fsa_j_norm = [];
 
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
      
        
        rec_name = [rec_name ; string(filename(1,1:16))];
        neu_id = [neu_id ; k];
        ratio0to1BefRun = [ratio0to1BefRun ; ratio0to1BefRun_j];
     end

 
    
    RiseDownTable5s = table(rec_name, neu_id, ratio0to1BefRun, isRise, isDown);
    clear mean_fsa_j ratio0to1BefRun_i  neu_id ratio0to1BefRun isRise isDown  
   rec_name = [];
    neu_id = [];
    ratio0to1BefRun = [];
    isRise = [];
    isDown = [];
    mFR = [];
     


     for j = 1:length(Neurons)
        k = Neurons(j);
        fsa_j = filteredSpikeArray{k}(Delay3s,1:indTime);
        mean_fsa_temp = mean(fsa_j,1);
        
        %normalize to get rid of neg dFF values
        mean_fsa_j =  (mean_fsa_temp - min(mean_fsa_temp))/(max(mean_fsa_temp) - min(mean_fsa_temp));     
        ratio0to1BefRun_j = mean(mean_fsa_j(indFR0to1))/mean(mean_fsa_j(indFRBefRun));     
        fsa_j_norm = [];
 
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
      
        
        rec_name = [rec_name ; string(filename(1,1:16))];
        neu_id = [neu_id ; k];
        ratio0to1BefRun = [ratio0to1BefRun ; ratio0to1BefRun_j];
       end
    
    RiseDownTable3s = table(rec_name, neu_id, ratio0to1BefRun, isRise, isDown);
    clear mean_fsa_j ratio0to1BefRun_i  neu_id ratio0to1BefRun isRise isDown  

    for Block = 1:4
        if Block == 1 
            Trials = Delay3sBlock1
        elseif Block == 2 
            Trials = Delay5sBlock1
        elseif Block == 3
            Trials = Delay3sBlock2
            elseif Block == 4
            Trials = Delay5sBlock2
        end
   rec_name = [];
    neu_id = [];
    ratio0to1BefRun = [];
    isRise = [];
    isDown = [];
    mFR = [];
     
     for j = 1:length(Neurons)
        k = Neurons(j);
        fsa_j = filteredSpikeArray{k}(Trials,1:indTime);
        mean_fsa_temp = mean(fsa_j,1);
        
        %normalize to get rid of neg dFF values
        mean_fsa_j =  (mean_fsa_temp - min(mean_fsa_temp))/(max(mean_fsa_temp) - min(mean_fsa_temp));     
        ratio0to1BefRun_j = mean(mean_fsa_j(indFR0to1))/mean(mean_fsa_j(indFRBefRun));     
        fsa_j_norm = [];
 
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
      
        
        rec_name = [rec_name ; string(filename(1,1:16))];
        neu_id = [neu_id ; k];
        ratio0to1BefRun = [ratio0to1BefRun ; ratio0to1BefRun_j];
       end
    
    RiseDownTableTemp = table(rec_name, neu_id, ratio0to1BefRun, isRise, isDown);

        if Block == 1 
            RiseDownTable3sBlock1 = RiseDownTableTemp
        elseif Block == 2 
            RiseDownTable5sBlock1 = RiseDownTableTemp
        elseif Block == 3
           RiseDownTable3sBlock2 = RiseDownTableTemp
            elseif Block == 4
              RiseDownTable5sBlock2 = RiseDownTableTemp
        end

    clear mean_fsa_j ratio0to1BefRun_i  neu_id ratio0to1BefRun isRise isDown  RiseDownTableTemp

    end


   cd(save_path(i,:))
    save_path1 = [filename(1,1:16) '_RiseDownID_' CondStr 'WholePop' thresStr '.mat'];
    save(save_path1, 'RiseDownTable', 'RiseDownTable3s', 'RiseDownTable5s', 'RiseDownTable3sBlock1', 'RiseDownTable3sBlock2', 'RiseDownTable5sBlock1', 'RiseDownTable5sBlock2');
    clear  Neurons filteredSpikeArray
        end
   end    
end