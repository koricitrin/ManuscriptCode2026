% quantify overlap in rise down 


Path = ['Z:\Kori\immobile_code\BlockDelay\RiseDown\Tables\']
% sess = [Path(1,43:58)];
cd(Path)

% FileNameLickTable = [sess '_RiseDownID_LickWholePopthres.mat'];
% FileNameLastLickTable = [sess '_RiseDownID_LastLickWholePopthres.mat'];

FileNameLickTable = ['All_Recs_RiseDownID_AlignLickBlockDelaythres.mat'];
FileNameLastLickTable = ['All_Recs_RiseDownID_AlignLastLickBlockDelaythres.mat'];
    for trtype = 1:3
         if trtype == 1   
         load(FileNameLickTable)
         TableLick = RiseDownTable;  
         load(FileNameLastLickTable)
         TableLastLick = RiseDownTable;
         TrLabel = 'AllTr';
         elseif trtype == 2
         load(FileNameLickTable)
         TableLick = RiseDownTable3s;   
         load(FileNameLastLickTable)
         TableLastLick = RiseDownTable3s;
         TrLabel = '3sTr';    
          elseif trtype == 3
         load(FileNameLickTable)
         TableLick = RiseDownTable5s;   
         load(FileNameLastLickTable)
         TableLastLick = RiseDownTable5s;
         TrLabel = '5sTr';    
         end

    
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
        savename = ['RiseLastLickDownLickNeurons_thres' TrLabel '.mat'];
        save(savename, 'RiseLLDownLickNeuronID', 'RiseLLDownLickRatio', 'PropRiseLLDownL', 'RiseLLDownLickInd')
        
         RiseLickDownLLInd = (RiseDownTableAllCond.RiseLick == 1 & RiseDownTableAllCond.DownLastLick == 1);
        RiseLickDownLLNeuronID =  RiseDownTableAllCond(RiseLickDownLLInd,1:2);
        RiseLickDownLLRatio =  RiseDownTableAllCond(RiseLickDownLLInd,7:8);
        PropRiseLickDownLL = size(RiseLickDownLLNeuronID,1)/size(TableLastLick,1);
        savename = ['RiseLickDownLLNeurons_thres' TrLabel '.mat'];
        
        save(savename, 'RiseLickDownLLNeuronID', 'RiseLickDownLLRatio')
        clear TableLastLick TableLick
    end