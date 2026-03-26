function PropPACBlockDelay(Paths)

    for k = 1:size(Paths,1)
    
          cd(Paths(k,:))

          load(['RiseLastLickDownLickNeurons_thres3sTr.mat'])
          PropPAC_3s(k,:) = PropRiseLLDownL*100;

          load(['RiseLastLickDownLickNeurons_thres5sTr.mat'])
          PropPAC_5s(k,:) = PropRiseLLDownL*100;

    end

 
  std_data = std(PropPAC_3s, 0,1,'omitnan');
 std_data_1 = std_data/ sqrt(size(Paths,1));
 Data3s = [mean(PropPAC_3s), std_data_1]

 std_data = std(PropPAC_5s, 0,1,'omitnan');
 std_data_2 = std_data/ sqrt(size(Paths,1));
 Data5s = [mean(PropPAC_5s), std_data_2]

     a = 0.9; b = 1.1;
     X1 = (b-a).*rand(size(PropPAC_3s,1),1) + a;
 
     a = 1.9; b = 2.1;
     X2 = (b-a).*rand(size(PropPAC_5s,1),1) + a;

    C = parula(10);
        f = figure;
        f.Position = [350 350 380 380];
        hold on

        scatter(X1, PropPAC_3s, 120, MarkerFaceColor =   'k' , MarkerEdgeColor='k'); 
        c =  bar(1, mean(PropPAC_3s))
        set(c,'FaceColor', 'k' ,'FaceAlpha', 0.3); 
        SEM =   std(PropPAC_3s,[],2)/sqrt(size(PropPAC_3s,2));  
        errorbar(1,  mean(PropPAC_3s),SEM, 'Color', 'k', 'LineWidth', 2)


        scatter(X2, PropPAC_5s, 120, MarkerFaceColor =  C(4,:), MarkerEdgeColor='k'); 
        c =  bar(2, mean(PropPAC_5s))
        set(c,'FaceColor',  C(4,:) ,'FaceAlpha', 0.3); 
        SEM =   std(PropPAC_5s,[],2)/sqrt(size(PropPAC_5s,2));  
        errorbar(2,  mean(PropPAC_5s),SEM, 'Color', 'k', 'LineWidth', 2)
    
        
        ylim([0 0.6])
        xticks(1:1:3)
        xticklabels({'3s Delay', '5s Delay'})
        ylabel('Proportion')
        set(gca, 'FontSize', 16)


        [p,h] = ranksum(PropPAC_3s, PropPAC_5s);
            P_TEMP = p;
            xl = 1.35;
            yl = 0.5;    
     
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
        xpts = [xl-0.1 xl+0.4]
        ypts = [yl yl];
        f = line(xpts, ypts-0.05, 'LineWidth', 1, 'Color', 'k');
            
        xlim([0 3])
        axis square

        cd('Z:\Kori\immobile_code\BlockDelay\Plots\')
        T = ['Proportion PAC'];
        title(T)
       SaveName = [T '_ranksum']
       print('-painters','-dpng',[SaveName],'-r600');
       savefig([SaveName '.fig'])
       print('-painters','-dpdf',[SaveName],'-r600');

      
    
    % Y = [{PropPAC_3s} {PropPAC_5s}];
    % X = [{X1} {X2}];
    % 
    % [p,h] = ranksum(PropPAC_3s, PropPAC_5s);
    % 
    % 
    % f = figure;
    % f.Position = [350 350 380 400];
    % hold on 
    % T = ['Proportion PAC ']
    % C = parula(10);
    % 
    % 
    % for Stages = 1:2
    % b = boxchart(X{Stages}, Y{Stages})
    % 
    % if Stages == 1
    % % b.BoxFaceColor = C(1,:); 
    % b.BoxFaceColor = ['k'];
    % b.BoxFaceAlpha = [0.6]
    % elseif  Stages == 2
    % % b.BoxFaceColor = C(4,:); 
    %  b.BoxFaceColor =  [0 0.4470 0.7410];
    % 
    % end
    % 
    % 
    % 
    % title(T)
    % xticks(1:1:3)
    % xticklabels({'3s Delay', '5s Delay'})
    % %ylabel('Proportion')
    % set(gca, 'FontSize', 16)
    % 
    % 
    %         P_TEMP = p;
    %         xl = 1.4;
    %         yl = 0.8;
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
    %     text(xl, yl, ptext, 'FontSize',18) 
    %     xpts = [xl-0.2 xl+0.4]
    %     ypts = [yl yl];
    %     xlim([0 3])
    %     f = line(xpts, ypts-0.04, 'LineWidth', 1, 'Color', 'k');
    %  set(gca, 'FontSize', 19)
    % 
    % 
    %  ylim([0 1])   
    %  ylabel('Index')
    %  cd('Z:\Kori\immobile_code\BlockDelay\Plots\')
    %  SaveName = [T 'ranksum']
    %  print('-painters','-dpng',[SaveName],'-r600');
    %  % print('-painters','-dpdf',[SaveName],'-r600');
    %  savefig([SaveName '.fig'])
           
       
    
    

end