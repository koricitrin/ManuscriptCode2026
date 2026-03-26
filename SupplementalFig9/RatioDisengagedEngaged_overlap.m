function RatioDisengagedEngaged_overlap(EngagedPath, BasePath, cond)

EngArrayCat = [];
    for k = 1:size(EngagedPath,1)
        cd(EngagedPath(k,:))
        if cond ==1
        load('EngagedArray_LastLick.mat')
       EngArrayCat = [EngArrayCat; EngArray(:,1:5000)];
        condstr = 'LastLick'
        elseif cond ==2
       load('EngagedArray_FirstLick.mat')
       EngArrayCat = [EngArrayCat; EngArray(:,1:5000)];
       condstr = 'FirstLick'
        end
    end

  DisengArrayCat = [];
    for k = 1:size(BasePath,1)
        PathTemp = [BasePath(k,:) 'Disengaged Engaged Plots\']
        cd(PathTemp)
        if cond ==1
        load('DisengagedArray_LastLick1sPreLicks.mat')
       DisengArrayCat = [DisengArrayCat; PAC_OverLapBefLL];
        elseif cond ==2
             load('DisengagedArray_FirstLick1sPreLicks.mat')
       DisengArrayCat = [DisengArrayCat; PAC_OverLapBefLick];
        end
    end
 
    cd('Z:\Kori\immobile_code\RiseLLDownL\Disengaged\')
   
    for neurons = 1:size(DisengArrayCat, 1)
        NeuronDisTemp = DisengArrayCat(neurons,:);
        AftNeuronData = NeuronDisTemp(1,1000:1250);
         BefNeuronData = NeuronDisTemp(1,750:1000);
        Ratio_dis(neurons,:) =  mean(AftNeuronData)/mean(BefNeuronData);
    end

    for neurons = 1:size(EngArrayCat, 1)
        NeuronEngTemp = EngArrayCat(neurons,:);
        AftNeuronData = NeuronEngTemp(1,1500:1750);
         BefNeuronData = NeuronEngTemp(1,1250:1500);
        Ratio_eng(neurons,:) =  mean(AftNeuronData)/mean(BefNeuronData);
    end


 
  std_data = std(Ratio_eng, 0,1,'omitnan');
 std_data_1 = std_data/ sqrt(size(BasePath,1));
 DataEng = [mean(Ratio_eng), std_data_1]

 std_data = std(Ratio_dis, 0,1,'omitnan');
 std_data_2 = std_data/ sqrt(size(BasePath,1));
 DataDis = [mean(Ratio_dis), std_data_2]

       [pRank,h] = ranksum(Ratio_eng, Ratio_dis)
     [h, ptttest] = ttest(Ratio_eng, Ratio_dis)

           C = winter(10);


    figure
        axis square
    hold on
    X2 = ones(size(Ratio_dis,1),1)*2;
    X1 = ones(size(Ratio_eng,1),1);


    Y = [{Ratio_eng} {Ratio_dis}];
    X = [{X1} {X2}];
 
        for Stages = 1:2
        b = boxchart(X{Stages}, Y{Stages})
        
        if Stages == 1
        b.BoxFaceColor = 'b'; 
        elseif  Stages == 2
        b.BoxFaceColor = 'g'; 
         
        end
        end

    xlim([0 3])

    yline(1.5, '--', 'LineWidth', 2, 'Color', 'k')
       ylim([0 18])

     
     yticklabels(0:2:18)
    xticks(0:3)
     xticklabels([{'', 'Time', 'Dis', ''}])
     xlim([0 3])
    ylabel('dFFaft/dFFbef')

    T = ['RatioAligned' 'Overlap']
    % axis square
    title(T)
    set(gca ,'FontSize', 18)
     print('-painters','-dpng',[T],'-r600');
   savefig([T '.fig'])
   print('-painters','-dpdf',[T],'-r600');


    figure
        axis square
    hold on
    X2 = ones(size(Ratio_eng,1),1)*2;
    X1 = ones(size(Ratio_dis,1),1);
    a = 0.93;
    b = 1.07;
    X1 = (b-a).*rand(size(Ratio_dis,1),1) + a;
    a = 1.93;
    b = 2.07;
    X2 = (b-a).*rand(size(Ratio_eng,1),1) + a;
    scatter(X1, Ratio_eng, 60, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k')
    scatter(X2,Ratio_dis, 60, 'MarkerFaceColor','g', 'MarkerEdgeColor', 'k')
    xlim([0 3])
    for n = 1:length(Ratio_eng)
        x = [X2(n), X1(n)]
        y = [Ratio_dis(n), Ratio_eng(n)]
  
    plot(x, y, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.6);
    end
    if cond == 1
    yline(1.5, '--', 'LineWidth', 2, 'Color', 'k')
       ylim([0 18])
    elseif cond ==2
        yline(0.66, '--')  
        ylim([0 6])
    end
     
     yticklabels(0:2:18)
    xticks(0:3)
     xticklabels([{'', 'Time', 'Dis', ''}])
     xlim([0.5 2.5])
    ylabel('Ratio')
    T = ['Ratio aligned' condstr 'rect' '0213']
    % axis square
    title(T)
    set(gca ,'FontSize', 18)
     print('-painters','-dpng',[T],'-r600');
   savefig([T '.fig'])
   print('-painters','-dpdf',[T],'-r600');
      clearvars -except EngagedPath BasePath
end