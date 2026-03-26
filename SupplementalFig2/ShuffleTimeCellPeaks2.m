%% code to shuffle time cell peaks and check for signficicance 

function ShuffleTimeCellPeaks2(Paths, trtype, cond, Early)

        for k = 1:size(Paths,1)
            Path = Paths{k,:};
            Filename = [Path(1,43:58) '_DataStructure_mazeSection1_TrialType1'];
             if (cond == 1)
                condStr = 'Cue';
                namex = ('Time from cue onset (s)')
               elseif (cond == 2)
                   condStr = 'Rew';
                    namex = ('Time from reward (s)')
               elseif (cond == 3)
                   condStr = 'LastLick';       
                    namex = ('Time from last lick (s)')
               elseif (cond == 4)
                   condStr = 'Lick';      
                   namex = ('Time from lick (s)')
             end
         
            if trtype == 1 
            fieldpath = [Path 'FieldDetectionShuffle\'];
            cd(fieldpath)
            fieldfilename = ['FieldIndexShuffle' condStr '99.mat'];
            load(fieldfilename)
            Fields =  FieldID;
            Fstr = ['Fields'  'dFFGF-Shuf99']
            elseif trtype == 2
            fieldpath = [Path 'FieldDetectionShuffleLateLick\'];
            cd(fieldpath)
            fieldfilename = ['FieldIndexShuffle' condStr 'LateLickTr' '99.mat'];
            load(fieldfilename)
            Fields =  FieldID;
            Fstr = ['Fields'  'dFFGF-Shuf99']
               elseif trtype == 3
            fieldpath = [Path 'FieldDetectionShuffleEarlyLick\'];
            cd(fieldpath)
            fieldfilename = ['FieldIndexShuffle' condStr 'EarlyLickTr' '99.mat'];
            load(fieldfilename)
            Fields =  FieldID;
            Fstr = ['Fields'  'dFFGF-Shuf99']
            end
           timeMax = [3500];  %changed from 4000 3/11
            cd(Path)
            load('FirstLick_LL.mat')
            ConvPath = ([Filename '_convSpikesAlignedLastLick_msess1.mat']);
            load(ConvPath,'dFFArray','paramC');
            filteredSpikeArray = dFFArray;
             AllTrials = 1:size(filteredSpikeArray{1},1)
            if Early == 2
                Trials = 1:size(filteredSpikeArray{1},1);
                savestr = 'AllTr';
                elseif Early == 1
               Trials = AllTrials(Ind_35to45); 
               savestr = '3545';
                elseif Early == 0
                  Trials = AllTrials(Ind_5to6); 
                   savestr = '56';
            end
            avgFilteredSpikeArrayAll  = avgFilteredSpikeArray(filteredSpikeArray,Trials,Fields, timeMax);
            for neur = 1:size(Fields,2)
                [~,indPeakTmp] = max(avgFilteredSpikeArrayAll(neur,:));
                indPeak(neur) = indPeakTmp(1);
            end
   
           


            %%shuffle the array
            numShuffle = 1000;
               rowArray = size(avgFilteredSpikeArrayAll,1);
                colArray = size(avgFilteredSpikeArrayAll,2);
                shufMeanArray_i = zeros(rowArray,colArray);
              indPeak_Shuf_i = zeros(numShuffle, rowArray);
                Peak_i = [];
               parfor i = 1:numShuffle
                   indPeak_Shuf_temp = zeros(rowArray,1);
               
                    randShift = randi([1 colArray], rowArray, 1);
                    for j = 1:rowArray %%neuron
                        shiftTmp = circshift(avgFilteredSpikeArrayAll(:,1:colArray)',randShift(j));
                        [~,indPeakTmp] = max(shiftTmp);
                        indPeak_Shuf_temp(j) = indPeakTmp(1);
                   
                    end
                       
                       indPeak_Shuf_i(i,:) = indPeak_Shuf_temp';
               end
       
             cd(fieldpath)
   
           savename= ['PeaksShuffleResults_1000' condStr  savestr '7s.mat']
          save(savename, 'indPeak_Shuf_i', 'indPeak', 'Peak_i')
          clearvars -except Paths cond condStr trtype Early
        end
 
end

 function [avgFilteredSpikeArr]...
                = avgFilteredSpikeArray(filteredSpikeArr,indTr,neuronNo, timeMax)
    % lenTr = size(filteredSpikeArr{neuronNo(1)},2);
    lenTr = timeMax;
    nTrials = length(indTr);
    nNeurons = length(neuronNo);
    avgFilteredSpikeArr = zeros(nNeurons,lenTr);
    for i = 1:nNeurons
        avgFilteredSpikeTmp = zeros(1,lenTr);
        for j = 1:nTrials
            avgFilteredSpikeTmp = avgFilteredSpikeTmp + filteredSpikeArr{neuronNo(i)}(indTr(j),1:timeMax);
        end
     avgFilteredSpikeArr(i,:) =  (avgFilteredSpikeTmp - min(avgFilteredSpikeTmp))/(max(avgFilteredSpikeTmp) - min(avgFilteredSpikeTmp)); 

    end      
 end