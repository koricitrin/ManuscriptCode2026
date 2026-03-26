function PropDelayLickStatsCue(Path1, Path2, savepath)
%% RiseDownMeanPropStatsLearning('Z:\Kori\immobile_code\RiseDown\tables\2025-1p5to1p5\Variable\', 2, 1)
   VariableBOAnmPath  
  %ConstBoList
 
    figure
    hold on  

    for i = 1:size(Path1,1)  
         cd(Path1(i,:));
         sess = Path1(i,43:58);
      
           
        InfoPath = [sess '_DataStructure_mazeSection1_TrialType1_Info.mat'];
         if(exist(InfoPath) ~= 0)
            load(InfoPath);

            DelayPropTemp = (beh.FirstLick/500)/ ((beh.delayLen(1)/1000000)+1);
            DelayPropTemp(isnan(DelayPropTemp)) = [];
            DelayPropTemp(isinf(DelayPropTemp)) = [];
            PredlickInd = DelayPropTemp < 1;
            DelayPropTemp = DelayPropTemp(PredlickInd);
            DelayProp1(i,:) = mean(DelayPropTemp);
 
         else
            lickfile = [sess '_lickavgSC.mat']
            load(lickfile)
           DelayPropTemp =  (cell2mat(firstLick)/1000)/ 5;
           DelayPropTemp(isnan(DelayPropTemp)) = [];
            DelayPropTemp(isinf(DelayPropTemp)) = [];
            PredlickInd = DelayPropTemp < 1;
            DelayPropTemp = DelayPropTemp(PredlickInd);
            DelayProp1(i,:) = mean(DelayPropTemp);
            condstr = 'Cue'
         end
    
 

    end

     for i = 1:size(Path2,1)  
         cd(Path2(i,:));
         sess = Path2(i,43:58);
      
      InfoPath = [sess '_DataStructure_mazeSection1_TrialType1_Info.mat'];
         if(exist(InfoPath) ~= 0)
            load(InfoPath);

            DelayPropTemp = (beh.medTimeFirst5Licks/500)/ ((beh.delayLen(1)/1000000)+1);
            DelayPropTemp(isnan(DelayPropTemp)) = [];
            DelayPropTemp(isinf(DelayPropTemp)) = [];
            PredlickInd = DelayPropTemp < 1;
            DelayPropTemp = DelayPropTemp(PredlickInd);
            DelayProp2(i,:) = mean(DelayPropTemp);
 
         else
            lickfile = [sess '_lickavgSC.mat']
            load(lickfile)
           DelayPropTemp =  (median5lickAll/1000)/ 5;
           DelayPropTemp(isnan(DelayPropTemp)) = [];
            DelayPropTemp(isinf(DelayPropTemp)) = [];
            PredlickInd = DelayPropTemp < 1;
            DelayPropTemp = DelayPropTemp(PredlickInd);
            DelayProp2(i,:) = mean(DelayPropTemp);
         end
    

    end


 
 X1 = ones(size(DelayProp1,1),1)';
 X2 = ones(size(DelayProp2,1),1)'*2;
  

Y = [{DelayProp1} {DelayProp2}];
X = [{X1} {X2}];

 std_data = std(DelayProp1, 0,1,'omitnan')
 std_data_1 = std_data/ sqrt(size(Path1,1));
 CueData = [mean(DelayProp1), std_data_1];

  std_data = std(DelayProp2, 0,1,'omitnan')
 std_data_2 = std_data/ sqrt(size(Path2,1));
 NoCueData = [mean(DelayProp2), std_data_2];

% [p,h] = ranksum(DelayProp1, DelayProp2)
[p,h] = signrank(DelayProp1, DelayProp2)

% [h,p] = ttest2(DelayProp1, DelayProp2)
p3 = round(p,3)
 

f = figure;
f.Position = [350 350 380 400];
hold on 

        C = parula(10);


for Stages = 1:2
b = boxchart(X{Stages}, Y{Stages})

if Stages == 1
% b.BoxFaceColor = C(1,:); 
b.BoxFaceColor = ['k'];
b.BoxFaceAlpha = [0.6]
elseif  Stages == 2
% b.BoxFaceColor = C(4,:); 
 b.BoxFaceColor =  [0.66 0.66 0.66];

end


 T = ['Predictive Licking Index']

title(T)
xticks(1:1:3)
xticklabels({'Cue', 'No Cue'})
%ylabel('Proportion')
set(gca, 'FontSize', 16)
 

        P_TEMP = p3;
        xl = 1.4;
        yl = 0.73;
 
    if P_TEMP  < 0.001
       ptext = ['***'];
    elseif P_TEMP < 0.01
       ptext = ['**'];
    elseif P_TEMP < 0.05
       ptext = ['*'];
    elseif P_TEMP > 0.05
       ptext = ['ns'];
    end   
    text(xl, yl, ptext, 'FontSize',18) 
    xpts = [xl-0.2 xl+0.4]
    ypts = [yl yl];
    xlim([0 3])
    f = line(xpts, ypts-0.04, 'LineWidth', 1, 'Color', 'k');
 set(gca, 'FontSize', 19)

xlim([0.5 2.5])
     ylim([0.0 0.9])   
     ylabel('Index')
     cd(savepath)
     SaveName = [T 'ranksum' condstr]
     print('-painters','-dpng',[SaveName],'-r600');
     print('-painters','-dpdf',[SaveName],'-r600');
     savefig([SaveName '.fig'])
       
   
end

end