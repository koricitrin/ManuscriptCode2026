% quantify overlap in rise down 
function quantifyOverlapRiseLLDownL_Sess_Run(Path, BaseNames, TablePath)

for k = 1:size(BaseNames,1)
    cd(TablePath)
    sess = BaseNames(k,:)
 % load('All_Recs_RiseDownID_AlignLick.mat')
   LickTablePath = [sess '_RiseDownID_LickWholePop.mat']
   load(LickTablePath)
   TableLick = RiseDownTable;
 % load('All_Recs_RiseDownID_AlignLastLick.mat')
   LickTablePath = [sess '_RiseDownID_LastLickWholePop.mat']
   load(LickTablePath) 
   TableLastLick = RiseDownTable;
    
    sum(TableLick.isRise)
    sum(TableLick.isDown)
    sum(TableLastLick.isRise)
    sum(TableLastLick.isDown)
    
    TableLick = renamevars(TableLick,"isRise","RiseLick");
    TableLastLick = renamevars(TableLastLick,"isRise","RiseLastLick");
    
    TableLick = renamevars(TableLick,"isDown","DownLick");
    TableLastLick = renamevars(TableLastLick,"isDown","DownLastLick");
    
    TableLick = renamevars(TableLick,"ratio0to1BefRun","RatioLick");
    TableLastLick = renamevars(TableLastLick,"ratio0to1BefRun","RatioLastLick");
    
    RiseDownTableAllCond = [TableLick(:,1), TableLick(:,2), TableLick(:,4), TableLastLick(:,4),  TableLick(:,5), TableLastLick(:,5), TableLick(:,3), TableLastLick(:,3)];
    
    RiseLLDownLickInd = (RiseDownTableAllCond.RiseLastLick == 1 & RiseDownTableAllCond.DownLick == 1);
    RiseLLDownLickNeuronID =  RiseDownTableAllCond(RiseLLDownLickInd,1:2);
    RiseLLDownLickRatio =  RiseDownTableAllCond(RiseLLDownLickInd,7:8);
    PropRiseLLDownL = size(RiseLLDownLickNeuronID,1)/size(TableLastLick,1);
    %cd('Z:\Kori\immobile_code\ConstantBOPlots\New100\')
    PercDownLofRiseLL(k,:) = (sum(RiseLLDownLickInd)/sum(RiseDownTableAllCond.RiseLastLick == 1))*100
    PercRiseLLDownL(k,:) = (size(RiseLLDownLickNeuronID,1)/size(TableLastLick,1))*100;
    cd(Path(k,:))
    save("RiseLastLickDownLickNeurons.mat", 'RiseLLDownLickNeuronID', 'RiseLLDownLickRatio', 'PropRiseLLDownL')
    
     RiseLickDownLLInd = (RiseDownTableAllCond.RiseLick == 1 & RiseDownTableAllCond.DownLastLick == 1);
    RiseLickDownLLNeuronID =  RiseDownTableAllCond(RiseLickDownLLInd,1:2);
    RiseLickDownLLRatio =  RiseDownTableAllCond(RiseLickDownLLInd,7:8);
    PropRiseLickDownLL = size(RiseLickDownLLNeuronID,1)/size(TableLastLick,1);
    %cd('Z:\Kori\immobile_code\ConstantBOPlots\New100\')
    save("RiseLickDownLLNeurons.mat", 'RiseLickDownLLNeuronID', 'RiseLickDownLLRatio')

 clearvars -except Path TablePath PercDownLofRiseLL BaseNames PercRiseLLDownL
end

sem_P = std(PercRiseLLDownL)/ sqrt(size(BaseNames,1));
datamean = [mean(PercRiseLLDownL) sem_P ]