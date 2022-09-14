function compileNMJdata(mouseWT,mouseFLX,mouseLOA,mouseFLXLOA)
%% Function written by Eleni Christoforidou in MATLAB 2022a.

%The current directory must contain the 'Final endplates' and 'Final
%terminals' folders, which will contain subfolders and CSV files created by
%ImageJ and MATLAB beforehand.

%This function will combine the data from the following files into a single
%Excel file called 'NMJ_data.xlsx': 'AChR_area_perim.csv',
%'ConvexHull_area_perim', 'Endplate_fragments.csv',
%'Terminal_area_perim.csv'.

%The following will also be calculated and added to the Excel file:
%Coverage, Compactness.

%FUNCTION INPUT:
%Four cell arrays, where each cell contains a character array representing
%the unique ID corresponding to the mice included in each of the four groups.
% E.g., mouseWT={'FCD27-7','FCD10-10','FCD8-1'};

%%
ACHR=dir('**\AchR_area_perim.csv');
ACHR=readtable(strcat(ACHR.folder,'\',ACHR.name));
ACHR.Properties.VariableNames={'Item','Filename','AchR_area','AchR_perim'};
ACHR=removevars(ACHR,{'Item'});
ACHR=sortrows(ACHR);

CH=dir('**\ConvexHull_area_perim.csv');
CH=readtable(strcat(CH.folder,'\',CH.name));
CH.Properties.VariableNames={'Item','Filename','CH_area','CH_perim'};
CH=removevars(CH,{'Item'});
CH=sortrows(CH);

frag=dir('**\Endplate_fragments.csv');
frag=readtable(strcat(frag.folder,'\',frag.name),'ReadVariableNames',false,'Delimiter',',');
frag.Properties.VariableNames={'Fragments','Filename'};
frag=movevars(frag,'Fragments','After','Filename');
frag=sortrows(frag);

terminal=dir('**\Terminal_area_perim.csv');
terminal=readtable(strcat(terminal.folder,'\',terminal.name));
terminal.Properties.VariableNames={'Item','Filename','SV2_area','Min','Max','SV2_perim'};
terminal=removevars(terminal,{'Item','Min','Max'});
terminal=sortrows(terminal);

%%
T=[ACHR(:,:),CH(:,2:end),frag(:,2),terminal(:,2:end)];

Coverage=table(T.SV2_area./T.AchR_area.*100);
Coverage.Properties.VariableNames={'Coverage'};
Compactness=table(T.AchR_area./T.CH_area.*100);
Compactness.Properties.VariableNames={'Compactness'};

WT=contains(T.Filename,mouseWT);
FLX=contains(T.Filename,mouseFLX);
LOA=contains(T.Filename,mouseLOA);
FLXLOA=contains(T.Filename,mouseFLXLOA);

T=[T,Coverage,Compactness,table(WT),table(FLX),table(LOA),table(FLXLOA)];
writetable(T,'NMJ_data.xlsx','WriteMode','replacefile');
end