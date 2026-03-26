%%COM Calculation

%formula: COMtime = Summation(i)[(time(i)*rate(i))]/  Summation(i)[rate(i)]

function PAC_COM_ephys_normTogether(path, filename, endtime)

    for i = 1:size(path,1)
        path_i = [path(i,:) filename(i,:)];
        cd(path(i,:))

        sess = filename(i,1:16);

            % 
            fsa_path = [path_i '_convSpikesAligned_msess1_BefLastLick0.mat'];
            load(fsa_path);

            filteredSpikeArray = filteredSpikeArrayLastLickOnSet;

        load('FirstLick_LL.mat')

        Trials =  1:length(FirstLick);
        Tr3to4temp =   FirstLick< 4 & FirstLick >3;
        Tr35to45temp =   FirstLick< 4.5 & FirstLick >3.5;
         Tr45to55temp =   FirstLick< 5.5 & FirstLick >4.5;
        Tr4to5temp =   FirstLick< 5 & FirstLick >4;

         Tr5to6temp =   FirstLick< 6 & FirstLick >5;
         Tr6to7temp =   FirstLick< 7 & FirstLick >6;

         Tr3to4 = Trials(Tr3to4temp);
         Tr4to5 = Trials(Tr4to5temp);
        Tr35to45 = Trials(Tr35to45temp);
         Tr45to55 = Trials(Tr45to55temp);
        Tr5to6 = Trials(Tr5to6temp);
         Tr4to5 = Trials(Tr4to5temp);
        Tr6to7 = Trials(Tr6to7temp);

         load([sess 'PACmanual_NoInt.mat'])
        % load("RiseLastLickDownLickNeurons.mat") 
   
        Fields = PACmanual_NoInt;
   
       foldername = ['PAC_COM_EarlyLate'];   
       mkdir(foldername)  
       savepath = [path(i,:) foldername]
       cd(savepath)
       if endtime == 9
           savestr = '9';
       elseif endtime == 8
            savestr = '8';
                   elseif endtime == 7
            savestr = '7';
       end
       timeStepRunNew = timeStepRun/1250
       Range = ([find(timeStepRunNew == 0), find(timeStepRunNew == endtime)]);
         time = 1:(Range(2)-Range(1))+1;
       smoothWindow = floor(0.1 * 1250);
        b_filt = ones(1, smoothWindow) / smoothWindow; % Numerator for moving average
        a_filt = 1;
         
            for n = 1:size(Fields,2)
                neuron = Fields(n)
     
                NeuronDataEarly =  mean(filteredSpikeArray{neuron}(Tr45to55,Range(1):Range(2)));
                 NeuronDataLate =  mean(filteredSpikeArray{neuron}(Tr6to7,Range(1):Range(2)));
         
                  DataCombine = [NeuronDataEarly, NeuronDataLate];
                 NeuronData_Norm_cat = (DataCombine - min(DataCombine))/(max(DataCombine) - min(DataCombine));
            
               NeuronDataEarly_Norm = NeuronData_Norm_cat(:,1:length(NeuronDataEarly));
               NeuronDataLate_Norm = NeuronData_Norm_cat(:,length(NeuronDataEarly)+1:end);
              
                 com_4555(n,:) = sum(time .* NeuronDataEarly_Norm) / sum(NeuronDataEarly_Norm);
                com_67(n,:) = sum(time .* NeuronDataLate_Norm) / sum(NeuronDataLate_Norm);


           
            end

            savename = ['COM_NormTogether_0' savestr '.mat']
            save(savename, 'com_4555', 'com_67', 'timeStepRun')
            clearvars -except path filename endtime

    end
end