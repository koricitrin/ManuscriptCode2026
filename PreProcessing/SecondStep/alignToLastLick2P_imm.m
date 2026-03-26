function alignToLastLick2P_imm(path, fileName, mazeSess)
    % aligns trials to last lick in previous trial
    
    indexFileName = findstr(fileName, '.mat');
    if(~isempty(indexFileName))
        fileName = fileName(1:indexFileName(end)-1);
    end
   
    fileNameLick = [fileName '_alignLastLick_msess' num2str(mazeSess) '.mat'];                    
   
    indRecName = strfind(fileName, '_');
    fileNameBehElec = [fileName(1:indRecName) 'Behav2PDataLFP.mat'];
            
    fullPath = [path fileNameBehElec];
    if(exist(fullPath) == 0)
        disp('The recording BehElectDataLFP file does not exist.');
        disp(fullPath)
        return;
    end
    load(fullPath,'Laps','Track');
    
    GlobalConst2P_imm;
    
    trialsLastLick = [];
    indTr = find(Laps.mazeSess == mazeSess);

    LastLickLfpInd = {};
    
    for i = 1:length(Laps.lickLfpInd)
        if isempty(Laps.lickLfpInd{i})
            last_lick_i = [];
        else
            last_lick_i = Laps.lickLfpInd{i}(end);
        end
        LastLickLfpInd{end + 1} = last_lick_i;
    end
    
    
    for i = 1:length(indTr) - 1
        
        if(i == 1)
            trialsLastLick.pumpLfpInd{i} = Laps.pumpLfpInd{indTr(i)};
            trialsLastLick.lastLickLfpInd{i} = LastLickLfpInd{i};
        end
        
        trialsLastLick.pumpLfpInd{i+1} = Laps.pumpLfpInd{indTr(i+1)};
        trialsLastLick.lastLickLfpInd{i+1} = LastLickLfpInd{i+1};
                
        if(~isempty(trialsLastLick.lastLickLfpInd{i}))
            trialsLastLick.goodTrial(i+1) = 1;
            trialsLastLick.startLfpInd(i+1) = LastLickLfpInd{indTr(i)};   %Laps.pumpLfpInd{indTr(i)}(1); 
%             try
%                 trialsLastLick.startLfpInd(i+1) = firstLickLfpInd{indTr(i)};   %Laps.pumpLfpInd{indTr(i)}(1); 
%             catch
%                 disp('here');
%             end
        else
            trialsLastLick.goodTrial(i+1) = -1; % trials without reward
            trialsLastLick.startLfpInd(i+1) = Laps.startLfpInd(indTr(i+1)); 
        end
                
        trialsLastLick.endLfpInd(i+1) = Laps.endLfpInd(indTr(i+1)); 
        trialsLastLick.numSamples(i+1) = trialsLastLick.endLfpInd(i+1) - ...
            trialsLastLick.startLfpInd(i+1)+1;

        indEeg = trialsLastLick.startLfpInd(i+1):trialsLastLick.endLfpInd(i+1);
        trialsLastLick.dFF{i+1} = Track.dFFSM(indEeg,:);
        trialsLastLick.dFFGF{i+1} = Track.dFFGF(indEeg,:); % added on 9/6/2023 by Yingxue
        trialsLastLick.F{i+1} = Track.F(indEeg,:);
        trialsLastLick.Fneu{i+1} = Track.Fneu(indEeg,:);
        trialsLastLick.spikes{i+1} = Track.spikesSM(indEeg,:);
        
        licks = [Laps.lickLfpInd{indTr(i)}; Laps.lickLfpInd{indTr(i+1)}];
        indLick = licks > trialsLastLick.startLfpInd(i+1);
        trialsLastLick.lickLfpInd{i+1} = licks(indLick);
           
        indEegBef = trialsLastLick.startLfpInd(i+1)-befTime*sampleFq:trialsLastLick.startLfpInd(i+1)-1;
        trialsLastLick.dFFBef{i+1} = Track.dFFSM(indEegBef,:);
        trialsLastLick.dFFBefGF{i+1} = Track.dFFGF(indEegBef,:); % added on 9/6/2023 by Yingxue
        trialsLastLick.FBef{i+1} = Track.F(indEegBef,:);
        trialsLastLick.FneuBef{i+1} = Track.Fneu(indEegBef,:);
        trialsLastLick.spikesBef{i+1} = Track.spikesSM(indEegBef,:);
        
        indLick = licks >= trialsLastLick.startLfpInd(i+1)-befTime*sampleFq & ... 
            licks <= trialsLastLick.startLfpInd(i+1)-1;
        trialsLastLick.lickLfpIndBef{i+1} = licks(indLick);
       
    end

    save([path fileNameLick],'trialsLastLick','-v7.3');
    
end