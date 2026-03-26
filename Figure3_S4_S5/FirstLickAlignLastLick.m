%%%% plot diff lick time for scalable cells
function FirstLickAlignLastLick(Paths, ephys, savepath, cond) 
   for k = 1:size(Paths,1)
     path = Paths{k,:}  
     % path = Paths(k,:) 
    cd(path)
    sess = path(43:58);
    samplerate = 500;
    if ephys == 1
    sess = path(52:67)
    samplerate = 1250;
    end

    if cond == 2
     AlignLastLickPath =  [sess '_DataStructure_mazeSection1_TrialType1_alignLastLick_msess1.mat'];
     load(AlignLastLickPath)
     trialsData = trialsLastLick;
     savename =   'FirstLick_LL.mat';
     savenameTr =   'TrNum_AlignLL.mat';
    elseif cond  == 1 
     AlignCuePath =  [sess '_DataStructure_mazeSection1_TrialType1_alignCue_msess1.mat'];
     load(AlignCuePath)
     trialsData = trialsCue;
     savename =   'FirstLick_Cue.mat';
     savenameTr =   'TrNum_AlignCue.mat';
     elseif cond  == 3 
     AlignRewPath =  [sess '_DataStructure_mazeSection1_TrialType1_alignRew_msess1.mat'];
     load(AlignRewPath)
     trialsData = trialsRew;
     savename =   'FirstLick_Rew.mat';
     savenameTr =   'TrNum_AlignRew.mat';

    end

    for tr = 2:size(trialsData.lickLfpInd,2)
        if isempty(trialsData.lickLfpInd{tr})
              FirstLick(tr,:) = 0;
        else
       
        FirstLick(tr,:) = (trialsData.lickLfpInd{tr}(1) -  trialsData.startLfpInd(tr))/samplerate;
        end

         if isempty(trialsData.pumpLfpInd{tr})
              Pump(tr,:) = 0;
         else
              Pump(tr,:) = (trialsData.pumpLfpInd{tr}(1) -  trialsData.startLfpInd(tr))/samplerate;
         end
    end

    % load('FirstLick_LL.mat', 'FirstLick')

    % figure
    % histogram(FirstLick)
 
   
    Ind_3to4 = FirstLick > 3 & FirstLick< 4;
    Ind_2to3 = FirstLick > 2 & FirstLick< 3;
    Ind_1to2 = FirstLick > 1 & FirstLick< 2;
    Ind_35to45 = FirstLick > 3.5 & FirstLick< 4.5;
    Ind_45to55 = FirstLick > 4.5 & FirstLick< 5.6;
    Ind_5to6 = FirstLick > 5 & FirstLick< 6;
    Ind_55to65 = FirstLick > 5.5 & FirstLick< 6.5;
    Ind_4to5 = FirstLick > 4 & FirstLick< 5;
    Ind_6to7 = FirstLick > 6 & FirstLick< 7;
      Ind_7to8 = FirstLick > 7 & FirstLick< 8;
     % trNo1to2(k,:)  = sum(Ind_1to2)
     % trNo2to3(k,:)  = sum(Ind_2to3)
      trNo5to6(k,:)  = sum(Ind_5to6)
      trNo4to5(k,:)  = sum(Ind_2to3)
        trNo6to7(k,:)  = sum(Ind_6to7)
            trNo7to8(k,:)  = sum(Ind_7to8)
     trNo45to55(k,:)  = sum(Ind_45to55)
     % trNo3to4(k,:)  = sum(Ind_3to4)
          Med4555(k,:)=      median(FirstLick(Ind_45to55));
            Med67(k,:)=      median(FirstLick(Ind_6to7));
     NzInd = FirstLick> 0;
     FirstLickMedian(k,:) = median(FirstLick(NzInd));
     % MeanPump(k,:) = mean(Pump)
     save(savename, 'FirstLick', 'Pump', 'Ind_55to65', 'Ind_4to5', 'Ind_6to7', 'Ind_1to2', 'Ind_3to4', 'Ind_5to6', 'Ind_35to45', 'Ind_2to3', 'Ind_45to55')
   %    cd(savepath)
   % save(savenameTr, 'trNo4to5', 'trNo6to7', 'trNo1to2', 'trNo2to3', "trNo5to6", 'trNo45to55', 'trNo3to4',"trNo35to45" )
    clear FirstLick Ind_3to4 Ind_5to6 Ind_35to45 Pump
   end
   clearvars -except Paths savepath
 
end