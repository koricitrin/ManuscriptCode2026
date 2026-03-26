%%%

%%COM Calculation

%formula: COMtime = Summation(i)[(time(i)*rate(i))]/  Summation(i)[rate(i)]

function PAC_COM_Run(TablePath,FileBase, Paths, warp, FrPath)


         cd(TablePath)
         load("RiseLastLickDownLickNeurons.mat") 
        Fields = RiseLLDownLickNeuronID.neu_id;
         time = 1:3000';

     
     if warp == 0

    for k = 1:size(Paths,1)
         Path = Paths(k,:);
        % Path = Paths{k,:};
        cd(Path)
        sess = FileBase(k,:);
        datapath = [Path 'dFFGF_befLastLick.mat';]
        load('FirstLick_LL.mat')
       
        FirstLick =  FirstLick(2:end);
        Trials =  1:length(FirstLick);
        Tr2to3temp =   FirstLick< 3 & FirstLick >2;
        Tr3to4temp =   FirstLick< 4 & FirstLick > 3;
         Tr35to45temp =   FirstLick< 4.5 & FirstLick > 3.5;

        Tr3to4 = Trials(Tr3to4temp);
        Tr35to45 = Trials(Tr35to45temp);
 
  
        cd(TablePath)
         % load("RiseLastLickDownLickNeurons_thres.mat") 
         load("RiseLastLickDownLickNeurons.mat") 
        tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
        Fields = RiseLLDownLickNeuronID.neu_id(tf,:)
         time = 1:3000';
    
         cd(Path)
            load(datapath);  % Adjust filename pattern as needed
            dFFGFArray;
            
           cd(Path)
           foldername = ['PAC_COM_EarlyLate'];   
           mkdir(foldername)  
           savepath = [Path foldername]
           cd(savepath)

            for n = 1:size(Fields,1)
                neuron = Fields(n)
     
                NeuronDataEarly =  mean(dFFGFArray{neuron}(Tr2to3,1501:end-500));
                NeuronDataEarly_Norm = (NeuronDataEarly - min(NeuronDataEarly))/(max(NeuronDataEarly) - min(NeuronDataEarly));
                com_23(n,:) = sum(time .* NeuronDataEarly_Norm) / sum(NeuronDataEarly_Norm);
                if (com_23(n) >3500) || (com_23(n) < 0)
                    'stop'
                end
                 NeuronDataLate =  mean(dFFGFArray{neuron}(Tr3to4,1501:end-500));
                 NeuronDataLate_Norm = (NeuronDataLate - min(NeuronDataLate))/(max(NeuronDataLate) - min(NeuronDataLate));
                 com_34(n,:) = sum(time .* NeuronDataLate_Norm) / sum(NeuronDataLate_Norm);
                  NeuronData3545 =  mean(dFFGFArray{neuron}(Tr35to45,1501:end-500));
                 NeuronData3545_Norm = (NeuronData3545 - min(NeuronData3545))/(max(NeuronData3545) - min(NeuronData3545));
                 com_3545(n,:) = sum(time .* NeuronData3545_Norm) / sum(NeuronData3545_Norm);
    
            end

            save('COM_23_34_Norm_thres.mat', 'com_34', 'com_23', 'com_3545')
            clearvars -except TablePath Paths FileBase
        end
        elseif warp == 1
               cd(FrPath) 
               load('TimewarpMatrix.mat')
                time = 1:3000';
               cd(FrPath)
               foldername = ['PAC_COM_EarlyLate'];   
               mkdir(foldername)  
               savepath = [FrPath foldername]
               cd(savepath)
            for n = 1:size(Fields,1)

                NeuronDataEarly =  warpedCaEarly(n,:);
           
                com_23(n,:) = sum(time .* NeuronDataEarly) / sum(NeuronDataEarly);
                if (com_23(n) >3500) || (com_23(n) < 0)
                    'stop'
                end

                 NeuronDataLate =  warpedCaLate(n,:);
                 com_3545(n,:) = sum(time .* NeuronDataLate) / sum(NeuronDataLate);
    
            end
            save('COM_Warp.mat', 'com_23', 'com_3545')
            clearvars -except TablePath Paths FileBase
        end

    
end