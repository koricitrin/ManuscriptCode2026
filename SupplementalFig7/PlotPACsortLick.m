
function PlotPACsortLick(paths, filename)
        for i = 1:size(paths,1)
        paths_i = [paths(i,:) filename(i,:)]
        
        sess =  filename(i,1:16);
        cd(paths(i,:))
        LL_paths = [paths_i  '_alignLastLick_msess1.mat'];
        load(LL_paths)
         
        fsa_paths = [paths_i '_convSpikesAligned_msess1_BefLastLick0.mat'];
        
        load(fsa_paths)
        NeurData = filteredSpikeArrayLastLickOnSet;
       timeStepRun = timeStepRun/1250
             % timeStepRun = -3:(1/1250):9;
        
         StartCue = trialsLastLick.startLfpInd; % start cue on
        
         for tr = 2:size(trialsLastLick.lickLfpInd,2)
             if isempty(trialsLastLick.lickLfpInd{tr})
                     fLick = trialsLastLick.startLfpInd(tr);
             else
                     fLick = trialsLastLick.lickLfpInd{tr}(1);
             end    
         firstLick(tr) = fLick;
         end
        
          for tr = 1:size(trialsLastLick.pumpLfpInd,2)
                if isempty(trialsLastLick.pumpLfpInd{tr});
                    continue
                end    
         RW = trialsLastLick.pumpLfpInd{tr}(1);   
         Reward(tr) = RW;
          end

          StartCued = []
          flicks = [];
        
        %%%Sort by First lick 
        StartCued = StartCue(2:end); %exclude first cue so you can align to last lick
        
        firstLick = firstLick(2:end);
        flicks = firstLick - StartCued;
        firstLickSorted = sort(flicks);
        
        
        % cd('Z:\Kori\immobile_code\Ephys\RiseDown\tables\')
        % % load("RiseLastLickDownLickNeurons.mat") 
        % % tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1))
        % % Fields = RiseLLDownLickNeuronID.neu_id(tf,:);

        load([sess 'PACmanual_NoInt.mat'])  
        NeurSel = PACmanual_NoInt;
        
        
             cd(paths(i,:))
             foldername = ['IndLLtoFLickPlot_PAC_manual_0217'];   
             mkdir(foldername)  
           savepaths = [paths(i,:) foldername]
        
              cd(savepaths)
         %1:size(Fields,1)
        % 1:size(filteredSpikeArrayLastLickOnSet,2)
              for    u = 1:size(NeurSel,2)
                     b =u;
                        b = NeurSel(u)
            
                     Neuron = NeurData{b}(2:end,:);
                    data =   [flicks', Neuron];
                    FRsortFlick = sortrows(data,1);
                    FRsortLick =  FRsortFlick(:,2:end);    
            
                    figure
                    hold on 
                  
                    imagesc(timeStepRun, 1:size(FRsortLick,1), (FRsortLick)) 
                    % imagesc(Neuron)
                    colormap(flipud(gray))
                   axis square
              %    % % 
           
               xlim([-3 10])
                    tr = [1:1:size(firstLickSorted,2)];
                   firstLickSortedEdit =    (firstLickSorted/1250);
                   firstLickSortedEdit = firstLickSortedEdit;
                   plot(firstLickSortedEdit,tr,'magenta', 'LineWidth',2)   %uncomment later
            
                    ylim([0 size(firstLickSorted,2)])
                    ylabel('Trials')
                    xlabel('Time from last lick (s)')
              
                  % l = legend('First Lick')
                    T = ['Neuron' num2str(b) sess];
                    title(T)
                    set(gca,'FontSize',17.5)
                     fileName1 = ['Neuron' num2str(b) '-LastLick to FirstLick' ]; %uncomment later
                     savefig([ fileName1 '.fig'])
                    print('-painters','-dpng',[ fileName1],'-r600');
        
              end
              clearvars -except paths filename
        end
        close all
end