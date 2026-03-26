%get the trialsCue.dFFGF to be by ind cell with bef time

function IndNeu_dFFGF(path, delay)

    if delay == 4
        time = 5000;
    elseif  delay == 3
        time = 4500;    
    elseif  delay == 2
        time = 4000;
    elseif  delay == 35
        time = 4750;   
    elseif  delay == 25
        time = 4250;  

          elseif  delay == 5
        time = 5500;  
    end    


       
    for cond = 3:4
    
          if cond == 1
          CondStr = 'Cue';
          elseif cond == 2
          CondStr = 'LastLick';   
          elseif cond == 3
          CondStr = 'Rew';
          elseif cond == 4
          CondStr = 'Lick';
          elseif cond == 5
          CondStr = 'CueOff'; 
          elseif cond == 6
          CondStr = 'Run';
    end  
    for k = 1:size(path,1)
    cd(path(k,:))
    dataPath = [path(k,43:58) '_DataStructure_mazeSection1_TrialType1_align' CondStr '_msess1.mat'];
   %dataPath = ['A747-20240811-01' '_DataStructure_mazeSection1_TrialType1_align' CondStr '_msess1.mat'];
    load(dataPath)  

        if cond == 1
          DataNeu = trialsCue; 
        elseif cond == 2
          DataNeu = trialsLastLick;   
        elseif cond == 3
          DataNeu = trialsRew;   
          elseif cond == 4
         DataNeu = trialsLick;   
           elseif cond == 5
         DataNeu = trialsCueOff;   
        end  

    %add the before 3 seconds to the current trial
    
    for i = 2:size(DataNeu.dFFBefGF,2)
        temp = [DataNeu.dFFBefGF{i}; DataNeu.dFFGF{i}];
        dFFTrialBefGF{i} = temp; 
    end

    indNeu = 1:size(DataNeu.dFFBefGF{2},2);

    
    for j = 1:size(indNeu,2) %neuron id
                  dFFGFArray{j} = [];
                  nNeur =  indNeu(j);  
                  for  i = 2:size(dFFTrialBefGF,2) %tr num %%change to dFF from spikes
                      spikesTr =  dFFTrialBefGF{i};
                      if size(spikesTr,1)< time
                          difference =    time - size(spikesTr,1);
                           z = repmat(0, difference,size(spikesTr,2));  %pad the difference with zeros
                          spikesTr = [spikesTr; z];
                      end
                    neurTr = spikesTr(1:time,nNeur);
                    dFFGFArray{j} = [dFFGFArray{j}; neurTr'];
                    clearvars neurTr
                  end

                 %  filteredSpikeArrayMat =  cell2mat(filteredSpikeArrayNew(i));         
    end
  savename = ['dFFGF_bef' CondStr '.mat']
save(savename, "dFFGFArray", "-v7.3")
clear dFFTrialBefGF dFFGFArray
    end
end