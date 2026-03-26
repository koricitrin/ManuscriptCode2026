
 path =  'Z:\Zhuoyang\ImagingExp\A_GCaMP8\ANMY747\A747-20240812\01\test_GF_100\'
sess = 'A747-20240812-01'
cd(path)
LL_path = [path sess '_DataStructure_mazeSection1_TrialType1_alignLastLick_msess1.mat'];
load(LL_path)
% 
dffgfPath = ['dFFGF_befLastLick.mat'];
load(dffgfPath)
NeurData = dFFGFArray;
neurStr = 'dffgf';

% fsa_path = [path sess '_DataStructure_mazeSection1_TrialType1_convSpikesAlignedBefLastLick_msess1.mat'];
%         load(fsa_path, 'dFFArray')
%         neurStr = 'dff';
%        NeurData = dFFArray;

 StartCue = trialsLastLick.startLfpInd; % start cue on

 for i = 2:size(trialsLastLick.lickLfpInd,2)
     if isempty(trialsLastLick.lickLfpInd{i})
         continue
     end    
 fLick = trialsLastLick.lickLfpInd{i}(1);
 firstLick(i) = fLick;
 end

  for i = 1:size(trialsLastLick.pumpLfpInd,2)
        if isempty(trialsLastLick.pumpLfpInd{i});
            continue
        end    
 RW = trialsLastLick.pumpLfpInd{i}(1);   
 Reward(i) = RW;
 end

%%%Sort by First lick 
StartCued = StartCue(2:end); %exclude first cue so you can align to last lick

firstLick = firstLick(2:end);
flicks = firstLick - StartCued;
firstLickSorted = sort(flicks);


% load neurons 
cd('Z:\Kori\RunningTask2pCode\RiseDown\tables\ZY\')
load('RiseLastLickDownLickNeurons.mat')
 tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1))
Fields = RiseLLDownLickNeuronID.neu_id(tf,:); 


      cd(path)
      foldername = ['IndLLtoFLickPlot_PAC'];   
     mkdir(foldername)  

      savepath = [path foldername]
      cd(savepath)
 
       for u = 1 %1:size(NeuronSel,2)   %1:size(Fields,1) 
             b =u;
              b = Fields(u)
           b = 512
             Neuron = NeurData{b}(1:end,500:end);
            data =   [flicks', Neuron];
            FRsortFlick = sortrows(data,1);
            FRsortLick =  FRsortFlick(:,2:end);    
        %     
            figure
            hold on 
            imagesc(FRsortLick)
           colormap gray
               cm = colormap;
               colormap(flipud(cm));
               clim([0 1])
           axis square
              %colorbar
             tr = [1:1:size(firstLickSorted,2)];
          firstLickSortedEdit =    firstLickSorted + 1000;
          plot(firstLickSortedEdit,tr,'magenta', 'LineWidth',2)  
             %plot(RewSort,tr,'green', 'LineWidth',2) 
           % plot(Rewplot,tr,'cyan', 'LineWidth',2)  
            FLickplot=firstLick; % make a copy of the data specifically for plotting.
            FLickplot(FLickplot==0)=nan; % replace 0 elements with NaN.
             plot(FLickplot,tr,'yellow', 'LineWidth',2) 
             xlim([0 3500])
            ylim([0 size(firstLickSorted,2)])
            ylabel('Trials')
            xlabel('Time from last lick (s)')
            xticks([0 500 1000 1500 2000 2500 3000 3500 4000 4500])
           xticklabels({'-2', '-1', '0','1','2', '3', '4','5', '6', '7'})
          % l = legend('First Lick')
            T = ['Neuron' num2str(b) sess]
            title(T)
            set(gca,'FontSize',17.5)
            fileName1 = ['Neuron' num2str(b) '-LastLick to FirstLick-' neurStr];
             savefig([ fileName1 '.fig'])
            print('-painters','-dpng',[ fileName1],'-r600');

    end
    