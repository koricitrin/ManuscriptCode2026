function aligntsp2dat_smTr2P_imm(file,sampleFreq,lfpFreq,ChanNum, data_2p)


if exist([file '-whl.mat'], 'file') == 2
    disp('whl file already exists.')
    return;
else    
    %% get timestamps and positions from BTDT file
    load([file 'BTDT.mat']);
    
    timeStep = 1000/lfpFreq;
    timeStepSf = 1000/sampleFreq;
    
%     interpTsp(:,1) = 0:timeStepSf:behEventsTdt.TDTsyncMsecLfp(end); % in ms
%     whlDataLfp(:,1) = 0:timeStep:behEventsTdt.TDTsyncMsecLfp(end); % in ms
    
    interpTsp(:,1) = behEventsTdt.ArdSyncMsec; % in ms
    whlDataLfp(:,1) = 0:timeStep:behEventsTdt.ArdSyncMsecLfp(end)/lfpFreq*1000; % in ms
    
    behType = zeros(max(behEventsTdt.trialDescr(:,5)),1);
    trStartLfpIndArr = zeros(max(behEventsTdt.trialDescr(:,5)),1);
    trEndLfpIndArr = zeros(max(behEventsTdt.trialDescr(:,5)),1);
    trackLenArr = zeros(max(behEventsTdt.trialDescr(:,5)),1);
    
    
    %% interpolate the running distance for each trial
    disp('interpolate the running distance for each trial')
    for tr = 1:max(behEventsTdt.trialDescr(:,5))
        indTaskDescr = find(behEventsTdt.taskDescr(:,4) < ...
                behEventsTdt.trialDescr(tr,4),1,'last');
        trackLenArr(tr) = behEventsTdt.movieTDescr{indTaskDescr}(2); % just using delay time for tracklen 
        behType(tr) = 1;
        
        trStartLfpIndArr(tr) = behEventsTdt.taskDescr(indTaskDescr,4);           
        trEndLfpIndArr(tr) = behEventsTdt.trialDescr(tr,4);
        
        disp(tr);
    end
    
    twoPTime = behEventsTdt.ArdSyncMsec;
    twoPTimeLfp = behEventsTdt.ArdSyncMsecLfp;
   
    % interpolate the 2p data
    load([file '_corrFluo.mat'],'Clu','dFF');
    cluNo = Clu.localClu;
    interpTspF = zeros(length(cluNo), length(whlDataLfp));
    interpTspFneu = zeros(length(cluNo),length(whlDataLfp));
    interpTspSpks = zeros(length(cluNo), length(whlDataLfp));
    interpTspdFF = zeros(length(cluNo), length(whlDataLfp));
      
    disp('interpolate the neural data')
    for n = 1:length(cluNo) % range all the cells
        i = cluNo(n);
        for j = 1:(length(twoPTimeLfp)-1)
%           range of arduinoarcsync

%           interpolate in between
            interpF = interp1([twoPTimeLfp(j) (twoPTimeLfp(j+1))],...
                    [data_2p.F(i, j) data_2p.F(i, j+1)],...
                    twoPTimeLfp(j)+1:(twoPTimeLfp(j+1)),'linear');
            interpTspF(n, twoPTimeLfp(j)+1:twoPTimeLfp(j+1)) = interpF;

            interpFneu = interp1([twoPTimeLfp(j) (twoPTimeLfp(j+1))],...
                    [data_2p.Fneu(i, j) data_2p.Fneu(i, j+1)],...
                    twoPTimeLfp(j)+1:(twoPTimeLfp(j+1)),'linear');
            interpTspFneu(n, twoPTimeLfp(j)+1:twoPTimeLfp(j+1)) = interpFneu;

            interpSpks = interp1([twoPTimeLfp(j) ( twoPTimeLfp(j+1))],...
                    [data_2p.spks(i, j) data_2p.spks(i, j+1)],...
                    twoPTimeLfp(j)+1:(twoPTimeLfp(j+1)),'linear');
            interpTspSpks(n, twoPTimeLfp(j)+1:twoPTimeLfp(j+1)) = interpSpks;
            
            interpdFF = interp1([twoPTimeLfp(j) (twoPTimeLfp(j+1))],...
                    [dFF(n, j) dFF(n, j+1)],...
                    twoPTimeLfp(j)+1:(twoPTimeLfp(j+1)),'linear');
            interpTspdFF(n, twoPTimeLfp(j)+1:twoPTimeLfp(j+1)) = interpdFF;

%             now repeat for Fneu and spikes (and also get the total num of
%             frames between the first and last recorded/saved FMs for
%             step_2p
        end  
    end
    
%     disp(['Samples in .dat file per channel: ' int2str(DatLength)]);
    disp(['Lines in interpTsp:' int2str(size(interpTsp,1))]);
    disp(['Lines in whlDataLfp:' int2str(size(whlDataLfp,1))]);

    %save it
    disp('save data')
    save([file '-whl.mat'], 'whlDataLfp','interpTsp','behType',...
         'trStartLfpIndArr','trEndLfpIndArr', 'trackLenArr', ...
         'interpTspF','interpTspFneu','interpTspSpks','interpTspdFF','-v7.3');
end
