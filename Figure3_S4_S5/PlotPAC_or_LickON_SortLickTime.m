% 
 path = 'Z:\Kori\immobile_2p\anmc132\A132-20221123\A132-20221123-03\test_GF_100\'
sess = 'A132-20221123-03'
cd(path)
LL_path = [path sess '_DataStructure_mazeSection1_TrialType1_alignLastLick_msess1.mat'];
load(LL_path)

dffgfPath = ['dFFGF_befLastLick.mat'];
load(dffgfPath)
NeurData = dFFGFArray;
neurStr = 'dffgf';



 StartCue = trialsLastLick.startLfpInd; % start cue on

 for i = 2:size(trialsLastLick.lickLfpInd,2)
     if isempty(trialsLastLick.lickLfpInd{i})
         continue
     end    
 fLick = trialsLastLick.lickLfpInd{i}(1);
 firstLick(i) = fLick;
 end


%%%Sort by First lick 
    StartCued = StartCue(2:end)
    firstLick = firstLick(2:end); 
    flicks = firstLick - StartCued;
    firstLickSorted = sort(flicks);


% % % load neurons 

% % cd('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\Shuff\')
% % load("RiseLastLickDownLickNeurons.mat") 

cd('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\')
load("RiseLastLickDownLickNeurons_thres.mat") 
tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1))
NeurSel = RiseLLDownLickNeuronID.neu_id(tf,:);


% % cd('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\')
% % load("RiseLickDownLLNeurons_thres.mat") 
% % tf = strcmp(sess,RiseLickDownLLNeuronID.rec_name(:,1))
% % NeurSel = RiseLickDownLLNeuronID.neu_id(tf,:);
% % 


      cd(path)
      foldername = ['IndLLtoFLickPlot_PAC_sort'];   
     mkdir(foldername)  

      savepath = [path foldername]
      cd(savepath)

      for u =  1:size(NeurSel,1)
             % b =u;
            b = NeurSel(u)
             Neuron = NeurData{b}(:,500:end); %%500 = -2
             data =   [flicks', Neuron];
             FRsortFlick = sortrows(data,1);
             FRsortLick =  FRsortFlick(:,2:end);    
    
            figure
            hold on 
            imagesc(FRsortLick)  %uncomment later
            colormap(flipud(gray))
            clim([0 0.6])
            axis square
            tr = [1:1:size(firstLickSorted,2)];
            firstLickSortedEdit =    firstLickSorted + 1000;
            plot(firstLickSortedEdit,tr,'magenta', 'LineWidth',2)   %uncomment later
            
            xlim([0 4500])
            ylim([0 size(firstLickSorted,2)])
            ylabel('Trials')
            xlabel('Time from last lick (s)')
            xticks([0 500 1000 1500 2000 2500 3000 3500 4000 4500])
            xticklabels({'-2', '-1', '0','1','2', '3', '4','5', '6', '7'})
            T = ['Neuron' num2str(b) sess]
            title(T)
            set(gca,'FontSize',17.5)
            fileName1 = ['Neuron' num2str(b) '-LastLick to FirstLick' ];
            savefig([ fileName1 '.fig'])
            print('-painters','-dpng',[ fileName1],'-r600');
            print('-painters','-dpdf',[ fileName1],'-r600');

    end
    