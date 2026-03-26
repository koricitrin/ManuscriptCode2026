% quantify overlap in rise down 

cd('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\')

   load('All_Recs_RiseDownID_AlignLickthres.mat')
     % load('A218-20260227-02_RiseDownID_LickWholePopthres.mat')
TableLick = RiseDownTable;
     load('All_Recs_RiseDownID_AlignLastLickthres.mat')
     % load('A218-20260227-02_RiseDownID_LastLickWholePopthres.mat')
TableLastLick = RiseDownTable;


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
save("RiseLastLickDownLickNeurons.mat", 'RiseLLDownLickNeuronID', 'RiseLLDownLickRatio', 'PropRiseLLDownL')

 RiseLickDownLLInd = (RiseDownTableAllCond.RiseLick == 1 & RiseDownTableAllCond.DownLastLick == 1);
RiseLickDownLLNeuronID =  RiseDownTableAllCond(RiseLickDownLLInd,1:2);
RiseLickDownLLRatio =  RiseDownTableAllCond(RiseLickDownLLInd,7:8);
PropRiseLickDownLL = size(RiseLickDownLLNeuronID,1)/size(TableLastLick,1);
%cd('Z:\Kori\immobile_code\ConstantBOPlots\New100\')
save("RiseLickDownLLNeurons.mat", 'RiseLickDownLLNeuronID', 'RiseLickDownLLRatio')

