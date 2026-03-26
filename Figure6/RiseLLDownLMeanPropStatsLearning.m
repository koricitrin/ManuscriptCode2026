function RiseLLDownLMeanPropStatsLearning(TablePath, cond)
%% RiseLLDownLMeanPropStatsLearning('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\', 1)
  VariableBOAnmPath  
%  ConstBoList
 
    cd(TablePath) 
 dtemp = [1:3 8:10]
   for d = dtemp
    if d == 1
       Recs1 = D1;
    elseif d ==2 
        Recs1 = D2;
    elseif d == 3  
       Recs1 = D3; 
    elseif d == 4;
       Recs1 = D4;
    elseif d == 5
       Recs1 = D5; 
    elseif d == 6
       Recs1 = D6;   
    elseif d == 7
       Recs1 = D7;   
    elseif d == 8
       Recs1 = D8;   
    elseif d == 9
       Recs1 = D9; 
    elseif d == 10
       Recs1 = D10
    end  

    if cond == 1
         condStr = 'LastLick';
         tablepath2 = [TablePath 'D' num2str(d) '\' 'RiseLastLickDownLickNeurons_thres.mat'];
          load(tablepath2) 
          RiseDownTable_2 = RiseLLDownLickNeuronID;
           T = ['Proportion PAC thres'];
           % SaveVarName = ['PropRiseLLDownLickPropDaysValid.mat'];
    elseif cond == 11
                condStr = 'LastLick';
         tablepath2 = [TablePath 'D' num2str(d) '\valid\' 'RiseLastLickDownLickNeurons_thres2.mat'];
          load(tablepath2) 
          RiseDownTable_2 = RiseLLDownLickNeuronID;
           T = ['Proportion PAC thres valid'];
           % SaveVarName = ['PropRiseLLDownLickPropDaysValid.mat'];

         elseif cond == 2
         condStr = 'Lick';
          tablepath2 = [TablePath 'D' num2str(d) '\' 'RiseLickDownLLNeurons_thres.mat'];
         load(tablepath2) 
         RiseDownTable_2 = RiseLickDownLLNeuronID;
          T = ['Prop Rise Lick Down LL Neurons thres'];
        % SaveVarName = ['PropRiseLickDownLLPropDays.mat'];
          elseif cond == 22
         condStr = 'Lick';
          tablepath2 = [TablePath 'D' num2str(d) '\valid\' 'RiseLickDownLLNeurons_thres2.mat'];
         load(tablepath2) 
         RiseDownTable_2 = RiseLickDownLLNeuronID;
          T = ['Prop Rise Lick Down LL Neurons thres valid'];

         elseif cond == 3
         condStr = 'Cue';
          tablepath2 = [TablePath 'D' num2str(d) '\' 'RiseCueDownLickNeurons.mat'];
         load(tablepath2) 
         RiseDownTable_2 = RiseCueDownLickNeuronID;
          T = ['Prop Rise Cue Down Lick Neurons'];

            elseif cond == 4
         condStr = 'Cue';
          tablepath2 = [TablePath 'D' num2str(d) '\' 'RiseCueDownRewNeurons.mat'];
         load(tablepath2) 
         RiseDownTable_2 = RiseCueDownRewNeuronID;
          T = ['Prop Rise Cue Down Rew Neurons'];
         end  
 
         tablepath1 = [TablePath 'D' num2str(d) '\' 'All_Recs_RiseDownID_AlignLastLick.mat'];
         load(tablepath1) 


    for i = 1:size(Recs1,1)
      sess = Recs1(i,43:58);
      sessInd = strcmp(sess,RiseDownTable_2.rec_name(:,1));
      AnmID(i,:) = sess(1:4);
      RiseLog = RiseDownTable_2.neu_id(sessInd,:);
      totalNeuInd = strcmp(sess,RiseDownTable.rec_name(:,1));

      RiseSessProp(i,:) = size(RiseLog,1)/sum(totalNeuInd);
    end
    RiseSessPropDays{d,:} = RiseSessProp;
    RisePropDaysMean(d,:) = mean(RiseSessProp);
    
    
   end
  

EarlyProp = [];
 for Early = 1:3
    Temp =  cell2mat(RiseSessPropDays(Early))
     EarlyProp = [EarlyProp, Temp']
     X(Early,:) = 1;
     clear Temp
 end
  % X1 = ones(size(EarlyProp,2),1)';
    
    a = 0.93;
    b = 1.07;
    X1 = (b-a).*rand(size(EarlyProp,2),1) + a;

MiddleProp = [];
 for Middle = 4:6
      Temp =  cell2mat(RiseSessPropDays(Middle))
     MiddleProp = [MiddleProp, Temp']
      X(Middle,:) = 2;
     clear Temp
 end
 a = 1.93;
    b = 2.07;
    X2= (b-a).*rand(size(MiddleProp,2),1) + a;

LateProp = [];
 for Late = 8:10
     Temp =  cell2mat(RiseSessPropDays(Late))
     LateProp = [LateProp, Temp']
       X(Late,:) = 3;
     clear Temp
 end
% X3 = ones(size(LateProp,2),1)'*3;
 % X3 = ones(size(LateProp,2),1)'*2;
    
    a = 1.93;
    b = 2.07;
    X3 = (b-a).*rand(size(LateProp,2),1) + a;

 std_data = std(EarlyProp', 0,1,'omitnan');
sem_data = std_data/ sqrt(size(EarlyProp,2));
EarlyStats_SEM = [mean(EarlyProp), sem_data]*100


 std_data = std(LateProp', 0,1,'omitnan');
sem_data = std_data/  sqrt(size(LateProp,2));
LateStats_SEM = [mean(LateProp), sem_data]*100


Y = [{EarlyProp} {MiddleProp} {LateProp}];
X = [{X1} {X2} {X3}];
% Y = [{EarlyProp} {LateProp}];
% X = [{X1} {X3}];

% [p_EM,h] = ranksum(EarlyProp, MiddleProp)
% p_EM3 = round(p_EM,3)
 % [p_EL,h] = ttest(EarlyProp, LateProp)

[p_EL,h] = ranksum(EarlyProp, LateProp)
p_EL3 = round(p_EL,3)
% [p_ML,h] = ranksum(MiddleProp, LateProp)
% p_ML3 = round(p_ML,3)

% [h,p_EM] = ttest2(EarlyProp, MiddleProp)
% p_EM3 = round(p_EM,3)
% [h,p_EL] = ttest2(EarlyProp, LateProp)
% p_EL3 = round(p_EL,3)
% [h, p_ML] = ttest2(MiddleProp, LateProp)
% p_ML3 = round(p_ML,3)

 C = parula(d);
  %    %%
%     f = figure;
%     % f.Position = [350 350 380 400];
%     hold on 
%     for Stages = 1:3
%         if Stages == 1
%         scatter(X{Stages}, Y{Stages}, 120, MarkerFaceColor = C(1,:), MarkerEdgeColor='k'); 
%          c =  bar(1, mean(Y{Stages}))
%         set(c,'FaceColor', C(1,:) ,'FaceAlpha', 0.3); 
%         SEM =   std(Y{Stages},[],2)/sqrt(size(Y{Stages},2));  
%         errorbar(1,  mean(Y{Stages}),SEM, 'Color', 'k', 'LineWidth', 2)
%         elseif  Stages == 2
%         scatter(X{Stages}, Y{Stages}, 120, MarkerFaceColor = C(3,:), MarkerEdgeColor='k'); 
%          c =  bar(2, mean(Y{Stages}))
%         set(c,'FaceColor', C(3,:) ,'FaceAlpha', 0.3); 
%         SEM =   std(Y{Stages},[],2)/sqrt(size(Y{Stages},2));  
%         errorbar(2,  mean(Y{Stages}),SEM, 'Color', 'k', 'LineWidth', 2)
%         elseif  Stages == 3
%         scatter(X{Stages}, Y{Stages}, 120, MarkerFaceColor = C(5,:), MarkerEdgeColor='k'); 
%          c =  bar(3, mean(Y{Stages}))
%         set(c,'FaceColor', C(5,:) ,'FaceAlpha', 0.3); 
%         SEM =   std(Y{Stages},[],2)/sqrt(size(Y{Stages},2));  
%         errorbar(3,  mean(Y{Stages}),SEM, 'Color', 'k', 'LineWidth', 2)
%         end
% 
%         title(T)
%         xticks(1:1:3)
%         xticklabels({'Early', 'Middle', 'Late'})
%         ylabel('Proportion')
%         set(gca, 'FontSize', 22)
% 
%         P_TEMP = p_EL;
%         xl = 2;
%         yl = 0.22;    
%     end
% 
%     if P_TEMP  < 0.001
%        ptext = ['***'];
%     elseif P_TEMP < 0.01
%        ptext = ['**'];
%     elseif P_TEMP < 0.05
%        ptext = ['*'];
%     elseif P_TEMP > 0.05
%        ptext = ['ns'];
%     end   
%     % text(xl, yl, ptext, 'FontSize',25) 
%     % xpts = [xl-0.25 xl+0.45]
%     % ypts = [yl yl];
%     % f = line(xpts, ypts-0.02, 'LineWidth', 1, 'Color', 'k');
%  set(gcf, 'Position', [100 100  775 600]);
%     ylim([0 0.27])
%     xlim([0 4])
%     SaveName = [T '_ranksum' 'scatter_E13M46L810']
%     print('-painters','-dpng',[SaveName],'-r600');
%     savefig([SaveName '.fig'])
%     save(SaveVarName, 'RiseSessPropDays')
% 
% % 
 %    %%
    f = figure;
    % f.Position = [350 350 380 400];
    hold on 
    for Stages = 1:3
        if Stages == 1
        scatter(X{Stages}, Y{Stages}, 120, MarkerFaceColor = C(1,:), MarkerEdgeColor='k'); 
         c =  bar(1, mean(Y{Stages}))
        set(c,'FaceColor', C(1,:) ,'FaceAlpha', 0.3); 
        SEM =   std(Y{Stages},[],2)/sqrt(size(Y{Stages},2));  
        errorbar(1,  mean(Y{Stages}),SEM, 'Color', 'k', 'LineWidth', 2)
        elseif  Stages == 2
            continue
           
        elseif  Stages == 3
        scatter(X{3}, Y{Stages}, 120, MarkerFaceColor = C(4,:), MarkerEdgeColor='k'); 
         c =  bar(2, mean(Y{Stages}))
        set(c,'FaceColor', C(4,:) ,'FaceAlpha', 0.3); 
        SEM =   std(Y{Stages},[],2)/sqrt(size(Y{Stages},2));  
        errorbar(2,  mean(Y{Stages}),SEM, 'Color', 'k', 'LineWidth', 2)
        end

        title(T)
        xticks(1:1:3)
        xticklabels({'Early Training', 'Late Training'})
        ylabel('Proportion')
        set(gca, 'FontSize', 24)

        P_TEMP = p_EL;
        xl = 1.43;
        yl = 0.26;    
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
    f = line(xpts, ypts-0.02, 'LineWidth', 1.2, 'Color', 'k');
 set(gcf, 'Position', [100 100  775 600]);
     ylim([0 0.35])
    xlim([0 3])
    axis square
    savepath = 'Z:\Kori\PaperDrafting2025\Plots\fig4\'
    cd(savepath)
    SaveName = [T '_ranksum' 'scatter_13_810' 'thres2']
    print('-painters','-dpng',[SaveName],'-r600');
       print('-painters','-dpdf',[SaveName],'-r600');
    savefig([SaveName '.fig'])
    % save(SaveVarName, 'RiseSessPropDays')
 % 
end