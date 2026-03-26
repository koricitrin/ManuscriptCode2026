%%COM Calculation

%formula: COMtime = Summation(i)[(time(i)*rate(i))]/  Summation(i)[rate(i)]

function PAC_COM_Block_Warp(StartRange,Lick, savepath, datapath, overlap)

     
%% Rew array 3501 (1000 pre, 2500 warp)
%% Lick array 4501 (1000 pre, 2500 warp, 1000 post)
if StartRange == 1001
        StartStr = '0'
        elseif StartRange == 1
         StartStr = '-2'
        end


        if Lick == 1 
            EndRange =1000
       %  if EndRange == 0
       %      EndStr = '7'
       %  elseif EndRange == 500
       %      EndStr = '6'
       %   elseif EndRange == 1000
       %      EndStr = '5'   
       % elseif EndRange == 1500
       %      EndStr = '4' 
       %  elseif EndRange == 2000
       %      EndStr = '3'   
       %  end
        else
            EndRange = 0
        end


       
        cd(savepath)
          if overlap == 1
           foldername = ['PAC_COM_Warp_' StartStr '-Warp_normTogetherOverlap'];   
          else
              foldername = ['PAC_COM_Warp_' StartStr '-Warp_normTogether']; 
          end
            mkdir(foldername)  
        
        cd(datapath)
        if Lick == 1
        % load('WarpedLick.mat')
        load('TimewarpMatrixDelay3000.mat')
        savename = 'COM_Blocks_Norm_Warp_Lick3000.mat';
        else
          load('WarpedRew.mat')  
             savename = 'COM_Blocks_Norm_Warp_Rew.mat';
        end
       savepath2 = [savepath foldername]
      cd(savepath2)
            for n = 1:size(PrePost5s,1)
   

                   NeuronDataEarly =  PrePost3s(n,StartRange:end-EndRange);
           
                   NeuronDataLate =  PrePost5s(n,StartRange:end-EndRange);
              
            

                  time = 1:length(NeuronDataEarly)';
                com_3s(n,:) = sum(time .* NeuronDataEarly) / sum(NeuronDataEarly);
                if (com_3s(n) >3500) || (com_3s(n) < 0)
                    'stop'
                end
                  time = 1:length(NeuronDataLate)';
                   com_5s(n,:) = sum(time .* NeuronDataLate) / sum(NeuronDataLate);
           
            end

          cd(savepath)
            save(savename, 'com_5s', 'com_3s')
            clearvars -except TablePath Paths PAC StartRange EndRange StartStr  EndStr

    
end