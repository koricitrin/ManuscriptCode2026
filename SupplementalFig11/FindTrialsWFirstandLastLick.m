%%find trials with clear first and last lick 

%%find when the end of the trial is/cue on see when the first and last lick
%%are. if too close to tr end maybe not stopping licking 
 
function FindTrialsWFirstandLastLick(Paths)
 
for k = 1:size(Paths,1)

    cd(Paths(k,:))
    sessname = Paths(k,43:end-13)
     LickFile = [sessname '_DataStructure_mazeSection1_TrialType1_alignCue_msess1.mat']; 
     load(LickFile);

    for trials = 2:size(trialsCue.startLfpInd,2)-1
    
     if    isempty(trialsCue.lickLfpInd{trials})
         trialsCue.lickLfpInd{trials} = 0

     end
     EndfromLL(trials,:) =   (trialsCue.endLfpInd(trials) - trialsCue.lickLfpInd{trials}(end))/500;
     StartfromL(trials,:) =    (trialsCue.lickLfpInd{trials}(1)- trialsCue.startLfpInd(trials))/500;
    end
    
    
    LastLickSelInd = EndfromLL>0.9;
    % FirstLickSelInd = StartfromL> 0.5;
    % 
      FirstLickSelInd = StartfromL> 1; %%changed 10/16 file now called  ValidTr_FirstLastLick2.mat
    % 
    Data = [LastLickSelInd, FirstLickSelInd]
    
    TrData = sum(Data,2)
    %%find consequtive trial where value is 2 
ValidTrInd = [];
    for i = 1:size(TrData,1)-1
        TrData(i)
        if TrData(i) == 0  
            continue

        elseif TrData(i) == 1
            continue
        elseif TrData(i) == 2
            
            if (TrData(i+1) == 2)
              ValidTrInd(i,:) = i;
            else
                continue
            end
        end


    end
ValidTrInd= ValidTrInd(ValidTrInd~=0)

     ValidTrInd=  unique(sort(ValidTrInd))
    % ValidTrInd = (TrData == 2);
    % AllTrials = (1:size(trialsCue.startLfpInd,2)-1)';

    % ValidTrialsTemp = AllTrials(ValidTrInd)

    % ValidTrialsNext =  ValidTrialsTemp + 1; 
    % 
    % ValidTrAllTemp =  [ValidTrialsTemp, ValidTrialsNext];
    % 
    % ValidTrAll =   unique(ValidTrAllTemp);

    % ValidTrAll = ValidTrAll(1:end-1);
    ValidTrAll = ValidTrInd;

    save('ValidTr_FirstLastLick2.mat', 'ValidTrAll')
    clearvars -except Paths 
end

end