function TDPpunctaCheck
%% Function written by Eleni Christoforidou in MATLAB 2022a.

%%
parentdir=cd;
folders=dir;
idx=[];
for i=1:length(folders)
    if isfolder(folders(i).name)
        idx=[idx;i]; %Ignore items that are not folders
    end
end
folders=folders(idx);

for j=3:length(folders)
    folname=folders(j).name;
    cd(folname);
    set(gcf,'WindowState','maximized')
    subplot(1,3,1), imshow('MAX_C4_grey.tif')
    title('Original')
    subplot(1,3,2), imshow('Flat of MAX_C4_grey_Thresh.tif')
    title('Thresholded')
    subplot(1,3,3), imshow('Mask of MAX_C4_grey.tif')
    title('Analysed')
    imageName=strrep(folname,'_',' ');
    sgtitle(imageName)
    pause; %press any key to move to the next figure in the loop.
    close
    cd(parentdir)
end
end