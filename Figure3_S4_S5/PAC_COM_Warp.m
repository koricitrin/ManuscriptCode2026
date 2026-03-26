%%COM Calculation

%formula: COMtime = Summation(i)[(time(i)*rate(i))]/  Summation(i)[rate(i)]

function PAC_COM_Warp(StartRange, savepath, FRPath)


%% Early Lick array 4501 (1000 pre, 2500 warp, 1484 post)
%Late Lick array 4501 (1000 pre, 2500 warp, 791 post)
if StartRange == 1001
        StartStr = '0'
        elseif StartRange == 1
         StartStr = '-2'
        end


     
        cd(savepath)
          
           foldername = ['PAC_COM_Warp_' StartStr '-Warp_normTogether'];   
            mkdir(foldername)  
        
        cd(FRPath)
        load('TimewarpMatrix3000.mat')
       
        savename = 'COM_Norm_Warp3000.mat';
   
            for n = 1:size(PrePost56,1)
   

                   NeuronDataEarly =  PrePost3545(n,StartRange:3000);
           
                   NeuronDataLate =  PrePost56(n,StartRange:3000);
              
            

                  time = 1:length(NeuronDataEarly)';
                com_3545(n,:) = sum(time .* NeuronDataEarly) / sum(NeuronDataEarly);
                if (com_3545(n) >3500) || (com_3545(n) < 0)
                    'stop'
                end
                  time = 1:length(NeuronDataLate)';
                   com_56(n,:) = sum(time .* NeuronDataLate) / sum(NeuronDataLate);
           
            end
        com_56 = com_56/3000;
        com_3545 = com_3545/3000;
        cd(savepath)
            save(savename, 'com_56', 'com_3545')
            clearvars -except  StartRange StartStr  savename

    
end