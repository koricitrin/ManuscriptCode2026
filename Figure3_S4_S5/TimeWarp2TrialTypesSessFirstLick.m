

function TimeWarp2TrialTypesSessFirstLick(FRProf, Paths)
  
cd('Z:\Kori\immobile_code\RiseDown\tables\2025-05to05\Variable\Path4sData\')
load('FirstLickMedSessions.mat')
        cd(FRProf)
        load('FRprofileTable_alignLastLickdffgfthres.mat')
        % load('FRprofileTable_alignLastLickdffgf.mat')
 
fs = 500; 
PrePost3545Cat = [];
PrePost56Cat = [];
warpedCa3545Cat = [];
warpedCa56Cat = [];
% ca_aligned : [T x N x Trials]
% time_aligned : [T x 1], e.g. -1:0.1:2
% lickLatency(tr) : time from cue to first lick for this trial
LTtarget =1;  % warp cue→lick to 1 second

 
% Choose how many samples you want in the warped trace
nWarp = 3000; %%change from 2500 3/12
warpTime = linspace(0, LTtarget, nWarp);  % warped timeline starting at cue
DataNormTogether = [];
Combinedata= [avgFR_profile_3545_NotNorm, avgFR_profile_56_NotNorm];
for neur = 1:size(avgFR_profile_3545_NotNorm,1) 
 DataNormTogether_temp =  (Combinedata(neur,:) - min(Combinedata(neur,:)))/(max(Combinedata(neur,:)) - min(Combinedata(neur,:)));
   DataNormTogether = [DataNormTogether; DataNormTogether_temp];
end
Avg3545s =  DataNormTogether(:,1:5000);
Avg56s =  DataNormTogether(:,5001:10000);
 
for k = 1:length(unique(rec_name))

sess = Paths{k}(1,43:58) 
IndexSess = strcmp(sess, rec_name);
for trtype = 1:2

    cueT = 0;
    if trtype == 1 
    lickT =  Med3545(k)*fs;
    ca_seg = Avg3545s(IndexSess,1501:end); %%remove the bef time

    seg_pre = Avg3545s(IndexSess,501:1500);
    seg_post = Avg3545s(IndexSess,lickT+1500:end);
    elseif trtype == 2
     lickT = Med56(k)*fs;
    ca_seg = Avg56s(IndexSess,1501:end);

    seg_pre = Avg56s(IndexSess,501:1500);
    seg_post = Avg56s(IndexSess,lickT+1500:end);
   
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
     warpedCa3545 =  warpedCa;
     warpedCa3545Cat = [warpedCa3545Cat; warpedCa3545];
     PrePost3545 = [(seg_pre), (warpedCa3545), (seg_post(:,1:500))];
     PrePost3545Cat = [PrePost3545Cat; PrePost3545];
    elseif trtype == 2
     warpedCa56 =  warpedCa;
     warpedCa56Cat = [warpedCa56Cat; warpedCa56];
      PrePost56 = [(seg_pre), (warpedCa56), (seg_post(:,1:500))];
      PrePost56Cat = [PrePost56Cat; PrePost56];
    end
   clear warpedCa seg_pre seg_post
end
end
save('TimewarpMatrixSessLick.mat', 'PrePost56Cat', 'PrePost3545Cat', 'warpedCa56Cat', 'warpedCa3545Cat')




 c = winter(10);
figure
hold on
 

Mean3545 = mean(PrePost3545Cat);
Mean3545Norm =  (Mean3545 - min(Mean3545))/(max(Mean3545) - min(Mean3545));
Mean56 = mean(PrePost56Cat);
Mean56Norm =  (Mean56 - min(Mean56))/(max(Mean56) - min(Mean56));

 avg_data = (Mean3545);
  x = 1:size(avg_data,2);
 std_data = std(PrePost3545Cat, 0,1,'omitnan')
 std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)],  'k', 'FaceAlpha',0.3)
plot(x, avg_data, 'k', 'LineWidth', 4)


 avg_data = (Mean56);
  x = 1:size(avg_data,2);
 std_data = std(PrePost56Cat, 0,1,'omitnan')
 std_data = std_data/ sqrt(15);
fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)],  [0 0.4470 0.7410], 'FaceAlpha',0.3)
plot(x, avg_data, 'Color', [0 0.4470 0.7410], 'LineWidth', 4)
% plot(mean(PrePost4555), 'LineWidth', 2, 'Color', c(7,:))
% plot(mean(PrePost56), 'LineWidth', 2, 'Color', c(10,:))
  % legend({'3-4s', '3.5-4.5s', '4.5-5.5s', '5-6s'}, 'Location', 'best')
 legend({'','3.5-4.5s', '','5-6s'}, 'Location', 'best')
 
xticks([0 1000 3500])
xticklabels({' ' 'Last Lick' 'First Lick'})
xlabel('Norm. time')
ylabel('dF/F')
ylim([0.1 0.8])
T = ['Time warped']
title(T)
TT = [ T 'SessLick'  ]
axis square
set(gca, 'FontSize', 16)
  savefig([ TT '.fig'])
  print('-painters','-dpng',[ TT],'-r600');
  print('-painters','-dpdf',[ TT],'-r600');



