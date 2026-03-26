function FieldsMeanPropStatsLearning(PathsEarly, PathsLate, cond)
%% RiseLLDownLMeanPropStatsLearning('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\', 1)
  VariableBOAnmPath;  
%  ConstBoList 
if cond == 1
    condstr = 'LastLick';
elseif cond == 2
    condstr = 'Rew';
end

   for k = 1:size(PathsEarly)
                 Path = PathsEarly(k,:);
               
                    fieldpath = [Path 'FieldDetectionShuffle\'];
                    namestr = '';     
                    cd(fieldpath)   
                     dataname = ['FieldIndexShuffle'  condstr '99.mat'];
                    load(dataname)
                    FieldNO =  size(FieldID,2);

                    cd(Path) 
                    load([Path(43:58) '_corrFluo.mat']);
                    totalFields(k,:) = FieldNO;
                    totalNeurons(k,:) = length(Clu.localClu);
                    PercentFieldsEarly(k,:) = (FieldNO/length(Clu.localClu))*100;
 
   end
  
      for kk = 1:size(PathsLate)
                 Path = PathsLate(kk,:);
               
                    fieldpath = [Path 'FieldDetectionShuffle\'];
                    namestr = '';     
                    cd(fieldpath)   
                     dataname = ['FieldIndexShuffle' condstr '99.mat'];
                    load(dataname)
                    FieldNO =  size(FieldID,2);

                    cd(Path)
                    load([Path(43:58) '_corrFluo.mat']);
                    PercentFieldsLate(kk,:) = (FieldNO/length(Clu.localClu))*100;
 
   end
  


    a = 0.93;
    b = 1.07;
    X1 = (b-a).*rand(size(PercentFieldsEarly,1),1) + a;
 
 
    a = 1.93;
    b = 2.07;
    X2 = (b-a).*rand(size(PercentFieldsLate,1),1) + a;

 std_data = std(PercentFieldsEarly, 0,1,'omitnan');
sem_data = std_data/ sqrt(size(PercentFieldsEarly,1));
EarlyStats_SEM = [mean(PercentFieldsEarly), sem_data]
EarlyStats_STD = [mean(PercentFieldsEarly), std_data]

 std_data = std(PercentFieldsLate, 0,1,'omitnan');
sem_data = std_data/  sqrt(size(PercentFieldsLate,1));
LateStats_SEM = [mean(PercentFieldsLate), sem_data]
LateStats_STD = [mean(PercentFieldsLate), std_data]

Y = [{PercentFieldsEarly} {PercentFieldsLate}];
X = [{X1} {X2}];
 
[p_EL,h] = ranksum(PercentFieldsEarly, PercentFieldsLate)
 
 [p_t,h] = ttest2(PercentFieldsEarly, PercentFieldsLate)
 

 C = parula(10)
    f = figure;
    % f.Position = [350 350 380 400];
    hold on 
    for Stages = 1:2
        if Stages == 1
        scatter(X{Stages}, Y{Stages}, 120, MarkerFaceColor = C(1,:), MarkerEdgeColor='k'); 
         c =  bar(1, mean(Y{Stages}))
        set(c,'FaceColor', C(1,:) ,'FaceAlpha', 0.3); 
        SEM =   std(Y{Stages},[],1)/sqrt(size(Y{Stages},1));  
        errorbar(1,  mean(Y{Stages}),SEM, 'Color', 'k', 'LineWidth', 2)
    
        elseif  Stages == 2
        scatter(X{2}, Y{Stages}, 120, MarkerFaceColor = C(4,:), MarkerEdgeColor='k'); 
         c =  bar(2, mean(Y{Stages}))
        set(c,'FaceColor', C(4,:) ,'FaceAlpha', 0.3); 
       SEM =   std(Y{Stages},[],1)/sqrt(size(Y{Stages},1));  
        errorbar(2,  mean(Y{Stages}),SEM, 'Color', 'k', 'LineWidth', 2)
        end

        title('Time cells over learning')
        xticks(1:1:3)
        xticklabels({'Early', 'Late'})
        ylabel('% of time cells')
        set(gca, 'FontSize', 24)

        P_TEMP = p_EL;
        xl = 1.43;
        yl = 70;    
    end

    if P_TEMP  < 0.001
       ptext = ['***'];
       text(xl, yl, ptext, 'FontSize',40) 
    elseif P_TEMP < 0.01
       ptext = ['**'];
       text(xl, yl, ptext, 'FontSize',40) 
    elseif P_TEMP < 0.05
       ptext = ['*'];
       text(xl, yl, ptext, 'FontSize',40) 
    elseif P_TEMP > 0.05
       ptext = ['ns'];
       text(xl, yl, ptext, 'FontSize',30) 
    end   
   
    xpts = [xl-0.25 xl+0.45]
    ypts = [yl yl];
    f = line(xpts, ypts-6, 'LineWidth', 1.2, 'Color', 'k');
 set(gcf, 'Position', [100 100  775 600]);
     ylim([0 100])
    xlim([0 3])
    axis square
    savepath = 'Z:\Kori\PaperDrafting2025\Plots\fig4\'
    cd(savepath)
       T = ['TimeCellLearning' condstr 'D2-D10']
    SaveName = [T '_ranksum' 'Fields' condstr]
    print('-painters','-dpng',[SaveName],'-r600');
       print('-painters','-dpdf',[SaveName],'-r600');
    savefig([SaveName '.fig'])
    % save(SaveVarName, 'RiseSessPropDays')
 % 
end