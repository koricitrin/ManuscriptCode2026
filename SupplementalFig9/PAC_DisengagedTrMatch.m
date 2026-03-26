        
        
function PAC_DisengagedTrMatch(PACSessPath, DisengagedPaths, PubMatchPath)
 
    for k = 1:size(PACSessPath,1)  
         cd(PACSessPath(k,:));
         sess = PACSessPath(k,43:58);
        cluFile = [sess '_corrFluo.mat'];
        load(cluFile)
       
        load('RiseLastLickDownLickNeurons_thres.mat')
        tf = strcmp(sess,RiseLLDownLickNeuronID.rec_name(:,1));
        PAC_sess = RiseLLDownLickNeuronID.neu_id(tf,:);  
        
           % OverlapAll(k,:) = intersect( Clu.localClu, roiMatchData.allSessionMapping(:,1));
        %%Clu.localClu = suite2p ID 
        Suite2pIDTemp =     Clu.localClu(PAC_sess);
        Suite2p_ID_PAC{k} =Suite2pIDTemp;
        Suite2pIDTemp,PAC_sess

         IDs = [Suite2pIDTemp',PAC_sess];

        cd(PubMatchPath(k,:))
        load('RoiPubMatch.mat')
        if strcmp(PACSessPath(k,:), roiMatchData.allRois{1}(1:end-23)) == 1
        OverlapPACDisengagedSuite2pID = intersect(Suite2pIDTemp, roiMatchData.allSessionMapping(:,1));
        elseif strcmp(PACSessPath(k,:), roiMatchData.allRois{2}(1:end-23)) == 1
        OverlapPACDisengagedSuite2pID = intersect(Suite2pIDTemp, roiMatchData.allSessionMapping(:,2));
        end
        for n = 1:length(OverlapPACDisengagedSuite2pID)
         Ind =  find(IDs(:,1) == OverlapPACDisengagedSuite2pID(n)) 
        MatLabID_PAC_Overlap(n,:) =  IDs(Ind,2)
        end

        for n = 1:length(OverlapPACDisengagedSuite2pID)
         Ind =  find(roiMatchData.allSessionMapping(:,1) == OverlapPACDisengagedSuite2pID(n)) 
        DisengagedMatchSuite2p(n,:) =  roiMatchData.allSessionMapping(Ind,2)
        end

        cd(DisengagedPaths(k,:));
        sess = DisengagedPaths(k,43:58);
        cluFile = [sess '_corrFluo.mat'];
        load(cluFile)
        
        %%double checke this is right
        MatLabID_Disengaged_Overlap =     Clu.localClu(DisengagedMatchSuite2p);
     
       cd(PubMatchPath(k,:))
      save('OverlapPAC_Disengaged.mat', 'MatLabID_Disengaged_Overlap', 'MatLabID_PAC_Overlap')
      clearvars -except PACSessPath DisengagedPath PubMatchPath
    end

end