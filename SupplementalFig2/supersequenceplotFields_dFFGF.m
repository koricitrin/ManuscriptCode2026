
function supersequenceplotFields_dFFGF(path, cond, delay, savepath, fieldstype, run, FileNameBase)
%% ex. supersequenceplotgoodbad(pathD10, 1, 4)
%%All fields and all trials
if run == 0 
GlobalConst2P_imm;
elseif run == 1
    GlobalConst2P;
end
mazeSess = 1;
 intervalT = 10;
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
       elseif (cond == 5)
       condStr = 'Run';      
       namex = ('Time from run onset (s)')
 end
     
 
 Fields = [];
     
%%Note: get fileName from path
    for   i = 1:size(path,1)

             if run == 1
             currentpath = path(i,:) ;
             sess = FileNameBase(i,:);
             else 
             currentpath = path{i,1:end} ;
             sess = currentpath(1, 43:58);
             end
     sessions(i,:) = sess;

    end
     for i = 1:size(path,1)
     ext = '_DataStructure_mazeSection1_TrialType1';
     extension = repmat(ext,i,1);
     end 
      fileName = [sessions,extension];
      

  for   i = 1:size(path,1)
 
      if run == 1
             currentpath = path(i,:) ;
             sess = FileNameBase(i,:);
             else 
             currentpath = path{i,1:end} ;
             sess = currentpath(1, 43:58);
      end
      cd(currentpath)
    if fieldstype  ==  2
    fieldfile =  [fileName(i,:) '_FieldSpCorrAlignedAllTrTest2_' condStr '1.mat'];

    load(fieldfile); 
    FieldC = fieldSpCorrSessNonStim.indNeuron;
    Fields{i} = FieldC;
    Fstr = ['FieldsID' condStr 'fsa'];

    
    elseif fieldstype == 1
    Files = dir('catFieldsAll*.*');
    F = Files.name;
    Field = load(F); 
    FieldC = struct2cell(Field) ;
    Fields{i} = cell2mat(FieldC);
    Fstr = ['FieldsAllCond'  'fsa'];
    
    elseif fieldstype == 3
    Files = dir('catFieldsdFFGF_All*.*');
    F = Files.name;
    Field = load(F); 
    FieldC = struct2cell(Field) ;
    Fields(i,:) = FieldC;
    Fstr = ['FieldsAllCond'  'dFFGF'];
      elseif fieldstype == 4
    Files = dir('catFieldsdFFGF_Allrun*.*');
    F = Files.name;
    Field = load(F); 
    FieldC = struct2cell(Field) ;
    Fields(i,:) = FieldC;
    Fstr = ['FieldsAllCond'  'dFFGF-selrun'];
       elseif fieldstype == 5
    Files = dir('catFieldsdFFGF_All5*.*');
    F = Files.name;
    Field = load(F); 
    FieldC = struct2cell(Field) ;
    Fields(i,:) = FieldC;
    Fstr = ['FieldsAllCond'  'dFFGF-5w'];
      elseif fieldstype == 6
    fieldpath = [currentpath 'FieldDetectionShuffle\'];
    cd(fieldpath)
     fieldfilename = ['FieldIndexShuffle' condStr '99.mat'];
    % fieldfilename = ['FieldIndexShuffle' 'LastLick' '99.mat'];
    load(fieldfilename)
    Fields{i} =  FieldID;
    Fstr = ['Fields' condStr  'dFFGF-Shuf99']
      elseif fieldstype == 7
    TablePath = [savepath];
    cd(TablePath)
    % fieldfilename = ['FieldIndexShuffle' condStr '99.mat'];
 
     load("RiseLastLickDownLickNeurons_thres.mat") 
     tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
     Fieldtemp = RiseLLDownLickNeuronID.neu_id(tf,:);
    Fields{i} =  Fieldtemp;
    Fstr = ['PAC' condStr]

      elseif fieldstype == 8
    fieldpath = [currentpath 'FieldDetectionShuffleLateLick\'];
    cd(fieldpath)
    savename = ['FieldIndexShuffle' condStr 'LateLickTr' '99.mat'];
    load(fieldfilename)
    Fields{i} =  FieldID;
    Fstr = ['Fields' condStr 'LateLickTr'  'dFFGF-Shuf99']
      elseif fieldstype == 9
    fieldpath = [currentpath 'FieldDetectionShuffleEarlyLick\'];
    cd(fieldpath)
 
    fieldfilename = ['FieldIndexShuffle' condStr 'EarlyLickTr' '99.mat'];
    load(fieldfilename)
    Fields{i} =  FieldID;
    Fstr = ['Fields' condStr 'EarlyLickTr'  'dFFGF-Shuf99']
    nameStr = 'EarlyFields'
    
    end
  end

neuronNo = Fields;




     
         
    %%load good and bad trials from each session and concatenate
   

       for i = 1:size(path,1)
      if run == 1     
      cd(path(i,:));
        fullPath = [path(i,:) fileName(i,:) '_Info.mat']; 
      else
          cd(path{i,:});
          fullPath = [path{i,:} fileName(i,:) '_Info.mat']; 
      end
   
     load(fullPath)
     allTrials = beh.indTrCtrl;
     allTrialsAll{i} = allTrials;

       FirstLick = '';
     load('FirstLick_LL.mat', 'FirstLick')
     allTrials = 1:length(FirstLick);;
     if run == 0
        latelicktrInd = (FirstLick > 5) & (FirstLick < 6); 
        latelicktrAll{i} = allTrials(latelicktrInd);
        latelicktrCat = latelicktrAll';
    
        earlylicktrInd = (FirstLick > 3.5) & (FirstLick < 4.5);  
        earlylicktrAll{i} = allTrials(earlylicktrInd);
        earlylicktrCat = earlylicktrAll';
     elseif run == 1 
         latelicktrInd = (FirstLick > 3.5) & (FirstLick < 4.5); 
         latelicktrAll{i} = allTrials(latelicktrInd);
         latelicktrCat = latelicktrAll';
    
         earlylicktrInd = (FirstLick > 2) & (FirstLick < 3);  
         earlylicktrAll{i} = allTrials(earlylicktrInd);
         earlylicktrCat = earlylicktrAll';
     end

     end
     
     allTrialsCat = allTrialsAll';


 %%
   %%Note: Get fields avg for all trials/ plot
    for i = 1:size(path,1)
        NZ = find(~cellfun(@isempty,Fields'))
        if isempty(intersect(NZ,i))
            continue
        end   
        if run == 1 
            cd(path(i,:))
            fullPath = [fileName(i,:) '_convSpikesAligned' condStr '_msess' num2str(mazeSess) '_run1.mat'];
            load(fullPath,'dFFArrayRun','paramC');
            filteredSpikeArray = dFFArrayRun;
        else
          cd(path{i,:})
          fullPath = [fileName(i,:) '_convSpikesAligned' condStr '_msess' num2str(mazeSess) '.mat'];
          load(fullPath,'dFFArray','paramC');
          filteredSpikeArray = dFFArray;
        end

        AllTrialsN = cell2mat(allTrialsCat(i,:));
        neuronNoN = cell2mat(neuronNo(i));
        if isempty(neuronNoN) 
        continue
        end  
       avgFilteredSpikeArrayAlll  = avgFilteredSpikeArray(filteredSpikeArray,AllTrialsN,neuronNoN);
       avgFilteredSpikeArrayAll{i} =  avgFilteredSpikeArrayAlll;
     end
% 
% % 
      for i = 1:size(path,1);
           NZ = find(~cellfun(@isempty,Fields'))
        if isempty(intersect(NZ,i))
            continue
        end   
         neuronP =  neuronNo(i);
         avgFilteredSpikeArrayAllp = avgFilteredSpikeArrayAll(1,i);
         avgFilteredSpikeArrayAllP = cell2mat(avgFilteredSpikeArrayAllp);
         neuronPe = cell2mat(neuronP);
            for k = 1:length(neuronPe)
             [~,indPeakTmp] = max(avgFilteredSpikeArrayAllP(k,:));
             indPeak(k) = indPeakTmp(1);
            end
            if isempty(indPeak)
            continue
            end
            indPeaks{i} = indPeak;
            clear indPeak
      end

        %%Note: Loop to group all the sorted peaks into mat
        ip = [];
        for i = 1:size(path,1);
                      NZ = find(~cellfun(@isempty,Fields'))
                if isempty(intersect(NZ,i))
                    continue
                end   
            a = indPeaks(1,i);
            b =   cell2mat(a);
            c = b';
            ip = [ip; c];
        end

     [~,indNeuronOrder] = sort(ip);

    avgFilteredSpikeArrayAllMat = [];
    for i = 1:size(path,1);
                  NZ = find(~cellfun(@isempty,Fields'))
            if isempty(intersect(NZ,i))
                continue
            end   
        a = avgFilteredSpikeArrayAll(1,i);
        b =   cell2mat(a);
        c = b;
        avgFilteredSpikeArrayAllMat = [avgFilteredSpikeArrayAllMat; c];
    end

    avgFilteredSpikeArrayAll = avgFilteredSpikeArrayAllMat(indNeuronOrder,:);

  %%Note: make figure 

      paramC.trialLenT = 20;

       timeSteps = 0:timeStep:timeStep*(3500);
    plotSequenceDist1(avgFilteredSpikeArrayAll,...
        timeSteps,...
        'Time (s)','Neuron No.','Firing rate all trials');

      if(delay == 2)
        set(gca,'XLim',[0,5])
             xticks([0:1:5]);
      delayStr = '2s';
        elseif(delay == 3)
            set(gca,'XLim',[0,6])
             delayStr = '3s';
        elseif(delay == 4)
             set(gca,'XLim',[0,7])
             xticks([0:1:7]);
             delayStr = '4s';
                  elseif(delay == 5)
             set(gca,'XLim',[0,9])
             xticks([0:1:9]);

      end 
 colormap jet 
    set(gca, 'FontSize', 20)
    xlabel(namex)
   cd(savepath)
    name = [Fstr  '-AllTr' condStr] 

    title('')
    axis square

    savefig([name '.fig'])
    print('-painters','-dpng',[name],'-r600');
    print('-painters','-dpdf',[name],'-r600');

     %%

% %%
% %  %%Note: late lick trials get fields/avg/ plot 
% 
%   for i = 1:size(path,1)
%        if run == 1 
%         cd(path(i,:))
%           fullPath = [fileName(i,:) '_convSpikesAligned' condStr '_msess' num2str(mazeSess) '_run1.mat'];
%             load(fullPath,'dFFArrayRun','paramC');
%             filteredSpikeArray = dFFArrayRun;
%         else
%         cd(path(i,:))
%          fullPath = [fileName(i,:) '_convSpikesAligned' condStr '_msess' num2str(mazeSess) '.mat'];
%          load(fullPath,'dFFArray','paramC');
%            filteredSpikeArray = dFFArray;
%         end
% 
%         LateLickTrialsN = cell2mat(latelicktrCat(i,:));
%      neuronNoN = cell2mat(neuronNo(i));
% 
%      avgFilteredSpikeArrayLateLick  = avgFilteredSpikeArray(filteredSpikeArray,LateLickTrialsN,neuronNoN);
%     avgFilteredSpikeArrayLateLicks{i} =  avgFilteredSpikeArrayLateLick;
%   end
% 
% 
%     for i = 1:size(path,1);
%          neuronP =  neuronNo(i);
%          avgFilteredSpikeArrayUnRp = avgFilteredSpikeArrayLateLicks(1,i);
%          avgFilteredSpikeArrayUnRP = cell2mat(avgFilteredSpikeArrayUnRp);
%          neuronPe = cell2mat(neuronP);
%             for k = 1:length(neuronPe)
%          [~,indPeakTmp] = max(avgFilteredSpikeArrayUnRP(k,:));
%          indPeak(k) = indPeakTmp(1);
%             end
%             if isempty(indPeak)
%             continue
%             end
%             indPeaks{i} = indPeak;
%             clear indPeak
%       end
% 
% 
% %Note: Loop to group all the sorted peaks into mat
% ip = [];
% for i = 1:size(path,1);
%     a = indPeaks(1,i);
%     b =   cell2mat(a);
%     c = b';
%     ip = [ip; c];
% end
% 
%      [~,indNeuronOrder] = sort(ip);
% 
%    avgFilteredSpikeArrayLateLickMat = [];
% for i = 1:size(path,1);
%     a = avgFilteredSpikeArrayLateLicks(1,i);
%     b =   cell2mat(a);
%     c = b;
%     avgFilteredSpikeArrayLateLickMat = [avgFilteredSpikeArrayLateLickMat; c];
% end
% 
%    avgFilteredSpikeArrayLateLickMat = avgFilteredSpikeArrayLateLickMat(indNeuronOrder,:);
% 
%       paramC.trialLenT = 20;
% 
%       timeSteps = 0:timeStep:timeStep*(size(filteredSpikeArray{2},2)-1);
%     plotSequenceDist1(avgFilteredSpikeArrayLateLickMat,...
%         timeSteps,...
%         'Time (s)','Neuron No.','Firing rate all trials');
% 
% 
%       if(delay == 2)
%       set(gca,'XLim',[0,5])
%       delayStr = '2s';
%         elseif(delay == 3)
%             set(gca,'XLim',[0,6])
%              delayStr = '3s';
%         elseif(delay == 4)
%              set(gca,'XLim',[0,7])
%              xticks([0:1:7]);
%                 elseif(delay == 5)
%              set(gca,'XLim',[0,9])
%              xticks([0:1:9]);
% 
%     end 
% 
%     xlabel(namex)
% 
%      cd(savepath)
%     name = [Fstr  '-LateLickTr' condStr 'orderlate'] 
%   axis square
%     title(name)
% 
%   savefig([name '.fig'])
%     print('-painters','-dpng',[name],'-r600');
% 

%            for i = 1:size(path,1)
%            if run == 1 
%         cd(path(i,:))
%           fullPath = [fileName(i,:) '_convSpikesAligned' condStr '_msess' num2str(mazeSess) '_run1.mat'];
%             load(fullPath,'dFFArrayRun','paramC');
%             filteredSpikeArray = dFFArrayRun;
%         else
%         cd(path{i,:})
%          fullPath = [fileName(i,:) '_convSpikesAligned' condStr '_msess' num2str(mazeSess) '.mat'];
%          load(fullPath,'dFFArray','paramC');
%            filteredSpikeArray = dFFArray;
%         end
% 
%        EarlyLickTrialsN = cell2mat(earlylicktrCat(i,:));
%        neuronNoN = cell2mat(neuronNo(i));
% 
%      avgFilteredSpikeArrayEarlyLick  = avgFilteredSpikeArray(filteredSpikeArray,EarlyLickTrialsN,neuronNoN);
%     avgFilteredSpikeArrayEarlyLicks{i} =  avgFilteredSpikeArrayEarlyLick;
%   end
% 
% 
%     for i = 1:size(path,1);
%          neuronP =  neuronNo(i);
%          avgFilteredSpikeArrayUnRp = avgFilteredSpikeArrayEarlyLicks(1,i);
%          avgFilteredSpikeArrayUnRP = cell2mat(avgFilteredSpikeArrayUnRp);
%          neuronPe = cell2mat(neuronP);
%             for k = 1:length(neuronPe)
%          [~,indPeakTmp] = max(avgFilteredSpikeArrayUnRP(k,:));
%          indPeak(k) = indPeakTmp(1);
%             end
%             if isempty(indPeak)
%             continue
%             end
%             indPeaks{i} = indPeak;
%             clear indPeak
%       end
% 
% 
% %Note: Loop to group all the sorted peaks into mat
% ip = [];
% for i = 1:size(path,1);
%     a = indPeaks(1,i);
%     b =   cell2mat(a);
%     c = b';
%     ip = [ip; c];
% end
% 
%      [~,indNeuronOrder] = sort(ip);
% 
%    avgFilteredSpikeArrayEarlyLickMat = [];
% for i = 1:size(path,1);
%     avgFilteredSpikeArrayEarlyLickMat = [avgFilteredSpikeArrayEarlyLickMat; cell2mat(avgFilteredSpikeArrayEarlyLicks(1,i))];
% end
% 
%    avgFilteredSpikeArrayEarlyLickMat = avgFilteredSpikeArrayEarlyLickMat(indNeuronOrder,:);
% 
%       paramC.trialLenT = 7;
% 
%       timeSteps = 0:timeStep:timeStep*(3500);
%     plotSequenceDist1(avgFilteredSpikeArrayEarlyLickMat,...
%         timeSteps,...
%         'Time (s)','Neuron No.','Firing rate all trials');
% 
% 
%       if(delay == 2)
%       set(gca,'XLim',[0,5])
%       delayStr = '2s';
%         elseif(delay == 3)
%             set(gca,'XLim',[0,6])
%              delayStr = '3s';
%         elseif(delay == 4)
%              set(gca,'XLim',[0,7])
%              xticks([0:1:7]);
%                     elseif(delay == 5)
%              set(gca,'XLim',[0,9])
%           xticks([0:1:9]);
% 
%     end 
% 
%     xlabel(namex)
%   axis square
%      cd(savepath)
%     name = [Fstr  '-EarlyLickTr' condStr 'orderEarly'] 
% 
%     title(name)
% 
%   savefig([name '.fig'])
%     print('-painters','-dpng',[name],'-r600');
end    
    

%%% Note: Fuctions within script 
 function [avgFilteredSpikeArr]...
                = avgFilteredSpikeArray(filteredSpikeArr,indTr,neuronNo)
    % lenTr = size(filteredSpikeArr{neuronNo(1)},2);
    lenTr = 3500;
    nTrials = length(indTr);
    nNeurons = length(neuronNo);
    avgFilteredSpikeArr = zeros(nNeurons,lenTr);
    for i = 1:nNeurons
        avgFilteredSpikeTmp = zeros(1,lenTr);
        for j = 1:nTrials
            avgFilteredSpikeTmp = avgFilteredSpikeTmp + filteredSpikeArr{neuronNo(i)}(indTr(j),1:3500);
        end
        % avgFilteredSpikeArr(i,:) = avgFilteredSpikeTmp/max(avgFilteredSpikeTmp);
     avgFilteredSpikeArr(i,:) =  (avgFilteredSpikeTmp - min(avgFilteredSpikeTmp))/(max(avgFilteredSpikeTmp) - min(avgFilteredSpikeTmp)); 

          NormValues(i,:) = max(avgFilteredSpikeTmp); %added 6/7
         save("NormValuesAllFields.mat", "NormValues") %%added 6/7
    end      
 end

 function plotSequenceDist1(arr1,timeSteps,xl,yl,title)
    [figNew,pos] = CreateFig2P();
    set(0,'Units','pixels')
    set(figure(figNew),'OuterPosition',...
            [pos(1) pos(2) 400 560],'Name',title)
    nNeurons = size(arr1,1);
    imagesc(timeSteps,1:nNeurons,arr1);
    colormap(flipud(gray))
%     set(gca,'XLim',[0 20])
    xlabel(xl);
    ylabel(yl);
   
 end