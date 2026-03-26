function PlotPACSegmentedOverlapHeatmap(BasePath, EngagedPath)

        PAC_Dis_Cat = [];
        DisIndex = [];
        for k = 1:size(BasePath,1)

         datapath =   [BasePath(k,:)  'Disengaged Engaged Plots'];
         cd(datapath)
         load('DisengagedArray_LastLick1sPreLicks.mat')
         Index = ones(size(PAC_OverLapBefLL,1),1)*k;
         DisIndex = [DisIndex;Index]
         PAC_Dis_Cat = [PAC_Dis_Cat; PAC_OverLapBefLL];
        end
        DisArrayCat = PAC_Dis_Cat;
        cd('Z:\Kori\immobile_code\RiseLLDownL\Disengaged\')
        save('DisMatrix.mat', 'DisIndex', 'DisArrayCat')

        PAC_Eng_Cat  = [];
             EngIndex = []
        for k = 1:size(EngagedPath,1)
         cd(EngagedPath(k,:))
         load('EngagedArray_LastLick.mat')
           Index = ones(size(EngArray,1),1)*k;
          EngIndex = [EngIndex;Index];
         PAC_Eng_Cat = [PAC_Eng_Cat; EngArray(:,1:5000)];
        end
        EngArrayCat = PAC_Eng_Cat;
      cd('Z:\Kori\immobile_code\RiseLLDownL\Disengaged\')
        save('EngMatrix.mat', 'EngIndex', 'EngArrayCat')

    
         
           for neurons = 1:size(PAC_Eng_Cat, 1)
        NeuronEngTemp = PAC_Eng_Cat(neurons,:);
        AftNeuronData = NeuronEngTemp(1,1500:1750);
         BefNeuronData = NeuronEngTemp(1,1250:1500);
        Ratio_eng(neurons,:) =  mean(AftNeuronData)/mean(BefNeuronData);
    end


       [M,Ind] = sort(Ratio_eng, 'ascend');

           cd('Z:\Kori\immobile_code\RiseLLDownL\Disengaged\')   
          figure
          hold on
          axis square
          imagesc(PAC_Dis_Cat(Ind,:))
          colormap(flipud(gray))
          xline(1000, '--',  'LineWidth', 3, 'Color', 'm')
          xlim([0 4500])
          ylim([0 size(PAC_Dis_Cat,1)])
            xticks(0:500:5000)
          xticklabels({'-2' '-1' '0' '1' '2' '3' '4' '5' '6' '7'})
          xlabel(' Time from last lick (s)')
           ylabel('Neurons')
          set(gca, 'FontSize', 16)
           T = ('Disengaged Array - last lick')
           title(T)
           savefig([T '.fig'])
           print('-painters','-dpdf', [T '.pdf'], '-r600')
           % print('-painters','-dpng', [T '.png'], '-r600')

           figure
          hold on
          axis square
          imagesc(PAC_Eng_Cat(Ind,:))
          colormap(flipud(gray))
           set(gca, 'FontSize', 16)
          xline(1500, '--',  'LineWidth', 3, 'Color', 'm')
          xlim([500 5000])
          ylim([0 size(PAC_Dis_Cat,1)])
            xticks(0:500:5000)
            ylabel('Neurons')
          xticklabels({'-3', '-2' '-1' '0' '1' '2' '3' '4' '5' '6' '7'})
          xlabel(' Time from last lick (s)')
           T = ('Engaged Array - last lick')
            title(T)
           savefig([T '.fig'])
            print('-painters','-dpdf', [T '.pdf'], '-r600')
           % print('-painters','-dpng', [T '.png'], '-r600')
end