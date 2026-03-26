function PredLickIndBlockDelay(Paths, Cond)

    for k = 1:size(Paths,1)
    
          cd(Paths(k,:))

                 load([Paths(k,43:58) '_DataStructure_mazeSection1_TrialType1_Info.mat'])
              
                delay3sInd =  (beh.delayLen/1000000) == 3;
                delay5sInd =  (beh.delayLen/1000000) == 5;

          if Cond == 1 
                CondStr = 'Cue'

                DelayPropTemp = (beh.medTimeFirst5Licks(delay3sInd)/500)/ 4;
                DelayPropTemp(isnan(DelayPropTemp)) = [];
                DelayPropTemp(isinf(DelayPropTemp)) = [];
                PredlickInd = DelayPropTemp < 1;
                DelayPropTemp = DelayPropTemp(PredlickInd);
                DelayProp3s(k,:) = mean(DelayPropTemp);

                DelayPropTemp = [];
                DelayPropTemp = (beh.medTimeFirst5Licks(delay5sInd)/500)/ 6;
                DelayPropTemp(isnan(DelayPropTemp)) = [];
                DelayPropTemp(isinf(DelayPropTemp)) = [];
                PredlickInd = DelayPropTemp < 1;
                DelayPropTemp = DelayPropTemp(PredlickInd);
                DelayProp5s(k,:) = mean(DelayPropTemp);

             elseif Cond == 2
                CondStr = 'LastLick'
                FirstLick_LL_3s = [];
                FirstLick_LL_5s = [];
                Pump_3s = [];
                Pump_5s = [];
                load('FirstLick_LL.mat')
                FirstLick_LL = FirstLick;

                %% see if tr index is the same so you can get the 3 and 5s trials do that before 
                % removing unrewarded tr 
                % RewInd = [];
                % %remove unreward tr 
                %  RewInd = (Pump > 0);
                % FirstLick_LL =  FirstLick_LL(RewInd);
                % Pump = Pump(RewInd)
          
                Trials = 1:length(delay3sInd);
                Trials3s = Trials(delay3sInd);
                Trials5s = Trials(delay5sInd);

                FirstLick_LL_3s = FirstLick_LL(Trials3s);
                FirstLick_LL_5s = FirstLick_LL(Trials5s);
                Pump_3s = Pump(Trials3s);
                Pump_5s = Pump(Trials5s);
              for tr = 1:length(FirstLick_LL_3s)

                DelayPropTemp = (FirstLick_LL_3s(tr))/ Pump_3s(tr); %7s
                DelayPropTemp(isnan(DelayPropTemp)) = [];
                DelayPropTemp(isinf(DelayPropTemp)) = [];
                PredlickInd = DelayPropTemp < 1;
                DelayPropTemp = DelayPropTemp(PredlickInd);
                if ~isempty(DelayPropTemp)
                DelayPropTr(tr,:)  =DelayPropTemp;
                end
              end
                 DelayPropTrNz = DelayPropTr(DelayPropTr ~= 0);  
                DelayProp3s(k,:) = mean(DelayPropTrNz);   

                clear DelayPropTr
               for tr = 1:length(FirstLick_LL_5s)
                Pump_5s(tr)
                DelayPropTemp = (FirstLick_LL_5s(tr))/ Pump_5s(tr) %7s
                DelayPropTemp(isnan(DelayPropTemp)) = [];
                DelayPropTemp(isinf(DelayPropTemp)) = [];
                PredlickInd = DelayPropTemp < 1;
                DelayPropTemp = DelayPropTemp(PredlickInd);
                if ~isempty(DelayPropTemp)
                DelayPropTr(tr,:)  =DelayPropTemp;
                end
               end
                 DelayPropTrNz = DelayPropTr(DelayPropTr ~= 0);  
                DelayProp5s(k,:) = mean(DelayPropTrNz);   
        
            end

     end
 
 std_data = std(DelayProp3s, 0,1,'omitnan');
 std_data_1 = std_data/ sqrt(size(Paths,1));
 Data3s = [mean(DelayProp3s), std_data_1]

 std_data = std(DelayProp5s, 0,1,'omitnan');
 std_data_2 = std_data/ sqrt(size(Paths,1));
 Data5s = [mean(DelayProp5s), std_data_2]
 

    [p,h] = ranksum(DelayProp3s, DelayProp5s)

    [p,h] = ttest(DelayProp3s, DelayProp5s)

     X1 = ones(size(DelayProp3s,1),1)';
     X2 = ones(size(DelayProp5s,1),1)'*2;
      
    
    Y = [{DelayProp3s} {DelayProp5s}];
    X = [{X1} {X2}];
    
 
    
    f = figure;
    f.Position = [350 350 380 400];
    hold on 
    T = ['Predicitive Licking Index ']
    C = parula(10);
    
    
    for Stages = 1:2
    b = boxchart(X{Stages}, Y{Stages})
    
    if Stages == 1
    % b.BoxFaceColor = C(1,:); 
    b.BoxFaceColor = ['k'];
    b.BoxFaceAlpha = [0.6]
    elseif  Stages == 2
    % b.BoxFaceColor = C(4,:); 
     b.BoxFaceColor =  [0 0.4470 0.7410];
    
    end
    
    
    
    title(T)
    xticks(1:1:3)
    xticklabels({'3s Delay', '5s Delay'})
    %ylabel('Proportion')
    set(gca, 'FontSize', 16)
     
    
            P_TEMP = p;
            xl = 1.4;
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
        text(xl, yl, ptext, 'FontSize',18) 
        xpts = [xl-0.2 xl+0.4]
        ypts = [yl yl];
        xlim([0 3])
        f = line(xpts, ypts-0.04, 'LineWidth', 1, 'Color', 'k');
     set(gca, 'FontSize', 19)
    
    
     ylim([0 1])   
     ylabel('Index')
     cd('Z:\Kori\immobile_code\BlockDelay\Plots\')
     SaveName = [T 'ranksum' CondStr]
     print('-painters','-dpng',[SaveName],'-r600');
     % print('-painters','-dpdf',[SaveName],'-r600');
     savefig([SaveName '.fig'])
           
       
    end
    

end