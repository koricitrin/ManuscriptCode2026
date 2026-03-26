function ProcessingAligned2P_immList2(pathList, delay, INT, ch2)
%  cue  --- condition 2
% rew --- condition 1
% last lick --- condition 3
%lick --- condition 4

mazeSess = 1;
 GlobalConst2P_imm;
 if delay  == 2
     intervalTSpInfo = 5; % sec
     corrIntervalT = 5; %5; %20; % sec
 elseif delay == 25
     intervalTSpInfo = 5.5;
      corrIntervalT = 5.5;
   elseif delay == 3
     intervalTSpInfo = 6;
      corrIntervalT = 6;
  elseif delay == 35
     intervalTSpInfo = 6.5;
      corrIntervalT = 6.5;
 elseif  delay == 4
        intervalTSpInfo = 7;
      corrIntervalT = 7; 
 end     
%           
% %       
 nRec = size(pathList,1);
 for j = 1:nRec
     path =  pathList(j,:);
     if INT == 0 
      % fileName = [path(1,43:end-13) '_DataStructure_mazeSection1_TrialType1']
       fileName = [path(1,43:end-1) '_DataStructure_mazeSection1_TrialType1']
       fileName = [path(1,43:end-6) '_DataStructure_mazeSection1_TrialType1']
     elseif INT ==1
      fileName = [path(1,43:end-1) '_DataStructure_mazeSection1_TrialType1']
     end
   
     if ch2 == 1
        path = [path 'Ch2\'];
     end
      cd(path)

    BasicInfo_smTr2P_immCopy(path,fileName); %%changed 5/24/24
%     %% align the spikes based on different run onset/reward/cue onset
    disp('Align trials based on reward onset')
    alignToReward2P_imm(path, fileName,mazeSess);

    disp('Align trials based on cue onset')
    alignToCue2P_imm(path, fileName,mazeSess);

    % disp('Align trials based on cue offset')
    % alignToCueOff2P_imm(path, fileName,mazeSess);

    disp('Align trials to first lick')
    alignToLick2P_imm(path, fileName, mazeSess)

   disp('Align trials to last lick')
    alignToLastLick2P_imm(path, fileName, mazeSess);
   IndNeu_dFFGF(path, delay)
% 
%    %%get behavior parameters
%      disp('Get behavior parameters')
%      getBehParameters2P_imm(path,fileName,mazeSess);
% 

   for i = 1:4
       %  % smooth spike trains
       %  disp('Convolve spike trains with Gaussian kernel (Rew,CueOn,LaskLick,FirstLick)')
       % ConvSpikeTrain_Aligned2P_imm(path,fileName,mazeSess,i);
       % 
       %   disp(['Calculate peak firing rate with Gaussian kernel, only for spikes aligned to running onset'])
       %  PeakFiringRate_Aligned2P_immEdit(path,fileName,i,mazeSess,0);
       % 
       %   disp('Calculate mean firing rate') 
       %   MeanFiringRateAligned2P_immEdit(path,fileName,i,mazeSess,0);

         % disp('Calculate mean firing rate dffgf') 
         % MeanFiringRateAligned2P_immEdit_dFFGF(path,fileName,i,mazeSess,0);
        disp('Convolve spike trains with Gaussian kernel (Rew,CueOn,LaskLick,FirstLick), including the time before 0')
        ConvSpikeTrain_AlignedBef2P_imm(path,fileName,mazeSess,i);
        % 
        % disp(['Calculate peak firing rate with Gaussian kernel, only for spikes aligned' ...
        %     'to running onset, including the time before 0'])
        % PeakFiringRate_AlignedBef2P_imm(path,fileName,i,mazeSess,0);

      end
% %     
%    % disp('Calculate lick over distance')
%    %  LickOverTimeAligned2P_imm(path, fileName, mazeSess);

    delete(gcp('nocreate'));
    parpool('local',4);
% %     
     begT = 0; % two seconds from the start of the filteredSpikeArray, not absolute time 
% %     % single neuron corr between trials
%    disp('Single neuron correlation T')
     neuronSpikeCorrT2P_imm(path,fileName,mazeSess,corrIntervalT,begT);
     neuronSpikeCorrT2P_imm_dFFGF(path,fileName,mazeSess,corrIntervalT,begT);

    meanNeuronSpikeCorrT2P_immEdit(path,fileName,mazeSess,corrIntervalT,begT); %%with cue %added 3/11 to pipeline
    meanNeuronSpikeCorrT2P_imm_dFFGF_Edit(path,fileName,mazeSess,corrIntervalT,begT)

    meanNeuronSpikeCorrT2P_immCross(path,fileName,mazeSess,corrIntervalT,begT) %added by kori 4/18 need to finish

%     %% single neuron trial similarity
    disp('Single neuron cosine similarity')
    spikeTrainSimilarityT2P_imm(path,fileName,mazeSess,corrIntervalT,begT);    
    meanSpikeTrainSimilarityT2P_imm(path,fileName,mazeSess,corrIntervalT,begT);

    %% population corrT between trials
    disp('Population vector correlation time')
    popSpikeCorrT2P_imm(path,fileName,mazeSess,corrIntervalT,begT);
    meanPopSpikeCorrT2P_imm(path,fileName,mazeSess,corrIntervalT,begT);

    % population corrDist between trials
    disp('Population vector correlation distance')
    popSimilarityT2P_imm(path,fileName,mazeSess,corrIntervalT,begT);
    meanPopSpikeSimT2P_imm(path,fileName,mazeSess,corrIntervalT,begT);
% % 
% % %     % calculate spatial information
   for i = 1:4
        disp('Calculate spatial information');
       GetFRMapInfo_Aligned2P_imm(path,fileName,mazeSess,i,intervalTSpInfo);
      % GetFRMapInfo_Aligned2P_imm_dFFGF(path,fileName,mazeSess,i,intervalTSpInfo);
    end
% % % 

      close all;
% 
  % % Field detection/plot fields

  if INT == 0

      for i = 1:4
        begT = 0;      

               if delay  == 2
         intervalTSpInfo = 5; % sec
         corrIntervalT = 5; %5; %20; % sec

     elseif delay == 25
         intervalTSpInfo = 5.5;
          corrIntervalT = 5.5;

       elseif delay == 3
         intervalTSpInfo = 6;
          corrIntervalT = 6;

      elseif delay == 35
         intervalTSpInfo = 6.5;
          corrIntervalT = 6.5;

     elseif  delay == 4
            intervalTSpInfo = 7;
          corrIntervalT = 7; 

               end     
    %       %%CHANGED MIN NUMBER OF ACTIVE TRIALS 5/27/24 need to redo analysis for days after that      
    %       FieldDetectionAligned2P_immGoodTr(path,fileName,2,mazeSess,i,intervalTSpInfo,begT); % mazeSess is only used for plotting purpose
    % %         close all;
    %         FieldDetectionAligned2P_immVeryGoodTr(path,fileName,2,mazeSess,i,intervalTSpInfo,begT);
    %         close all
    %     FieldDetectionAligned2P_immBadTr(path,fileName,2,mazeSess,i,intervalTSpInfo,begT); % mazeSess is only used for plotting purpose
    %        close all;
    %         FieldDetectionAligned2P_immVeryBadTr(path,fileName,2,mazeSess,i,intervalTSpInfo,begT);
    %         close all
    %   FieldDetectionAligned2P_immUnRewTr(path,fileName,2,mazeSess,i,intervalTSpInfo,begT);
    %        close all
    %        added by Yingxue on 3/16/2023
    % FieldDetectionAligned2PAllTrials_imm_dFFGF(Paths,i,intervalTSpInfo,begT, detectionParam);
        FieldDetectionAligned2PAllTrials_imm(path,fileName,2,mazeSess,i,intervalTSpInfo,begT); % detecting fields using all trials

          close all;
          end
      CatFields(path)
    plotSequenceAlignedTime2P_immAllTr(path, mazeSess,1, delay)
  elseif INT == 1
         begT = 3;
        for i = 1:4
            plotdFFAligned2P_imm(path,fileName,mazeSess,i,intervalTSpInfo,begT); % plot dFF for each neuron
            close all;
    %       plotdFFAligned2P_immGoodBad(path,fileName,mazeSess,i,intervalTSpInfo,begT); % plot dFF for each neuron
    %         close all;
        end
  end
 delete(gcp('nocreate'));

end  
end


