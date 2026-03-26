    folderPath = 'Z:\Kori\ImmobileTaskExperiment';

%% active licking
%% muscimol

activeLickMuscPath = [...
    'Z:\Kori\ImmobileTaskExperiment\ANMC120\A120-20220528\';...
      'Z:\Kori\ImmobileTaskExperiment\ANMC123\A123-20220627\';...
       % % 'Z:\Kori\ImmobileTaskExperiment\ANMC123\A123-20220713\';...
     'Z:\Kori\ImmobileTaskExperiment\ANMC126\A126-20220805\';...
     'Z:\Kori\ImmobileTaskExperiment\ANMC127\A127-20220804\';...
 
%    
];


recCtrlMusc = [...
   '-01_lickavgSC.mat' 
   '-01_lickavgSC.mat' 
  % % '-02_lickavgSC.mat' 
   '-03_lickavgSC.mat' 
   '-02_lickavgSC.mat' 
]

rec1hrMusc = [...
   '-03_lickavgSC.mat' 
   '-03_lickavgSC.mat' 
    % % '-03_lickavgSC.mat' 
   '-05_lickavgSC.mat' 
   '-04_lickavgSC.mat' 
]


recRecoveryMusc = [...
   '-06_lickavgSC.mat' 
   '-06_lickavgSC.mat' 
   % % '-05_lickavgSC.mat' 
   '-07_lickavgSC.mat' 
   '-07_lickavgSC.mat' 
]

% recSessionsALMusc = [...
%     {[1 2 3 4 6]};... % ctrl, 30, 1hr, 2hr, recovery
%     {[1 2 3 5 6 ]};... % ctrl, 30 min, 1hr, 8.5hr, recovery  
%     {[2 3 4 5]};... % ctrl, 1hr, 1.5, 2hr 
%     {[3 4 5 6 7]};... % ctrl, 30min, 1hr, 2hr, recovery  
%     {[2 3 4 5 7]};... % ctrl, 30min, 1hr, 2hr, recovery
% 
% 

% 
% % active licking
% %% scopolamine
% 
% activeLickScopPath = [...
%      'Z:\Kori\ImmobileTaskExperiment\ANMC120\A120-20220530\';...
%        'Z:\Kori\ImmobileTaskExperiment\ANMC120\A120-20220613\';...
%       'Z:\Kori\ImmobileTaskExperiment\ANMC123\A123-20220629\';...
%      'Z:\Kori\ImmobileTaskExperiment\ANMC126\A126-20220811\';...
%      'Z:\Kori\ImmobileTaskExperiment\ANMC127\A127-20220809\';...
% 
% ];
% 
% recSessionsALScop = [...
%     {[1 2 3 4 6]};... % ctrl, 30 min, 1hr  2hr, recovery
%     {[3 4 5 7]};...% ctrl, 30 min, 1hr , recovery 
%      {[2 3 4]};... % ctrl, 45 min, 1hr 15,  
%     {[3 4 5 6 7]};... % ctrl, 30min, 1hr, 2hr, recpvery  
%     {[2 3 4 5 6]};... % ctrl, 30min, 1hr, 2hr , recovery 
% 
% ];
% %
% %% active licking
% %% pirenzepine
% 
% activeLickPirePath = [...
%      'Z:\Kori\ImmobileTaskExperiment\ANMC120\A120-20220601\';...
%        'Z:\Kori\ImmobileTaskExperiment\ANMC120\A120-20220615\';...
%       'Z:\Kori\ImmobileTaskExperiment\ANMC123\A123-20220706\';...
%       'Z:\Kori\ImmobileTaskExperiment\ANMC127\A127-20220822\';...
%        'Z:\Kori\ImmobileTaskExperiment\ANMC126\A126-20220823\';...
% ];
% 
% recSessionsALPire = [...
%  {[2 3 4 5]};... % ctrl, 30 min, 1hr  2hr
% {[2 3 4]};...% ctrl, 30 min, 1hr  
% {[1 2 3 4]};... % ctrl, 30 min, 1hr  2hr  
%  {[2 3 4 5]};... % ctrl, 30 min, 1hr  2hr
%  {[3 4 5 6]};... % ctrl, 30 min, 1hr  2hr
% 
% ];
% 
% 
% ];
% 
% % 
% 
% 
% %% saline
% activeLickMuscPath = [...
%     'Z:\Kori\ImmobileTaskExperiment\ANMC120\A120-20220603\';...
%       'Z:\Kori\ImmobileTaskExperiment\ANMC123\A123-20220608\';...
%       'Z:\Kori\ImmobileTaskExperiment\ANMC123\A123-20220715\';...
%      'Z:\Kori\ImmobileTaskExperiment\ANMC126\A126-20220817\';...
%      'Z:\Kori\ImmobileTaskExperiment\ANMC127\A127-20220811\';...
% ];
% 
% recSessionsALMusc = [...
%     {[1 2 3 4]};... % ctrl, 30, 1hr, 2hr %30 min sess bad(had to make new dummy)
%     {[1 2 3 4 5]};... % ctrl, ctrl, 30 min, 1hr, 2hr %%exclude 2hr motivation
%     {[1 2 3 5]};... %  ctrl, 30, 1hr, 2hr
%     {[1 2 3 4]};... %  ctrl, 30, 1hr, 2hr
%     {[1 3 4 5]};... %  ctrl, 30, 1hr, 2hr
% 
