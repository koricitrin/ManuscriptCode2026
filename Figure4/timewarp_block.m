FRProf = ['Z:\Kori\immobile_code\BlockDelay\RiseDown\FR_Profiles\OverlapPAC\'] 
cd(FRProf)
       load('DataNormTogetherBlock_AllPAC.mat')
 
fs = 500; 

% ca_aligned : [T x N x Trials]
% time_aligned : [T x 1], e.g. -1:0.1:2
% lickLatency(tr) : time from cue to first lick for this trial
LTtarget = 1;  % warp cue→lick to 1 second

% [T, N, nTrials] = size(ca_aligned);
LTtarget = 1;

% Choose how many samples you want in the warped trace
nWarp = 3000;
warpTime = linspace(0, LTtarget, nWarp);  % warped timeline starting at cue
 
Avg3s = Block3sArrayNormTogether_PAC;
Avg5s = Block5sArrayNormTogether_PAC;

for trtype = 1:2


    cueT = 0;
    if trtype == 1 
    lickT =  3.605*fs;
    % lickT = 5.47*fs;

    ca_seg = Avg3s(:,1501:end); %%r
    % emove the bef time
    seg_pre = Avg3s(:,501:1500);
     seg_post = Avg3s(:,lickT+1500:lickT+2500);
 
    
    elseif trtype == 2
    lickT = 4.608*fs;
    % lickT = 7.4*fs;

    ca_seg = Avg5s(:,1501:end);

    seg_pre = Avg5s(:,501:1500);
     seg_post = Avg5s(:,lickT+1500:lickT+2500);
   
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
     warpedCa3s =  warpedCa;
      PrePost3s = [(seg_pre), (warpedCa3s), (seg_post)];
     % PrePost3s = [(seg_pre), (warpedCa3s)];
    elseif trtype == 2
     warpedCa5s =  warpedCa;
       PrePost5s = [(seg_pre), (warpedCa5s), (seg_post)];
     % PrePost5s = [(seg_pre), (warpedCa5s)];
    end
   clear warpedCa seg_pre seg_post
end

save('TimewarpMatrixDelay3000.mat', 'warpedCa3s', 'warpedCa5s', 'PrePost3s', 'PrePost5s')



 c = winter(10);
figure
hold on
 

Mean3s= mean(PrePost3s);
Mean5s = mean(PrePost5s);
 
 avg_data = (Mean3s);
  x = 1:size(avg_data,2);
 std_data = std(PrePost3s, 0,1,'omitnan')
 std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)],  'k', 'FaceAlpha',0.3)
plot(x, avg_data, 'k', 'LineWidth', 4)


 avg_data = (Mean5s);
  x = 1:size(avg_data,2);
 std_data = std(PrePost5s, 0,1,'omitnan')
 std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)],  [0 0.4470 0.7410], 'FaceAlpha',0.3)
plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth', 4)
% plot(mean(PrePost4555), 'LineWidth', 2, 'Color', c(7,:))
% plot(mean(PrePost56), 'LineWidth', 2, 'Color', c(10,:))
  % legend({'3-4s', '3.5-4.5s', '4.5-5.5s', '5-6s'}, 'Location', 'best')
 legend({'','3sBlocks', '','5s Block'}, 'Location', 'best')
xticks([0 1000 4000])
xlim([0 5000])
xticklabels({' ' 'Last Lick' 'First Lick'})
xlabel('Norm. time')
ylabel('dF/F')
ylim([0 1])
T = ['Time warped']
title(T)
TT = [ T 'normTogether' 'Lick']
axis square
set(gca, 'FontSize', 16)
  savefig([ TT '.fig'])
  print('-painters','-dpng',[ TT],'-r600');
  print('-painters','-dpdf',[ TT],'-r600');



