function NaiveBayesWithCrossValImmRiseLLDownL_EarlyLate(paths, delay, cond, TablePath, TrType, PAC)
% use a subpopulation of neurons to predit time or distance
addpath 'Z:\Kori\immobile_code\Decoder\'
if cond == 1
    CondStr = 'Cue';
elseif cond == 2
    CondStr = 'LastLick';
elseif cond == 3
    CondStr = 'Rew'
elseif Cond == 4
    CondStr = 'Lick'
end

 % sec = 5 for 2s, 6 for 3s, 7 for 4s delay 
% %%%Note: get fileName from path
    for   i = 1:size(paths,1)
    path = paths{i,1:end};
     cd(path)
     sessions = path(1, 43:58)

      filenames = [sessions  '_DataStructure_mazeSection1_TrialType1'];

      if delay == 44       
        paramC.trialLenT = 6.5; %sec
        timelength = 3250;
        bins = 65;
      elseif delay == 4
        paramC.trialLenT = 7; %sec
        timelength = 3500;
        bins = 70;  
        
      elseif delay == 22
        paramC.trialLenT = 4.5; %sec
        timelength = 2250;
        bins = 45;
       elseif delay == 33
        paramC.trialLenT = 5.5; %sec
        timelength = 2750;
        bins = 55;  
        
      end    
      
    mazeSess = 1;

    GlobalConst2P_imm;
    
   paramC.minTrNum = 30;
    paramC.timeBin = 0.002; %sec
    std0 = 0.2/paramC.timeBin; %0.2
    paramC.timeBin1 = 0.1; %sec
    timeBinRatio = paramC.timeBin1/paramC.timeBin;
%     std0 = 0.05/paramC.timeBin;
    paramC.gaussFilt = gaussFilter(12*std0, std0);
    lenGaussKernel = length(paramC.gaussFilt);
    normFactor = sum(paramC.gaussFilt);
    paramC.gaussFilt = paramC.gaussFilt./normFactor;
    paramC.numShuffle = 50;
    paramC.minNoNeurons = 20;
    
    nMaxSample = paramC.trialLenT*sampleFq;
    nSamplePerBin = paramC.timeBin*sampleFq;
    if(floor(nSamplePerBin/2) ~= 0)
        paramC.timeStep = floor(nSamplePerBin/2):nSamplePerBin:nMaxSample;
    else
        paramC.timeStep = 1:nSamplePerBin:nMaxSample;
    end

    nSamplePerBin = paramC.timeBin1*sampleFq;
    paramC.timeStep1 = floor(nSamplePerBin/2):nSamplePerBin:nMaxSample;
    nBins = length(paramC.timeStep);
        
     numRec = 1   
            
    naiveBayes = struct( ...
        'trialNo',{cell(1,numRec)},...
        'indNeu',{cell(1,numRec)},...
        'task',zeros(1,numRec),...
        ...
        'filteredSpikeNorm2',{cell(1,numRec)},...
        'time',{cell(1,numRec)},...
        'mdlNorm2',{cell(1,numRec)},...
        'labelN2',{cell(1,numRec)},...
        'PosteriorN2',{cell(1,numRec)},...
        'CostN2',{cell(1,numRec)},...
        'decodingErr',{cell(1,numRec)},...
        'cmNorm2',{cell(1,numRec)},...
        ...
        'labelN2Shuf',{cell(numRec,paramC.numShuffle)},...
        'PosteriorN2Shuf',{cell(numRec,paramC.numShuffle)},...
        'decodingErrShuf',{cell(numRec,paramC.numShuffle)});
    
    naiveBayesMean = struct( ...
        'labelN2',{cell(1,numRec)},...
        'PosteriorN2',{cell(1,numRec)},...
        'CostN2',{cell(1,numRec)},...
        'decodingErr',{cell(1,numRec)},...
        ...
        'labelN2Shuf',{cell(1,numRec)},...
        'PosteriorN2Shuf',{cell(1,numRec)},...
        'decodingErrShuf',{cell(1,numRec)});
    

    
    for r = 1:numRec
        disp(['rec' num2str(r) ' ' filenames(r,:)])
               
        fileNamePeakFR = [filenames(r,:) '_PeakFRAligned' CondStr '_msess1.mat'];
        fullPath = [path fileNamePeakFR];
   
        load(fullPath, 'pFRNonStimStruct', 'trialNoNonStim');
         neuronNo = 1:size(pFRNonStimStruct.peakFR,2);
        indNeu = neuronNo;
        
       % trialNo = length(trialNoNonStim);
    
          fileNameConv = [filenames(r,:) '_align' CondStr '_msess1.mat'];
            fullPath = [path fileNameConv];
            load(fullPath);

            if cond == 1
            CondStr = 'Cue';
            trialsData = trialsCue;
             elseif cond == 2
            CondStr = 'LastLick';
            trialsData = trialsLastLick;
             elseif cond == 3
            CondStr = 'Rew'
            trialsData = trialsRew;
             elseif Cond == 4
            CondStr = 'Lick'
             trialsData = trialsLick;
            end
                    
             fileNameInfo = [filenames(r,:) '_Info.mat'];
             fullPath = [path fileNameInfo];
             load(fullPath);
             alltrials = beh.indTrCtrl -1;
             alltrials = alltrials(2:end);
             trialNoAll = size(alltrials,2);    
    

            load('FirstLick_LL.mat')
            FirstLick = FirstLick(2:end);
           Ind_5to6 = Ind_5to6(2:end);
           Ind_35to45 = Ind_35to45(2:end);
             Trials = 1:length(FirstLick);
             Trials_56 = Trials(Ind_5to6);
            Trials_3545 = Trials(Ind_35to45);

       for j = 1:size(indNeu,2) %neuron id
              trialsSpikeNeur{j} = [];
              nNeur =  indNeu(j);  
              for  i =2:size(trialsData.dFFGF,2) %tr num %%change to dFF from spikes
                  
                  spikesTr =  trialsData.dFFGF{i};
                neurTr = spikesTr(1:timelength,nNeur);
                trialsSpikeNeur{j} = [trialsSpikeNeur{j}; neurTr'];
                clearvars neurTr
              end
                  
             %  filteredSpikeArrayMat =  cell2mat(filteredSpikeArrayNew(i));     
         
       end
         
       
    cd(TablePath)

    if PAC == 1 
    load("RiseLastLickDownLickNeurons_thres.mat")
   % load("RiseLickDownLLNeurons.mat")

  tf = strcmp(sessions,RiseLLDownLickNeuronID.rec_name(:,1));
  k = [RiseLLDownLickNeuronID.neu_id(tf,:)];
  neurStr = 'PAC'
    elseif PAC == 2 
   load("RiseLickDownLLNeurons_thres.mat")
  tj = strcmp(sessions,RiseLickDownLLNeuronID.rec_name(:,1))
  k = [RiseLickDownLLNeuronID.neu_id(tj,:)];
neurStr = 'LickOn'
    end


    for neuID = 1:length(k)
       NeuronID =  k(neuID);
               if TrType == 1
             temp =  trialsSpikeNeur{NeuronID}(Ind_35to45,:);
             goodstr = '3545';
               trialNo =  size(Trials_3545,2);
               elseif TrType == 0
              temp =  trialsSpikeNeur{NeuronID}(Ind_5to6,:);
             goodstr = '56';  
               trialNo = size(Trials_56,2);
               elseif TrType == 2
              temp =  trialsSpikeNeur{NeuronID};
               trialNo =  trialNoAll; 
             goodstr = '';  
               end
     trialsSpikeNeurNew{neuID} = temp;
    
    end   


        % collect basic information about the session
      %  naiveBayes.trialNo{r} = trialNoNonStim;
        naiveBayes.indNeu{r} = k;
       neuronNo =  length(k);
        %% calculate filtered spike array for each neuron over  trials
        filteredSpikeArrayRunNorm2 = cell(1,neuronNo);        
        
        for i  = 1:neuronNo
          %  disp(['Neuron ' num2str(indNeu(i))]);   
            %% filter spikes aligned to start run
%             spikeArray = zeros(length(trialNoNonStim),nBins+2*lenGaussKernel);
            spikeArray = trialsSpikeNeurNew{i};

             filteredSpikeArrayRunNorm2{i} = zscore(spikeArray,0,2);
            
            % reshape the filtered spike array for training data
            tmp = filteredSpikeArrayRunNorm2{i}';
            tmp1 = reshape(tmp,timeBinRatio,[],size(tmp,2));
            tmp2 = reshape(tmp1,timeBinRatio,[]);
              % filteredSpikeNorm2((i-1)*timeBinRatio+1:i*timeBinRatio,:) = tmp2;  
            filteredSpikeNorm2(i,:) = mean(tmp2,1);  %%Edit so you have one vector per cell instead of 50 changed 11/2024
            


        end
        
        timeTmp = repmat(paramC.timeStep1'/sampleFq,1,trialNoAll);
        naiveBayes.timeTrain{r} = timeTmp(:);
       gpuTime = naiveBayes.timeTrain{r};
       % gpuTime= gpuTime(1:end-bins,1);
       gpuTime = gpuTime(1:length(filteredSpikeNorm2));
                
        %% naive bayes classification trian on 80%  tr test on 20%       
        kf = 10;
        naiveBayes.mdlNorm2{r} = fitcnb(filteredSpikeNorm2',gpuTime,'KFold', kf);
        [naiveBayes.labelN2{r},naiveBayes.PosteriorN2{r},naiveBayes.CostN2{r}] = ...
             kfoldPredict(naiveBayes.mdlNorm2{r});
         ('first model done')
        naiveBayes.decodingErr{r} = naiveBayes.labelN2{r}-gpuTime; 

         
        clear   indNeu newneuron filteredSpikeNorm2 filteredSpikeArrayRun filteredSpikeArray spikeArray trialsSpikeNeurNew filteredSpikeTmp
   
%        save_path = ['Z:\Kori\immobile_code\Decoder\fsaNorm\' filenames(r,:) '_filteredSpikeArrayRunNorm2Good.mat'];
%        save(save_path, 'gpuTimeGood', 'timeTmp', 'naiveBayes', 'filteredSpikeNorm2Good', 'filteredSpikeArrayRunNorm2Good',...
%            'paramC', 'timeBinRatio', '-v7.3'); 
        %  save([filenames(r,:) '_cmNorm2dFF.fig']);
       % print('-painters', '-dpng', [filenames(r,:) '_cmNorm2'], '-r600');
      
%         %% calculate mean of classification results
      nBins1 = nBins/timeBinRatio;
       % trialNo = trialNo + 1
        labelN2Tmp = reshape(naiveBayes.labelN2{r},nBins1,trialNo);
        naiveBayesMean.labelN2{r} = mean(labelN2Tmp,2);
        PosteriorN2Tmp = reshape(naiveBayes.PosteriorN2{r},nBins1,trialNo,nBins1);
        naiveBayesMean.PosteriorN2{r} = squeeze(mean(PosteriorN2Tmp,2));
        CostN2Tmp = reshape(naiveBayes.CostN2{r},nBins1,trialNo,nBins1);
        naiveBayesMean.CostN2{r} = squeeze(mean(CostN2Tmp,2));
        decodingErrTmp = reshape(naiveBayes.decodingErr{r},nBins1,trialNo);
        naiveBayesMean.decodingErr{r} = mean(decodingErrTmp,2);
        clear  decodingErrTmp  CostN2Tmp PosteriorN2Tmp labelN2Tmp
     cd(path)
    NB_Path = ['Decoder' neurStr '_' CondStr goodstr]
    NB_Save = [NB_Path '.mat']
        save([NB_Save],'naiveBayes','naiveBayesMean','paramC','-v7.3');
     ShuffleLabelWholePop(path, delay,NB_Path, CondStr)  
    clearvars -except delay paths CondStr cond TablePath good TrType PAC 
    end
      end