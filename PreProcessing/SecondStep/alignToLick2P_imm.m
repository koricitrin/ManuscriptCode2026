function alignToLick2P_imm(path, fileName, mazeSess)
    % aligns trials to first predictive lick 
    
    indexFileName = findstr(fileName, '.mat');
    if(~isempty(indexFileName))
        fileName = fileName(1:indexFileName(end)-1);
    end
   
    fileNameLick = [fileName '_alignLick_msess' num2str(mazeSess) '.mat'];                    
   
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
    
    trialsLick = [];
    indTr = find(Laps.mazeSess == mazeSess);

    firstLickLfpInd = {};
    for i = 1:length(Laps.lickLfpInd)
        if sum(Laps.lickLfpInd{i}  > Laps.movieOnLfpInd{i}(2)) == 0
            first_lick_i = [];
        else
            first_lick_i = Laps.lickLfpInd{i}(find(Laps.lickLfpInd{i}  > Laps.movieOnLfpInd{i}(2),1));
        end
        firstLickLfpInd{end + 1} = first_lick_i;
    end
    
    
    for i = 1:length(indTr) - 1
        
        if(i == 1)
            trialsLick.pumpLfpInd{i} = Laps.pumpLfpInd{indTr(i)};
            trialsLick.firstLickLfpInd{i} = firstLickLfpInd{indTr(i)};
        end
        
        trialsLick.pumpLfpInd{i+1} = Laps.pumpLfpInd{indTr(i+1)};
        trialsLick.firstLickLfpInd{i+1} = firstLickLfpInd{indTr(i+1)};
        
        
        if(~isempty(trialsLick.firstLickLfpInd{i}))
            trialsLick.goodTrial(i+1) = 1;
            trialsLick.startLfpInd(i+1) = firstLickLfpInd{indTr(i)};   %Laps.pumpLfpInd{indTr(i)}(1); 
%             try
%                 trialsLick.startLfpInd(i+1) = firstLickLfpInd{indTr(i)};   %Laps.pumpLfpInd{indTr(i)}(1); 
%             catch
%                 disp('here');
%             end
        else
            trialsLick.goodTrial(i+1) = -1; % trials without reward
            trialsLick.startLfpInd(i+1) = Laps.startLfpInd(indTr(i+1)); 
        end
        
        trialsLick.endLfpInd(i+1) = Laps.endLfpInd(indTr(i+1)); 
        trialsLick.numSamples(i+1) = trialsLick.endLfpInd(i+1) - ...
            trialsLick.startLfpInd(i+1)+1;

        indEeg = trialsLick.startLfpInd(i+1):trialsLick.endLfpInd(i+1);
        trialsLick.dFF{i+1} = Track.dFFSM(indEeg,:);
        trialsLick.dFFGF{i+1} = Track.dFFGF(indEeg,:); % added on 9/6/2023 by Yingxue
        trialsLick.F{i+1} = Track.F(indEeg,:);
        trialsLick.Fneu{i+1} = Track.Fneu(indEeg,:);
        trialsLick.spikes{i+1} = Track.spikesSM(indEeg,:);
         
        licks = [Laps.lickLfpInd{indTr(i)}; Laps.lickLfpInd{indTr(i+1)}];
        indLick = licks > trialsLick.startLfpInd(i+1);
        trialsLick.lickLfpInd{i+1} = licks(indLick);
        
        indEegBef = trialsLick.startLfpInd(i+1)-befTime*sampleFq:trialsLick.startLfpInd(i+1)-1;
        idxTmp = find(indEegBef <= 0);
        if(~isempty(idxTmp))
            indEegBef(idxTmp) = 1;
        end
        trialsLick.dFFBef{i+1} = Track.dFFSM(indEegBef,:);
        trialsLick.dFFBefGF{i+1} = Track.dFFGF(indEegBef,:); % added on 9/6/2023 by Yingxue
        trialsLick.FBef{i+1} = Track.F(indEegBef,:);
        trialsLick.FneuBef{i+1} = Track.Fneu(indEegBef,:);
        trialsLick.spikesBef{i+1} = Track.spikesSM(indEegBef,:);
        
        if(i > 1)
            licks = [Laps.lickLfpInd{indTr(i-1)}; Laps.lickLfpInd{indTr(i)}; Laps.lickLfpInd{indTr(i+1)}];
        end
        indLick = licks >= trialsLick.startLfpInd(i+1)-befTime*sampleFq & ... 
            licks <= trialsLick.startLfpInd(i+1)-1;
        trialsLick.lickLfpIndBef{i+1} = licks(indLick);
    end
    
    save([path fileNameLick],'trialsLick','-v7.3');
    
end
