 

cd('Z:\Kori\immobile_code\RiseLLDownL\isPersistent\Method2\PercDelayActive75\')

load('PersistentClassificationBaselinePreEng.mat')

for k = 1:size(unique(Index),1)
        
   CurrInd = (Index==k);
    PercActSessEng(k,:) =  mean(PercAct(CurrInd));
   isPerstSessEng(k,:) =  sum(ispersistent(CurrInd))/length(ispersistent(CurrInd));

end
DataEng = [mean(isPerstSessEng), std(isPerstSessEng)/sqrt(k)]*100
clear  PerAct Index
load('PersistentClassificationBaselinePreDis.mat')

for k = 1:size(unique(Index),1)
        
   CurrInd = (Index==k);
    PercActSessDis(k,:) =  mean(PercAct(CurrInd));
isPerstSessDis(k,:) =  sum(ispersistent(CurrInd))/length(ispersistent(CurrInd));

end

DataDis = [mean(isPerstSessDis), std(isPerstSessDis)/sqrt(k)]*100