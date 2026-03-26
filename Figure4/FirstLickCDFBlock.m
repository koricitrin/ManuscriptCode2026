function FirstLickCDFBlock(Paths, Cond)

 FirstLick_LL_3sCat = [];
  FirstLick_LL_5sCat = [];
    for k = 1:size(Paths,1)
    
          cd(Paths(k,:))

                 load([Paths(k,43:58) '_DataStructure_mazeSection1_TrialType1_Info.mat'])
              
                delay3sInd =  (beh.delayLen/1000000) == 3;
                delay5sInd =  (beh.delayLen/1000000) == 5;

          if Cond == 1 
                CondStr = 'Cue'

                FirstLick3s = (beh.medTimeFirst5Licks(delay3sInd)/500);
              FirstLick_LL_3sCat = [FirstLick_LL_3sCat,FirstLick3s];
                FirstLick5s = (beh.medTimeFirst5Licks(delay5sInd)/500);
                 FirstLick_LL_5sCat = [FirstLick_LL_5sCat,FirstLick5s];
           
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
         
                FirstLick_LL_3sCat = [FirstLick_LL_3sCat; FirstLick_LL_3s];
                FirstLick_LL_5sCat = [FirstLick_LL_5sCat; FirstLick_LL_5s];
            end

     end
 
 std_data = std(FirstLick_LL_3sCat, 0,1,'omitnan');
 std_data_1 = std_data/ sqrt(size(Paths,1));
 Data3s = [mean(FirstLick_LL_3sCat), std_data_1]

 std_data = std(FirstLick_LL_5sCat, 0,1,'omitnan');
 std_data_2 = std_data/ sqrt(size(Paths,1));
 Data5s = [mean(FirstLick_LL_5sCat), std_data_2]
 
[p,h] = kstest2(FirstLick_LL_3sCat, FirstLick_LL_5sCat)
    [p,h] = ranksum(FirstLick_LL_3sCat, FirstLick_LL_5sCat)

         cd('Z:\Kori\immobile_code\BlockDelay\Plots\')
  
      f = figure;
    f.Position = [350 350 380 400];
    hold on
    axis square
    [f1,x1]=ecdf(FirstLick_LL_3sCat);
    plot(x1,f1, 'Color', [0.2 0.2 0.2],'LineWidth',3)
    [f2,x2]=ecdf(FirstLick_LL_5sCat);
    plot(x2,f2, 'Color', [0 0.4470 0.7410],'LineWidth',3)
    ylabel('Cumulative probability')
    xlabel('First lick time (s)')
    xlim([0 7])
    xticks([0:7])
    legend('3s Blocks', '5s Blocks', 'Location', 'best')
    set(gca, 'FontSize', 19)
      T = ['FirstLick-ecdf' CondStr]
        print('-painters','-dpng',[T],'-r600');
      print('-painters','-dpdf',[T],'-r600');
     savefig([T '.fig'])


     cd('Z:\Kori\immobile_code\BlockDelay\Plots\')
  
       
    end
    

