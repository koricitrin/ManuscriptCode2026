
function PlotPosteriorWholePopSingleTr(Paths, delay, TrSess, cond, NBPath)
%PlotPosteriorNaiveBayesKori('Z:\Kori\immobile_2p\anmc132\A132-20221120\A132-20221120-02\', 'A132-20221120-02', 1, 2, 2, 2, 1)
%(DatavsShuf == 1) = data, 2 == shuf

path = Paths{1,:}

cd(path)


    naiveBayesPath = [path NBPath '.mat']
   % naiveBayesPath = [path 'NaiveBayesDecoderGoodTrNoFields.mat']
    load(naiveBayesPath)
    

 if(delay == 2)
        naiveBayesMean.time = {0:0.2:4.9};
       singleTr =  1:25:size(naiveBayes.PosteriorN2{1},1);
    elseif(delay == 3)
         naiveBayesMean.time = {0:0.2:5.9};
       singleTr =  1:30:size(naiveBayes.PosteriorN2{1},1);
    elseif(delay == 4)
        naiveBayesMean.time = {0.05:0.1:6.95};
          singleTr =  1:70:size(naiveBayes.PosteriorN2{1},1);
       % singleTrBad =  1:70:size(naiveBayes.PosteriorN2Bad{1},1);
        bins = 70;
   elseif(delay == 44)
        naiveBayesMean.time = {0.05:0.1:6.5};   
         singleTr =  1:65:size(naiveBayes.PosteriorN2{1},1);
        bins =65;
 end
    
  time = naiveBayesMean.time{1}   
 
  if(cond == 1)
        condStr = 'Cue';
        labelStr = 'cue onset'
    elseif(cond == 2)
        condStr = 'LastLick';
        labelStr = 'last lick'
     end
    
  if(TrSess == 1)
        TrSStr = 'Tr';
     elseif(TrSess == 2)
         TrSStr = 'Sess';
  end
  
    
  

 if(TrSess == 2)
       PosteriorP = cell2mat(naiveBayesMean.PosteriorN2); %for sess

       figure 
       hold on
       imagesc(time',time',PosteriorP');
          hold on
           colormap(flipud(sky))
         colorbar
            caxis([0 0.15]);
            TX = ['Time from ' labelStr ' (s)']
            xlabel(TX, 'FontSize', 22)
            ylabel('Decoded time (s)', 'FontSize', 22)
            plot(time(1:65),naiveBayesMean.labelN2{1}, 'LineWidth', 1.5, 'Color', 	[1 1 1 ])
            diagonal = [time(1:65), time(1:65)]
            plot(time(1:65), time(1:65), '--k', 'LineWidth', 1.5)
          ax = gca
          ax.XAxis.FontSize = 20;
          ax.YAxis.FontSize = 20;
          set(gca,'YDir','reverse')
          xticks([0:1:7])
          yticks([0:1:7])
          xlim([0 6.5])
          ylim([0 6.5])
           T = [ 'Decoding - Single' TrSStr]
         title(T)
            axis square
            fileName1 = [ 'Decoding' condStr  TrSStr ];
           savefig([path fileName1 '.fig'])
            print('-painters','-dpng',[path fileName1],'-r600');
        a=colorbar;
        ylabel(a,'Posterior Prob.','FontSize',20,'Rotation',270);
        a.Label.Position(1) = 3.5;
    
     elseif(TrSess == 1)  
     foldername = ['SingleTrPosterior_3545'];   
     mkdir(foldername)   

     labelSingleTr =  reshape(naiveBayes.labelN2{1}, bins, []);
       % for i = 1:size(singleTr,2)
       %    TempLabelTr = (labelSingleTr(:,i)*10)';
       %    % LabelTr0to1s(i,:) = TempLabelTr(1:10); 
       % end
       % 
       %   for i = 1:size(singleTr,2)
       %    TempLabelTr = (labelSingleTr(:,i)*10)';
       %    LabelTrFullTr(i,:) = TempLabelTr; 
       % end
       %   savepath1 = [path foldername '\']
       %     cd(savepath1)
       % save('LabelsFirstSec.mat', 'LabelTr0to1s', 'LabelTrFullTr')
         for i = 1:size(singleTr,2)
             j = singleTr(i);
             PosteriorPtemp = naiveBayes.PosteriorN2{1}(j:j+bins-1, :); %%for single TR 
             PosteriorP{i} = PosteriorPtemp;
         end
         for i= 1:size(singleTr,2)
                 figure
                 hold on
                 imagesc(time*10',time*10',PosteriorP{i}')
                 plot(labelSingleTr(:,i)*10, 'LineWidth', 1.5, 'Color', 	[1 1 1])
                
                 colormap(flipud(sky))
                 colorbar
                 % caxis([0 1]);
                 yticks(0:10:bins)
                 xticks(0:10:bins)
                 yticklabels({0:1:7})
                 xticklabels({0:1:7})
                 xlim([0 bins])
                 ylim([0 bins])
                 plot(0:bins, 0:bins, '--k', 'LineWidth', 1.5)
                 TX = ['Time from ' labelStr ' (s)']
                 xlabel(TX, 'FontSize', 22)
                 ylabel('Decoded time (s)', 'FontSize', 22)
                ax = gca
                ax.XAxis.FontSize = 20;
                ax.YAxis.FontSize = 20;
                set(gca,'YDir','reverse')
                T = ['Decoding' 'Trial' num2str(i)]
                title(T)
                axis square
                fileName1 = [ 'Decoding' condStr  'Trial' num2str(i)];
                savepath1 = [path foldername '\']
                cd(savepath1)
                savefig([fileName1 '.fig'])
                print('-painters','-dpng',[fileName1],'-r600');
% 
         end
         
      
         end
             

  
 
%   h = imagesc(time',time',PosteriorP);
%     colormap hot
%     colorbar
%     TX = ['Time aligned to ' condStr '(s)']
%     xlabel(TX, 'FontSize', 22)
%     ylabel('Decoded time (s)', 'FontSize', 22)
%  
% 
%  ax = gca
% ax.XAxis.FontSize = 20;
% ax.YAxis.FontSize = 20;
% 
%    T = ['Decoding - Single' TrSStr]
%   title(T, 'FontSize', 20)
% 
%    fileName1 = ['Decoding' condStr  TrSStr ];
%    savefig([path fileName1 '.fig'])
%     print('-painters','-dpng',[path fileName1],'-r600');
% 
% 
% a=colorbar;
% ylabel(a,'Posterior Prob.','FontSize',20,'Rotation',270);
% a.Label.Position(1) = 3.5;
end