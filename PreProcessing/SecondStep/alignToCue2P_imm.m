function alignToCue2P_imm(path, fileName, mazeSess)
% align the spikes in each trial to the cue onset of the last trial

    indexFileName = findstr(fileName, '.mat');
    if(~isempty(indexFileName))
        fileName = fileName(1:indexFileName(end)-1);
    end
    
    fileNameCue = [fileName '_alignCue_msess' num2str(mazeSess) '.mat'];  
  
    indRecName = strfind(fileName, '_');
    fileNameBehElec = [fileName(1:indRecName) 'Behav2PDataLFP.mat'];
            
    fullPath = [path fileNameBehElec];
    if(exist(fullPath) == 0)
        disp('The recording Behav2PDataLFP file does not exist.');
        disp(fullPath)
        return;
    end
    load(fullPath,'Laps','Track');
    
    GlobalConst2P_imm;
     
    trialsCue = [];
    indTr = find(Laps.mazeSess == mazeSess);
    for i = 2:length(indTr)
        trialsCue.pumpLfpInd{i} = Laps.pumpLfpInd{indTr(i)};
         if(~isempty(trialsCue.pumpLfpInd{i}))
            trialsCue.goodTrial(i) = 1;
        else
            trialsCue.goodTrial(i) = -1;
        end
        trialsCue.startLfpInd(i) = Laps.startLfpInd(indTr(i)); 
        trialsCue.endLfpInd(i) = Laps.endLfpInd(indTr(i)); 
        trialsCue.numSamples(i) = trialsCue.endLfpInd(i) - ...
            trialsCue.startLfpInd(i)+1;
        
        indEeg = trialsCue.startLfpInd(i):trialsCue.endLfpInd(i);
        trialsCue.dFF{i} = Track.dFFSM(indEeg,:);
        trialsCue.dFFGF{i} = Track.dFFGF(indEeg,:); % added on 9/6/2023 by Yingxue
        trialsCue.F{i} = Track.F(indEeg,:);
        trialsCue.Fneu{i} = Track.Fneu(indEeg,:);
        trialsCue.spikes{i} = Track.spikesSM(indEeg,:);
        
        indLick = Laps.lickLfpInd{indTr(i)} > trialsCue.startLfpInd(i);
        trialsCue.lickLfpInd{i} = Laps.lickLfpInd{indTr(i)}(indLick);
        
        indEegBef = trialsCue.startLfpInd(i)-befTime*sampleFq:trialsCue.startLfpInd(i)-1;
        trialsCue.dFFBef{i} = Track.dFFSM(indEegBef,:);
        trialsCue.dFFBefGF{i} = Track.dFFGF(indEegBef,:); % added on 9/6/2023 by Yingxue
        trialsCue.FBef{i} = Track.F(indEegBef,:);
        trialsCue.FneuBef{i} = Track.Fneu(indEegBef,:);
        trialsCue.spikesBef{i} = Track.spikesSM(indEegBef,:);
        
        licks = [Laps.lickLfpInd{indTr(i-1)}; Laps.lickLfpInd{indTr(i)}];
        indLick = licks >= trialsCue.startLfpInd(i)-befTime*sampleFq & ... 
            licks <= trialsCue.startLfpInd(i)-1;
        trialsCue.lickLfpIndBef{i} = licks(indLick);
    end
    
    save([path fileNameCue],'trialsCue','-v7.3');
end
