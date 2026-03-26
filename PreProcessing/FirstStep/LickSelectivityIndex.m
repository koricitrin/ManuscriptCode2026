%Lick selectivity Index
  
function LickSelectivityIndex(Paths, Filenames)

    for k = 1:size(Paths)
        Path = Paths(k,:)
        Filename = Filenames(k,:)
        cd(Path)
        LickPath = [Path Filename '.mat'];
        BehPath = [Path Filename '_Info.mat'];
        load(LickPath)
        load(BehPath)

        GlobalConst2P_imm;
        SelIndexNAN = zeros(size(trials,2),1)
        for i = 1:size(trials,2)
            if isempty(trials{i}.lickLfpInd) ||  isempty(trials{i}.pumpLfpInd)
                continue
            end    
        %off target is licks bef 3.4s and rewarded TR
        OffTargetLicks = trials{i}.lickLfpInd < ((sampleFq*beh.delayLen(i)/1666600) + 500) & ~isempty(trials{i}.pumpLfpInd) ;
        
%         %on target is licks within 3.4s and the pump time, and rewarded TR
              
        OnTargetLicks = trials{i}.lickLfpInd >  ((sampleFq*beh.delayLen(i)/1666600) +500)  & ~isempty(trials{i}.pumpLfpInd) & trials{i}.lickLfpInd < (trials{i}.pumpLfpInd(1))  ;
       
         %on target is licks after  3.4s and rewarded TR (did this bc it's
         %nan if they lick first in the RZ and its the same as pump time)
      %  OnTargetLicks = trials{i}.lickLfpInd >  ((sampleFq*beh.delayLen(i)/1666600) +500)  & ~isempty(trials{i}.pumpLfpInd);


        
        if trials{i}.lickLfpInd(1) == trials{i}.pumpLfpInd(1)
            SelIn = 1
            'catch'
        else    
            SelIn = sum(OnTargetLicks)/(sum(OnTargetLicks)+sum(OffTargetLicks));
        end    
        SelIndexNAN(i,:) = SelIn;
        end

   % SelIndex = SelIndexNAN(~isnan(SelIndexNAN))
   SelIndex = SelIndexNAN;
    GoodTr = SelIndex > 0.85;
     GoodTrLickSel = find(GoodTr)';
    BadTr = SelIndex < 0.65 & SelIndex > 0.01;
    BadTrLickSel = find(BadTr)'
    numGoodTr = sum(GoodTr)
    numBadTr = sum(BadTr)
    meanSelIndex = mean(SelIndex);
   BadTrInd =  SelIndex(BadTr);
  GoodTrInd =  SelIndex(GoodTr);
     'hey'
     save("LickSelectivityInd.mat", "SelIndex", "meanSelIndex", "BadTrInd", "GoodTrInd", "GoodTrLickSel", "numGoodTr", "BadTrLickSel", "numBadTr")
    clear  SelIndex meanSelIndex GoodTr numGoodTr
    end
%      %%% Good trials =  first licks after 0.6 delay & rewarded, cant lick to cue
%                 if  beh.medTimeFirst5Licks(i) > ((sampleFq*beh.delayLen(i)/1666600) +500) & ~isempty(trials{i}.pumpLfpInd) ;
%                  beh.indGoodTrCtrl = [beh.indGoodTrCtrl i];
%                 
%             %%% Bad trials = first licks before 0.4 & rewarded, cant lick to cue    
%                 elseif beh.medTimeFirst5Licks(i) < ((sampleFq*beh.delayLen(i)/2500000) + 500)  & ~isempty(trials{i}.pumpLfpInd);
%                  beh.indBadTrCtrl = [beh.indBadTrCtrl i];
%                
%                 end
end