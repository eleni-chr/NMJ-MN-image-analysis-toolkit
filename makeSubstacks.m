function makeSubstacks
%% Function written by Eleni Christoforidou in MATLAB R2022a.

%This function takes a z-stack and creates a substack using the range of
%frames specified in the file 'substackFrames.xlsx' which is outputted by
%running the function checkFrames.m.

%REQUIREMENTS
%The current directory must contain the following:
%(1) The file substackFrames.xlsx.
%(2) The folders 'z-Endplates', 'z-Terminals', and 'z-Merge', which all
%contain z-stacks.

%OUTPUT
%The function will create the foldres 'z-Endplates substacks',
%'z-Terminals substacks', and 'z-Merge substacks', which will all contain
%the new z-stacks with only the desired frames.

%NOTE
%The function will not create substacks from any images whose start frame
%and end frame are defined as zero in the substackFrames.xlsx file.

%%
status=mkdir('z-Endplates substacks');
if status==0
    mkdir 'z-Endplates substacks'
end
status=mkdir('z-Terminals substacks');
if status==0
    mkdir 'z-Terminals substacks'
end
status=mkdir('z-Merge substacks');
if status==0
    mkdir 'z-Merge substacks'
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
    if strcmp(directories(d).name,'z-Endplates substacks')
        subenddir=strcat(directories(d).folder,'\z-Endplates substacks\');
    end
    if strcmp(directories(d).name,'z-Terminals substacks')
        subterdir=strcat(directories(d).folder,'\z-Terminals substacks\');
    end
    if strcmp(directories(d).name,'z-Merge substacks')
        submerdir=strcat(directories(d).folder,'\z-Merge substacks\');
    end
end
source_dirlist={enddir;terdir};
destination_dirlist={subenddir;subterdir};
dirlist=[source_dirlist,destination_dirlist];

filedata=readtable("substackFrames.xlsx");
for n=1:length(dirlist)
    cd(dirlist{n,1});
    for i=1:height(filedata)
        endFrame=filedata.endFrame(i);
        if endFrame~=0
            startFrame=filedata.startFrame(i);
            fname=filedata.filename{i};
            frames=filedata.endFrame(i)-filedata.startFrame(i)+1;
            info=imfinfo(fname);
        
            imageZ=uint8(zeros(info(1).Height,info(1).Width,frames));

            for f=1:frames
                imageZ(:,:,f)=uint8(im2gray(imread(fname,startFrame)));
                startFrame=startFrame+1;
            end
            cd(dirlist{n,2});

            tE=Tiff(fname,'w');
            tagstruct.ImageLength=size(imageZ,1);
            tagstruct.ImageWidth=size(imageZ,2);
            tagstruct.SampleFormat=1; %uint
            tagstruct.Photometric=Tiff.Photometric.MinIsBlack;
            tagstruct.BitsPerSample=8;
            tagstruct.SamplesPerPixel=1;
            tagstruct.Compression=Tiff.Compression.Deflate;
            tagstruct.PlanarConfiguration=Tiff.PlanarConfiguration.Chunky;
            for ii=1:size(imageZ,3)
               setTag(tE,tagstruct);
               write(tE,imageZ(:,:,ii));
               writeDirectory(tE);
            end
            close(tE)
            cd(dirlist{n,1});
        end
    end
end

cd(merdir);
for i=1:height(filedata)
    endFrame=filedata.endFrame(i);
    if endFrame~=0
        startFrame=filedata.startFrame(i);
        fname=filedata.filename{i};
        frames=filedata.endFrame(i)-filedata.startFrame(i)+1;
        info=imfinfo(fname);
    
        imageZ=uint8(zeros(info(1).Height,info(1).Width,3,frames)); %4-D array for RGB data

        for f=1:frames
            imageZ(:,:,:,f)=uint8(imread(fname,startFrame));
            startFrame=startFrame+1;
        end
        cd(submerdir);

        tM=Tiff(fname,'w');
        tagstruct.ImageLength=size(imageZ,1);
        tagstruct.ImageWidth=size(imageZ,2);
        tagstruct.SampleFormat=1; %uint
        tagstruct.Photometric=Tiff.Photometric.RGB;
        tagstruct.BitsPerSample=8;
        tagstruct.SamplesPerPixel=3;
        tagstruct.Compression=Tiff.Compression.Deflate;
        tagstruct.PlanarConfiguration=Tiff.PlanarConfiguration.Chunky;
        for ii=1:size(imageZ,4)
           setTag(tM,tagstruct);
           write(tM,imageZ(:,:,:,ii));
           writeDirectory(tM);
        end
        close(tM)
        cd(merdir);
    end
end
cd(parentdir);
end