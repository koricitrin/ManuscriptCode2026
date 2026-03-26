function ShuffleLabelWholePop(paths, delay, NB_Path, CondStr)  
 %good =1 , bad = 0 
   for i = 1:size(paths,1)
       cd(paths{i,:})
    
    naiveBayesPath = [paths{i,:} NB_Path '.mat']
   % naiveBayesPath = [paths(i,:) 'NaiveBayesDecoderAllTrWholePop10.mat']
    load(naiveBayesPath, 'naiveBayes')
    
    if (delay == 2)
      nBins1 = 50; 
      time = [0.05:0.1:5]';
      decodedErrShuf = zeros(50,1);
      
    elseif (delay == 22)
    nBins1 = 45;
    time = [0.05:0.1:4.5]';
    decodedErrShuf = zeros(45,1);     
   
      elseif (delay == 33)
    nBins1 = 55;
    time = [0.05:0.1:5.5]';
    decodedErrShuf = zeros(55,1);     
      
    
    elseif (delay == 44)
    nBins1 = 65;
    time = [0.05:0.1:6.5]';
    decodedErrShuf = zeros(65,1);  
      
    elseif (delay == 4)
    nBins1 = 70;
    time = [0.05:0.1:7]';
    decodedErrShuf = zeros(70,1);
    end

        label = naiveBayes.labelN2{1};
        trs = size(label,1)/nBins1;
        templabel = reshape(label, [nBins1, trs]);
    
        for j = 1:trs
        labelRandTr = datasample(templabel(:,j),nBins1, 'Replace',false);
       decodedErrShuff =  labelRandTr - time; 
       decodedErrShuf = [decodedErrShuf + decodedErrShuff];
        end
       decodedErrShuf  =  decodedErrShuf/trs;
           
        labelN2Tmp = reshape(naiveBayes.labelN2{1},nBins1,[]);
        LabelN2Mode = mode(labelN2Tmp,2);
        
        
   SaveShufName = [NB_Path CondStr 'Shuf.mat']
   
   SaveLabelName = [NB_Path CondStr 'Label.mat']
    save(SaveShufName, "decodedErrShuf")
   save(SaveLabelName, "LabelN2Mode")

       
   
   
   
   clear   decodedErrShuf
  end
    
end