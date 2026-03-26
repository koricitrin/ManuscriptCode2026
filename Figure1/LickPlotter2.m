

% %%Run ImmobileLickRec for the session first 
% %%Align Cue
function LickPlotter2(path, good, delay, rewOmission, cue) 
%%ex. LickPlotter2('Z:\yihan\immobile2p\anmj002\A002-20240807\A002-20240807-02\', 1, 2)
%good =1 , bad = 2, All = 0

if (delay == 2)
delay = 2
pumpvalue = 3.9
xval = 6;
elseif (delay == 3)
delay = 3
pumpvalue = 4.9
xval = 6;
elseif (delay == 4)
delay = 4
pumpvalue = 5.95
xval = 8;
end
    
    for k = 1:size(path,1)
        lickpath =  path(k,:);
        cd(lickpath);
          sessname = path(1,43:end-13)
          sessname = path(k,43:end-1)
        LickFile = [sessname '_DataStructure_mazeSection1_TrialType1_alignCue_msess1.mat']; 
         load(LickFile);
       
         if rewOmission == 1
            load('RewardOmissionTrInd.mat')
         end
    
        Licks = trialsCue.lickLfpInd;
        Start = trialsCue.startLfpInd;
        End = trialsCue.endLfpInd;
        Pump = trialsCue.pumpLfpInd;
    
            for i = 2:size(Start,2)
              LickTemp =  Licks{i} - Start(i);
              AllLick{i} = LickTemp/500;
                 if  isempty(Pump{i}) 
                    continue
                 end
                RewTemp =  Pump{i}(1) - Start(i); 
                RewDel{i} = RewTemp/500;
            end
            
            for i = 2:size(Start,2)
              if  isempty(Pump{i}) 
                    continue
              else
                  BO = End(i) - Pump{i}(1);
                  BlackOut(i,:) =  BO/500;
             end
        
            end
    
    

        InfoPath = [lickpath sessname '_DataStructure_mazeSection1_TrialType1_Info.mat']
        load(InfoPath)
      

        
     if (good == 1)
         Trials = (beh.indGoodTrCtrl);
         titleStr = 'GoodTr';
     elseif  (good == 2)  
          Trials = (beh.indBadTrCtrl);
           titleStr = 'BadTr';
    
     elseif (good == 0)
         Trials = beh.indTrCtrl;
           titleStr = 'All';
      elseif (good == 4)
         Trials = beh.indUnRewTrCtrl;
           titleStr = 'UnRewTr';     
      elseif (good == 5)
             load('RewardOmissionTrInd.mat')
         Trials =  sort([RewOmissionTr , RewOmissionTr(1:end-1)+1]);
           titleStr = 'UnRewTrNext'; 
  
       elseif (good == 6)
         load('ValidTr_FirstLastLick.mat')
         Trials =  ValidTrAll';
         titleStr = 'ValidFLLLCon'; 
     end    
     
        foldername = ['LickPlot' titleStr]
          mkdir(foldername)
          savepath = [lickpath foldername]
          cd(savepath)
          
        figure
        hold on
        xlim ([0,xval])
        xticks([0:1:xval]);
        count = 0;
      % Trials = 1 %custom select trials
         for j = 1:size(Trials,2) 
             count = [count  + 1];
              i = Trials(count);
             isaninteger = @(x)isfinite(x) & x==floor(x);
             numFigs = j/10;
       if isaninteger(numFigs) == 1 
            T = [titleStr ' Trials']
            xlim ([0,xval])
            xticks([0:1:xval]);
            savename = [T 'LickPlot' num2str(j)]
            print('-painters','-dpng',[savename],'-r600')
           savefig([savename '.fig'])
           figure
           hold on
           xlim ([0,xval]) 
       end
          
        pump = RewDel{i};
        
        if isempty(pump)
           pump = delay + 2; %2000 for 1000sc and 1000rw
        end
       
        ends = pump + BlackOut(i);
        % ends = pump + 2;
        x2 = [pump+ 0.35, ends, ends, pump+0.35];
        x4 = [pump, ends, ends, pump]; 
        y2 = [j, j, j+1, j+1];
        
        x3 = [pump, pump + 0.35, pump + 0.35, pump]; 
        if rewOmission == 0 & cue == 1 
            if pump< pumpvalue 
             patch(x3, y2,'black', 'FaceColor', 'cyan', 'FaceAlpha', 0.9, 'EdgeColor', 'none'); %%blue bar for rew
             patch(x2, y2,'black', 'FaceColor', 'blue', 'FaceAlpha', 0.2, 'EdgeColor', 'none'); %%blackout
            else   
                patch(x4, y2,'black', 'FaceColor',  'blue', 'FaceAlpha', 0.2, 'EdgeColor', 'none');  %%blackout
            end
        elseif rewOmission == 0 & cue == 0
            if pump< pumpvalue 
             patch(x3, y2,'black', 'FaceColor', 'cyan', 'FaceAlpha', 0.9, 'EdgeColor', 'none'); %%blue bar for rew
    
            end    
        elseif rewOmission == 1 & cue == 1 
            if ~isempty(intersect(j, RewOmissionTr))
            pumptemp = pump-1;
            x3 = [pumptemp, pumptemp + 1, pumptemp + 1, pumptemp]; 
            x2 = [pump, ends, ends, pump];
            patch(x3, y2,'black', 'FaceColor', [ 0.6350    0.0780    0.1840], 'FaceAlpha', 0.7, 'EdgeColor', 'none'); %%red bar for rew omission
             patch(x2, y2,'black', 'FaceColor', 'blue', 'FaceAlpha', 0.2, 'EdgeColor', 'none'); %%blackout
            elseif pump< pumpvalue &   isempty(intersect(j, RewOmissionTr))
             patch(x3, y2,'black', 'FaceColor', 'cyan', 'FaceAlpha', 0.9, 'EdgeColor', 'none'); %%blue bar for rew
            patch(x2, y2,'black', 'FaceColor', 'blue', 'FaceAlpha', 0.2, 'EdgeColor', 'none'); %%blackout
            else
              patch(x4, y2,'black', 'FaceColor',  'blue', 'FaceAlpha', 0.2, 'EdgeColor', 'none');  %%blackout
            end
         elseif rewOmission == 1 & cue == 0
            if ~isempty(intersect(j, RewOmissionTr))
            pumptemp = pump-1;
            x3 = [pumptemp, pumptemp + 1, pumptemp + 1, pumptemp]; 
            x2 = [pump, ends, ends, pump];
            patch(x3, y2,'black', 'FaceColor', 'red', 'FaceAlpha', 0.6, 'EdgeColor', 'none'); %%red bar for rew omission
            elseif pump< pumpvalue &   isempty(intersect(j, RewOmissionTr))
             patch(x3, y2,'black', 'FaceColor', 'cyan', 'FaceAlpha', 0.9, 'EdgeColor', 'none'); %%blue bar for rew
            end
        end    
             data = AllLick{i};
            x = data;
            x2 = x;
            y = j;
            y2 = j+1;
            lick = [x x2];
            tr = [y y2];
            if ~isempty(lick)
            plot(lick,tr, 'Color','m')
            end
          % num2str(round(SelIndex(i),2))
          % 
          %  txt = num2str(round(SelIndex(i),2));
          %  ptext = text(1,y+0.5,txt);
          %  ptext.FontSize = 15  ;
    ylabel('Trials', 'FontSize', 22);
    %xlabel('Time from cue onset (s)', 'FontSize', 22);
    xlabel('Time (s)', 'FontSize', 22);
     xticks([0:1:xval]);
    xticklabels({'0' '1' '2' '3' '4' '5' '6' '7'});
    xlim([0 xval])
    % yticklabels({'0' '1' '2' '3' '4' '5'});
    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',16)
    x = [0, 1, 1, 0];
    y = [j, j, j+1, j+1];
    if cue == 1
      patch(x, y,'black', 'FaceColor', 'black' , 'FaceAlpha', 0.3,'EdgeColor', 'none'); %%for cue 
    end
    yticks = ([min(Trials):1:max(Trials)]);
    % %k = trials(end);
    % ylim([trials(1), (k+1)])
    
    %yticks(min(trials):1:(k+1));
    %      clear y data
        T = [titleStr ' Trials'];
        title(T, 'FontSize', 20);
        a = get(gca,'XTickLabel'); 
         end
              T = [titleStr ' Trials'];
     savename = [T 'LickPlot' num2str(j)]
    print('-painters','-dpng',[savename],'-r600')
    savefig([savename '.fig'])
    close all
    end
    clear pump pumptemp
    clearvars -except delay pumpvalue xval path good rewOmission cue 
 
end
  
