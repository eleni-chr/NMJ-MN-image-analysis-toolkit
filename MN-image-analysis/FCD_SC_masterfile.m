function FCD_SC_masterfile
%% Function written by Eleni Christoforidou in MATLAB R2022a.

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
writetable(T,'masterfile.xlsx','Sheet','All data','WriteMode','overwritesheet');

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

writetable(WT,'masterfile.xlsx','Sheet','WT','WriteMode','overwritesheet');
writetable(FLX,'masterfile.xlsx','Sheet','FLX','WriteMode','overwritesheet');
writetable(LOA,'masterfile.xlsx','Sheet','LOA','WriteMode','overwritesheet');
writetable(FLXLOA,'masterfile.xlsx','Sheet','FLX-LOA','WriteMode','overwritesheet');

writetable(WT_L3,'masterfile.xlsx','Sheet','WT L3','WriteMode','overwritesheet');
writetable(WT_L4,'masterfile.xlsx','Sheet','WT L4','WriteMode','overwritesheet');
writetable(WT_L5,'masterfile.xlsx','Sheet','WT L5','WriteMode','overwritesheet');
writetable(WT_L6,'masterfile.xlsx','Sheet','WT L6','WriteMode','overwritesheet');

writetable(FLX_L3,'masterfile.xlsx','Sheet','FLX L3','WriteMode','overwritesheet');
writetable(FLX_L4,'masterfile.xlsx','Sheet','FLX L4','WriteMode','overwritesheet');
writetable(FLX_L5,'masterfile.xlsx','Sheet','FLX L5','WriteMode','overwritesheet');
writetable(FLX_L6,'masterfile.xlsx','Sheet','FLX L6','WriteMode','overwritesheet');

writetable(LOA_L3,'masterfile.xlsx','Sheet','LOA L3','WriteMode','overwritesheet');
writetable(LOA_L4,'masterfile.xlsx','Sheet','LOA L4','WriteMode','overwritesheet');
writetable(LOA_L5,'masterfile.xlsx','Sheet','LOA L5','WriteMode','overwritesheet');
writetable(LOA_L6,'masterfile.xlsx','Sheet','LOA L6','WriteMode','overwritesheet');

writetable(FLXLOA_L3,'masterfile.xlsx','Sheet','FLX-LOA L3','WriteMode','overwritesheet');
writetable(FLXLOA_L4,'masterfile.xlsx','Sheet','FLX-LOA L4','WriteMode','overwritesheet');
writetable(FLXLOA_L5,'masterfile.xlsx','Sheet','FLX-LOA L5','WriteMode','overwritesheet');
writetable(FLXLOA_L6,'masterfile.xlsx','Sheet','FLX-LOA L6','WriteMode','overwritesheet');

%Additional calculations per animal
mouseWT={'FCD8-1','FCD9-9','FCD9-10'};
mouseFLX={'FCD10-6','FCD14-1','FCD7-2'};
mouseLOA={'FCD10-4','FCD5-28','FCD7-6'};
mouseFLXLOA={'FCD14-2','FCD8-27','FCD10-3'};

T_WT=[];
T_FLX=[];
T_LOA=[];
T_FLXLOA=[];

for i=1:length(mouseWT)
    mouseID=mouseWT(i);
    genotype={'DYNC1H1(+/+),CHAT(+/CRE)'};
    lookup=WT(strcmp(WT.mouseID,mouseID),:);
    percent_cells_major_cyt_TDP=num2cell(sum(lookup.MajorCytTDP)/height(lookup)*100); %percentage of cells with majority cytoplasmic TDP-43
    totalTDP=height(lookup)-sum(isnan(lookup.Total_TDP_puncta)); %total number of cells (without the excluded cells)
    percent_cells_TDP_puncta=num2cell((length(find(lookup.Total_TDP_puncta))-sum(isnan(lookup.Total_TDP_puncta)))/totalTDP*100); %percentage of cells with TDP-43 puncta
    totalp62=height(lookup)-sum(isnan(lookup.Total_p62_puncta)); %total number of cells (without the excluded cells)
    percent_cells_p62_puncta=num2cell((length(find(lookup.Total_p62_puncta))-sum(isnan(lookup.Total_p62_puncta)))/totalp62*100); %percentage of cells with p62 puncta
    T_WT=[T_WT;table(mouseID,genotype,percent_cells_major_cyt_TDP,percent_cells_TDP_puncta,percent_cells_p62_puncta)];
end

for i=1:length(mouseFLX)
    mouseID=mouseFLX(i);
    genotype={'DYNC1H1(+/F),CHAT(+/CRE)'};
    lookup=FLX(strcmp(FLX.mouseID,mouseID),:);
    percent_cells_major_cyt_TDP=num2cell(sum(lookup.MajorCytTDP)/height(lookup)*100);
    totalTDP=height(lookup)-sum(isnan(lookup.Total_TDP_puncta)); %total number of cells (without the excluded cells)
    percent_cells_TDP_puncta=num2cell((length(find(lookup.Total_TDP_puncta))-sum(isnan(lookup.Total_TDP_puncta)))/totalTDP*100); %percentage of cells with TDP-43 puncta
    totalp62=height(lookup)-sum(isnan(lookup.Total_p62_puncta)); %total number of cells (without the excluded cells)
    percent_cells_p62_puncta=num2cell((length(find(lookup.Total_p62_puncta))-sum(isnan(lookup.Total_p62_puncta)))/totalp62*100); %percentage of cells with p62 puncta
    T_FLX=[T_FLX;table(mouseID,genotype,percent_cells_major_cyt_TDP,percent_cells_TDP_puncta,percent_cells_p62_puncta)];
end

for i=1:length(mouseLOA)
    mouseID=mouseLOA(i);
    genotype={'DYNC1H1(+/L),CHAT(+/CRE)'};
    lookup=LOA(strcmp(LOA.mouseID,mouseID),:);
    percent_cells_major_cyt_TDP=num2cell(sum(lookup.MajorCytTDP)/height(lookup)*100);
    totalTDP=height(lookup)-sum(isnan(lookup.Total_TDP_puncta)); %total number of cells (without the excluded cells)
    percent_cells_TDP_puncta=num2cell((length(find(lookup.Total_TDP_puncta))-sum(isnan(lookup.Total_TDP_puncta)))/totalTDP*100); %percentage of cells with TDP-43 puncta
    totalp62=height(lookup)-sum(isnan(lookup.Total_p62_puncta)); %total number of cells (without the excluded cells)
    percent_cells_p62_puncta=num2cell((length(find(lookup.Total_p62_puncta))-sum(isnan(lookup.Total_p62_puncta)))/totalp62*100); %percentage of cells with p62 puncta
    T_LOA=[T_LOA;table(mouseID,genotype,percent_cells_major_cyt_TDP,percent_cells_TDP_puncta,percent_cells_p62_puncta)];
end

for i=1:length(mouseFLXLOA)
    mouseID=mouseFLXLOA(i);
    genotype={'DYNC1H1(F/L),CHAT(+/CRE)'};
    lookup=FLXLOA(strcmp(FLXLOA.mouseID,mouseID),:);
    percent_cells_major_cyt_TDP=num2cell(sum(lookup.MajorCytTDP)/height(lookup)*100);
    totalTDP=height(lookup)-sum(isnan(lookup.Total_TDP_puncta)); %total number of cells (without the excluded cells)
    percent_cells_TDP_puncta=num2cell((length(find(lookup.Total_TDP_puncta))-sum(isnan(lookup.Total_TDP_puncta)))/totalTDP*100); %percentage of cells with TDP-43 puncta
    totalp62=height(lookup)-sum(isnan(lookup.Total_p62_puncta)); %total number of cells (without the excluded cells)
    percent_cells_p62_puncta=num2cell((length(find(lookup.Total_p62_puncta))-sum(isnan(lookup.Total_p62_puncta)))/totalp62*100); %percentage of cells with p62 puncta
    T_FLXLOA=[T_FLXLOA;table(mouseID,genotype,percent_cells_major_cyt_TDP,percent_cells_TDP_puncta,percent_cells_p62_puncta)];
end
T2=[T_WT;T_FLX;T_LOA;T_FLXLOA];
writetable(T2,'masterfile.xlsx','Sheet','Additional data','WriteMode','overwritesheet');
end
