%%COM Calculation

%formula: COMtime = Summation(i)[(time(i)*rate(i))]/  Summation(i)[rate(i)]

function PAC_COM_Warp_Ephys(savepath, FRPath)


%% Early Lick array 4501 (1000 pre, 2500 warp, 1484 post)
%Late Lick array 4501 (1000 pre, 2500 warp, 791 post)

     
        cd(savepath)
          
           foldername = ['PAC_COM_Warp_0-Warp_normTogether'];   
            mkdir(foldername)  
        
        cd(FRPath)
        load('TimeWarpedMatrix.mat')
        savename = 'COM_Norm_Warp.mat';
   
            for n = 1:size(warpedCa67,1)
   

                   NeuronDataEarly =  warpedCa4555(n,:);
           
                   NeuronDataLate =  warpedCa67(n,:);
              
            

                  time = 1:length(NeuronDataEarly)';
                com_4555(n,:) = sum(time .* NeuronDataEarly) / sum(NeuronDataEarly);
             
                  time = 1:length(NeuronDataLate)';
                   com_67(n,:) = sum(time .* NeuronDataLate) / sum(NeuronDataLate);
           
            end

        cd(savepath)
            save(savename, 'com_67', 'com_4555')
            clearvars -except  StartRange StartStr  savename

    
end