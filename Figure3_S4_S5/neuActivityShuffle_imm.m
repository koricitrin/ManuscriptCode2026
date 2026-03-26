function ShufDistRatio = neuActivityShuffle_imm(filteredSpikeArray,indFR0to1,indFRBefRun,numShuffle)
       
    rowArray = size(filteredSpikeArray,1);
    colArray = size(filteredSpikeArray,2);
    ShufDistRatio = [];
    parfor i = 1:numShuffle
        shufSpikeArray = zeros(rowArray,colArray);
        randShift = randi(floor(colArray/2),1,rowArray)-floor(colArray/2);
        for j = 1:rowArray
            shiftTmp = circshift(filteredSpikeArray(j,:)',randShift(j));
            shufSpikeArray(j,:) = shiftTmp';
        end
        shufMeanArray_i = mean(shufSpikeArray);
             %% add in normalization  
       shufMeanArray_i_Norm =  (shufMeanArray_i - min(shufMeanArray_i))/(max(shufMeanArray_i) - min(shufMeanArray_i));   
       
        ShufDistRatio = [ShufDistRatio mean(shufMeanArray_i_Norm(indFR0to1))/mean(shufMeanArray_i_Norm(indFRBefRun))];
    end
    
end