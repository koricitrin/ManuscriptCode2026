FRProf = ['Z:\Kori\RunningTask2pCode\RiseDown\FR_profiles\ZY\'] 
cd(FRProf)
        load('FRprofileTable_alignLastLickPAC.mat') 
 
fs = 500; 

% ca_aligned : [T x N x Trials]
% time_aligned : [T x 1], e.g. -1:0.1:2
% lickLatency(tr) : time from cue to first lick for this trial
LTtarget = 1;  % warp cue→lick to 1 second

% [T, N, nTrials] = size(ca_aligned);
LTtarget = 1;

% Choose how many samples you want in the warped trace
nWarp = 2250; %%change from 2500 3/12
warpTime = linspace(0, LTtarget, nWarp);  % warped timeline starting at cue
DataNormTogether = [];
Combinedata= [avgFR_profile_23_NotNorm, avgFR_profile_3545_NotNorm];
for neur = 1:size(avgFR_profile_3545_NotNorm,1) 
 DataNormTogether_temp =  (Combinedata(neur,:) - min(Combinedata(neur,:)))/(max(Combinedata(neur,:)) - min(Combinedata(neur,:)));
   DataNormTogether = [DataNormTogether; DataNormTogether_temp];
end
AvgEarly =  DataNormTogether(:,1:5000);
AvgLate =  DataNormTogether(:,5001:10000);

for trtype = 1:2


    cueT = 0;
    if trtype == 1 
    lickT =  2.585*fs;
   
    ca_seg = AvgEarly(:,1501:end); %%remove the bef time

    seg_pre = AvgEarly(:,501:1500);
    seg_post = AvgEarly(:,lickT+1500:end);
    elseif trtype == 2
     lickT = 3.814*fs;

    ca_seg = AvgLate(:,1501:end);

    seg_pre = AvgLate(:,501:1500);
    seg_post = AvgLate(:,lickT+1500:end);
   
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
     warpedCaEarly =  warpedCa;
     PrePostEarly = [(seg_pre), (warpedCaEarly), (seg_post)];
    elseif trtype == 2
     warpedCaLate =  warpedCa;
      PrePostLate = [(seg_pre), (warpedCaLate), (seg_post)];
     
    end
   clear warpedCa seg_pre seg_post
end

save('TimewarpMatrix2250.mat', 'warpedCaEarly', 'warpedCaLate', 'PrePostEarly', 'PrePostLate')




 c = winter(10);
figure
hold on
 

MeanEarly = mean(PrePostEarly);
MeanLate = mean(PrePostLate);
Mean56Norm =  (MeanLate - min(MeanLate))/(max(MeanLate) - min(MeanLate));

 avg_data = (MeanEarly);
  x = 1:size(avg_data,2);
 std_data = std(PrePostEarly, 0,1,'omitnan')
 std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)],  'k', 'FaceAlpha',0.3)
plot(x, avg_data, 'k', 'LineWidth', 4)


 avg_data = (MeanLate);
  x = 1:size(avg_data,2);
 std_data = std(PrePostLate, 0,1,'omitnan')
 std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)],  [0 0.4470 0.7410], 'FaceAlpha',0.3)
plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth', 4)
 
 legend({'','2-3s', '','3.5-4.5'}, 'Location', 'best')
xticks([0 1000 3500])
xticklabels({' ' 'Last Lick' 'First Lick'})
xlabel('Norm. time')
ylabel('dF/F')
ylim([0.1 0.8])
T = ['Time warped']
title(T)
TT = [ T 'normTogether'  ]
axis square
set(gca, 'FontSize', 16)
  savefig([ TT '.fig'])
  print('-painters','-dpng',[ TT],'-r600');
  print('-painters','-dpdf',[ TT],'-r600');

