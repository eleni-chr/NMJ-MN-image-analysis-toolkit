function FCD_SC_DYN_masterfile
%% Function written by Eleni Christoforidou in MATLAB 2022a.

%%
%Loop through subfolders
folders=dir;
idx=[];
for i=1:length(folders)
    if isfolder(folders(i).name)
        idx=[idx;i]; %Ignore items that are not folders
    end
end
folders=folders(idx);

T=[];
for j=3:length(folders)
    folname=folders(j).name;
    cd(folname);
    
    if isfile('mergedData.xlsx')
        data=readtable('mergedData.xlsx');
        T=[T;data];
    end
    cd ..
end
writetable(T,'DYNmasterfile.xlsx','Sheet','All data','WriteMode','overwritesheet');

%Add additional sheets to the Excel file with separate genotypes and lumbar segments
WT=T(strcmp(T.genotype,'DYNC1H1(+/+),CHAT(+/CRE)'),:);
FLX=T(strcmp(T.genotype,'DYNC1H1(+/F),CHAT(+/CRE)'),:);
LOA=T(strcmp(T.genotype,'DYNC1H1(+/L),CHAT(+/CRE)'),:);
FLXLOA=T(strcmp(T.genotype,'DYNC1H1(F/L),CHAT(+/CRE)'),:);

WT_L3=WT(strcmp(WT.L_seg,'L3'),:);
WT_L4=WT(strcmp(WT.L_seg,'L4'),:);
WT_L5=WT(strcmp(WT.L_seg,'L5'),:);
WT_L6=WT(strcmp(WT.L_seg,'L6'),:);

FLX_L3=FLX(strcmp(FLX.L_seg,'L3'),:);
FLX_L4=FLX(strcmp(FLX.L_seg,'L4'),:);
FLX_L5=FLX(strcmp(FLX.L_seg,'L5'),:);
FLX_L6=FLX(strcmp(FLX.L_seg,'L6'),:);

LOA_L3=LOA(strcmp(LOA.L_seg,'L3'),:);
LOA_L4=LOA(strcmp(LOA.L_seg,'L4'),:);
LOA_L5=LOA(strcmp(LOA.L_seg,'L5'),:);
LOA_L6=LOA(strcmp(LOA.L_seg,'L6'),:);

FLXLOA_L3=FLXLOA(strcmp(FLXLOA.L_seg,'L3'),:);
FLXLOA_L4=FLXLOA(strcmp(FLXLOA.L_seg,'L4'),:);
FLXLOA_L5=FLXLOA(strcmp(FLXLOA.L_seg,'L5'),:);
FLXLOA_L6=FLXLOA(strcmp(FLXLOA.L_seg,'L6'),:);

writetable(WT,'DYNmasterfile.xlsx','Sheet','WT','WriteMode','overwritesheet');
writetable(FLX,'DYNmasterfile.xlsx','Sheet','FLX','WriteMode','overwritesheet');
writetable(LOA,'DYNmasterfile.xlsx','Sheet','LOA','WriteMode','overwritesheet');
writetable(FLXLOA,'DYNmasterfile.xlsx','Sheet','FLX-LOA','WriteMode','overwritesheet');

writetable(WT_L3,'DYNmasterfile.xlsx','Sheet','WT L3','WriteMode','overwritesheet');
writetable(WT_L4,'DYNmasterfile.xlsx','Sheet','WT L4','WriteMode','overwritesheet');
writetable(WT_L5,'DYNmasterfile.xlsx','Sheet','WT L5','WriteMode','overwritesheet');
writetable(WT_L6,'DYNmasterfile.xlsx','Sheet','WT L6','WriteMode','overwritesheet');

writetable(FLX_L3,'DYNmasterfile.xlsx','Sheet','FLX L3','WriteMode','overwritesheet');
writetable(FLX_L4,'DYNmasterfile.xlsx','Sheet','FLX L4','WriteMode','overwritesheet');
writetable(FLX_L5,'DYNmasterfile.xlsx','Sheet','FLX L5','WriteMode','overwritesheet');
writetable(FLX_L6,'DYNmasterfile.xlsx','Sheet','FLX L6','WriteMode','overwritesheet');

writetable(LOA_L3,'DYNmasterfile.xlsx','Sheet','LOA L3','WriteMode','overwritesheet');
writetable(LOA_L4,'DYNmasterfile.xlsx','Sheet','LOA L4','WriteMode','overwritesheet');
writetable(LOA_L5,'DYNmasterfile.xlsx','Sheet','LOA L5','WriteMode','overwritesheet');
writetable(LOA_L6,'DYNmasterfile.xlsx','Sheet','LOA L6','WriteMode','overwritesheet');

writetable(FLXLOA_L3,'DYNmasterfile.xlsx','Sheet','FLX-LOA L3','WriteMode','overwritesheet');
writetable(FLXLOA_L4,'DYNmasterfile.xlsx','Sheet','FLX-LOA L4','WriteMode','overwritesheet');
writetable(FLXLOA_L5,'DYNmasterfile.xlsx','Sheet','FLX-LOA L5','WriteMode','overwritesheet');
writetable(FLXLOA_L6,'DYNmasterfile.xlsx','Sheet','FLX-LOA L6','WriteMode','overwritesheet');
end