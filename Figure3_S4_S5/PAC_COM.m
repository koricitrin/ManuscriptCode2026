%%%

%%COM Calculation

%formula: COMtime = Summation(i)[(time(i)*rate(i))]/  Summation(i)[rate(i)]

function PAC_COM(TablePath,Paths, PAC)

    for k = 1:size(Paths,1)
        % Path = Paths(k,:);
        Path = Paths{k,:};
        cd(Path)
        sess = Path(43:58)
        datapath = [Path 'dFFGF_befLastLick.mat';]
        load('FirstLick_LL.mat')
       
        FirstLick =  FirstLick(2:end);
        Trials =  1:length(FirstLick);
        Tr3to4temp =   FirstLick< 4 & FirstLick >3;
        Tr35to45temp =   FirstLick< 4.5 & FirstLick >3.5;
        Tr5to6temp =   FirstLick< 6 & FirstLick >5;
      
        Tr3to4 = Trials(Tr3to4temp);
        Tr35to45 = Trials(Tr35to45temp);
        Tr5to6 = Trials(Tr5to6temp);

        if PAC == 1
        cd(TablePath)
          load("RiseLastLickDownLickNeurons_thres.mat") 
         % 
         % load("RiseLastLickDownLickNeurons.mat") 
        tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
        Fields = RiseLLDownLickNeuronID.neu_id(tf,:);
        cd(Path)
           foldername = ['PAC_COM_EarlyLate_0-6'];   
            mkdir(foldername)  
             % StartRange = 501 %-2
              StartRange = 1501 %0
            EndRange = 500 %6
         
        elseif PAC == 0
            fieldpath = [Path 'FieldDetectionShuffle\'];
            cd(fieldpath)
            fieldfilename = ['FieldIndexShuffle' 'LastLick' '99.mat'];
            load(fieldfilename)
            Fields =  FieldID';
            cd(Path)
            foldername = ['Field_EarlyLate=0-6'];   
            mkdir(foldername)  
            StartRange = 1501 %0
           EndRange = 500 %6
        elseif PAC == 3
        cd(TablePath)
         % load("RiseLastLickDownLickNeurons_thres.mat") 
         load("RiseLickDownLLNeurons_thres.mat") 
        tf = strcmp(sess,RiseLickDownLLNeuronID.rec_name(:,1));
        Fields = RiseLickDownLLNeuronID.neu_id(tf,:);
        cd(Path)
           foldername = ['LickON_COM_EarlyLate_0'];   
            mkdir(foldername)  
             % StartRange = 501 %-2
             StartRange = 1501 %0
            EndRange = 500 %
        end
        
        load(datapath);  % Adjust filename pattern as needed
        dFFGFArray;
   
           cd(Path)
       
       savepath = [Path foldername]
      cd(savepath)
            for n = 1:size(Fields,1)
                neuron = Fields(n)
     
                NeuronDataEarly =  mean(dFFGFArray{neuron}(Tr35to45,StartRange:end-EndRange));
                NeuronDataEarly_Norm = (NeuronDataEarly - min(NeuronDataEarly))/(max(NeuronDataEarly) - min(NeuronDataEarly));
                  time = 1:length(NeuronDataEarly)';
                com_3545(n,:) = sum(time .* NeuronDataEarly_Norm) / sum(NeuronDataEarly_Norm);
                if (com_3545(n) >3500) || (com_3545(n) < 0)
                    'stop'
                end
                 NeuronDataLate =  mean(dFFGFArray{neuron}(Tr5to6,StartRange:end-EndRange));
                 NeuronDataLate_Norm = (NeuronDataLate - min(NeuronDataLate))/(max(NeuronDataLate) - min(NeuronDataLate));
                  time = 1:length(NeuronDataLate)';
                 com_56(n,:) = sum(time .* NeuronDataLate_Norm) / sum(NeuronDataLate_Norm);
     
            end


            save('COM_3454_Norm_thres.mat', 'com_56', 'com_3545')
            clearvars -except TablePath Paths PAC

    end
end