function ConvSpikeTrain_AlignedBef2P_imm(path, fileName, mazeSess, cond)
% convolve spike train with gaussian filter in time
% e.g. ConvSpikeTrain_Aligned('./','A011-20190218-01_DataStructure_mazeSection1_TrialType1',0)
%


    if(cond == 1)
        fileName1 = [fileName '_alignRew_msess' num2str(mazeSess) '.mat']; 
        condStr = 'Rew';
    elseif(cond == 2)
        fileName1 = [fileName '_alignCue_msess' num2str(mazeSess) '.mat']; 
        condStr = 'Cue';
    elseif(cond == 3)
        fileName1 = [fileName '_alignLastLick_msess' num2str(mazeSess) '.mat']; 
        condStr = 'LastLick';
    elseif(cond == 4)
        fileName1 = [fileName '_alignLick_msess' num2str(mazeSess) '.mat']; 
        condStr = 'Lick';
    elseif(cond == 5)
        fileName1 = [fileName '_alignCueOff_msess' num2str(mazeSess) '.mat']; 
        condStr = 'CueOff';    
    end
    fullPath = [path fileName1];
    if(exist(fullPath) == 0)
        disp(['The align ' condStr ' file does not exist']);
        return;
    end
    load(fullPath);
    
    if(cond == 1)
        trials = trialsRew;
    elseif(cond == 2)
        trials = trialsCue;
    elseif(cond == 3)
        trials = trialsLastLick;
    elseif(cond == 4)
        trials = trialsLick;
    elseif(cond == 5)
        trials = trialsCueOff;    
    end
           
%     fullPath = [path fileName '_behPar_msess' num2str(mazeSess) '.mat']; 
%     if(exist(fullPath) == 0)
%         disp('The _behPar file does not exist');
%         return;
%     end
%     load(fullPath);
    
    GlobalConst2P_imm;
    
    paramC.trialLenT = 20; %sec
    paramC.timeBin = timeStep; %sec
    std = timeBin/paramC.timeBin;
    paramC.gaussFilt = gaussFilter2P(12*std, std);
    lenGaussKernel = length(paramC.gaussFilt);
    normFactor = sum(paramC.gaussFilt);
    paramC.gaussFilt = paramC.gaussFilt./normFactor;
    paramC.timeSteps = -befTime:timeStep:paramC.trialLenT-befTime-timeStep;
        
    trialNo = length(trials.dFF);
    neuronNo = size(trials.dFF{end},2);
    nMaxSample = round(paramC.trialLenT*sampleFq);
              
    disp('Convolve spike trains with Gaussian kernel')
    [filteredSpikeArray,dFFArray] = convSpikeTrain(trials,trialNo,neuronNo,nMaxSample,...
                    paramC.gaussFilt,lenGaussKernel,paramC.timeBin);
    
    fileNameConv = [fileName '_convSpikesAlignedBef' condStr '_msess' num2str(mazeSess)  '.mat'];
    fullPath = [path fileNameConv];
    save(fullPath, 'filteredSpikeArray','dFFArray','paramC','-v7.3'); 
    
end

function [filteredSpikeArrayRun,dFFArrayRun] = convSpikeTrain(trialsRun,trialNo,neuronNo,nMaxSample,...
                    gaussFilt,lenGaussKernel,timeBin)

    for i  = 1:neuronNo
       % disp(['Neuron ' num2str(i)]);   
        %% filter spikes aligned to start run
        filteredSpikeArrayTmp = zeros(trialNo,nMaxSample);
        dFFArrayTmp = zeros(trialNo,nMaxSample);
        for j = 1:trialNo
            if(isempty(trialsRun.spikes{j}) && isempty(trialsRun.spikesBef{j}))
                continue;
            end
            spike = [trialsRun.spikesBef{j}(:,i)' trialsRun.spikes{j}(:,i)'];
            numSamples = min(length(spike),nMaxSample);
            spike = spike(1:numSamples);  
            spikeArray = [spike(numSamples-lenGaussKernel+1:numSamples)...
                        spike spike(1:lenGaussKernel)];
                    
            filteredSpikeTmp = conv(spikeArray,gaussFilt);
            filteredSpikeArrayTmp(j,1:numSamples) = ...
                filteredSpikeTmp(floor(lenGaussKernel/2)+lenGaussKernel+1:...
                    (end-2*lenGaussKernel+floor(lenGaussKernel/2)+1));  
                 
            dFF = [trialsRun.dFFBefGF{j}(:,i)' trialsRun.dFFGF{j}(:,i)']; % changed to use gaussian filtered dFF instead of the thresholded dFF
            dFFArrayTmp(j,1:numSamples) = dFF(1:numSamples);
        end
        
        filteredSpikeArrayRun{i} = filteredSpikeArrayTmp/timeBin; % added *sampleFq on 1/7/2022 ;
        dFFArrayRun{i} = dFFArrayTmp;
        clear filteredSpikeArrayTmp dFFArrayTmp spike spikeArray filteredSpikeTmp
    end

end

