function terminalColocalisation
%% Function written by Eleni Christoforidou in MATLAB R2022a.

%The current directory must contain the folders 'Final endplates', and
%'Final terminals'.

%%
if exist('Terminal colocalisation','dir')
    rmdir('Terminal colocalisation','s')
end
status=mkdir('Terminal colocalisation');
if status==0
    mkdir 'Terminal colocalisation'
end
parentdir=cd;
directories=dir;
for d=1:length(directories)
    if strcmp(directories(d).name,'Final endplates')
        enddir=strcat(directories(d).folder,'\Final endplates\Binary endplates');
    end
    if strcmp(directories(d).name,'Final terminals')
        terdir=strcat(directories(d).folder,'\Final terminals\Binary terminals');
    end
    if strcmp(directories(d).name,'Terminal colocalisation')
        outdir=strcat(directories(d).folder,'\Terminal colocalisation');
    end
end

cd(enddir)
endplateList=dir('*.tif');
cd(parentdir)
cd(terdir)
terminalList=dir('*.tif');
cd(parentdir)

for i=1:length(endplateList)
    endName=endplateList(i).name;
    cd(endplateList(i).folder);
    endplate=imread(endName);
    
    for j=1:length(terminalList) %check if a terminal exists for this endplate
        if strcmp(terminalList(j).name,endName)
            cd(terminalList(j).folder);
            terminal=imread(endName);

            coloc=bitand(endplate,terminal);
            cd(outdir)
            imwrite(coloc,endName);
            cd(parentdir)
        end
    end
end
cd(parentdir)
end
