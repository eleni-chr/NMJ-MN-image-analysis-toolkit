function checkFrames
%% Function written by Eleni Christoforidou in MATLAB R2022a.

%FUNCTION OUTPUT
%The function saves an Excel file called 'substackFrames' with the user-defined start and end
%frames for each z-stack image analysed, next to the image filename.

%FUNCTION TERMINATION
%(1)    The function can be terminated at any point by Ctrl-C and the data up to
        %that point will be saved in the Excel file.

%(2)    If the function terminates due to an error during user input, the data up to that point will be saved.

%(3)    The next time the function is called after a previous termination, it will continue from where it left off
        %and append the new data to the same file.

%(4)    If all data has been analysed
        %then the function will no longer execute. The only way to re-start from
        %the beginning is to manually delete the output file from the current
        %directory.

%(5)    Following termination (either on purpose or due to an error), make sure to navigate back to the parent
        %directory in order to be able to call the function again, as this is not done
        %automatically.

%FUNCTION USAGE
%(1)    Call the function as checkFrames. A figure will appear on the screen showing the individual frames
        %of the red and green channels as well as the frames of the two channels merged.

%(2)    Press any key on the keyboard. The phrase 'start frame:' will appear
        %in the Command Window. Enter an integer to denote which frame should
        %be the first in the substack, then press Enter.

%(3)    The phrase 'end frame:' will appear now, so enter an integer to
        %denote which frame should be the last in the substack, then press Enter.

%(4)    The next figure will now appear, so repeat steps 2-3. Note that if
        %no substack is required (i.e., the entire z-stack should remain
        %as is, then input the first and last frames when prompted.

%(5)    To completely exclude an image from subsequent analysis then put 0
        %as the start and end frames when prompted.

%%
status=isfile('substackFrames.xlsx');
if status==1
    filedata=readtable("substackFrames.xlsx");
    h=height(filedata)+1;
else
    h=1;
end

parentdir=cd;
directories=dir;
for d=1:length(directories)
    if strcmp(directories(d).name,'z-Endplates')
        enddir=strcat(directories(d).folder,'\z-Endplates\');
    end
    if strcmp(directories(d).name,'z-Terminals')
        terdir=strcat(directories(d).folder,'\z-Terminals\');
    end
    if strcmp(directories(d).name,'z-Merge')
        merdir=strcat(directories(d).folder,'\z-Merge\');
    end
end

cd(enddir)
endplateList=dir('*.tif');
cd(parentdir)

for i=h:length(endplateList)
    endName=endplateList(i).name;
    cd(endplateList(i).folder);
    info=imfinfo(endName);
    frames=length(info);

    redZ=uint8(zeros(info(1).Height,info(1).Width,frames));
    greenZ=uint8(zeros(info(1).Height,info(1).Width,frames));
    mergeZ=uint8(zeros(info(1).Height,info(1).Width,3,frames)); %4-D array for RGB data
    
    for f=1:frames
        cd(enddir);
        redZ(:,:,f)=uint8(im2gray(imread(endName,f)));
        cd(terdir);
        greenZ(:,:,f)=uint8(im2gray(imread(endName,f)));
        cd(merdir);
        mergeZ(:,:,:,f)=uint8(imread(endName,f));
    end

    set(gcf,'WindowState','maximized')
    t=tiledlayout(3,frames);
    for f=1:frames
        nexttile(f)
        imshow(redZ(:,:,f))
        title(strcat(num2str(f),' red'))
        nexttile(f+frames)
        imshow(greenZ(:,:,f))
        title(strcat(num2str(f),' green'))
        nexttile(f+(frames*2))
        imshow(mergeZ(:,:,:,f))
        title(strcat(num2str(f),' merge'))
    end
    t.TileSpacing='compact';
    t.Padding='compact';

    pause; %press any key to move to the next figure in the loop.

    %Ask for user input
    s=input('start frame: ');
    if ~floor(s)==s || s<0 || s>frames
        error('Input must be an integer between 0 and %d',frames);
    end
    e=input('end frame: ');
    if ~floor(e)==e || e<0 || e>frames
        error('Input must be an integer between 0 and %d',frames);
    elseif e<s
        error('Input must be an integer between "start frame" value and %d',frames);
    end
    fnames={endName};

    close
    T=table(fnames,s,e,'VariableNames',{'filename','startFrame','endFrame'});
    cd(parentdir)
    writetable(T,'substackFrames.xlsx','WriteMode','append');
end
end