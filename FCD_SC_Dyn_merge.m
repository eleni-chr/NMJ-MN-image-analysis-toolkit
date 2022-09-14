function FCD_SC_Dyn_merge(mouseWT,mouseFLX,mouseLOA,mouseFLXLOA)
%% Function written by Eleni Christoforidou in MATLAB 2022a.

%FUNCTION INPUT:
%Four cell arrays, where each cell contains a character array representing
%the unique ID corresponding to the mice included in each of the four groups.
% E.g., mouseWT={'FCD27-7','FCD10-10','FCD8-1'};

%%
%Loop through subfolders
folders=dir;
for j=3:length(folders)
    if ~isfolder(folders(j).name)
        continue; %Ignore items that are not folders
    end
    
    folname=folders(j).name;
    cd(folname);
    
    %Load data
    BackgroundIntDenDYN=readtable('BackgroundIntDenDYN.csv');
    BackgroundIntDenDYN.Properties.VariableNames={'ROI_num','Bkg_Area','Bkg_IntDen','Bkg_RawIntDen'};
    
    DYN=readtable('DynHC.csv');
    DYN.Properties.VariableNames={'Cell_num','Area_C','DYN_IntDen','DYN_RawIntDen'};

    ChATsize=readtable('ChATsize.csv');
    ChATsize.Properties.VariableNames={'Cell_num','Soma_area'};
    
    DAPIshape=readtable('DAPIshape.csv');
    DAPIshape.Properties.VariableNames={'Cell_num','nucArea'};

    CHATcytoplasmIntDen=readtable('ChAT_CytoplasmIntDen.csv');
    CHATcytoplasmIntDen.Properties.VariableNames={'Cell_num','CHAT_Area_Cyt','CHAT_IntDen_Cyt','CHAT_RawIntDen_Cyt'};
    
    %Concatenate data into table
    Tbl=[DYN(:,1:2),ChATsize(:,2),DAPIshape(:,2)];

    %Calculations
    DYN_Bkg=mean(BackgroundIntDenDYN.Bkg_RawIntDen./BackgroundIntDenDYN.Bkg_Area);
    DYN_C=(DYN.DYN_RawIntDen-DYN_Bkg.*DYN.Area_C)./DYN.Area_C; %DYN fluorescence intensity in the cytoplasm
    CHAT_C=(CHATcytoplasmIntDen.CHAT_RawIntDen_Cyt-(DYN_Bkg.*DYN.Area_C))./DYN.Area_C; %CHAT fluorescence intensity in the cytoplasm

    %Adjust negative values
    for i=1:length(DYN_C)
        if DYN_C(i)<0
            DYN_C(i)=0;
        end
        if CHAT_C(i)<0
            CHAT_C(i)=0;
        end
    end
    
    %Concatenate calculation results into table
    Tbl2=array2table(DYN_C,'VariableNames',{'DYN_Cyt_FI'});
    Tbl3=array2table(CHAT_C,'VariableNames',{'CHAT_Cyt_FI'});

    %Additional calculations
    NucToSomaArea=array2table(Tbl.nucArea./(Tbl.nucArea+Tbl.Area_C),'VariableNames',{'NucToSomaArea'}); %ratio of nucleus to soma area

    %Concatenate raw data and calculations into table
    Data=[Tbl,Tbl2,Tbl3,NucToSomaArea];
    
    %Extract identifier info and append to table
    ID=extractBefore(folname,'_');
    mouseID=char(zeros(length(DYN_C),length(ID)));
    genotype=char(zeros(length(DYN_C),24));
    for i=1:length(DYN_C)
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
    Data.mouseID=cellstr(mouseID);
    Data.genotype=cellstr(genotype);
    
    segment=char(extractBetween(folname,'_','_'));
    L_seg=char(zeros(length(DYN_C),length(segment)));
    for i=1:length(DYN_C)
        L_seg(i,:)=segment;
    end
    Data.L_seg=cellstr(L_seg);
    
    side=contains(folname,'LEFT');
    if side==1
        VH_side=char(zeros(length(DYN_C),4));
        for i=1:length(DYN_C)
            VH_side(i,:)='LEFT';
        end
    else
        VH_side=char(zeros(length(DYN_C),5));
        for i=1:length(DYN_C)
            VH_side(i,:)='RIGHT';
        end
    end
    Data.VH_side=cellstr(VH_side);
    
    image_num=zeros(length(DYN_C),1);
    if folname(end)~='T'
        im_num=str2double(folname(end));
        for i=1:length(DYN_C)
            image_num(i,:)=im_num;
        end
    else
        im_num=1;
        for i=1:length(DYN_C)
            image_num(i,:)=im_num;
        end
    end
    Data.image_num=image_num;
    
    writetable(Data,'mergedData.xlsx','WriteMode','replacefile');
    cd ..
end
end