function PropDelayLickStatsLearning(TablePath, savepath, Cond)
%% PropDelayLickStatsLearning('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\', 'Z:\Kori\PaperDrafting2025\Plots\fig4\', 2)
   VariableBOAnmPath  
  %ConstBoList

         cd(TablePath)
         
            % figure
            % hold on 
             C = hsv(size(AnmNames,1));
            days = [1:3 8:10]
            for day = 1:length(days)
                  d = days(day)
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
            RatiosRiseNeurons = [];
            for i = 1:size(Recs1,1)  
             cd(Recs1(i,:));
             sess = Recs1(i,43:58);
              AnmID(i,:) = sess(1:4);
          
             if Cond == 1 
            CondStr = 'Cue'
            InfoPath = [sess '_DataStructure_mazeSection1_TrialType1_Info.mat'];
            load(InfoPath)
            DelayPropTemp = (beh.medTimeFirst5Licks/500)/ ((beh.delayLen(1)/1000000)+1);
            DelayPropTemp(isnan(DelayPropTemp)) = [];
            DelayPropTemp(isinf(DelayPropTemp)) = [];
            PredlickInd = DelayPropTemp < 1;
            DelayPropTemp = DelayPropTemp(PredlickInd);
            DelayProp(i,:) = mean(DelayPropTemp);
             elseif Cond == 2
                    CondStr = 'LastLick'
               InfoPath = [sess '_DataStructure_mazeSection1_TrialType1_Info.mat'];
                load(InfoPath);
                load('FirstLick_LL.mat')
                FirstLick_LL = FirstLick;

                RewInd = [];
                %remove unreward tr 
                 RewInd = (Pump > 0);
                FirstLick_LL =  FirstLick_LL(RewInd);
                Pump = Pump(RewInd)
         
              for tr = 1:length(FirstLick_LL)
                DelayPropTemp = (FirstLick_LL(tr))/ Pump(tr); %7s
                DelayPropTemp(isnan(DelayPropTemp)) = [];
                DelayPropTemp(isinf(DelayPropTemp)) = [];
                PredlickInd = DelayPropTemp < 1;
                DelayPropTemp = DelayPropTemp(PredlickInd);
                if ~isempty(DelayPropTemp)
                DelayPropTr(tr,:)  =DelayPropTemp;
                end
              end
                DelayProp(i,:) = mean(DelayPropTr);   
        
            end
            DelayTrPropDays{d,:} = DelayProp;
            DelayTrPropDaysMean(d,:) = mean(DelayProp);
   
         
               DataInd =  DelayProp;
               DataDays =  DelayTrPropDays;
               DataDaysMean = DelayTrPropDaysMean;
        

            a = 0.98;
            b = 1.02;
            randnum = (b-a).*rand(size(Recs1,1),1) + a;

            % for w =  1:size(Recs1,1)
            %     for n = 1:size(AnmNames,1)
            %      if   AnmID(w,:) == AnmNames(n,:);
            %          Color = C(n,:);
            %      end  
            %     end 
            %  scatter(randnum(w)*d, DataInd(w), 80, MarkerFaceColor = Color , MarkerEdgeColor='k')
            % end
            %  scatter(d, mean(DataInd), 80,  MarkerEdgeColor='k')

            clear GoodTrSessProp AnmID BadTrSessProp DelayPropTemp
            end
           
            % plot(DataDaysMean, 'k', LineWidth = 3)
            % ylabel('Ratio')
            % xlabel('Day')
            % xticks([1:1:10])
            % xlim([0 11])
            % ylim([min(cell2mat(DataDays))- 0.05 max(cell2mat(DataDays))+ 0.05]) 
            % set(gca, 'FontSize', 17)
            % Days = [1:d]
            % [Rho, Pval] = corr(Days', DataDaysMean, 'Type', 'Spearman')
            % 
            %     txt2 = num2str(round(Rho,3));
            %     rhotext = ['ρ = ' txt2];
            %     text(4, min(cell2mat(DataDays)), rhotext, 'FontSize',16) 
            %     if Pval < 0.001
            %           ptext = ['***'];
            %            text(5.5, min(cell2mat(DataDays))-0.03, ptext, 'FontSize',16) 
            %     elseif  Pval < 0.01     
            %         ptext = ['**'];
            %            text(5.5, min(cell2mat(DataDays))-0.03, ptext, 'FontSize',16) 
            %     elseif  Pval < 0.05     
            %         ptext = ['*'];
            %            text(5.5, min(cell2mat(DataDays))-0.03, ptext, 'FontSize',16) 
            %     elseif  Pval > 0.05     
            %         ptext = ['NS'];
            %            text(5.5, min(cell2mat(DataDays))-0.03, ptext, 'FontSize',16)        
            %     end
            T = ['Predictive Licking Index']
            %  title(T)
            %  cd(savepath)
            %     print('-painters','-dpng',[T],'-r600');
            %     savefig([T '.fig'])

            end
        
                   cd(TablePath)
                figure
                hold on 
        
        EarlyRatio = [];
         for Early = 1:3
            Temp =  cell2mat(DataDays(Early))
             EarlyRatio = [EarlyRatio, Temp'];
             X(Early,:) = 1;
             clear Temp
         end
         X1 = ones(size(EarlyRatio,2),1)';
        
        
        MiddleRatio = [];
         for Middle = 4:7
              Temp =  cell2mat(DataDays(Middle))
             MiddleRatio = [MiddleRatio, Temp'];
              X(Middle,:) = 2;
             clear Temp
         end
         X2 = ones(size(MiddleRatio,2),1)'*2;
        
        
        LateRatio = [];
         for Late = 8:10
             Temp =  cell2mat(DataDays(Late))
             LateRatio = [LateRatio, Temp'];
             X(Late,:) = 3;
             clear Temp
         end 
        X3 = ones(size(LateRatio,2),1)'*2;
        
        % Y = [{EarlyRatio} {MiddleRatio} {LateRatio}];
        % X = [{X1} {X2} {X3}];
        Y = [{EarlyRatio}  {LateRatio}];
        X = [{X1} {X3}];
        
  std_data = std(EarlyRatio', 0,1,'omitnan');
std_data = std_data/ sqrt(size(EarlyRatio,2));
EarlyStats = [mean(EarlyRatio), std_data]

 std_data = std(LateRatio', 0,1,'omitnan');
std_data = std_data/  sqrt(size(LateRatio,2));
LateStats = [mean(LateRatio), std_data]

        % [p_EM,h] = ranksum(EarlyRatio, MiddleRatio)
        % p_EM3 = round(p_EM,3)
        [p_EL,h] = ranksum(EarlyRatio, LateRatio)
        p_EL3 = round(p_EL,3)
        % [p_ML,h] = ranksum(MiddleRatio, LateRatio)
        % p_ML3 = round(p_ML,3)
        % % 
        % [h,p_EM] = ttest2(EarlyRatio, MiddleRatio)
        % p_EM3 = round(p_EM,3)
        % [h,p_EL] = ttest2(EarlyRatio, LateRatio)
        % p_EL3 = round(p_EL,3)
        % [h, p_ML] = ttest2(MiddleRatio, LateRatio)
        % p_ML3 = round(p_ML,3)
        
        
        f = figure;
        f.Position = [350 350 380 400];
        hold on 
        
         C = parula(d);

        % C = turbo(d);

        for Stages = 1:2
        b = boxchart(X{Stages}, Y{Stages})
        
        if Stages == 1
        b.BoxFaceColor = C(1,:); 
        % elseif  Stages == 2
        % b.BoxFaceColor = C(3,:); 
        elseif  Stages == 2
        b.BoxFaceColor = C(4,:); 
        end
        
        
        
        
        title(T)
        xticks(1:1:3)
        % xticklabels({'Early', 'Middle', 'Late'})
        xticklabels({'Early', 'Late'})
        ylabel('Index')
        set(gca, 'FontSize', 16)
         ylim([0.0 0.9])
        
        % for Groups = 1:3 
        %     if Groups == 1
        %         P_TEMP = p_EM;
        %         xl = 1.15;
        %         yl = 0.58;
        %     elseif Groups == 2
        %         P_TEMP = p_ML;
        %         xl = 2.45;
        %         yl = 0.58;
        %     elseif Groups == 3
        %         P_TEMP = p_EL;
        %         xl = 1.88;
        %         yl = 0.63;    
        %     end
        %     if P_TEMP  < 0.001
        %        ptext = ['***'];
        %     elseif P_TEMP < 0.01
        %        ptext = ['**'];
        %     elseif P_TEMP < 0.05
        %        ptext = ['*'];
        %     elseif P_TEMP > 0.05
        %        ptext = ['ns'];
        %     end   
        %     text(xl, yl, ptext, 'FontSize',15) 
        %     xpts = [xl-0.3 xl+0.4]
        %     ypts = [yl yl];
        %     f = line(xpts, ypts-0.02, 'LineWidth', 1, 'Color', 'k');
        % end
         
                P_TEMP = p_EL;
                xl = 1.35;
                yl = 0.75;    
         
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
            xpts = [xl-0.25 xl+0.4]
            ypts = [yl yl];
            f = line(xpts, ypts-0.02, 'LineWidth', 1, 'Color', 'k');
        end
        
        cd(savepath)
        
        SaveName = [T '_ranksum' CondStr]
          print('-painters','-dpng',[SaveName],'-r600');
              print('-painters','-dpdf',[SaveName],'-r600');
            savefig([SaveName '.fig'])
               
   
end