function FCD_SC_merge_data(mouseWT,mouseFLX,mouseLOA,mouseFLXLOA)
%% Function written by Eleni Christoforidou in MATLAB R2022a.

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
    BackgroundIntDenTDP=readtable('BackgroundIntDenTDP.csv');
    BackgroundIntDenTDP.Properties.VariableNames={'ROI_num','Bkg_Area','Bkg_IntDen','Bkg_RawIntDen'};
    
    BackgroundIntDenp62=readtable('BackgroundIntDenp62.csv');
    BackgroundIntDenp62.Properties.VariableNames={'ROI_num','Bkg_Area','Bkg_IntDen','Bkg_RawIntDen'};
    
    NucleusIntDen=readtable('NucleusIntDen.csv');
    NucleusIntDen.Properties.VariableNames={'Cell_num','Area_Nuc','TDP_IntDen_Nuc','TDP_RawIntDen_Nuc'};
    
    CytoplasmIntDen=readtable('CytoplasmIntDen.csv');
    CytoplasmIntDen.Properties.VariableNames={'Cell_num','Area_Cyt','TDP_IntDen_Cyt','TDP_RawIntDen_Cyt'};
    
    p62cytoplasmIntDen=readtable('p62_cytoplasmIntDen.csv');
    p62cytoplasmIntDen.Properties.VariableNames={'Cell_num','p62_Area_Cyt','p62_IntDen_Cyt','p62_RawIntDen_Cyt'};
    
    CHATcytoplasmIntDen=readtable('ChAT_CytoplasmIntDen.csv');
    CHATcytoplasmIntDen.Properties.VariableNames={'Cell_num','CHAT_Area_Cyt','CHAT_IntDen_Cyt','CHAT_RawIntDen_Cyt'};
    
    CHATsize=readtable('CHATsize.csv');
    CHATsize.Properties.VariableNames={'Cell_num','Soma_area'};
    
    DAPIshape=readtable('DAPIshape.csv');
    DAPIshape.Properties.VariableNames={'Cell_num','nucArea'};
    
    p62punctaPerCell=readtable('p62punctaPerCell.xlsx');
    if ~isempty(p62punctaPerCell)
        p62punctaPerCell.Properties.VariableNames={'Cell_num','Total_p62_puncta'};
    else
        p62punctaPerCell=array2table(nan(height(NucleusIntDen),1));
        p62punctaPerCell.Properties.VariableNames={'Total_p62_puncta'};
    end

    if isfile('TDPpunctaPerCell.xlsx')
        TDPpunctaPerCell=readtable('TDPpunctaPerCell.xlsx');
        if ~isempty(TDPpunctaPerCell)
            TDPpunctaPerCell.Properties.VariableNames={'Cell_num','Total_TDP_puncta'};
            if height(TDPpunctaPerCell)~=height(NucleusIntDen)
                v=1:height(NucleusIntDen);
                t=TDPpunctaPerCell.Cell_num;
                diff=setdiff(v,t)';
                missing=nan(length(diff),1);
                new1=[TDPpunctaPerCell.Cell_num;diff];
                new2=[TDPpunctaPerCell.Total_TDP_puncta;missing];
                [new1,index]=sort(new1);
                new2=new2(index);
                TDPpunctaPerCell=table(new1,new2);
                TDPpunctaPerCell.Properties.VariableNames={'Cell_num','Total_TDP_puncta'};
            end
        else
            TDPpunctaPerCell=array2table(nan(height(NucleusIntDen),1));
            TDPpunctaPerCell.Properties.VariableNames={'Total_TDP_puncta'};
        end
    else
        var1=1:height(NucleusIntDen);
        var1=var1';
        var2=nan(size(var1));
        TDPpunctaPerCell=table(var1,var2);
        TDPpunctaPerCell.Properties.VariableNames={'Cell_num','Total_TDP_puncta'};
    end
    
    %Concatenate data into table
    Tbl=[NucleusIntDen,CytoplasmIntDen(:,2:end),CHATsize(:,2:end),DAPIshape(:,2:end),...
        p62cytoplasmIntDen(:,2:end),CHATcytoplasmIntDen(:,2:end)];

    Tbl_final=[NucleusIntDen(:,1),CytoplasmIntDen(:,2),CHATsize(:,2),DAPIshape(:,2),CHATcytoplasmIntDen(:,2)];
    
    %Calculations for TDP-43
    TDP_Bkg=mean(BackgroundIntDenTDP.Bkg_RawIntDen./BackgroundIntDenTDP.Bkg_Area); %background fluorescence intensity in TDP-43 channel
    TDP_N=(Tbl.TDP_RawIntDen_Nuc-(TDP_Bkg.*Tbl.Area_Nuc))./Tbl.Area_Nuc; %TDP-43 fluorescence intensity in the nucleus
    TDP_C=(Tbl.TDP_RawIntDen_Cyt-(TDP_Bkg.*Tbl.Area_Cyt))./Tbl.Area_Cyt; %TDP-43 fluorescence intensity in the cytoplasm
    
    %Adjust negative values (i.e., when there is less signal in the ROI than in the background)
    for i=1:length(TDP_N)
        if TDP_N(i)<0
            TDP_N(i)=0;
        end
        if TDP_C(i)<0
            TDP_C(i)=0;
        end
    end

    TDP_T=TDP_N+TDP_C; %TDP-43 fluorescence intensity in soma
    TDP_pN=TDP_N./TDP_T.*100; %percentage of TDP-43 in nucleus
    TDP_pC=TDP_C./TDP_T.*100; %percentage of TDP-43 in cytoplasm
    NucToSomaArea=Tbl.Area_Nuc./(Tbl.Area_Nuc+Tbl.Area_Cyt); %ratio of nucleus to soma area
    
    %Calculate if the cell contains more than 50% cytoplasmic TDP-43
    MajorCytTDP=zeros(length(TDP_pC),1);
    for i=1:length(TDP_pC)
        if TDP_pC(i)>50
            MajorCytTDP(i)=1; %majority of TDP-43 is in cytoplasm
        else
            MajorCytTDP(i)=0; %majority of TDP-43 is in nucleus
        end
    end
    
    %Calculations for p62
    p62_Bkg=mean(BackgroundIntDenp62.Bkg_RawIntDen./BackgroundIntDenp62.Bkg_Area); %background fluorescence intensity in p62 channel
    p62_C=(Tbl.p62_RawIntDen_Cyt-(p62_Bkg.*Tbl.p62_Area_Cyt))./Tbl.p62_Area_Cyt; %p62 fluorescence intensity in cytoplasm

    %Adjust negative values (i.e., when there is less signal in the ROI than in the background)
    for i=1:length(p62_C)
        if p62_C(i)<0
            p62_C(i)=0;
        end
    end

    %Calculations for CHAT
    CHAT_Bkg=mean(BackgroundIntDenTDP.Bkg_RawIntDen./BackgroundIntDenTDP.Bkg_Area); %background fluorescence intensity in CHAT channel
    CHAT_C=(Tbl.CHAT_RawIntDen_Cyt-(CHAT_Bkg.*Tbl.Area_Cyt))./Tbl.Area_Cyt; %CHAT fluorescence intensity in the cytoplasm
    
    %Adjust negative values (i.e., when there is less signal in the ROI than in the background)
    for i=1:length(CHAT_C)
        if CHAT_C(i)<0
            CHAT_C(i)=0;
        end
    end

    %Normalise puncta number to cytoplasm area
    TDPpunPerCell=TDPpunctaPerCell.Total_TDP_puncta./Tbl.Area_Cyt;
    p62punPerCell=p62punctaPerCell.Total_p62_puncta./Tbl.Area_Cyt;

    %Concatenate calculation results into table
    Tbl2=array2table([TDP_N,TDP_C,TDP_T,TDP_pN,TDP_pC,NucToSomaArea,MajorCytTDP,p62_C,CHAT_C,TDPpunPerCell,p62punPerCell],...
        'VariableNames',{'TDP_Nuc_FI','TDP_Cyt_FI','TDP_Soma_FI','TDP_percent_Nuc','TDP_percent_Cyt','NucToSomaArea','MajorCytTDP',...
        'p62_Cyt_FI','CHAT_Cyt_FI','Total_TDP_puncta','Total_p62_puncta'});

    %Concatenate raw data and calculations into table
    Data=[Tbl_final,Tbl2];
    
    %Extract identifier info and append to table
    ID=extractBefore(folname,'_');
    mouseID=char(zeros(length(TDP_N),length(ID)));
    genotype=char(zeros(length(TDP_N),24));
    for i=1:length(TDP_N)
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
    Data.mouseID=mouseID;
    Data.genotype=genotype;
    
    segment=char(extractBetween(folname,'_','_'));
    L_seg=char(zeros(length(TDP_N),length(segment)));
    for i=1:length(TDP_N)
        L_seg(i,:)=segment;
    end
    Data.L_seg=L_seg;
    
    side=contains(folname,'LEFT');
    if side==1
        VH_side=char(zeros(length(TDP_N),4));
        for i=1:length(TDP_N)
            VH_side(i,:)='LEFT';
        end
    else
        VH_side=char(zeros(length(TDP_N),5));
        for i=1:length(TDP_N)
            VH_side(i,:)='RIGHT';
        end
    end
    Data.VH_side=VH_side;
    
    image_num=zeros(length(TDP_N),1);
    if folname(end)~='T'
        im_num=str2double(folname(end));
        for i=1:length(TDP_N)
            image_num(i,:)=im_num;
        end
    else
        im_num=1;
        for i=1:length(TDP_N)
            image_num(i,:)=im_num;
        end
    end
    Data.image_num=image_num;
    
    writetable(Data,'mergedData.xlsx','WriteMode','replacefile');
    cd ..
end
end
