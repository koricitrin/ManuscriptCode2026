function BasicInfo_smTr2P_immCopy(path,fileName)
% This is to extract the basic information from the session (heating and cooling)
% Input arguments:
% path:         the path of the recording file
% fileName:     name of the recording file
%
% e.g.: BasicInfo_smTr('./','A111-20150301-01_DataStructure_mazeSection1_TrialType1')

    %%%%%%%% check arguments
    if nargin<2
        disp('At least two arguments are needed for this function.');
        return;
    elseif nargin > 3
        disp('Too many arguments');        
        return;
    end
    
    %%%%%%%%% load recording file
    indexFileName = findstr(fileName, '.mat');
    if(isempty(indexFileName))
        fileNameMinLen = [fileName '_Info.mat'];
        fileName = [fileName '.mat'];
    else
        fileNameMinLen = [fileName(1:indexFileName(end)-1) '_Info.mat'];
    end 
    fullPath = [path fileName];
    if(exist(fullPath) == 0)
        disp('File does not exist.');
        return;
    end
    load(fullPath);
    
    GlobalConst2P_imm;

    rec.numNeurons = size(trials{1}.F,2);
    
    %%%%%%%%% collect the basic information from a session    
    beh.trackLen = lap.trackLen';
    beh.mazeSess = lap.mazeSess;
    beh.mazeType = lap.mazeType;
    beh.delayLen = lap.delayLen;
    beh.mazeSessAll = unique(lap.mazeSess);
    if(sum(beh.mazeSessAll~=0) ~= 0)
        beh.mazeSessAll = beh.mazeSessAll(beh.mazeSessAll~=0);
    end
    beh.numTrials = size(lapList,1);
    beh.lenTrials = zeros(1,beh.numTrials); 
    beh.indGoodLap = [];
    beh.indErrLap = [];
    beh.indCorrLap = [];
    beh.indStimLap = zeros(1,beh.numTrials); 
    beh.pulseMethod = zeros(1,beh.numTrials);
    beh.stimPulseLfpInd = cell(1,beh.numTrials);
    beh.stimPulseWidth = cell(1,beh.numTrials);
    beh.stimDiode = cell(1,beh.numTrials);
    beh.stimDiodeCurr = cell(1,beh.numTrials); 
    beh.stimPulseLoc = cell(1,beh.numTrials);
    %%% added by Yingxue on 12/14/2020
    beh.numLickBef2s = zeros(1,beh.numTrials);
    beh.numLick2to4s = zeros(1,beh.numTrials);
    beh.numLickAft4s = zeros(1,beh.numTrials);
    beh.numLickAftRew = zeros(1,beh.numTrials);
    beh.indTrCtrl = [];
    beh.indGoodTrCtrl = [];
    beh.indBadTrCtrl = [];
    beh.indVeryBadTrCtrl = [];
    beh.indVeryGoodTrCtrl = [];
    beh.indUnrespondedTrCtrl = [];
    beh.indUnRewTrCtrl = [];
    beh.medTimeFirst5Licks = zeros(1,beh.numTrials);
    beh.meanTimeFirst5Licks = zeros(1,beh.numTrials);
    %%%
    
    noStimTr = 0;
    for i = 1:beh.numTrials
        if(lapList(i,1) ~= -1 && ~isempty(trials{i}));
            beh.lenTrials(i) = trials{i}.Nsamples; % the length of each trial in time
            %% licks; added by Yingxue on 12/14/2020
            beh.numLickBef2s(i) = sum(trials{i}.lickLfpInd - trials{i}.movieOnLfpInd(2) < sampleFq*beh.delayLen(i)/2000000 & ...
                trials{i}.lickLfpInd > trials{i}.movieOnLfpInd(2));
            beh.numLick2to4s(i) = sum(trials{i}.lickLfpInd - trials{i}.movieOnLfpInd(2) > sampleFq*beh.delayLen(i)/2000000 & ...
                trials{i}.lickLfpInd - trials{i}.movieOnLfpInd(2) < beh.delayLen(i)/1000000*sampleFq);
            beh.numLickAft4s(i) = sum(trials{i}.lickLfpInd - trials{i}.movieOnLfpInd(2) > beh.delayLen(i)/1000000*sampleFq);
            if(~isempty(trials{i}.pumpLfpInd))
                beh.numLickAftRew(i) = sum(trials{i}.lickLfpInd >= trials{i}.pumpLfpInd(1));
            else
                disp(['Trial no. ' num2str(i) ' is not rewarded. ']);
            end
            
            indLickAfterSC = find(trials{i}.lickLfpInd(trials{i}.lickLfpInd > trials{i}.movieOnLfpInd(2)));
            numLicks = length(indLickAfterSC);
            if(numLicks >=5)
                licksTmp = trials{i}.lickLfpInd(indLickAfterSC(1:5));
            else
                licksTmp = trials{i}.lickLfpInd(indLickAfterSC);
            end
            beh.medTimeFirst5Licks(i) = median(licksTmp);
            beh.meanTimeFirst5Licks(i) = mean(licksTmp);
            %%
                indLick = find(trials{i}.lickLfpInd(trials{i}.lickLfpInd > trials{i}.movieOnLfpInd(1)));
            numLicks = length(indLick);
            if(numLicks >=5)
                licksTmp = trials{i}.lickLfpInd(indLick(1:5));
            else
                licksTmp = trials{i}.lickLfpInd(indLick);
            end
            beh.medTimeFirst5LicksNoSC(i) = median(licksTmp);
            beh.meanTimeFirst5LicksNoSC(i) = mean(licksTmp);
            
            indLickAfterSC = find(trials{i}.lickLfpInd(trials{i}.lickLfpInd > trials{i}.movieOnLfpInd(2)));
            numLicks = length(indLickAfterSC);
            if(numLicks >=1)
                licksTmp = trials{i}.lickLfpInd(indLickAfterSC(1));
                  beh.FirstLick(i) = (licksTmp);
            else
                licksTmp = trials{i}.lickLfpInd(indLickAfterSC);
            end
   
        
            
            %% 
            
            if(beh.lenTrials(i) < sampleFq*100);
                beh.indGoodLap = [beh.indGoodLap i]; 
            else
                disp(['Trial no. ' num2str(i) ' is longer than 100 s']);
            end
            
            if(i > 1)
                beh.pauseBefTrial(i) = double((trials{i}.lfpIndStart ...
                        - (trials{i-1}.lfpIndStart + trials{i-1}.movieOnLfpInd(3))))/sampleFq;
            end
            
            if(isfield(trials{i},'stimOnLfpInd'))      
                if(~isempty(trials{i}.stimOnLfpInd))
                    noStimTr = noStimTr + 1; %% added by Yingxue on 12/14/2020
                    beh.pulseMethod(i) = trials{i}.stimPulseMethod;
                    beh.indStimLap(i) = 1;
                    beh.stimPulseLfpInd{i} = trials{i}.stimPulseLfpInd;
                    beh.stimPulseWidth{i} = trials{i}.stimPulseWidth;
                    beh.stimDiode{i} = trials{i}.stimDiode;
                    beh.stimDiodeCurr{i} = trials{i}.stimDiodeCurr;
                    beh.stimPulseLoc{i} = trials{i}.stimPulseLoc;
                end
            end
            %%% added by Yingxue on 12/14/2020
            if(noStimTr == 0) % control trials before the first stimulation trial
                if(beh.lenTrials(i) < sampleFq*100);
                    beh.indTrCtrl = [beh.indTrCtrl i]; 
                else
                    disp(['Trial no. ' num2str(i) ' is longer than 100 s']);
                end
            end
            %%% added by Yingxue on 12/14/2020
        end
    end
    
    %%% added by Yingxue on 12/14/2020
    medNumSample = median(beh.lenTrials(beh.indTrCtrl));
    %% mazetype = 32 is active
    for i = beh.indTrCtrl
       %% mazeType == 32 %%Active
       
%             %%% Good trials =  first licks after half way & rewarded
%                 if  beh.medTimeFirst5Licks(i) > ((sampleFq*beh.delayLen(i)/2000000) +500) & ~isempty(trials{i}.pumpLfpInd) ;
%                  beh.indGoodTrCtrl = [beh.indGoodTrCtrl i];
%                 
%             %%% Bad trials = first licks before half way & rewarded    
%                 elseif beh.medTimeFirst5Licks(i) < ((sampleFq*beh.delayLen(i)/2000000) + 500)  & ~isempty(trials{i}.pumpLfpInd);
%                  beh.indBadTrCtrl = [beh.indBadTrCtrl i];
%                
%                 end
%                 
   %%%%% changed 5/24/24    kori
      if   beh.mazeType(1) == 32 %active
            %%% Good trials =  first licks after 0.6 delay & rewarded, can't lick to cue
                if  beh.medTimeFirst5Licks(i) > ((sampleFq*beh.delayLen(i)/1666600) +500) & ~isempty(trials{i}.pumpLfpInd) ;
                 beh.indGoodTrCtrl = [beh.indGoodTrCtrl i];
                
            %%% Bad trials = first licks before 0.4 & rewarded, cant lick to cue    
                elseif beh.medTimeFirst5Licks(i) < ((sampleFq*beh.delayLen(i)/2500000) + 500)  & ~isempty(trials{i}.pumpLfpInd);
                 beh.indBadTrCtrl = [beh.indBadTrCtrl i];
               
                end
      end

      if  beh.mazeType(1) == 31
            %%% Good trials =  first licks after 0.6 delay & rewarded, can't lick to cue
                if  beh.medTimeFirst5Licks(i) > ((sampleFq*beh.delayLen(i)/1666600) +500) &&  beh.medTimeFirst5Licks(i) < (trials{i}.pumpLfpInd(1));
                 beh.indGoodTrCtrl = [beh.indGoodTrCtrl i];
                
            %%% Bad trials = first licks before 0.4 & rewarded, cant lick to cue    
                elseif beh.medTimeFirst5Licks(i) < ((sampleFq*beh.delayLen(i)/2500000) + 500)  & ~isempty(trials{i}.pumpLfpInd);
                 beh.indBadTrCtrl = [beh.indBadTrCtrl i];
               
                end
     end


          
                
            %%% Very Bad trials =  first licks before one third delay & rewarded
                if beh.medTimeFirst5Licks(i) < ((sampleFq*beh.delayLen(i)/3000000) + 500) & ~isempty(trials{i}.pumpLfpInd)
                 beh.indVeryBadTrCtrl = [beh.indVeryBadTrCtrl i] ;  
               
            %%% Very good trials =  first licks after two thirds delay  & rewarded
                elseif beh.medTimeFirst5Licks(i) > ((sampleFq*beh.delayLen(i)/1500000) + 500)  &  ~isempty(trials{i}.pumpLfpInd)
                 beh.indVeryGoodTrCtrl = [beh.indVeryGoodTrCtrl i]  ;
                end  
                
            %%% Unresponded trials =  no lick and no reward (active), just
            %%% no lick passive
                if isempty(beh.medTimeFirst5Licks(i)) & isempty(trials{i}.pumpLfpInd) & mazeType == 32 
                 beh.indUnrespondedTrCtrl = [beh.indUnrespondedTrCtrl i];  %% active
                 
                elseif isempty(beh.medTimeFirst5Licks(i)) & mazeType == 31
                 beh.indUnrespondedTrCtrl = [beh.indUnrespondedTrCtrl i];     %% passive
             %%% UnRew trials =  lick and no reward (active)   
                elseif ~isempty(beh.medTimeFirst5Licks(i)) & isempty(trials{i}.pumpLfpInd)
                 beh.indUnRewTrCtrl = [beh.indUnRewTrCtrl i];   
      
                end
    end
    disp(['Number of good trials in the control: ' num2str(length(beh.indGoodTrCtrl))]);
      disp(['Number of bad trials in the control: ' num2str(length(beh.indBadTrCtrl))]);
        disp(['Number of trials in the control: ' num2str(length(beh.indTrCtrl))]);
    fullPath = [path fileNameMinLen];
    save(fullPath, 'rec', 'beh');
    return;
end
