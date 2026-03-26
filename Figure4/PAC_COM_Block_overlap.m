%%COM Calculation

%formula: COMtime = Summation(i)[(time(i)*rate(i))]/  Summation(i)[rate(i)]

function PAC_COM_Block_overlap(StartRange, EndRange, datapath)


        if StartRange == 1501
        StartStr = '0'
        elseif StartRange == 501
         StartStr = '-2'
        end

        if EndRange == 0
            EndStr = '8'
        elseif EndRange == 500
            EndStr = '7'
         elseif EndRange == 1000
            EndStr = '6'   
       elseif EndRange == 1500
            EndStr = '5' 
        elseif EndRange == 2000
            EndStr = '4'   
        end
 savename = ['COM_Blocks_overlap_norm_' StartStr '-' EndStr '.mat'];
cd(datapath)    
load('DataNormTogetherBlock_AllPAC.mat')
            for n = 1:size(Block3sArrayNormTogether_PAC,1)
                
                 NeuronDataEarly_Norm = Block3sArrayNormTogether_PAC(n,StartRange:end-EndRange);
         
                 NeuronDataLate_Norm =  Block5sArrayNormTogether_PAC(n,StartRange:end-EndRange);

                  time = 1:length(NeuronDataEarly_Norm)';
                com_3s(n,:) = sum(time .* NeuronDataEarly_Norm) / sum(NeuronDataEarly_Norm);
                if (com_3s(n) >3500) || (com_3s(n) < 0)
                    'stop'
                end
                  time = 1:length(NeuronDataLate_Norm)';
                   com_5s(n,:) = sum(time .* NeuronDataLate_Norm) / sum(NeuronDataLate_Norm);
         
            end


            save(savename, 'com_5s', 'com_3s')
            clearvars -except TablePath Paths PAC StartRange EndRange StartStr  EndStr
  
    end
