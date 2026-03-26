%segment trials 2 

function SegmentTrialsPAC(EngagedPaths, DisengagedPaths, Cond)

    for k = 1:size(EngagedPaths,1)
        EngagedPath =  EngagedPaths(k,:)
         path = DisengagedPaths(k,:)
         cd(path)
         sess = path(1,43:58)
         load([sess 'BTDT.mat'])
         Licks = behEventsTdt.lick(:,4);
         Pump = behEventsTdt.pump(:,4);
         load([sess '-whl.mat'])
         Dff = interpTspdFF;
        dFFGF = [];
        
        
        BasePath =  path(1:end-17)
        cd(BasePath)
        
        load('OverlapPAC_Disengaged.mat')
          foldername = ['Disengaged Engaged Plots'];   
          mkdir(foldername)  
          savepaths = [BasePath foldername]
        
        
        Dff = Dff(MatLabID_Disengaged_Overlap, :);
        
            param.threStd = 3;
            param.prctile = 90;
            param.stdsm = 100 %changed 6/25
            h = gaussFilter2P(12*param.stdsm,param.stdsm); %change 6/25/24
            lenGaussKernel = length(h);
             for i = 1:size(Dff,1)
                dFFGF(i,:) = gauss_filter(Dff(i,:),h,lenGaussKernel);
                % figure
                % hold on
                % plot(Dff(i,:))
                % plot(dFFGF(i,:))
        
             end 

        Dff = dFFGF;
        %%find trial boundary time points where there is a diff of 6s between licks. 
        BoundaryIndTimeTemp = [];
               for j = 1:length(Licks)-1
                  Diff =  Licks(j+1) - Licks(j);
                  if (Diff > 1500) & (Diff < 3000)  %%greater than 3s and less than 6s
                       BoundaryIndTimeTemp = [BoundaryIndTimeTemp; Licks(j)  Licks(j+1)]; %%LickTr == LL, LickTr(j+1) == F
        
                  end
        
               end
        
        BoundaryIndTime = [];
        Keep = [];
               for B = 1:length(BoundaryIndTimeTemp)-1
                   DiffBound = BoundaryIndTimeTemp(B+1,1) - BoundaryIndTimeTemp(B,2); 
                   if DiffBound< 500 %lick bout lasts at least 1s
                       continue
                   else
                        Keep = [Keep; B, B+1]
                   end

               end

               
               keeps = unique(Keep);
             BoundaryIndTime = BoundaryIndTimeTemp(keeps,:)
     
 

            count = 0
        Segments = []
         for Segments = 1:size(BoundaryIndTime,1)-1
             
             % LicksTr_LL_log_bef = (Licks > BoundaryIndTime(Segments,1)-1000) & (Licks < BoundaryIndTime(Segments,1)) %
          LicksTr_LL_log_bef = (Licks > BoundaryIndTime(Segments,1)-500) & (Licks < BoundaryIndTime(Segments,1))%change to 500 2/12

         % LicksTr_LL_log_aft = (Licks < BoundaryIndTime(Segments,2)+1000) & Licks > BoundaryIndTime(Segments,2);
          LicksTr_LL_log_aft = (Licks < BoundaryIndTime(Segments,2)+500) & Licks > BoundaryIndTime(Segments,2); %change to 500 2/12
              Bout_preNum = sum(LicksTr_LL_log_bef)
             Bout_postNum = sum(LicksTr_LL_log_aft)

             if  (Bout_preNum <5 || Bout_postNum < 5)
                 'exclude'
                 continue
             else
                 count = count + 1
             end
             DffTrLastLickAlign_bef{Segments,:}  = Dff(:,BoundaryIndTime(Segments,1)-1000:BoundaryIndTime(Segments,2)+2000);
            
             LicksTr_LL_log= (Licks > BoundaryIndTime(Segments,1)-1000) &  (Licks < BoundaryIndTime(Segments,2)+1000); 
            
             LicksTr_LLBef{Segments,:} = Licks(LicksTr_LL_log);
          
             clear LicksTr_LL_log
            
         end

        
        %%disengaged array align last lick
        SegNum = [];
        NeurMat = [];
        for neur =  1:length(MatLabID_Disengaged_Overlap)
            count = 0;
            for tr = 1:length(DffTrLastLickAlign_bef)
                %%removes trs from array that are 0 (ie less than 5 licks)
                if isempty(DffTrLastLickAlign_bef{tr})
                    continue
                end
                count = [count+1]
                SegNum = [SegNum, tr];
                 NeurMat(count,:) =  DffTrLastLickAlign_bef{tr}(neur,1:4500); %%take from 0 which is -1000 to 1000 (-2 to 4s after LL)
            end

           NeurMat_Mean =  mean(NeurMat);
           PAC_OverLapBefLL(neur,:) =  (NeurMat_Mean -  min(NeurMat_Mean,[],'all'))./( max(NeurMat_Mean,[],'all') -  min(NeurMat_Mean,[],'all'));
          R = (corrcoef(NeurMat.'));
           U = triu(R);
          CorrTemp = U(~isnan(U));
          CorrTemp2 = nonzeros(CorrTemp);
          Corr = CorrTemp2(CorrTemp2~=1);
          MeanCorrNeur(neur,:) =  mean(Corr);
        
           % figure 
           % plot((NeurMat_Mean))
           % title(['neuron' num2str(neur)])
           % xline(1000)
           % xlabel(' Time from last lick (s)')
        end
        count
         cd(savepaths)
          figure
          hold on
          imagesc(PAC_OverLapBefLL)
          colormap(flipud(gray))
          xline(1000, '--',  'LineWidth', 3, 'Color', 'm')
          xlim([1 3500])
          ylim([0 size(PAC_OverLapBefLL,1)])
            xticks(0:500:5000)
          xticklabels({'-2' '-1' '0' '1' '2' '3' '4' '5'})
          xlabel(' Time from last lick (s)')
           T = ('Disengaged Array - last lick')
            title(T)
           savefig([T '.fig'])
           print('-painters','-dpng', [T '.png'], '-r600')
        save('DisengagedArray_LastLick1sPreLicks.mat', 'PAC_OverLapBefLL')
        save('DisengagedArray_LastLickCorr1sPreLicks..mat', 'MeanCorrNeur')
        
        %% disengaged array align lick
        
         BoundaryIndTimeFilt = BoundaryIndTime(unique(SegNum),:);
         for Segments = 2:size(BoundaryIndTimeFilt,1)-1

             DffTrFirstLickAlign_bef{Segments,:}  = Dff(:,BoundaryIndTimeFilt(Segments,2)-1000:BoundaryIndTimeFilt(Segments+1,1)+2000);
             LicksTr_Lick_log =  (Licks > BoundaryIndTimeFilt(Segments,2)-1000) &   (Licks < BoundaryIndTimeFilt(Segments+1,1)+1000); 
             LicksTr_FirstLickBef{Segments,:} = Licks(LicksTr_Lick_log);
             clear LicksTr_Lick_log
             LicksTr_Lick_log =  (Licks > BoundaryIndTimeFilt(Segments,2)) &   (Licks < BoundaryIndTimeFilt(Segments+1,1)); 
             LicksTr_FirstLick{Segments,:} = Licks(LicksTr_Lick_log);
             clear LicksTr_Lick_log
         end

        for neur =  1:length(MatLabID_Disengaged_Overlap)
            for tr = 2:length(DffTrFirstLickAlign_bef)
                 NeurMatLick(tr,:) =  DffTrFirstLickAlign_bef{tr}(neur,1:3000); %%take from 0 which is -1000 to 1000 (-2 to 2s after LL)
            end
            NeurMatLick_Mean =  mean(NeurMatLick);
           PAC_OverLapBefLick(neur,:) =  (NeurMatLick_Mean -  min(NeurMatLick_Mean,[],'all'))./( max(NeurMatLick_Mean,[],'all') -  min(NeurMatLick_Mean,[],'all'));
               
        
        end
        
        
          figure
          hold on
          imagesc(PAC_OverLapBefLick)
          colormap(flipud(gray))
          xline(1000, '--',  'LineWidth', 3, 'Color', 'm')
          xlim([1 4000])
          ylim([0 size(PAC_OverLapBefLick,1)])
          xticks(0:500:4000)
          xticklabels({'-2' '-1' '0' '1' '2' '3' '4'})
          xlabel(' Time from first lick (s)')
          T = ('Disengaged Array - first lick')
            title(T)
        
           savefig([T '.fig'])
           print('-painters','-dpng', [T '.png'], '-r600')
        save('DisengagedArray_FirstLickPreLicks1s.mat', 'PAC_OverLapBefLick')
        

          % engaged array
              cd(EngagedPath)
            load('RiseLastLickDownLickNeurons_thres.mat')

            if Cond == 1
            load('FRprofileTable_alignLastLickdffgfthres.mat', 'avgFR_profile')
            xname = 'Time from last lick (s)'
            elseif Cond == 2
            load('FRprofileTable_alignLickdffgfthres.mat', 'avgFR_profile')
            end

            Overlap = intersect(MatLabID_PAC_Overlap, RiseLLDownLickNeuronID.neu_id');
            TotalN = 1:length(RiseLLDownLickNeuronID.neu_id);
            for ov = 1:length(Overlap)
              Log =  (RiseLLDownLickNeuronID.neu_id == Overlap(ov))
               IndexArray(ov,:) = TotalN(Log);
            end

            EngArray = avgFR_profile(IndexArray,:);

         figure
          hold on 
          imagesc(EngArray)
          colormap(flipud(gray))
          xline(1500, '--',  'LineWidth', 3, 'Color', 'm')
          xlim([500 5000])
          ylim([0 size(EngArray,1)])
          xticklabels({'-2' '-1' '0' '1' '2' '3' '4' '5' '6' '7'})
          xlabel('Time (s)')
            T = ('EngagedArray - last lick')
            title(T)
         savefig([T '.fig'])
           print('-painters','-dpng', [T '.png'], '-r600')
        save('EngagedArray_LastLick.mat', 'EngArray')

        clear EngArray
  % cd(EngagedPath)
  %           load('FRprofileTable_alignLickdffgfthres.mat', 'avgFR_profile')
  %           xname = 'Time from first lick (s)'
  % 
  % 
  %           EngArray = avgFR_profile(IndexArray,:);
  % 
  %        figure
  %         hold on 
  %         imagesc(EngArray)
  %         colormap(flipud(gray))
  %         xline(1500, '--',  'LineWidth', 3, 'Color', 'm')
  %         xlim([500 5000])
  %         ylim([0 size(EngArray,1)])
  %         xticklabels({'-2' '-1' '0' '1' '2' '3' '4' '5' '6' '7'})
  %         xlabel(xname)
  %           T = ('EngagedArray - first lick')
  %           title(T)
  %        savefig([T '.fig'])
  %          print('-painters','-dpng', [T '.png'], '-r600')
  %       save('EngagedArray_FirstLick.mat', 'EngArray')
        clearvars -except EngagedPaths DisengagedPaths Cond
        end
end

