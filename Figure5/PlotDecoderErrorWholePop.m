function PlotDecoderErrorWholePop(paths, delay, NBPath, cond, TrType, Fields, savepath)
 

   if cond == 1
     CondStr = 'Cue';
     namex = 'Time from cue onset (s)';
    elseif cond == 2
      CondStr = 'LastLick';
      namex = 'Time from last lick (s)';
    elseif cond == 3
      CondStr = 'Rew'
      namex = 'Time from reward (s)';
    elseif cond == 4
     CondStr = 'Lick'
      namex = 'Time from first lick (s)';
   end

  if TrType == 1
     goodstr = '3545';
     datacolor = 	'k';
  elseif TrType == 0 
     goodstr = '56s';  
     datacolor = 	[0 0.4470 0.7410];
 elseif TrType == 2
goodstr = '';  %%all tr
datacolor = [0 0.4470 0.7410];
  end

   if Fields == 1
      FieldStr = ['FieldsAllCond']
   elseif Fields == 2
       FieldStr = ['FieldsAllTr']
   elseif Fields == 3
       FieldStr = ['NoFieldsDff']


   elseif Fields == 5 
       FieldStr = ['RiseLLDownL']
        elseif Fields == 6
       FieldStr = ['LickOn']

   else 
       FieldStr = ['']
   end

    if (delay == 2)
        bins = 50
     elseif (delay == 22)
        bins = 45   
          name = [ 'Mean Decoder Error -'  CondStr '-' FieldStr goodstr] 
    elseif (delay == 33)
        bins = 55      
    elseif (delay == 4)
        bins = 70
        name = ['Mean Decoder Error -'  CondStr '-' FieldStr]  
        
    elseif (delay == 44)
        bins = 65   
       name = [ 'Mean Decoder Error -'  CondStr '-' FieldStr goodstr] 
    end    
    
    Err = zeros(bins,1);
    ErrShuf = zeros(bins,1);

    for i = 1:size(paths,1)
        cd(paths{i,:})
        % cd(paths(i,:))
         naiveBayesPath = [paths{i,:} NBPath  '.mat'];
        % naiveBayesPath = [paths(i,:) NBPath  '.mat'];
        load(naiveBayesPath, 'naiveBayesMean')
       shufPath = [paths{i,:} NBPath CondStr  'Shuf.mat'];
        % shufPath = [paths(i,:) NBPath CondStr  'Shuf.mat'];
        load(shufPath)
        ErrTemp = naiveBayesMean.decodingErr{1}; 
        ErrorAll(i,:) = ErrTemp';
       ShufErrorAll(i,:) = decodedErrShuf(1:bins)';
        Err = [Err + ErrTemp]; 
        ErrShuf = [ErrShuf + decodedErrShuf(1:bins)];
    end

    
   ErrShufLabelMean = (ErrShuf/size(paths,1)); 
   ErrMean = (Err/size(paths,1)); 

   ErrorAll = ErrorAll';
   ShufErrorAll = ShufErrorAll';

   for i = 1:length(ErrorAll)
        pLabelN2temp = ranksum(ErrorAll(i,:), ShufErrorAll(i,:));
        pLabelN2_rank(i) = pLabelN2temp;

        [pLabelN2temp_h_t, pLabelN2temp_p_t]  = ttest(ErrorAll(i,:), ShufErrorAll(i,:));
        pLabelN2_ttest(i) = pLabelN2temp_p_t;
   end

    SEM = std(ErrMean)/sqrt(size(paths,1));
    SEMS = std(ErrShufLabelMean)/sqrt(size(paths,1));

   %[h2,p2] = kstest2(ErrMean, ErrShufLabelMean) 

   figure
   hold on
   axis square
  x = [1:1:bins]

  avg_data = ErrMean';
  x = 1:size(avg_data,2);
 std_data = std(ErrorAll', 0,1,'omitnan')
std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], datacolor, 'FaceAlpha',0.3)
 plot(x, avg_data, 'LineWidth', 3, 'Color', datacolor)

 avg_data = ErrShufLabelMean';
  x = 1:size(avg_data,2);
 std_data = std(ShufErrorAll', 0,1,'omitnan')
std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0.5 0.5 0.5], 'FaceAlpha',0.3)
 plot(x, avg_data, 'LineWidth', 3, 'Color',  [0.5 0.5 0.5])
      

%patch([x, flip(x)]', [ErrShufLabelMean-SEMS; flip(ErrShufLabelMean+SEMS)], [0.5 0.5 0.5], 'FaceAlpha',0.25, 'EdgeColor','none')  
   yline(0)
      
  for i = 1:length(ErrorAll)
      if   pLabelN2_rank(i) < 0.01
          scatter(x(i),max(ErrShufLabelMean)+0.6, 80,'.b')
      else 
      end
   end

   ptext.FontSize = 32
   title('Mean decoding error')
   set(gca,'FontSize', 22)
   xlim([0 bins])
   xticks([0:10:bins])
   xticklabels({'0' '1' '2' '3' '4' '5' '6' '7'})
   ylabel('Decoder error (s)')
   xlabel(namex)
   legend({'','Data', '','Shuffle'}, 'Location', 'southwest')
   
 cd(savepath)
    title(name)
    savename = [name 'p01' 'rank']
    savefig([savename '.fig'])
    print('-painters','-dpng',[savename],'-r600');    
      print('-painters','-dpdf',[savename],'-r600');   


      %%%bar chart 
Y1 = mean(abs(ErrorAll))
    a = 0.93;
    b = 1.07;
    X1 = (b-a).*rand(size(Y1,2),1) + a;
% X1 = ones(size(Y1))

Y2 = mean(abs(ShufErrorAll))
X2 = ones(size(Y2))
 a = 1.93;
 b = 2.07;
 X2 = (b-a).*rand(size(Y2,2),1) + a;
ErrMean = abs(ErrMean);
ErrShufLabelMean = abs(ErrShufLabelMean);

     std_data = std(Y1', 0,1,'omitnan');
 std_data_1 = std_data/ sqrt(size(paths,1));
 DataReal = [mean(Y1), std_data_1]

 std_data = std(Y2', 0,1,'omitnan');
 std_data_2 = std_data/ sqrt(size(paths,1));
 DataShuf = [mean(Y2), std_data_2]

     % [h,p] = ttest(Y1, Y2);
      [p,h] = ranksum(Y1, Y2);
     SEM = std(Y1)/sqrt(size(paths,1));
     SEMS = std(Y2)/sqrt(size(paths,1));

     figure
     hold on
     X = categorical({'Data','Shuffle'});
     X = reordercats(X,{'Data','Shuffle'});

    

     if TrType == 1

      c =  bar(X(1), mean(Y1))
     set(c,'FaceColor', datacolor ,'FaceAlpha', 0.5); 
     c =  bar(X(2), mean(Y2))
     set(c,'FaceColor', [.7 .7 .7] ,'FaceAlpha', 0.3); 
       scatter(X1, Y1, 120, MarkerFaceColor =  datacolor , MarkerFaceAlpha = 0.5,  MarkerEdgeColor='k')
     else
 
     c =  bar(X(1), mean(Y1))
     set(c,'FaceColor', datacolor ,'FaceAlpha', 0.3); 
     c =  bar(X(2), mean(Y2))
     set(c,'FaceColor', [.7 .7 .7] ,'FaceAlpha', 0.3); 
         scatter(X1, Y1, 120, MarkerFaceColor =  datacolor,MarkerFaceAlpha = 0.7, MarkerEdgeColor='k')
      
     end
     scatter(X2, Y2, 120, MarkerFaceColor = [.7 .7 .7], MarkerEdgeColor='k')
     errorbar(1,mean(Y1),SEM, 'LineWidth',3, 'Color',[0,0, 0]);
     errorbar(2,mean(Y2),SEMS, 'LineWidth',3, 'Color',[0,0, 0]);

   if p  < 0.001
       ptext = ['***'];
    elseif p < 0.01
       ptext = ['**'];
    elseif p < 0.05
       ptext = ['*'];
    elseif p > 0.05
       ptext = ['ns'];
    end
    xl = 1.3
    yl = 1.8
    text(xl, yl, ptext, 'FontSize',35) 
    % xpts = [xl-0.3 xl+0.4]
    % ypts = [yl yl];
    % f = line(xpts, ypts-0.05, 'LineWidth', 1.5, 'Color', 'k');

   title('Mean Decoder Error')
   ylabel('Decoder error (s)')
     set(gca,'FontSize', 22)
     axis square
    cd(savepath)
     T = ['Mean Decoder Error'] 
    %identitle(T)
   name = [name 'BarGraph' 'rank']
    savefig([name '.fig'])
    print('-painters','-dpng',[name],'-r600');    
     print('-painters','-dpdf',[name],'-r600');   


% 

end 

