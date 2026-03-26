%% -----------------------------
%  Linear Time-Warp Calcium Data
%  Based on Cue → First-Lick Latency
% ------------------------------

 
path = ['Z:\Kori\immobile_code\Ephys\RiseDown\FRprofiles\PAC\0217\']
cd(path)
load('FR_ArrayNormTogether_-2-9.mat')

    save_path2 = ['Z:\Kori\immobile_code\Ephys\RiseDown\FRprofiles\PAC\0217\'];

    cd(save_path2)


fs = 1250; 

 timeStepRunNew = timeStepRun/1250;
 
LTtarget = 1;

avgFR_profile_4555_pre = AvgFR_4555(:,find(timeStepRunNew == -2):find(timeStepRunNew == 0));
FR_Array_sorted_4555 =  AvgFR_4555(:,find(timeStepRunNew == 0):find(timeStepRunNew == 7));
avgFR_profile_67_pre = AvgFR_67(:,find(timeStepRunNew == -2):find(timeStepRunNew == 0)); %-2 to 0 
FR_Array_sorted_67 =  AvgFR_67(:,find(timeStepRunNew == 0):find(timeStepRunNew == 7));
 

% Choose how many samples you want in the warped trace
nWarp =  find(timeStepRunNew == 5) - find(timeStepRunNew == 0);
   warpTime = linspace(0, LTtarget, nWarp);  % warped timeline starting at cue

for trtype = 1:2

   Bin1s = 400;
    cueT = 0;
    if trtype == 1 
       lickT =    round(5.163*400); 

         LickTimeInd =     dsearchn(timeStepRunNew(:),lickT);
         PostEnd = LickTimeInd + Bin1s*2;
         LickTimeInd = find(timeStepRun == 5125);
          PostEnd = LickTimeInd + Bin1s*2;
        
         ca_seg = FR_Array_sorted_4555(:,1:lickT);
         seg_pre =  avgFR_profile_4555_pre;
         seg_post = FR_Array_sorted_4555(:,lickT:lickT+200);
        elseif trtype == 2
        lickT =  round(6.37*400);
        ca_seg = FR_Array_sorted_67(:,1:lickT);
        seg_pre = avgFR_profile_67_pre;
        seg_post = FR_Array_sorted_67(:,lickT:lickT+200);
    end
       t_orig =  1:length(ca_seg)

    LTtrial = lickT;   % cue→lick latency

    if LTtrial <= 0 || isnan(LTtrial)
        continue
    end

    % % -------- FEED ONLY POST-CUE TIMES --------
    % idx_post = find(time_aligned >= 0);
    % 
    % t_orig = time_aligned(idx_post);              % post-cue times
    % ca_seg = squeeze(ca_aligned(idx_post,:,tr));  % [postSamples x neurons]

    % -------- Compute warped time axis --------
    t_warp = t_orig * (LTtarget / LTtrial);

    % -------- Warp calcium by interpolation --------
    for neur = 1:size(ca_seg) 
    warpedCa(neur,:) = interp1(t_warp, ca_seg(neur,:), warpTime, 'linear', 'extrap');
    end

    if trtype == 1 
     warpedCa4555=  warpedCa;
       PrePost4555 = [(seg_pre), (warpedCa4555), (seg_post)];
         % % WarpPost4555 = [ (warpedCa4555), (seg_post)];
     elseif trtype == 2
      warpedCa67 =  warpedCa;
     PrePost67 = [(seg_pre), (warpedCa67), (seg_post)];
       % % WarpPost67 = [(warpedCa67), (seg_post)];
    end
   clear warpedCa seg_pre seg_post
end


 c = winter(10);
figure
hold on

avg_data = (mean(PrePost4555));
  x = 1:size(avg_data,2);
 std_data = std(PrePost4555, 0,1,'omitnan')
 std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], 'k', 'FaceAlpha',0.3)
plot(x, avg_data, 'Color', 'k', 'LineWidth', 3)

 avg_data = (mean(PrePost67));
  x = 1:size(avg_data,2);
 std_data = std(PrePost67, 0,1,'omitnan')
 std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)],  [0 0.4470 0.7410], 'FaceAlpha',0.3)
plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth', 3)
 ylim([0 0.7])
 yticks(0:0.2:0.8)
  
 xlim([0 size(PrePost67,2)])
 FL = (5*400)+801;
xticks([801 FL])
xticklabels({'Last Lick', 'First Lick'})
legend({'','4.5-5.5', '','6-7s'}, 'Location', 'best')

xlabel('Norm time to first lick')
ylabel('Spikes')
T = ['PAC time' ...
    ' warped']
title(T)
TT = [ T '4555-67' 'NormTogether_bef_L']
axis square
set(gca, 'FontSize', 16)
  savefig([ TT '.fig'])
  print('-painters','-dpng',[ TT],'-r600');
  print('-painters','-dpdf',[ TT],'-r600');

  