function MedFirstLickTime_AllLickCDF_Learning(Paths1, Paths2, cond)
   
           LicksAll1 = [];
    for k = 1:size(Paths1,1)
    
          % cd(Paths1(k,:))
            cd(Paths1{k,:})


          load([Paths1{k}(1,43:58) '_DataStructure_mazeSection1_TrialType1_Info.mat'])
          
       
          if cond == 1
          CondStr = 'Cue'
           namex = ['Time from cue onset (s)'];
          MedLicksTemp = (beh.medTimeFirst5Licks/500);
  
          MedLicksTemp = MedLicksTemp(~isnan(MedLicksTemp));
          LicksAll1 = [MedLicksTemp, LicksAll1];

          MedLicks1(k,:) = median(MedLicksTemp);
       

          elseif cond == 2
          CondStr = 'LastLick'
          namex = ['Time from last lick (s)'];
          load('FirstLick_LL.mat')
          
          FirstLicksTemp = (FirstLick);
    
          FirstLicksTemp = FirstLicksTemp(~isnan(FirstLicksTemp));
          FirstLicksTemp = FirstLicksTemp(~isnan(FirstLicksTemp));
          LicksAll1 = [FirstLicksTemp', LicksAll1];
        
          MedLicks1(k,:) = median(FirstLicksTemp);
 
          end

    end


LicksAll2 = [];
    for k = 1:size(Paths2,1)
    
          cd(Paths2(k,:))


          load([Paths2(k,43:58) '_DataStructure_mazeSection1_TrialType1_Info.mat'])
          
        
          if cond == 1
          CondStr = 'Cue'
           namex = ['Time from cue onset (s)'];
          MedLicksTemp = (beh.medTimeFirst5Licks/500);
  
          MedLicksTemp = MedLicksTemp(~isnan(MedLicksTemp));
          LicksAll2 = [MedLicksTemp, LicksAll2];

          MedLicks2(k,:) = median(MedLicksTemp);
       

          elseif cond == 2
          CondStr = 'LastLick'
          namex = ['Time from last lick (s)'];
          load('FirstLick_LL.mat')
          
          FirstLicksTemp = (FirstLick);
    
          FirstLicksTemp = FirstLicksTemp(~isnan(FirstLicksTemp));
          FirstLicksTemp = FirstLicksTemp(~isnan(FirstLicksTemp));
          LicksAll2 = [FirstLicksTemp', LicksAll2];
        
          MedLicks2(k,:) = median(FirstLicksTemp);
 
          end

    end

    C = parula(10);


   cd('Z:\Kori\PaperDrafting2025\Plots\fig4\')
       f = figure;
    f.Position = [350 350 380 400];
    hold on
    axis square
    [f1,x1]=ecdf(LicksAll1);
    plot(x1,f1, 'Color',  C(1,:),'LineWidth',3)
    [f2,x2]=ecdf(LicksAll2);
    plot(x2,f2, 'Color', C(4,:),'LineWidth',3)
    ylabel('Cumulative probability')
    xlabel('First lick time (s)')
    xlim([0 7])
    xticks([0:7])
    legend('Early training', 'Late training', 'Location', 'best')
    set(gca, 'FontSize', 19)
      T = ['FirstLick-ecdf' CondStr]
        print('-painters','-dpng',[T],'-r600');
      print('-painters','-dpdf',[T],'-r600');
     savefig([T '.fig'])

    
  
    std_data = std(LicksAll1', 0,1,'omitnan');
     std_data_1 = std_data/ sqrt(size(Paths1,1));
     Data1 = [mean(LicksAll1), std_data_1]

     std_data = std(LicksAll2', 0,1,'omitnan');
     std_data_2 = std_data/ sqrt(size(Paths2,1));
     Data2 = [mean(LicksAll2), std_data_2]


     [p,h] = ranksum(LicksAll1, LicksAll2);
     [h,p] = ttest2(LicksAll1, LicksAll2);
     [h,p] = kstest2(LicksAll1, LicksAll2);

     X1 = ones(size(MedLicks1,1),1)';
     X2 = ones(size(MedLicks2,1),1)'*2;
      
    
    Y = [{MedLicks1} {MedLicks2}];
    X = [{X1} {X2}]; 
 
    std_data = std(MedLicks1, 0,1,'omitnan');
 std_data_1 = std_data/ sqrt(size(Paths1,1));
 Data1 = [mean(MedLicks1), std_data_1]

 std_data = std(MedLicks2, 0,1,'omitnan');
 std_data_2 = std_data/ sqrt(size(Paths2,1));
 Data2 = [mean(MedLicks2), std_data_2]

     [p,h] = ranksum(MedLicks1, MedLicks2);
     % [p,h] = ttest2(MedLicks1, MedLicks2);

    f = figure;
    f.Position = [350 350 380 400];
    hold on 
    T = ['Med First Lick Time']
    

    for Stages = 1:2
    b = boxchart(X{Stages}, Y{Stages})

    if Stages == 1
     b.BoxFaceColor = C(1,:); 
   
    elseif  Stages == 2
     b.BoxFaceColor = C(4,:); 
     % b.BoxFaceColor =  [0 0.4470 0.7410];

    end


    title(T)
    xticks(1:1:3)
    xticklabels({'Early', 'Late'})
    %ylabel('Proportion')
    set(gca, 'FontSize', 16)


            P_TEMP = p;
            xl = 1.4;
            yl = 5.5;

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
        xlim([0.5 2.5])
        f = line(xpts, ypts-0.04, 'LineWidth', 1, 'Color', 'k');
     set(gca, 'FontSize', 19)


     ylim([0.0 7])   
     ylabel(namex)
     cd('Z:\Kori\PaperDrafting2025\Plots\fig4\')
     SaveName = [T 'ranksum' CondStr]
     print('-painters','-dpng',[SaveName],'-r600');
      print('-painters','-dpdf',[SaveName],'-r600');
     savefig([SaveName '.fig'])
    end
end