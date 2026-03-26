%%quantify 'persistence'

%%want to exclude possibility that cells dont just peak at LL then repeak
%%again just before first lick 

%get each neuron mean dFF curve. calculate a baseline threshold. see of
%cell dips below baseline before LL and mean first lick time? 


%%method 1 excludes neurons that go below baseline for 0.5s or more then cross baseline again during the delay
%%method 2: excludes neurons that are active for less than 75% of the delay
%method 3: excludes neurons that go below baseline for 0.5s then cross
%baseline during delay (meth 1) and neurons that are active for less than
%50% of delay

%%basetype 1: robust SD (not working)
%%basetype 2: shuffle the whole trace
%%basetype 3: take the mean 1s amplitude preceeding the LL as baseline
function QuantifyPersistence(FRPath, Paths, method,makeplot, basetype, propActive, eng)
Index = [];
if eng == 1
    engStr = 'eng'
elseif eng == 0
    engStr = '';
elseif eng == 2
    engStr = 'dis'
end

    for k = 1:size(Paths,1)
         % cd(Paths{k,:})
           cd(Paths(k,:))
         load('FirstLick_LL.mat')
         FirstLickTemp = FirstLick(2:end) *500;
       medianFirstLickTimeSess(k,:) =  round(median(FirstLickTemp) +1500);
    
    end
    
    cd(FRPath)
    avgFR_profile = [];
     load('FRprofileTable_alignLastLickdffgfthres.mat')
     % load('FRprofileTable_alignLastLick.mat')
    numShuffle = 1000;
    RecList = unique(rec_name);
    RecsNum = 1:length(RecList);

    SavePropName = num2str(propActive*100);
    if method == 1 
   cd('Z:\Kori\immobile_code\RiseLLDownL\isPersistent\Method1\medLick\')
    elseif method == 2 
        path1 = 'Z:\Kori\immobile_code\RiseLLDownL\isPersistent\Method2\'
        cd(path1)
         foldername = ['PercDelayActive' SavePropName engStr];   
      mkdir(foldername)  
          savepath = [path1 foldername]
          cd(savepath)
           elseif method == 3 
        cd('Z:\Kori\immobile_code\RiseLLDownL\isPersistent\Method3\')
    end

    numNeurons = size(avgFR_profile,1);
    ispersistent = [];
 
    if basetype == 2
    DataProfile = avgFR_profile;
     savename = 'PersistentClassificationShuff.mat';
    elseif basetype == 1 
    DataProfile = avgFR_profile_NotNorm;
    savename = 'PersistentClassificationRobust.mat';
       elseif basetype == 3
    DataProfile = avgFR_profile;
    savename = 'PersistentClassificationBaselinePre.mat';
    end
            for neur = 1:numNeurons
                            
                            CurrRec =  rec_name(neur);
                            idxRec =   strcmp(RecList, CurrRec);
                            SessIdx =    RecsNum(idxRec);
                            Index = [Index, SessIdx];
                            NeuronData =   DataProfile(neur,:);
                    
                    if basetype == 1
                      stdDFF = mad(NeuronData,1)/0.6745; % robust SD, David Tank, nature, 2021
                      Baseline = 3 * stdDFF;
                    elseif basetype == 2 

                                colArray = size(NeuronData,2) ;
                                rowArray = size(NeuronData,1);  %tr
                          for i = 1:numShuffle 
                                randShift = randi(floor(colArray/2),1,rowArray)-floor(colArray/2);
                                shiftTmp = circshift(NeuronData',randShift);
                                shufSpikeArrayTmp(i,:) = shiftTmp';
                          end
                         Baseline =     mean(mean(shufSpikeArrayTmp,1));

                    elseif basetype == 3 
                         Baseline =     mean(NeuronData(:,1000:1500)); %%1s before LL
                    end

                      if makeplot == 1   
                        figure
                       hold on
                   
                     
                       plot(DataProfile(neur,:),  'LineWidth', 2)
                       yline(Baseline, '--r',  'LineWidth', 2)
                        xline(1501, 'LineWidth', 2)
                      xline(medianFirstLickTimeSess(SessIdx),  'LineWidth', 2)  
                      end
                   
                         BelowBaselineLog = DataProfile(neur,1501:medianFirstLickTimeSess(SessIdx))<Baseline;
                        AboveBaselineLog = DataProfile(neur,1501:medianFirstLickTimeSess(SessIdx))>Baseline;

                        Bins= 1:length(BelowBaselineLog);
                        AboveBins =  Bins(AboveBaselineLog);
                        BelowBins =  Bins(BelowBaselineLog);
                        if ~isempty(AboveBins) & ~isempty(BelowBins)
                        BelowBetween =   BelowBins > min(AboveBins) & BelowBins < max(AboveBins);
                        end
                        T = ['Neuron-' num2str(neur)];
                       if method == 1 
                    
                        if sum(BelowBetween) > 250
                             ispersistent(neur,:) = 0; 
                             'not persistent';
                             TT = [T 'notpersistent'];
                        else
                           ispersistent(neur,:) = 1; 
                           'persistent';
                           TT = [T 'persistent'];
                        end
                       elseif method == 2 
                           bins = size(AboveBaselineLog,2);
                        persistFract =   (sum(AboveBaselineLog)/bins)*100
                            if persistFract< propActive
                             ispersistent(neur,:) = 0; 
                               'not persistent';
                                TT = [T 'notpersistent'];
                            else persistFract> propActive
                           ispersistent(neur,:) = 1; 
                           'persistent';
                           TT = [T 'persistent'];
                            end

                     elseif method == 3
                         bins = size(AboveBaselineLog,2);
                        persistFract =   (sum(AboveBaselineLog)/bins)*100
                            if persistFract< propActive  %active less than half the delay
                             ispersistent(neur,:) = 0; 
                               'not persistent';
                                TT = [T 'notpersistent'];
                            elseif sum(BelowBetween) > 250   %drops below baseline for over 0.5s then goes above baseline again in delay
                             ispersistent(neur,:) = 0; 
                             'not persistent';
                             TT = [T 'notpersistent'];
                            elseif persistFract> propActive && ~(sum(BelowBetween) > 250)
                           ispersistent(neur,:) = 1; 
                           'persistent';
                           TT = [T 'persistent'];
                        end
                       end

                       if makeplot == 1 
                         title(TT)
                         saven = [TT 'robust'];
                          print('-painters','-dpng', [saven '.png'], '-r600')
                        'stop'
                        close all
                       end
            end

            propPer =  sum(ispersistent)/length(ispersistent)
            save(savename, 'ispersistent', 'Index')
end
