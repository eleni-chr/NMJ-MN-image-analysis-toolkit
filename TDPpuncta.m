function TDPpuncta
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

empty=array2table(zeros(0,5));
empty.Properties.VariableNames={'Puncta_num','Area','IntDen','RawIntDen','TDPpunctaFI'};

punPerCell=array2table(zeros(0,1));
punPerCell.Properties.VariableNames={'PunctaPerCell'};

for j=3:length(folders)
    folname=folders(j).name;
    cd(folname);

    BackgroundIntDenTDP=readtable('BackgroundIntDenTDP.csv');
    BackgroundIntDenTDP.Properties.VariableNames={'ROI_num','Bkg_Area','Bkg_IntDen','Bkg_RawIntDen'};

    TDP_Bkg=mean(BackgroundIntDenTDP.Bkg_RawIntDen./BackgroundIntDenTDP.Bkg_Area);
    
    %Loop through files
    files=dir('TDPpuncta_*.csv');
    NumOfCells=length(dir('p62dist_*.csv'));
    numOfPuncta=zeros(NumOfCells,1);
    cellIDs=(1:NumOfCells)';

    delete 'merged_TDPpuncta.xlsx' 'TDPpunctaPerCell.xlsx';

    %Merge info into a single file
    if ~isempty(files) %ignore folders without the appropriate CSV files
        for m=1:NumOfCells
            writetable(empty,'merged_TDPpuncta.xlsx','Sheet',num2str(m),'WriteMode','overwritesheet'); %Create an empty Excel sheet for each cell
            writetable(punPerCell,'TDPpunctaPerCell.xlsx','WriteMode','replacefile');
        end
        
        for i=1:length(files)
            data=readtable(files(i).name);
            data.Properties.VariableNames={'Puncta_num','Area','IntDen','RawIntDen'};

            TDPpunctaFI=(data.RawIntDen-(TDP_Bkg.*data.Area))./data.Area;
            for k=1:length(TDPpunctaFI)
                if TDPpunctaFI(k)<0
                    TDPpunctaFI(k)=0; %Adjust negative values
                end
            end
            T2=table(TDPpunctaFI);

            cellID=extractBetween(files(i).name,'_','.');
            cellNum=str2double(cell2mat(cellID));
            numOfPuncta(cellNum)=data.Puncta_num(end,1); %calculate number of puncta per cell
            Cell_num(1:length(data.Puncta_num))=cellID;
            Cell_num=table(Cell_num');
            data=[Cell_num,data,T2];
            data.Properties.VariableNames{'Var1'}='Cell_num';
            writetable(data,'merged_TDPpuncta.xlsx','Sheet',cell2mat(cellID),'WriteMode','overwritesheet');
            clear Cell_num
        end
        T=table(cellIDs,numOfPuncta);
        T.Properties.VariableNames={'Cell_num','Total_puncta'};
        writetable(T,'TDPpunctaPerCell.xlsx','WriteMode','overwritesheet');

        %Combine data into single sheet
        combinedData=[];
        [~,sheets]=xlsfinfo('merged_TDPpuncta.xlsx');
        for s=1:length(sheets)
            cellData=readtable('merged_TDPpuncta.xlsx','Sheet',num2str(s));
            if ~isempty(cellData)
                combinedData=[combinedData;cellData];
            end
        end
        writetable(combinedData,'merged_TDPpuncta.xlsx','Sheet','combined','WriteMode','overwritesheet');
    else
        for m=1:NumOfCells
            writetable(empty,'merged_TDPpuncta.xlsx','Sheet',num2str(m),'WriteMode','overwritesheet');
            writetable(punPerCell,'TDPpunctaPerCell.xlsx','WriteMode','replacefile');
        end
    end
    cd ..
end
end