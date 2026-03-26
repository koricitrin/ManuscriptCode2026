function [Spike Clu Track Laps xml] = GenerateBehav2PDataStructures_smTrMPFI2Pv1_immSTD100(TwoPhotonPaths, isInt)
%GenerateBehav2PDataStructures_smTrMPFI2Pv1_immSTD100('Z:\Kori\immobile_2p\anmc164\A164-20230902\A164-20230902-05\suite2p\plane0\Fall.mat','Z:\Kori\immobile_2p\anmc164\A164-20230902\A164-20230902-05\','A164-20230902-05',0)


for j = 1:size(TwoPhotonPaths,1)
    
     TwoPhotonPath1 =  TwoPhotonPaths(j,:);
    TwoPhotonPath = [TwoPhotonPath1 'suite2p\plane0\Fall.mat']
     BehaviorPath = TwoPhotonPaths(j,:);
      FileNameBase =    TwoPhotonPaths(j,43:58);
     
%%  
cd(BehaviorPath); 
  
data_2p = load(TwoPhotonPath);      
            % get recording file information from the xml file
    % if uncommmenting the following line, make sure to change method
    % signature to include FileNameBaseList
nChannels = 0;
        % total number of recording channels    
SampleRate = data_2p.ops.fs; %???
        % recording sampling rate (default: 20,000 Hz)
lfpSampleRate = 500;
        % local field potential sampling rate (default: 1250 Hz)
    
 
    % load behavior file
fprintf(['\nLoad behavior file and align the event time between '...
            'behavior and recording\n']);
check = Arduino2RecordT_smTr2P_imm(FileNameBase,SampleRate,lfpSampleRate,data_2p);

if(check == 1)
    return;
end

% % extract clusters and calculate corrected calcium fluorescence
fprintf('\n Extract clusters and calculate corrected calcium fluorescence... \n')
calCorrectedFluo_imm(FileNameBase,data_2p,isInt);

% align tracking data with .dat file
fprintf('\nAlign tracking data with .dat file...\n')
aligntsp2dat_smTr2P_imm(FileNameBase,SampleRate,lfpSampleRate,nChannels, data_2p);
        
% get tracking related data
fprintf('\nGet Track and Laps...\n')
SortTrials_3armMaze_smTr2P_immSTD100(FileNameBase,lfpSampleRate,SampleRate,isInt); %changed filter 6/21/2024

fprintf('\nSeperating Trials....\n')
GetTrials_smTrMPFI2P_imm(TwoPhotonPath, BehaviorPath, FileNameBase, isInt);


fprintf('\nFinished!\n')
clearvars -except recordFolder TwoPhotonPaths BehaviorPaths FileNameBases isInt
end  
end





        
        
        
        
