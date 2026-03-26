function FieldDetectionAligned2p_ShuffleddFFFuncLateLickTr(Paths,cond, licktime)
    for k = 1:size(Paths,1)
  
        if(cond == 2)
            condStr = 'Rew';
        elseif(cond == 1)
            condStr = 'Cue';
        elseif(cond == 3)
            condStr = 'LastLick';
        else
            condStr = 'Lick';
        end
    odorOnsetBin = 1;
    delayOffsetBin = 4000;
    %max average rate in a particulr bin 
    % PARAMETERS
    nShuffles = 100;
    binSize = 0.002; % sec, change if your binning is different
    maxFieldDuration = 4; % seconds
    minFieldDuration = 0.5;
    maxFieldBins = maxFieldDuration / binSize;
    
    FieldID = [];
    FieldSize = [];
    path = Paths{k,:}
    sess = path(1,43:58)
    cd(path)
    arraypath = [sess '_DataStructure_mazeSection1_TrialType1_convSpikesAligned' condStr '_msess1.mat']

    load(arraypath)
load('FirstLick_LL.mat')
    if licktime == 1 
    TrSel = FirstLick > 5;
  
      foldername = ['FieldDetectionShuffleLateLick' ]
          savename = ['FieldIndexShuffle' condStr 'LateLickTr' '99.mat'];
    elseif licktime == 2
   TrSel = FirstLick > 3.5 & FirstLick < 4.5;

      foldername = ['FieldDetectionShuffleEarlyLick' ]
          savename = ['FieldIndexShuffle' condStr 'EarlyLickTr' '99.mat'];
    end

    
    mkdir(foldername)
    savepath = [path foldername]
    cd(savepath)
          
    % savepath = [path 'FieldDetectionShuffle\']
    % cd(savepath)
    % 
    firingRatesAll = dFFArray;


    
    delete(gcp('nocreate'))
     parpool('local',4);
    for neurons  = 1:size(firingRatesAll,2)
     firingRates = dFFArray{neurons}(TrSel,:);
    % Example input: firingRates (nTrials x nTimeBins)
    [nTrials, nBins] = size(firingRates);
    % ActiveTrials =nTrials*0.25;
    % if meanCorrTCue.nNonZeroTr(neurons) < ActiveTrials;
    %     continue
    % end
    
    % Step 1: Compute mean firing rate across trials
    meanRate = mean(firingRates, 1);
    
    % Step 2: Find time bin of max average firing rate
    [maxVal, maxBin] = max(meanRate);
    
    % Step 3: Circular shuffle and build null distribution
    nullMaxVals = zeros(1, nShuffles);
    for i = 1:nShuffles
        shiftedRates = zeros(size(firingRates));
        for t = 1:nTrials
            shiftAmount = randi([-nBins, nBins]); % ± full delay interval
            shiftedRates(t, :) = circshift(firingRates(t, :), shiftAmount, 2);
        end
        nullMean = mean(shiftedRates, 1);
        nullMaxVals(i) = max(nullMean);
    end
    
    % Step 4: Significance threshold (95th percentile)
    threshold = prctile(nullMaxVals, 99);
    isSignificant = maxVal > threshold;
    
    % Step 5: Label as odor-cell or time-cell
    if isSignificant
            cellType = 'time-cell';
    end
    
    % Step 6: Estimate field size
    % Filter the mean trace using lowpass filter <1Hz
    fs = 1 / binSize; % Sampling frequency
    lowpassCutoff = 1; % Hz
    
    filteredRate = lowpass(meanRate, lowpassCutoff, fs); 
    
    % Use preferred trials (could mean those with highest firing)
    % Here, we assume meanRate is the relevant signal
    
    % Compute baseline using mode
    baseline = mode(filteredRate(odorOnsetBin:delayOffsetBin));
    
    % Threshold = baseline + 0.5 * std
    rateSegment = filteredRate(odorOnsetBin:delayOffsetBin);
    thresholdVal = baseline + 0.5 * std(rateSegment);
    
    % Find left and right boundaries around peak
    left = maxBin;
    while left > odorOnsetBin && filteredRate(left) > thresholdVal
        left = left - 1;
    end
    if left == maxBin, left = odorOnsetBin; end
    
    right = maxBin;
    while right < delayOffsetBin && filteredRate(right) > thresholdVal
        right = right + 1;
    end
    if right == maxBin, right = delayOffsetBin; end
    
    % Field size
    fieldSizeBins = right - left + 1;
    fieldSizeSec = fieldSizeBins * binSize;
    
    % Reject too-large fields
    if fieldSizeSec > maxFieldDuration
        fieldSizeSec = NaN;
        % disp('Field size exceeds max duration; discarded.');
    elseif fieldSizeSec < minFieldDuration 
          fieldSizeSec = NaN;
        % disp('Field size is smaller than min duration; discarded.');
    end
     %% number of trials that having spikes within the field
          indStart = left;
          indEnd = right;
            nonZeroTrField = sum(firingRates(:,indStart:indEnd),2);
            numActiveFieldTr = sum(nonZeroTrField > 0);
            if(numActiveFieldTr <  nTrials*0.20);
               trReq = 0;
                disp('not enough in field firing; discard .');
            elseif (numActiveFieldTr >  nTrials*0.20);
                trReq = 1;
            end
    
    if ~isnan(fieldSizeSec) && isSignificant && trReq == 1;    
    
    FieldID = [FieldID, neurons];
    FieldSize = [FieldSize, fieldSizeSec];
    else 
    
    end
    
    % % OUTPUT
    % fprintf('Max rate: %.2f Hz at bin %d\n', maxVal, maxBin);
    % fprintf('Significant field: %d (%s)\n', isSignificant, cellType);
    % fprintf('Field size: %.2f sec\n', fieldSizeSec);
    % 
    % figure;
    % plot((1:nBins)*binSize, meanRate, 'k', 'LineWidth', 1.5); hold on;
    % plot((1:nBins)*binSize, filteredRate, 'r');
    % yline(thresholdVal, '--b');
    % xline(maxBin*binSize, '--g', 'Max Rate Bin');
    % xlim([0 8])
    % xlabel('Time (s)'); ylabel('Firing Rate (Hz)');
    % legend('Mean Firing', 'Filtered', 'Threshold', 'Max Bin');
    % if ~isnan(fieldSizeSec) && isSignificant;    
    % T = ['Neuron' num2str(neurons) 'Field' ];
    % title(T)
    % FieldID = [FieldID, neurons]
    % else 
    %   T = ['Neuron' num2str(neurons) 'Not Field' ];
    %   title(T)
    % end
    % savefig([T '.fig'])
    % print('-painters','-dpng',[T],'-r600');
    end
    FieldID
    
    save(savename,'FieldID')
    clearvars -except Paths condStr cond k licktime
     end
    
end