% quantify overlap in rise down 

cd('Z:\Kori\RunningTask2pCode\RiseDown\tables\ZY\')


 load('All_Recs_RiseDownID_AlignLick.mat')
 % load('A194-20240706-03_RiseDownID_LickWholePop.mat')
TableLick = RiseDownTable;
 load('All_Recs_RiseDownID_AlignLastLick.mat')
 % load('A194-20240706-03_RiseDownID_LastLickWholePop.mat')
TableLastLick = RiseDownTable;
% 
%  load('All_Recs_RiseDownID_AlignRun.mat')
%  % load('A194-20240706-03_RiseDownID_LastLickWholePop.mat')
% TableRun = RiseDownTable;


TableLick = renamevars(TableLick,"isRise","RiseLick");
TableLastLick = renamevars(TableLastLick,"isRise","RiseLastLick");
% TableRun = renamevars(TableRun,"isRise","RiseRun");

TableLick = renamevars(TableLick,"isDown","DownLick");
TableLastLick = renamevars(TableLastLick,"isDown","DownLastLick");
% TableRun = renamevars(TableRun,"isDown","DownRun");

TableLick = renamevars(TableLick,"ratio0to1BefRun","RatioLick");
TableLastLick = renamevars(TableLastLick,"ratio0to1BefRun","RatioLastLick");

RiseDownTableAllCond = [TableLick(:,1), TableLick(:,2), TableLick(:,4), TableLastLick(:,4), TableLick(:,5), TableLastLick(:,5), TableLick(:,3), TableLastLick(:,3)];

RiseLLDownLickInd = (RiseDownTableAllCond.RiseLastLick == 1 & RiseDownTableAllCond.DownLick == 1);
RiseLLDownLickNeuronID =  RiseDownTableAllCond(RiseLLDownLickInd,1:2);
RiseLLDownLickRatio =  RiseDownTableAllCond(RiseLLDownLickInd,7:8);
PropRiseLLDownL = size(RiseLLDownLickNeuronID,1)/size(TableLastLick,1);
%cd('Z:\Kori\immobile_code\ConstantBOPlots\New100\')
save("RiseLastLickDownLickNeurons.mat", 'RiseLLDownLickNeuronID', 'RiseLLDownLickRatio', 'PropRiseLLDownL')

RiseLickDownLLInd = (RiseDownTableAllCond.RiseLick == 1 & RiseDownTableAllCond.DownLastLick == 1);
RiseLickDownLLNeuronID =  RiseDownTableAllCond(RiseLickDownLLInd,1:2);
RiseLickDownLLRatio =  RiseDownTableAllCond(RiseLickDownLLInd,6:7);
PropRiseLickDownLL = size(RiseLickDownLLNeuronID,1)/size(TableLastLick,1);
%cd('Z:\Kori\immobile_code\ConstantBOPlots\New100\')
save("RiseLickDownLLNeurons.mat", 'RiseLickDownLLNeuronID', 'RiseLickDownLLRatio')

% RiseRunDownLickInd = (RiseDownTableAllCond.RiseRun == 1 & RiseDownTableAllCond.DownLick == 1);
% RiseRunDownLickNeuronID =  RiseDownTableAllCond(RiseRunDownLickInd,1:2);
% RiseRunDownLickRatio =  RiseDownTableAllCond(RiseRunDownLickInd,9:10);
% PropRiseRunDownL = size(RiseRunDownLickNeuronID,1)/size(TableLastLick,1);
% %cd('Z:\Kori\immobile_code\ConstantBOPlots\New100\')
% save("RiseRunDownLickNeurons.mat", 'RiseRunDownLickNeuronID', 'RiseRunDownLickRatio', 'PropRiseRunDownL')

clear