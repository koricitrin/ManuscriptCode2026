path = 'Z:\Kori\immobile_2p\anmc132\A132-20221123\A132-20221123-03\test_GF_100\'
sess = 'A132-20221123-03'
cd(path)

    
     dffgfPath = ['dFFGF_befLastLick.mat'];
     load(dffgfPath)
     NeurData = dFFGFArray;


     fieldpath = [path 'FieldDetectionShuffle\'];
     cd(fieldpath)
     fieldfilename = ['FieldIndexShuffle' 'LastLick' '99.mat'];
     load(fieldfilename)
     Fields =  FieldID;

     cd(path)
     foldername = ['FieldsPlot'];   
     mkdir(foldername)  
     savepath = [path foldername]
     cd(savepath)
      
      for u =  1:size(Fields,1)
      
            b = Fields(u)
            Neuron = NeurData{b}(:,1500:end); %1500 == 0
    
            figure
            hold on 
            imagesc((Neuron))
            colormap(flipud(gray))
            clim([0 1])
            axis square
            xlim([0 3500])
            xticks([0 500 1000 1500 2000 2500 3000 3500])
            xticklabels({'0','1','2', '3', '4','5', '6', '7'})
            xlabel('Time from last lick (s)')

            ylim([0 size(Neuron,2)])
            ylabel('Trials')
       
            T = ['Neuron' num2str(b)]
            title(T)
            set(gca,'FontSize',17.5)
            fileName1 = ['Neuron-' num2str(b)];
            savefig([ fileName1 '.fig'])
            print('-painters','-dpng',[ fileName1],'-r600');
            print('-painters','-dpdf',[ fileName1],'-r600');

    end
    