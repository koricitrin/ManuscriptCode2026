function PropDelayLickStatsUnRew2(Path,cond)
%% RiseDownMeanPropStatsLearning('Z:\Kori\immobile_code\RiseDown\tables\2025-1p5to1p5\Variable\', 2, 1)
 
     RewOmissionRecList


       Recs1 = Path;   

    for i = 1:size(Recs1,1)  
     cd(Recs1(i,:));
     sess = Recs1(i,43:58);
     AnmID(i,:) = sess(1:4);
   
    InfoPath = [sess '_DataStructure_mazeSection1_TrialType1_Info.mat'];
    load(InfoPath)
    load('RewardOmissionTrInd.mat')

    if cond == 1 
        CondStr = 'Cue';
        DelayPropTemp = (beh.FirstLick/500)/ ((beh.delayLen(1)/1000000)+1);
        NxtTrInd = RewOmissionTr(1:end-1)+1
        DelayPropTempUN = DelayPropTemp(NxtTrInd)
        DelayPropTempUN(isnan(DelayPropTempUN)) = [];
        DelayPropTempUN(isinf(DelayPropTempUN)) = [];
        PredlickInd = DelayPropTempUN < 1;
        DelayPropTempUN = DelayPropTempUN(PredlickInd);
        DelayPropUN_nxt(i,:) = mean(DelayPropTempUN);
    
        PrevTrInd = RewOmissionTr - 1;
        DelayPropTempUN_prev = DelayPropTemp(PrevTrInd)
        DelayPropTempUN_prev(isnan(DelayPropTempUN_prev)) = [];
        DelayPropTempUN_prev(isinf(DelayPropTempUN_prev)) = [];
        PredlickInd = DelayPropTempUN_prev < 1;
        DelayPropTempUN_prev = DelayPropTempUN_prev(PredlickInd);
        DelayPropUN_prev(i,:) = mean(DelayPropTempUN_prev);
    
        DelayPropTemp = (beh.medTimeFirst5Licks/500)/ ((beh.delayLen(1)/1000000)+1);
        TrInd = RewOmissionTr
        
        DelayPropTempUN = DelayPropTemp(TrInd)
        DelayPropTempUN(isnan(DelayPropTempUN)) = [];
        DelayPropTempUN(isinf(DelayPropTempUN)) = [];
        PredlickInd = DelayPropTempUN < 1;
        DelayPropTempUN = DelayPropTempUN(PredlickInd);
        DelayPropUNcurr(i,:) = mean(DelayPropTempUN);

    elseif cond == 2
               CondStr = 'LastLick'
                FirstLick_LL_Curr = [];
                FirstLick_LL_Prev = [];
                FirstLick_LL_Nxt = []
                Pump_Curr = [];
                Pump_Prev = [];
                Pump_Next = [];
                load('FirstLick_LL.mat')
                FirstLick_LL = FirstLick;
                PrevTrInd = RewOmissionTr - 1;
                NxtTrInd = RewOmissionTr(1:end-1)+1
                FirstLick_LL_Curr = FirstLick_LL(RewOmissionTr);
                FirstLick_LL_Prev = FirstLick_LL(PrevTrInd);
                FirstLick_LL_Nxt = FirstLick_LL(NxtTrInd);
                Pump_Prev = Pump(PrevTrInd);
                Pump_Next = Pump(NxtTrInd);
                PumpMean = mean(Pump(Pump~=0))

              for tr = 1:length(FirstLick_LL_Curr)

                DelayPropTemp = (FirstLick_LL_Curr(tr))/PumpMean; %7s
                DelayPropTemp(isnan(DelayPropTemp)) = [];
                DelayPropTemp(isinf(DelayPropTemp)) = [];
                PredlickInd = DelayPropTemp < 1;
                DelayPropTemp = DelayPropTemp(PredlickInd);
                if ~isempty(DelayPropTemp)
                DelayPropTr(tr,:)  =DelayPropTemp;
                end
              end
                 DelayPropTrNz = DelayPropTr(DelayPropTr ~= 0);  
                DelayPropUNcurr(i,:) = mean(DelayPropTrNz);   

                clear DelayPropTr DelayPropTrNz

               for tr = 1:length(FirstLick_LL_Prev)
                DelayPropTemp = (FirstLick_LL_Prev(tr))/ Pump_Prev(tr) %7s
                DelayPropTemp(isnan(DelayPropTemp)) = [];
                DelayPropTemp(isinf(DelayPropTemp)) = [];
                PredlickInd = DelayPropTemp < 1;
                DelayPropTemp = DelayPropTemp(PredlickInd);
                if ~isempty(DelayPropTemp)
                DelayPropTr(tr,:)  =DelayPropTemp;
                end
               end
                 DelayPropTrNz = DelayPropTr(DelayPropTr ~= 0);  
                DelayPropUN_prev(i,:) = mean(DelayPropTrNz);   
      
                clear DelayPropTr DelayPropTrNz

                  for tr = 1:length(FirstLick_LL_Nxt)
                DelayPropTemp = (FirstLick_LL_Nxt(tr))/ Pump_Next(tr) %7s
                DelayPropTemp(isnan(DelayPropTemp)) = [];
                DelayPropTemp(isinf(DelayPropTemp)) = [];
                PredlickInd = DelayPropTemp < 1;
                DelayPropTemp = DelayPropTemp(PredlickInd);
                if ~isempty(DelayPropTemp)
                DelayPropTr(tr,:)  =DelayPropTemp;
                end
               end
                 DelayPropTrNz = DelayPropTr(DelayPropTr ~= 0);  
                DelayPropUN_nxt(i,:) = mean(DelayPropTrNz);   
      
                clear DelayPropTr DelayPropTrNz
            end


    end

 
       % cd(TablePath)
        figure
        hold on 
        C = hot(10);

 std_data = std(DelayPropUNcurr, 0,1,'omitnan')
 std_data_1 = std_data/ sqrt(size(Path,1));
 CurrTrData = [mean(DelayPropUNcurr), std_data_1];

  std_data = std(DelayPropUN_nxt, 0,1,'omitnan')
 std_data_2 = std_data/ sqrt(size(Path,1));
 NextTrData = [mean(DelayPropUN_nxt), std_data_2];
 

X1 = ones(size(DelayPropUNcurr,1),1)'*1;
X2 = ones(size(DelayPropUN_nxt,1),1)'*2;
X3 = ones(size(DelayPropUN_prev,1),1)'*3;

 
Y = [ {DelayPropUN_prev} {DelayPropUNcurr}  {DelayPropUN_nxt}];
X = [{X1} {X2} {X3}];
[p_EL,h] = ranksum(DelayPropUNcurr, DelayPropUN_nxt)
[p_EL,h] = signrank(DelayPropUNcurr, DelayPropUN_nxt)
% 
% [p_t,h] = ttest(DelayPropUNcurr, DelayPropUN_nxt)
 
% [p_EM,h] = ranksum(DelayPropUNcurr, DelayPropUN_prev)
% p_EM3 = round(p_EM,3)
% 
 
 

f = figure;
f.Position = [350 350 380 400];
hold on 

for Stages = 2:3
b = boxchart(X{Stages}, Y{Stages})

if Stages == 2
b.BoxFaceColor = [0.6350 0.0780 0.1840]; 
b.BoxFaceAlpha = [0.65]
elseif  Stages == 1
b.BoxFaceColor = 'k'; 
b.BoxFaceAlpha = [0.6]
elseif  Stages == 3
b.BoxFaceColor = [0.6350 0.0780 0.1840]; 

end

cd('Z:\Kori\PaperDrafting2025\Plots\rewardOmission\wCue')

T = ['Predictive Licking Index']
title(T)
xticks(1:1:3)
% xticklabels({'Early', 'Middle', 'Late'})
xticklabels({'', 'N', 'N+1'})
% xticklabels({'Tr bef. Rew Omit','Rew Omit Tr.', 'Tr. after Rew Omit'})
ylabel('Index')
set(gca, 'FontSize', 19)
 ylim([0 0.9])


        P_TEMP = p_EL;
        xl = 2.5;
        yl = 0.8;    

    if P_TEMP  < 0.001
       ptext = ['***'];
    elseif P_TEMP < 0.01
       ptext = ['**'];
    elseif P_TEMP < 0.05
       ptext = ['*'];
    elseif P_TEMP > 0.05
       ptext = ['ns'];
    end   
    text(xl, yl-0.02, ptext, 'FontSize',20) 
    xpts = [xl-0.2 xl+0.5]
    ypts = [yl yl];
    f = line(xpts, ypts-0.05, 'LineWidth', 1, 'Color', 'k');
    % 
    %     P_TEMP = p_EM;
    %     xl = 1.3;
    %     yl = 0.8;    
    % 
    % if P_TEMP  < 0.001
    %    ptext = ['***'];
    % elseif P_TEMP < 0.01
    %    ptext = ['**'];
    % elseif P_TEMP < 0.05
    %    ptext = ['*'];
    % elseif P_TEMP > 0.05
    %    ptext = ['ns'];
    % end   
    % text(xl, yl, ptext, 'FontSize',20) 
    % xpts = [xl-0.2 xl+0.5]
    % ypts = [yl yl];
    % f = line(xpts, ypts-0.05, 'LineWidth', 1, 'Color', 'k');
end



SaveName = [T 'unrew3_ranksum' CondStr]
  print('-painters','-dpng',[SaveName],'-r600');
  print('-painters','-dpdf',[SaveName],'-r600');
    savefig([SaveName '.fig'])
       
   
end