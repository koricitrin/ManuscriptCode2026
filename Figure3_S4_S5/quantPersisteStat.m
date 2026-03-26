 

cd('Z:\Kori\immobile_code\RiseLLDownL\isPersistent\Method2\PercDelayActive7500\')

load('PersistentClassificationBaselinePre.mat')
Index = Index';
for k = 1:size(unique(Index),1)
        
   CurrInd = (Index==k);
    % PercActSessEng(k,:) =  mean(PercAct(CurrInd));
   isPerstSessEng(k,:) =  sum(ispersistent(CurrInd))/length(ispersistent(CurrInd));

end
DataEng = [mean(isPerstSessEng), std(isPerstSessEng)/sqrt(k)]*100
clear  PerAct Index
 