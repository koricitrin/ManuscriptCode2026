function PropDelayLickStatsDrug2(Path1, cond,rank)
cd('Z:\Kori\immobile_code\Paths\')
ImmobileRecordingListNT
   delay = 4000;

   if cond == 1 
    recCtrl = recCtrlMusc;
    rec1hr = rec1hrMusc;
    recRecovery = recRecoveryMusc;
    CondStr = 'Musc';
   elseif cond == 2
    recCtrl = recCtrlSaline;
    rec1hr = rec1hrSaline;
    recRecovery = [];
    CondStr = 'Saline';
   end
    
   %%get Control sess data
   DelayPropCtrl = [];
   for i = 1:size(Path1,1)  
         cd(Path1(i,:));
         currentpath = Path1(i,:);
         sess = Path1(i,40:52)
         filename = [sess recCtrl(i,:)];
         load(filename)

         %get first  licks
             
         for Tr = 1:size(LickNoNAN,2)
           First5Licks{Tr} =  LickNoNAN{Tr}(1);
         end
           First5LicksTemp = cellfun(@mean,First5Licks)
            DelayPropTemp = First5LicksTemp/ (4000+1000);
            DelayPropTemp(isnan(DelayPropTemp)) = [];
            DelayPropTemp(isinf(DelayPropTemp)) = [];
            PredlickInd = DelayPropTemp < 1;
            DelayPropTemp = DelayPropTemp(PredlickInd);
            DelayPropCtrlMean(i,:) = mean(DelayPropTemp);
            DelayPropCtrl = [DelayPropCtrl, DelayPropTemp];
            clear DelayPropTemp First5LicksTemp First5Licks
   end

       DelayProp1hr = [];
   %%get 1hr sess data
   for i = 1:size(Path1,1)  
         cd(Path1(i,:));
         currentpath = Path1(i,:);
         sess = Path1(i,40:52)
         filename = [sess rec1hr(i,:)];
         load(filename)
         
         %get first 5 licks
     
         for Tr = 1:size(LickNoNAN,2)
            if  size(LickNoNAN{Tr},1) < 1
                continue
            else    
           First5Licks{Tr} =  LickNoNAN{Tr}(1);
            end
         end
           First5LicksTemp = cellfun(@mean,First5Licks)
            DelayPropTemp = First5LicksTemp/ (4000+1000);
            DelayPropTemp(isnan(DelayPropTemp)) = [];
            DelayPropTemp(isinf(DelayPropTemp)) = [];
            PredlickInd = DelayPropTemp < 1;
            DelayPropTemp = DelayPropTemp(PredlickInd);
            DelayProp1hrMean(i,:) = mean(DelayPropTemp);
            DelayProp1hr = [DelayProp1hr, DelayPropTemp];
            clear DelayPropTemp First5LicksTemp First5Licks
    end
 
     X1 = ones(size(DelayPropCtrlMean,1),1)';
     X2 = ones(size(DelayProp1hrMean,1),1)'*2;
  
   %  if cond == 1
   %  DelayPropRecov = [];
   % %%get 1hr sess data
   % RecovList = [1 2 3 4 ]
   % for i = 1:4
   %     j = RecovList(i)
   %       cd(Path1(j,:));
   %       currentpath = Path1(j,:);
   %       sess = Path1(j,40:52)
   %       filename = [sess recRecoveryMusc(i,:)];
   %       load(filename)
   % 
   %       %get first 5 licks
   % 
   %       for Tr = 1:size(LickNoNAN,2)
   %          if  size(LickNoNAN{Tr},1) < 1
   %              continue
   %          else    
   %         First5Licks{Tr} =  LickNoNAN{Tr}(1);
   %          end
   %       end
   %         First5LicksTemp = cellfun(@median,First5Licks)
   %          DelayPropTemp = First5LicksTemp/ (4000+1000);
   %          DelayPropTemp(isnan(DelayPropTemp)) = [];
   %          DelayPropTemp(isinf(DelayPropTemp)) = [];
   %          PredlickInd = DelayPropTemp < 1;
   %          DelayPropTemp = DelayPropTemp(PredlickInd);
   %          DelayPropRecovMean(i,:) = mean(DelayPropTemp);
   %          DelayPropRecov = [DelayPropRecov, DelayPropTemp];
   %          clear DelayPropTemp First5LicksTemp First5Licks
   % end
   %  X3 = ones(size(DelayPropRecovMean,1),1)'*3;
   % 
   %  else 
   %      DelayPropRecov = [];
   %        DelayPropRecovMean = [];
   %        X3 =[];
   %  end

 
  
 std_data = std(DelayPropCtrlMean, 0,1,'omitnan');
std_data = std_data/ sqrt(size(DelayPropCtrlMean,1));
BefStats = [mean(DelayPropCtrlMean), std_data]

 std_data = std(DelayProp1hrMean, 0,1,'omitnan');
std_data = std_data/  sqrt(size(DelayProp1hrMean,1));
AFtStats = [mean(DelayProp1hrMean), std_data]

% 
%  std_data = std(DelayPropRecovMean, 0,1,'omitnan');
% std_data = std_data/  sqrt(size(DelayPropRecovMean,1));
% RecStats = [mean(DelayPropRecovMean), std_data]


Y = [{DelayPropCtrlMean} {DelayProp1hrMean}];
X = [{X1} {X2}];


if rank == 1 
    [p_C1,h] = ranksum(DelayPropCtrlMean, DelayProp1hrMean)
      teststr = 'rank'
    if cond == 3 
    [p_1R,h] = ranksum(DelayPropRecovMean, DelayProp1hrMean)
    
    [p_CR,h] = ranksum(DelayPropRecovMean, DelayPropCtrlMean)
    
    end
elseif rank == 0 

    [h, p_C1] = ttest(DelayPropCtrlMean, DelayProp1hrMean)
    
    if cond == 3 
    [h, p_1R] = ttest(DelayPropRecovMean, DelayProp1hrMean)
    
    [h, p_CR] = ttest(DelayPropRecovMean, DelayPropCtrlMean)
    end
    teststr = 'ttest'
elseif rank == 2 

    [h, p_C1] = signrank(DelayPropCtrlMean, DelayProp1hrMean)
    
    if cond == 3 
    [h, p_1R] = signrank(DelayPropRecovMean, DelayProp1hrMean)
    
    [h, p_CR] = signrank(DelayPropRecovMean, DelayPropCtrlMean)
    end
    teststr = 'ttest'
end

f = figure;
 f.Position = [350 350 440 400];
hold on 

        C = parula(10);

if cond == 1
    n = 2;
elseif cond == 2
    n =2;
end 

for Stages = 1:n
b = boxchart(X{Stages}, Y{Stages})

if Stages == 1
b.BoxFaceColor = 'k'; 
elseif  Stages == 2
    if cond == 2
b.BoxFaceColor = C(5,:);
    elseif cond == 1
        b.BoxFaceColor = C(7,:);
    end
 elseif  Stages == 3
b.BoxFaceColor = [0.5 0.5 0.5]; 
end


 T = ['Predictive Licking Index' '']

title(T)
xticks(1:1:3)
xticklabels({'Pre', 'Post', 'Recov'})
%ylabel('Proportion')
set(gca, 'FontSize', 18)
 ylim([0.0 0.9])
ylabel('Predictive licking index')

        P_TEMP = p_C1;
        xl = 1.45;
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
    text(1.43, 0.75, ptext, 'FontSize',15) 
    xpts = [xl-0.25 xl+0.4]
    ypts = [yl yl];
    f = line(xpts, ypts-0.02, 'LineWidth', 1, 'Color', 'k');
 
   if cond == 3    
    P_TEMP = p_1R;
        xl = 2.45;
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
    text(2.43, 0.75, ptext, 'FontSize',15) 
    xpts = [xl-0.25 xl+0.4]
    ypts = [yl yl];
    f = line(xpts, ypts-0.02, 'LineWidth', 1, 'Color', 'k');
   end
   

end


cd('Z:\Kori\PaperDrafting2025\Plots\Musc\')
SaveName = [T CondStr '_' teststr 'n4' 'norec_ylim']
  print('-painters','-dpdf',[SaveName],'-r600');
  print('-painters','-dpng',[SaveName],'-r600');
    savefig([SaveName '.fig'])

end