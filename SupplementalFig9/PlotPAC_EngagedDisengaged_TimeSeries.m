%segment trials 2 

function PlotPAC_EngagedDisengaged_TimeSeries(EngagedPaths, DisengagedPaths)

    for k = 1:size(EngagedPaths,1)
         EngagedPath_k =  EngagedPaths(k,:)
         cd(EngagedPath_k)
         sess = EngagedPath_k(1,43:58)
         load([sess 'BTDT.mat'])
         LicksEng = behEventsTdt.lick(:,4);
         PumpEng = behEventsTdt.pump(:,4);
         load([sess '-whl.mat'])
         DffEng = interpTspdFF;

         DisengagedPath_k = DisengagedPaths(k,:)
         cd(DisengagedPath_k)
         sess = DisengagedPath_k(1,43:58)
         load([sess 'BTDT.mat'])
         LicksDisengaged = behEventsTdt.lick(:,4);
         PumpDisengaged = behEventsTdt.pump(:,4);
         load([sess '-whl.mat'])
         DffDis = interpTspdFF;
        

          BasePath =  DisengagedPath_k(1:end-17)
          cd(BasePath)     
          load('OverlapPAC_Disengaged.mat')

          foldername = ['DisengagedEngagedTimeseries'];   
          mkdir(foldername)  
          savepaths = [BasePath foldername]
          cd(savepaths)
        
      %%plot the disengaged cells  
          Dff_Disengaged = DffDis(MatLabID_Disengaged_Overlap, :);
          Dff_Engaged =  DffEng(MatLabID_PAC_Overlap, :);
            param.threStd = 3;
            param.prctile = 90;
            param.stdsm = 100 %changed 6/25
            h = gaussFilter2P(12*param.stdsm,param.stdsm); %change 6/25/24
            lenGaussKernel = length(h);
             for i = 1:size(Dff_Disengaged,1)
                dFFGF_dis(i,:) = gauss_filter(Dff_Disengaged(i,:),h,lenGaussKernel);
                dFFGF_eng(i,:) = gauss_filter(Dff_Engaged(i,:),h,lenGaussKernel);
             end 
        
        Dff_Disengaged = dFFGF_dis;
        Dff_Engaged = dFFGF_eng;
 % 1:size(Dff_Disengaged,1)
        
        for neur =  14
            figure
         
            subplot(2,1,1)
             hold on
            ylabel('dF/F')
            plot(Dff_Engaged(neur,:), 'LineWidth', 2)
             scatter(LicksEng, ones(length(LicksEng),1), 'm', '|')
             scatter(PumpEng, ones(length(PumpEng),1), 'b', 'Filled')
             xlabel( 'Time')
             xlim([155000 170000])
             T = ['Neuron-' num2str(MatLabID_PAC_Overlap(neur))]
            title('Timing task')
            subplot(2,1,2)
             hold on
            ylabel('dF/F')
            plot(Dff_Disengaged(neur,:), 'LineWidth', 2)
            scatter(LicksDisengaged, ones(length(LicksDisengaged),1), 'm', '|')
              scatter(PumpDisengaged, ones(length(PumpDisengaged),1), 'b',  'Filled')
               xlim([ 10000       25000])
            T_2 = ['Neuron-' num2str(MatLabID_Disengaged_Overlap(neur)) 'pumpedit'];
             title('Disengaged')
             xlabel( 'Time (s)')
            savefig([T '.fig'])
            print('-painters','-dpng',[T],'-r600');
        end


        clearvars -except EngagedPaths DisengagedPaths
        end
end
