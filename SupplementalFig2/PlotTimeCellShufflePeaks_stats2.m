function PlotTimeCellShufflePeaks_stats2(Paths, savepath, trtype, cond, Early, bins)


           if Early == 2
               trstr = ''
                elseif Early == 1
               trstr = '3545';
                elseif Early == 0
                trstr = '56';
           end
               if (cond == 1)
                condStr = 'Cue';
                namex = ('Time from cue onset (s)')
               elseif (cond == 2)
                   condStr = 'Rew';
                    namex = ('Time from reward (s)')
               elseif (cond == 3)
                   condStr = 'LastLick';       
                    namex = ('Time from last lick (s)')
               elseif (cond == 4)
                   condStr = 'Lick';      
                   namex = ('Time from lick (s)')
             end

            RealData = [];
            ShuffleData = [];
            RealData_Peaks = [];
            ShuffleData_Peaks = [];
            for k = 1:size(Paths,1)
                       % Path = Paths(k,:);
                       Path = Paths{k,:};
                    Filename = [Path(1,43:58) '_DataStructure_mazeSection1_TrialType1'];
                    if trtype == 1
                    fieldpath = [Path 'FieldDetectionShuffle\'];
                    namestr = '';
                    elseif trtype == 2
                        fieldpath = [Path 'FieldDetectionShuffleLateLick\'];
                        namestr = ['LateLick']
                   elseif trtype == 3
                        fieldpath = [Path 'FieldDetectionShuffleEarlyLickk\'];
                        namestr = ['EarlyLick']
                    end
                    cd(fieldpath)
                     
                     % dataname= ['PeaksShuffleResults_1000' condStr  trstr '7s.mat']
                      dataname = ['PeaksShuffleResults_1000' condStr '2.mat']
                    load(dataname)
                    
                    [N_Real_sess,edgesReal_sess] = histcounts(indPeak,bins); 
                    N_Real_sessions(k,:) = N_Real_sess;
                    for i = 1:1000
                    [N_Shuff_t,edges] = histcounts(indPeak_Shuf_i(i,:),bins);
                    ShuffleHistogram_sess_i(i,:) = [N_Shuff_t];
                    end
                       ShuffleHistogram_sess(k,:) = mean(ShuffleHistogram_sess_i);
             
                    RealData_Peaks = [RealData_Peaks; indPeak'];
                    ShuffleData_Peaks = [ShuffleData_Peaks; indPeak_Shuf_i'];
            end

            for i = 1:bins %changed from 8 3/11
                [p_PeaksTemp, h] = ranksum(N_Real_sessions(:,i), ShuffleHistogram_sess(:,i));
                p_Peaks(i) = p_PeaksTemp;

           end

                  [N_Real,edgesReal] = histcounts(RealData_Peaks,bins); 
                    centersReal = (edgesReal(1:end-1) + edgesReal(2:end)) / 2; 

                    %%calculate probability for time bin 1
                     A = N_Real_sessions(:,1)';
                      B = sum(N_Real_sessions,2)';
                     PropBin1 =  A./B;
                     Data1s = [mean(PropBin1)  (std(PropBin1)/ sqrt(size(Paths,1)))]
               
                     A = ShuffleHistogram_sess(:,1)';
                      B = sum(ShuffleHistogram_sess,2)';
                     PropBin1 =  A./B;
                     Data1sShuff = [mean(PropBin1)  (std(PropBin1)/ sqrt(size(Paths,1)))]
                     


if trtype == 2 || 3 
    ShuffleData_Peaks = ShuffleData_Peaks';
    ShuffleData_PeaksTrans = ShuffleData_Peaks;
else
     ShuffleData_PeaksTrans = ShuffleData_Peaks';
end


                    for i = 1:1000
                    % [N_Shuff,edges] = histcounts(ShuffleData_PeaksTrans(i,:),8);
                    [N_Shuff,edges] = histcounts(ShuffleData_PeaksTrans(i,:),bins);
                      edgesShuf(i,:) =edges;
                    ShuffleHistogram(i,:) = [N_Shuff];
                    end
             
         std_data = std(ShuffleHistogram, 0,1,'omitnan')
         sem_data_Shuf = std_data/ sqrt(size(Paths,1));
         meanShuf = mean(ShuffleHistogram);
 
      
                             

      avg_data = mean(ShuffleHistogram);
          x = 1:size(avg_data,2);
         std_data = std(ShuffleHistogram, 0,1,'omitnan')
          SEM_data = std_data/ sqrt(15);
% SEM_data = std_data/ sqrt(1);
           cd(savepath)

             figure('Position', [50, 50, 500, 350]);
            hold on

            h1= histogram('BinCounts', N_Real, 'BinEdges', edgesReal,'Normalization','probability','DisplayStyle','stairs', 'LineWidth', 3 );
           h2=  histogram('BinCounts', mean(ShuffleHistogram),  'BinEdges', mean(edgesShuf), 'Normalization','probability','DisplayStyle','stairs', 'LineWidth', 3, 'EdgeColor', [0.5 0.5 0.5])
             
           
            x = mean(edgesShuf);
            % x = x(1:8);
             x = x(1:bins);
             upper = (mean(ShuffleHistogram) + SEM_data)/size(ShuffleData_PeaksTrans,2)
             lower = (mean(ShuffleHistogram) - SEM_data)/size(ShuffleData_PeaksTrans,2)

         patch([x fliplr(x)], [upper fliplr(lower)], [0.7 0.7 0.7],'EdgeColor', 'none', 'FaceAlpha', 0.5);
      
     
 
            xlim([0 3500])
            xticks(0:500:3500)
            xticklabels(0:1:7)
            ylim([0 0.6])
            xlabel(namex)
            ylabel('Probability')
            set(gca, 'FontSize', 20)
           
            for p = 1:bins
                xl = (500*p)-450;
                % if p_Peaks(p)< 0.05
                %       ptext = ['*'];
                % elseif p_Peaks(p)< 0.01
                %       ptext = ['**'];
                % elseif p_Peaks(p)< 0.001
                %       ptext = ['***'];
                % elseif p_Peaks(p) > 0.05
                %       ptext = ''
                % end
                 if p_Peaks(p)< 0.001
                      ptext = ['***'];
                       ptext = '♦'
                elseif p_Peaks(p)< 0.01
                      ptext = ['**'];
                elseif p_Peaks(p)< 0.05
                     ptext = ['*'];
                elseif p_Peaks(p) > 0.05
                      ptext = ''
                end
                      text(xl, 0.53, ptext, 'FontSize',26, 'Color', 'b') 
            end
           
             % legend({'Data', 'Shuffle'}, 'Location', 'best')
            T = ['TimeCellPeaks_Shuff_diamond_1000' namestr condStr trstr]
            savefig([ T '.fig'])
            print('-painters','-dpng',[ T],'-r600');
             print('-painters','-dpdf',[ T],'-r600');

end