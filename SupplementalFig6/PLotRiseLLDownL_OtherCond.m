%% Make bar graph rise Cue, down L and rise LL down L 

% cd('Z:\Kori\immobile_code\RiseDown\tables\SST\-0.5to0.5\')

    tablepath1 = ['Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\'];
    cd(tablepath1) 
load('All_Recs_RiseDownID_AlignLickthres.mat')
TableLick = RiseDownTable;
load('All_Recs_RiseDownID_AlignCuethres.mat')
TableCue = RiseDownTable;
load('All_Recs_RiseDownID_AlignRewthres.mat')
TableRew = RiseDownTable;

load('All_Recs_RiseDownID_AlignLastLickthres.mat')
TableLL = RiseDownTable;


TableLick = renamevars(TableLick,"isRise","RiseLick");
TableCue = renamevars(TableCue,"isRise","RiseCue");
TableLL = renamevars(TableLL,"isRise","RiseLL");
TableRew = renamevars(TableRew,"isRise","RiseRew");

TableLick = renamevars(TableLick,"isDown","DownLick");
TableCue = renamevars(TableCue,"isDown","DownCue");
TableLL = renamevars(TableLL,"isDown","DownLL");
TableRew = renamevars(TableRew,"isDown","DownRew");


RiseDownTableAllCond = [TableLick(:,1), TableLick(:,2), TableLick(:,4), TableCue(:,4), TableLL(:,4), TableRew(:,4), TableLick(:,5), TableCue(:,5), TableLL(:,5),  TableRew(:,5)];

RecNo = size(unique(RiseDownTableAllCond.rec_name),1);
for k =1:RecNo
Recs = unique(RiseDownTableAllCond.rec_name);
sess= Recs(k);
totalNeur = sum(strcmp(RiseDownTableAllCond.rec_name, sess))
 RiseCueDownLickInd = (RiseDownTableAllCond.RiseCue == 1 & RiseDownTableAllCond.DownLick == 1);
RiseCueDownLickNeuronID =  RiseDownTableAllCond(RiseCueDownLickInd,1:2);
RiseCueDownL_Sess = sum(strcmp(RiseCueDownLickNeuronID.rec_name, sess));
RiseCueDownL_Sess_Prop(k,:) = RiseCueDownL_Sess/totalNeur;

end

CueProp = RiseCueDownL_Sess_Prop;

for k =1:RecNo
Recs = unique(RiseDownTableAllCond.rec_name);
sess= Recs(k);
totalNeur = sum(strcmp(RiseDownTableAllCond.rec_name, sess))
 RiseLLDownLickInd = (RiseDownTableAllCond.RiseLL == 1 & RiseDownTableAllCond.DownLick == 1);
RiseLLDownLickNeuronID =  RiseDownTableAllCond(RiseLLDownLickInd,1:2);
RiseLLDownL_Sess = sum(strcmp(RiseLLDownLickNeuronID.rec_name, sess));
RiseLLDownL_Sess_Prop(k,:) = RiseLLDownL_Sess/totalNeur;

end

LLProp  = RiseLLDownL_Sess_Prop;

for k =1:RecNo
Recs = unique(RiseDownTableAllCond.rec_name);
sess= Recs(k);
totalNeur = sum(strcmp(RiseDownTableAllCond.rec_name, sess))
 RiseRewDownLickInd = (RiseDownTableAllCond.RiseRew == 1 & RiseDownTableAllCond.DownLick == 1);
RiseRewDownLickNeuronID =  RiseDownTableAllCond(RiseRewDownLickInd,1:2);
RiseRewDownL_Sess = sum(strcmp(RiseRewDownLickNeuronID.rec_name, sess));
RiseRewDownL_Sess_Prop(k,:) = RiseRewDownL_Sess/totalNeur;

end

RewProp = RiseRewDownL_Sess_Prop;

%%need to plot


    std_data = std(CueProp, 0,1,'omitnan');
 std_data_1 = std_data/ sqrt(15);
 DataCue = [mean(CueProp), std_data_1]*100

     std_data = std(LLProp, 0,1,'omitnan');
 std_data_1 = std_data/ sqrt(15);
 DataLL = [mean(LLProp), std_data_1]*100

      std_data = std(RewProp, 0,1,'omitnan');
 std_data_1 = std_data/ sqrt(15);
 DataRew = [mean(RewProp), std_data_1]*100


 
 a = 0.92;
 b = 1.08;
 X1 = (b-a).*rand(size(CueProp,1),1) + a;


 a = 2.92;
 b = 3.08;
 X3 = (b-a).*rand(size(LLProp,1),1) + a;
 
 a = 1.92;
 b = 2.08;
 X2 = (b-a).*rand(size(RewProp,1),1) + a;


    f = figure;
    % f.Position = [350 350 380 400];
    hold on 
         
        scatter(X1, CueProp, 120, MarkerFaceColor =  [.7 .7 .7], MarkerEdgeColor='k'); 
        c =  bar(1, mean(CueProp))
        set(c,'FaceColor', [.7 .7 .7] ,'FaceAlpha', 0.3); 
        SEM =   std(CueProp,[],2)/sqrt(size(CueProp,2));  
        errorbar(1,  mean(CueProp),SEM, 'Color', 'k', 'LineWidth', 2)

        scatter(X2, RewProp, 120, MarkerFaceColor = [0 0.4470 0.7410] , MarkerEdgeColor='k'); 
        c =  bar(2, mean(RewProp))
        set(c,'FaceColor', [0 0.4470 0.7410] ,'FaceAlpha', 0.3); 
        SEM =   std(RewProp,[],2)/sqrt(size(RewProp,2));  
        errorbar(2,  mean(RewProp),SEM, 'Color', 'k', 'LineWidth', 2)

        scatter(X3, LLProp, 120, MarkerFaceColor = 'm' , MarkerEdgeColor='k'); 
        c =  bar(3, mean(LLProp))
        set(c,'FaceColor', 'm' ,'FaceAlpha', 0.3); 
         SEM =   std(LLProp,[],2)/sqrt(size(LLProp,2));  
        errorbar(3,  mean(LLProp),SEM, 'Color', 'k', 'LineWidth', 2)
    
        xticks(1:1:3)
        xticklabels({'Cue', 'Rew', 'Last Lick'})
        ylabel('Proportion')
        set(gca, 'FontSize', 22)
          ylim([0 0.55])
        xlim([0 4])
        [p_LL_R,h] = ranksum(LLProp, RewProp)
        [p_Cue_R,h] = ranksum(CueProp, RewProp)
        [p_Cue_LL,h] = ranksum(CueProp, LLProp)

        p = p_Cue_R
         if p < 0.001
           ptext = ['***'];
        elseif p < 0.01
           ptext = ['**'];
        elseif p < 0.05
           ptext = ['*'];
        elseif p > 0.05
           ptext = ['ns'];
        end   
      
        xpts = [1 1.8];
        ypts = [0.35 0.35];
        text(mean(xpts)-0.1, mean(ypts)+0.03, ptext, 'FontSize',25) 
        f = line(xpts, ypts, 'LineWidth', 1.2, 'Color', 'k');

           p = p_LL_R
         if p < 0.001
           ptext = ['***'];
        elseif p < 0.01
           ptext = ['**'];
        elseif p < 0.05
           ptext = ['*'];
        elseif p > 0.05
           ptext = ['ns'];
        end   
     
        xpts = [2.2 3];
        ypts = [0.35 0.35];
        text(mean(xpts)-0.1, mean(ypts)+0.01, ptext, 'FontSize',25) 
        f = line(xpts, ypts, 'LineWidth', 1.2, 'Color', 'k');


           p =  p_Cue_LL
         if p < 0.001
           ptext = ['***'];
        elseif p < 0.01
           ptext = ['**'];
        elseif p < 0.05
           ptext = ['*'];
        elseif p > 0.05
           ptext = ['ns'];
        end   
      
        xpts = [1 3];
        ypts = [0.45 0.45];
        text(mean(xpts)-0.2, mean(ypts)+0.01, ptext, 'FontSize',25) 
        f = line(xpts, ypts, 'LineWidth', 1.2, 'Color', 'k');
       
        T = ['']
        title(T)
        savename = [T 'RiseXDownL_prop' 'thres']
        print('-painters','-dpng',[savename],'-r600');
        savefig([savename '.fig'])

