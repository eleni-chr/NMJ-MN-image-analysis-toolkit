function p62punctaMaster(mouseWT,mouseFLX,mouseLOA,mouseFLXLOA)
%% Function written by Eleni Christoforidou in MATLAB 2022a.

%FUNCTION INPUT:
%Four cell arrays, where each cell contains a character array representing
%the unique ID corresponding to the mice included in each of the four groups.
% E.g., mouseWT={'FCD27-7','FCD10-10','FCD8-1'};

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
    
    %Load data
    if isfile('merged_p62puncta.xlsx')
        sheets=sheetnames("merged_p62puncta.xlsx");
        if strcmp(sheets(end),'combined')
            data=readtable('merged_p62puncta.xlsx','Sheet','combined');
            
            %Extract identifier info and append to table
            ID=extractBefore(folname,'_');
            mouseID=char(zeros(height(data),length(ID)));
            genotype=char(zeros(height(data),24));
            for i=1:height(data)
                mouseID(i,:)=ID;
                if ismember(mouseID(i,:),mouseWT)
                    genotype(i,:)='DYNC1H1(+/+),CHAT(+/CRE)';
                elseif ismember(mouseID(i,:),mouseFLX)
                    genotype(i,:)='DYNC1H1(+/F),CHAT(+/CRE)';
                elseif ismember(mouseID(i,:),mouseLOA)
                    genotype(i,:)='DYNC1H1(+/L),CHAT(+/CRE)';
                elseif ismember(mouseID(i,:),mouseFLXLOA)
                    genotype(i,:)='DYNC1H1(F/L),CHAT(+/CRE)';
                end
            end
            data.mouseID=cellstr(mouseID);
            data.genotype=cellstr(genotype);

            segment=char(extractBetween(folname,'_','_'));
            L_seg=char(zeros(height(data),length(segment)));
            for i=1:height(data)
                L_seg(i,:)=segment;
            end
            data.L_seg=cellstr(L_seg);
            
            side=contains(folname,'LEFT');
            if side==1
                VH_side=char(zeros(height(data),4));
                for i=1:height(data)
                    VH_side(i,:)='LEFT';
                end
            else
                VH_side=char(zeros(height(data),5));
                for i=1:height(data)
                    VH_side(i,:)='RIGHT';
                end
            end
            data.VH_side=cellstr(VH_side);
            
            image_num=zeros(height(data),1);
            if folname(end)~='T'
                im_num=str2double(folname(end));
                for i=1:height(data)
                    image_num(i,:)=im_num;
                end
            else
                im_num=1;
                for i=1:height(data)
                    image_num(i,:)=im_num;
                end
            end
            data.image_num=image_num;

            T=[T;data];
        end
    end
    cd ..
end

if ~isempty(T)
    writetable(T(:,[1:3,6:end]),'p62punctaMaster.xlsx','Sheet','All data','WriteMode','overwritesheet');
    
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
    
    writetable(WT,'p62punctaMaster.xlsx','Sheet','WT','WriteMode','overwritesheet');
    writetable(FLX,'p62punctaMaster.xlsx','Sheet','FLX','WriteMode','overwritesheet');
    writetable(LOA,'p62punctaMaster.xlsx','Sheet','LOA','WriteMode','overwritesheet');
    writetable(FLXLOA,'p62punctaMaster.xlsx','Sheet','FLX-LOA','WriteMode','overwritesheet');
    
    writetable(WT_L3,'p62punctaMaster.xlsx','Sheet','WT L3','WriteMode','overwritesheet');
    writetable(WT_L4,'p62punctaMaster.xlsx','Sheet','WT L4','WriteMode','overwritesheet');
    writetable(WT_L5,'p62punctaMaster.xlsx','Sheet','WT L5','WriteMode','overwritesheet');
    writetable(WT_L6,'p62punctaMaster.xlsx','Sheet','WT L6','WriteMode','overwritesheet');
    
    writetable(FLX_L3,'p62punctaMaster.xlsx','Sheet','FLX L3','WriteMode','overwritesheet');
    writetable(FLX_L4,'p62punctaMaster.xlsx','Sheet','FLX L4','WriteMode','overwritesheet');
    writetable(FLX_L5,'p62punctaMaster.xlsx','Sheet','FLX L5','WriteMode','overwritesheet');
    writetable(FLX_L6,'p62punctaMaster.xlsx','Sheet','FLX L6','WriteMode','overwritesheet');
    
    writetable(LOA_L3,'p62punctaMaster.xlsx','Sheet','LOA L3','WriteMode','overwritesheet');
    writetable(LOA_L4,'p62punctaMaster.xlsx','Sheet','LOA L4','WriteMode','overwritesheet');
    writetable(LOA_L5,'p62punctaMaster.xlsx','Sheet','LOA L5','WriteMode','overwritesheet');
    writetable(LOA_L6,'p62punctaMaster.xlsx','Sheet','LOA L6','WriteMode','overwritesheet');
    
    writetable(FLXLOA_L3,'p62punctaMaster.xlsx','Sheet','FLX-LOA L3','WriteMode','overwritesheet');
    writetable(FLXLOA_L4,'p62punctaMaster.xlsx','Sheet','FLX-LOA L4','WriteMode','overwritesheet');
    writetable(FLXLOA_L5,'p62punctaMaster.xlsx','Sheet','FLX-LOA L5','WriteMode','overwritesheet');
    writetable(FLXLOA_L6,'p62punctaMaster.xlsx','Sheet','FLX-LOA L6','WriteMode','overwritesheet');
end
end