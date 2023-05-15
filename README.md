# NMJ-MN-image-analysis

[![DOI](https://zenodo.org/badge/536756993.svg)](https://zenodo.org/badge/latestdoi/536756993)

Morphometric analysis of neuromuscular junction microscopy images, and protein distribution and localisation analysis of immunohistochemically-labelled microscopy images.

*README written by Eleni Christoforidou.*

Disclaimer: The code provided in this release has not been peer-reviewed and is subject to errors. Users are encouraged to thoroughly test the code and verify its accuracy for their specific use cases. The authors of this code is not responsible for any errors or inaccuracies in the results obtained from using these functions. Additionally, the code may be subject to updates or modifications, and users should keep an eye out for future releases to ensure the most accurate and up-to-date functionality.

## A.	NMJ IMAGE ANALYSIS

BACKGROUND:
-	Images of neuromuscular junctions (NMJs) from fixed and immunostained tissue were acquired with a Leica SP8 confocal microscope. Immunostaining involved the use of an AChR antibody detected in the red channel and an SV2 and a 2H3 antibody detected in the green channel. All images were acquired with the same settings.

FOLDER HIERARCHY AND FILE STRUCTURE REQUIRED:
-	A folder called **z-Merge** which contains multi-frame (i.e., z-stack) RGB microscopy images in TIFF format. Each image contains a single endplate immunostained by an AChR antibody in the red channel and by an SV2 and a 2H3 antibody in the green channel. There is no staining in the blue channel. If each endplate has been cropped from a larger image, then each image may have different dimensions. The image filename must contain the mouse ID (e.g., FCD8-1).
-	A folder called **z-Endplates** which contains multi-frame (i.e., z-stack) single-channel microscopy images in TIFF format. These images correspond to the isolated red channel from the images in the **z-Merge** folder. The images have the same filename as their RGB source in the z-Merge folder.
-	A folder called **z-Terminals** which contains multi-frame (i.e., z-stack) single-channel microscopy images in TIFF format. These images correspond to the isolated green channel from the images in the **z-Merge** folder. The images have the same filename as their RGB source in the z-Merge folder.

WORKFLOW INSTRUCTIONS:
1.	Load MATLAB and set the directory to a folder which contains the subfolders **z-Endplates**, **z-Terminals**, and **z-Merge**.
2.	Run the MATLAB function **checkFrames.m** according to the instructions within the function file. This function allows you to loop through each image and define which frames need to be removed from each z-stack, in order to get rid of frames that contain overlapping axons stained by 2H3 in the green channel. Note that only consecutive frames at the start and/or end of the z-stack can be removed. The function saves an Excel file with this information, called **substackFrames.xlsx**. *Which frames to remove: (a)	Remove frames at the start and/or end of the z-stack that contain axons, as these will interfere when trying to colocalise AChR and SV2 later. (b)	Remove frames that correspond to two different endplates sitting on top of each other.*
3.	Run the MATLAB function **makeSubstacks.m**. This function will use the information in the above **substackFrames.xlsx** file to remove the unnecessary frames from each z-stack and save the new stacks in new folders called **z-Endplates substacks**, **z-Terminals substacks**, and **z-Merge substacks**.	There will be no substack images created for those endplates that have zeros in the Excel file as those are to be excluded.
4.	Load ImageJ.	Run the ImageJ macro **CreateMaxProjections.ijm**. When prompted, select the **z-Endplates substacks** folder. This macro will create MAX projection images for each z-stack and save these in the same subfolder.
5.	Repeat the above step for the folder **z-Terminals substacks**.
6.	Open the **z-Endplates substacks** folder. Manually move all images with “MAX” in the filename into a new folder called **Final endplates**. Do the same with the folder **z-Terminals substacks** by transferring the images to a new folder called **Final terminals**.
7.	Run the ImageJ macro **Endplates_binary.ijm**. When prompted, select the **Final endplates** folder. This macro will convert the images to binary images and save them in a subfolder called **Binary endplates**. The background will be black, and the endplate will be white. *Note that this macro also automatically sets the scale! Modify the macro according to your required scale.*
8.	Look through all the binary images and if there are any that are inverted (i.e., the background is white instead of black), then transfer all the inverted binary images into a new folder and run the ImageJ macro **InvertBinaries.ijm**. When prompted, select the folder with the images to be inverted. The macro will create a subfolder with the correct binary images, so transfer those back to the folder with the remaining correct binary images and delete the folder with the inverted images.
9.	Run the ImageJ macro **ConvexHull_area.ijm**. When prompted, select the **Binary endplates** folder. This macro will calculate the area of the convex hull of the endplate and save the results in a CSV file called **ConvexHull_area.csv** in the same folder. This macro will also create a new subfolder called **Convex hull area** with a copy of the binary images analysed, which will have an outline drawn around the endplate (this is only visible when opened in ImageJ) to show which object in the image was used for the analysis.
10.	Run the ImageJ macro **AChR_area.ijm**. When prompted, select the **Binary endplates** folder. This macro will calculate the area of the AChR staining and save the results in a CSV file called **AChR_area.csv** in the same folder. This macro will also create a new subfolder called **AChR** with a copy of the binary images analysed, which will have an outline drawn around the endplate (this is only visible when opened in ImageJ) to show which object in the image was used for the analysis.
11.	Run the ImageJ macro **Endplate_fragments.ijm**. When prompted, select the **Binary endplates** folder. This macro will calculate the number of binary objects in the image (i.e., the number of objects that are at least 2 microns in length), and save the results in a CSV file called **Endplate_fragments.csv** in the same folder. This macro will also create a new subfolder called **Fragments** with a copy of the binary images analysed, which will have an outline drawn around each fragment identified (this is only visible when opened in ImageJ).
12.	Run the ImageJ macro **Terminal_binary.ijm**. When prompted, select the **Final terminals** folder. This macro will convert the images to binary images and save them in a subfolder called **Binary terminals**. *Note that this macro also sets the scale! Modify the macro according to your required scale.*
13.	Look through all the binary images and if there are any that are inverted (i.e., the background is white instead of black), then transfer all the inverted binary images into a new folder and run the ImageJ macro **InvertBinaries.ijm**. The macro will ask you to select a folder so select the folder with the images to be inverted. The macro will create a subfolder with the correct binary images, so transfer those back to the folder with the remaining correct binary images and delete the folder with the inverted images.
14.	Load MATLAB and set the directory to the folder which contains the **Final terminals** and the **Final endplates** subfolders. Run the MATLAB function **terminalColocalisation.m**. This function will check which AChR pixels (red channel) colocalise with the nerve terminals (green channel) and save the binary images showing only the colocalised pixels in a new folder called **Terminal colocalisation**.
15.	Run the ImageJ macro **Terminal_area.ijm**. The macro will ask you to select a folder so select the **Terminal colocalisation** folder. This macro will calculate the area of the colocalised pixels and save the results in a CSV file called **Terminal_area.csv** in the same folder. This macro will also create a new subfolder called **Terminal area** with a copy of the binary images analysed, which will have an outline drawn around the endplate (this is only visible when opened in ImageJ) to show which object in the image was used for the analysis. *Note that this macro also sets the scale! Modify the macro according to your required scale.*
16.	Open the **Terminal_area.csv** file. For the terminals for which the Max column shows a zero, manually change the value in the *Area* column to zero and save the file (overwrite the original file). This is because when there is no object in the binary image, ImageJ calculates the area using the entire image (i.e., all the black pixels), which is wrong.
17.	Load MATLAB and set the current directory to the folder which contains the **Final terminals** and the **Final endplates** subfolders. Run the MATLAB function **compileNMJdata.m**. This function will combine the data from the following files **AChR_area.csv**, **ConvexHull_area**, **Endplate_fragments.csv**, and **Terminal_area.csv** into a single Excel file called **NMJ_data.xlsx**. It will also calculate the additional variables *Coverage* (i.e., the percentage of AChR area that colocalises with SV2 area) and *Compactness* (i.e., the percentage of AChR convex hull area that colocalises with AChR area).

## B.	MOTOR NEURON IMMUNOHISTOCHEMICAL IMAGE ANALYSIS

BACKGROUND: There are two types of images: Four-channel images are those stained for DAPI, ChAT, TDP-43, p62; Three-channel images are those stained for DAPI, ChAT, DYNC1H1.

NOTE: For the MATLAB functions to work, the confocal images must be in individual folders (one folder per image/stack) and the folder name must have the following format: E.g., "FCD7-2_L3_LEFT", or "FC5-28_L4_RIGHT", or "FCD12-1_L5_LEFT_1", or FCD8-25_L6_RIGHT_1" (i.e., "animalID_lumbarSegment_VentralHornSide_ImageNumber", where ImageNumber is optional).

WORKFLOW INSTRUCTIONS:
1. **For four-channel images:** Load the images (these are z-stacks) into ImageJ, and for each one, run the ImageJ macro **SC_IHC_prep.ijm**. This macro does the following in this order: (1) Sets the scale (modify the macro according to your required scale). (2) Defines the colours of each colour channel and saves the RGB stack. (3) Splits the colour channels and saves each channel stack individually. (4) Creates a maximum projection image of each coloured stack and saves these in TIFF format. (5) Converts each maximum projection image to greyscale, and saves these in TIFF format.
2. **For three-channel images:** Load the  images (these are z-stacks) into ImageJ, and for each one, run the ImageJ macro **SC_IHC_DynHC_prep.ijm**. This macro does the same thing as the above step, but for three channels instead of four.
3. Open the greyscale images corresponding to the colour channels that show the ChAT staining and the DAPI staining and arrange them side-by-side. Using the ChAT image as a reference, identify which nuclei correspond to motor neurons in the DAPI image. These are the nuclei that will be used for the analysis below. For each ChAT-positive cell: using the freehand selection tool, draw the outline of the nucleus on the DAPI image. Press **t** on the keyboard to open the ROI Manager and add this ROI to it. On the ChAT image, using the freehand selection tool, draw the outline of the soma that belongs to the cell whose nucleus was just measured. Make sure the nucleus selection does not fall outside the boundaries of the soma outline. Press **t** on the keyboard to add this ROI to the ROI Manager. There are now two ROIs in the ROI Manager: one for the nucleus, and one for the soma outline, in this order. Repeat this for any remaining ChAT-positive cells in the current image. Remember that the ROIs must be added to the ROI Manager in the same order for each cell (i.e., nucleus first, then soma outline).
4. Make sure that all the ROIs in the ROI Manager are selected (for Windows computers, Ctrl + A), then go to **More** > **Save**, to save the ROI Manager window with the filename **ManualROIs.zip**, in the same directory as the image that was just analysed. Close the ROI Manager and all images.
5. Repeat the previous steps for any remaining images.

**Background correction:**

6. Load the TDP-43 channel image into ImageJ. Using the rectangular selection tool, draw a box in a region that represents the background (i.e., no cells). The actual size of this ROI does not matter. Press **t** on the keyboard to add it to the ROI Manager. Repeat this for at least 3 background ROIs from the same image (the more the better, to capture an accurate representation of the background).
7. Make sure that all the ROIs in the ROI Manager are selected (Ctrl + A), then go to **More** > **Save**, to save the ROI Manager window with the filename **BackgroundROIsTDP.zip**. Close the ROI Manager and all images.
8. Repeat the previous steps for any remaining images.
9. Run the ImageJ macro **SC_IHC_TDP_Background.ijm**. When prompted, select the folder containing the image to be analysed. This macro will calculate the fluorescence intensity of the background ROIs and save the results in a file called **BackgroundIntDenTDP.csv**.
10. Load the p62 channel image into ImageJ. Repeat step 6. Make sure that all the ROIs in the ROI Manager are selected (Ctrl + A), then go to **More** > **Save**, to save the ROI Manager window with the filename **BackgroundROIsp62.zip**.
11. Repeat the previous step for any remaining images.
12. Run the ImageJ macro **SC_IHC_p62_Background.ijm**. When prompted, select the folder containing the image to be analysed. This macro will calculate the fluorescence intensity of the background ROIs and save the results in a file called **BackgroundIntDenp62.csv**.
13. Load the DYNC1H1 channel image into ImageJ. Repeat step 6. Make sure that all the ROIs in the ROI Manager are selected (Ctrl + A), then go to **More** > **Save**, to save the ROI Manager window with the filename **BackgroundROIsDYN.zip**.
14. Repeat the previous step for any remaining images.
15. Run the ImageJ macro **SC_IHC_DYN_Background.ijm**. When prompted, select the folder containing the image to be analysed. This macro will calculate the fluorescence intensity of the background ROIs and save the results in a file called **BackgroundIntDenDYN.csv**.

**Analysis of p62 fluorescence intensity and p62 puncta:**

16. Run the ImageJ macro called **SC_IHC_p62.ijm**. When prompted, select the image subfolders one by one until all images are processed. This macro calculates the integrated density of the cytoplasm (not the soma) for each cell separately, and saves these results in a file called **p62_cytoplasmIntDen.csv**. The results are in the order in which the ROIs appear in the ROI Manager.
17. Run the ImageJ macro called **SC_IHC_p62_puncta.ijm**. When prompted, select the image subfolders one by one until all images are processed. This macro auto-thresholds the image (using the 'Minimum' method, which was manually tested for a few random images and was selected as the best method. Modify the macro according to your specific needs.) so that only the puncta are identified. The thresholded image is saved as **MAX_C3_grey_Thresh.tif**. The macro also calculates the area and integrated density of the puncta within the cytoplasm for each cell separately, and saves these results in a file called **p62puncta_#.csv** (numbered according to the number of the cell, in the order that the cell appears in the ROI Manager, so there is one CSV file for each cell). Note that if there are no puncta in a cell, there is nothing to calculate so there will be no file produced for that cell. The macro also flattens all the cytoplasm ROIs onto the **MAX_C3_grey_Thresh.tif** image and saves this as a new image called **Flat of MAX_C3_grey_Thresh.tif**. This macro also saves a new image called **Mask of MAX_C3_grey.tif**, which shows the masks of all the puncta analysed with the cytoplasm ROIs flattened onto the image. These images are later on used by a MATLAB function.
18. Run the MATLAB function **p62punctaCheck.m**. This function is used to visually inspect all the thresholded images produced at the previous step, to ensure that they have been done correctly.
19. Run the MATLAB function **p62puncta.m**. This function does the following: (1) Compiles all the data from the **p62puncta_#.csv** files (from the same image) into one file called **merged_p62puncta.xlsx** and saves this in the same image folder. The information from each cell is on a different sheet in the Excel file. For cells that do not have a **p62puncta_#.csv** file (because they have no puncta), an empty sheet is created in the Excel file. The Excel sheets are numbered according to the cell numbering in the ROI Manager. (2) Calculates the background-corrected fluorescence intensity of each puncta and adds this information to the **merged_p62puncta.xlsx** file. (3) Calculates the total number of puncta per cell and saves this information in a file called **p62punctaPerCell.xlsx**.
20. Run the MATLAB function **p62punctaMaster.m**. This function compiles the information from all the **merged_p62puncta.xlsx** files into a master file called **p62punctaMaster.xlsx**.

**Analysis of TDP-43 fluorescence intensity and TDP-43 puncta:**

21. Run the ImageJ macro **SC_IHC_TDP.ijm**. When prompted, select the image subfolders one by one until all images are processed. This macro calculates the integrated density of the cytoplasm and the nucleus separately for each cell, and saves these results in two files called **NucleusIntDen.csv** and **CytoplasmIntDen.csv**. The results are in the order in which the ROIs appear in the ROI Manager window.
22. Run the ImageJ macro **SC_IHC_TDP_puncta.ijm**. When prompted, select the image subfolders one by one until all images are processed. This macro auto-thresholds the image (using the 'Minimum' method, which was manually tested for a few random images and was selected as the best method. Modify the macro according to your needs) so that only the puncta are identified. The thresholded image is saved as **MAX_C4_grey_Thresh.tif**. The macro also calculates the area and integrated density of the puncta (if puncta area is 2 pixels or more) within the cytoplasm for each cell separately, and saves these results in a file called **TDPpuncta_#.csv** (numbered according to the number of the cell, in the order that the cell appears in the ROI Manager, so there is one CSV file for each cell). Note that if there are no puncta in a cell, there is nothing to calculate so there will be no CSV file produced for that cell. The macro also flattens all the cytoplasm ROIs onto the **MAX_C4_grey_Thresh.tif** image and saves this as a new image called **Flat of MAX_C4_grey_Thresh.tif**. The macro also saves a new image called **Mask of MAX_C4_grey.tif**, which shows the masks of all the puncta analysed with the cytoplasm ROIs flattened onto the image. These images are later on used by a MATLAB function.
23. Load MATLAB and set the current directory to the folder containing the image subfolders. Run the MATLAB function **TDPpunctaCheck.m**. This function is used to visually inspect all the thresholded images produced at the previous step, to ensure that they have been done correctly. The three images shown by this function are the original C4 image, the thresholded image, and the image with the masks of the puncta that were analysed. There are two possibilities of incorrect thresholding: (1) There are cells that appear to have more puncta in the thresholded image than in the original image. (2) There are cells that appear to have some puncta in the thresholded image but they have zero puncta in the original image. Note that these cells can be rescued at a later step. In a new file called **TDPpunctaExcluded.xlsx**, make a note of which cells these are so that they can be excluded from the analysis later.
24. Run the MATLAB function **TDPpuncta.m**. This function does the following: (1) Compiles all the data from the **TDPpuncta_#.csv** files (from the same image) into one file called **merged_TDPpuncta.xlsx** and saves this in the same image folder. The information from each cell is on a different sheet in the Excel file. For cells that do not have a **TDPpuncta_#.csv** file (because they have no puncta), an empty sheet is created in the Excel file. The Excel sheets are numbered according to the cell numbering in the ROI Manager. For images in which ALL the cells have no puncta, a **merged_TDPpuncta.xlsx** file is not created. (2) Calculates the background-corrected fluorescence intensity of each puncta and adds this information to the **merged_TDPpuncta.xlsx** file. (3) Calculates the total number of puncta per cell and saves this information in a file called **TDPpunctaPerCell.xlsx**.
25. To exclude or rescue cells (as noted in file TDPpunctaExcluded.xlsx), do the following: (1) If a cell clearly has zero puncta by visual inspection of the original image, but the thresholded image identifies false puncta, then this cell can be rescued instead of being excluded. To do this, open the **merged_TDPpuncta.xlsx** file for that image, go to the "combined" sheet, and delete the rows corresponding to this cell, then re-save the file. Then open the **TDPpunctaPerCell.xlsx** file, and manually change the number of puncta for that cell to zero, then re-save the file. IMPORTANT: If by the end of this, there are no cells in that image that have puncta (either because they were excluded or manually set to zero), then delete the **merged_TDPpuncta.xlsx** file for that image so that subsequent functions can work properly. (2) If ALL the cells in an image need to be excluded, then delete the **merged_TDPpuncta.xlsx** file and the **TDPpunctaPerCell.xlsx** file for that image. (3) If only SOME of the cells in an image need to be excluded, then open the **merged_TDPpuncta.xlsx** file for that image, go to the sheet titled "combined", and delete the rows corresponding to the excluded cells, then re-save the file. Then open the **TDPpunctaPerCell.xlsx** file, delete the rows corresponding to the excluded cells, then re-save the file.
26. Run the MATLAB function **TDPpunctaMaster.m**. This function compiles the information from all the **merged_TDPpuncta.xlsx** file into a master file called **TDPpunctaMaster.xlsx**.

**Analysis of cell size**

27. Run the ImageJ macro **SC_IHC_ChAT.ijm**. When prompted, select the image subfolders one by one until all images are processed. This macro calculates the area of the soma for each cell, and saves these results in a file called **ChATsize.csv**. The results are in the order in which the ROIs appear in the ROI Manager window.
28. Run the ImageJ macro **SC_IHC_DAPI.ijm**. When prompted, select the image subfolders one by one until all images are processed. This macro calculates the area of the nucleus for each cell, and saves these results in a file called **DAPIshape.csv**. The results are in the order in which the ROIs appear in the ROI Manager window.

**Analysis of DYNC1H1 fluorescence intensity**

29. Run the ImageJ macro **SC_IHC_DynHC.ijm**. When prompted, select the image subfolders one by one until all images are processed. This macro calculates the integrated density of the cytoplasm for each cell, and saves these results in a file called **DynHC.csv**. The results are in the order in which the ROIs appear in the ROI Manager window. This macro also saves all the ROIs in the ROI Manager as a file called **ROIs.zip** that can be opened in ImageJ later.
30. Load MATLAB and set the current directory to the folder containing the image subfolders. Run the MATLAB function **FCD_SC_Dyn_merge.m**. This function merges all the data from the separate CSV files produced by the ImageJ macro into one file, and also does the below calculation for each cell in each image. The merged data for each image are saved in the image folder as **mergedData.xlsx**.

*Calculation:* Amount of DYNC1H1 that is in the cytoplasm (normalised to area): DYN_C = RawIntDen (of cytoplasm) / Area (of cytoplasm).

Note that the above calculation takes into account the background fluorescence, so the results are background-corrected.

*The function also appends the following information to each cell analysed:*

- Cell number in the image (1 to n).
- Lumbar segment (L3 to L6).
- Left or right ventral horn.
- Animal ID.
- Genotype.
- Image number (1 to n).

**Analysis of ChAT fluorescence intensity**

31. Run the ImageJ macro **SC_IHC_ChAT_intensity.ijm**. When prompted, select the image subfolders one by one until all images are processed. This macro calculates the integrated density of the cytoplasm for each cell, and saves these results in a file called **ChAT_CytoplasmIntDen.csv**. The results are in the order in which the ROIs appear in the ROI Manager window.

**Merge data into master files**

32. Load MATLAB and set the current directory to the folder containing the image subfolders. Run the MATLAB function **FCD_SC_merge_data.m**. This function merges all the data from the separate ImageJ CSV files into one file, and also does the below calculations for each cell in each image. The merged data for each image are saved in the image folder as **mergedData.xlsx**.

*Caluclations using the TDP-43 data:*

- **Amount of TDP-43 that is in the nucleus (normalised to area):** TDP_N = RawIntDen (of nucleus) / Area (of nucleus).
- **Amount of TDP-43 that is in the cytoplasm (normalised to area):** TDP_C = RawIntDen (of cytoplasm) / Area (of cytoplasm).
- **Total amount of TDP-43 in the cell:** TDP_T= TDP_N + TDP_C.
- **Percentage of TDP-43 that is localised to the nucleus:** TDP_pN = TDP_N/TDP_T*100.
- **Percentage of TDP-43 that is localised to the cytoplasm:** TDP_pC = TDP_C/TDP_T*100.
- **Nucleus/Soma area:** NucToPerArea = Area (of nucleus) / (Area of nucleus + Area of cytoplasm).
- **Whether more than 50% of TDP-43 is cytoplasmic:** If pC>50 then MajorCytTDP=1 (yes) else MajorCytTDP=0 (no).
 
*Calculation using the p62 data:*

- **Amount of p62 that is cytoplasmic (normalised to area):** p62_C = RawIntDen (of cytoplasm) / Area (of cytoplasm). 

Note that the above calculations take into account the background fluorescence, so the results are background-corrected.

*The function also calculates the following, for each animal:*

- **Percentage of cells with >50% TDP-43:** (Total cells with >50% cytoplasmic TDP-43) / (Total cells).
- **Percentage of cells with TDP-43 puncta:** (Total cells with TDP-43 puncta) / (Total cells).
- **Percentage of cells with p62 puncta :** Total cells with p62 puncta) / (Total cells).

*The function also appends the following information to each cell analysed:*

- Cell number in the image (1 to n).
- Lumbar segment (L3 to L6).
- Left or right ventral horn.
- Animal ID.
- Genotype.
- Image number (1 to n).

33. **For four-channel images:** Load MATLAB and set the current directory to the folder containing the image subfolders. Run the MATLAB function **FCD_SC_masterfile.m**. This function transfers the data from each **mergedData.xlsx** file into a single file called **masterfile.xlsx** which is saved in the parent directory.
34. **For three-channel images:** Load MATLAB and set the current directory to the folder containing the image subfolders. Run the MATLAB function **FCD_SC_DYN_masterfile.m**. This function transfers the data from each **mergedData.xlsx** file into a single file called **DYNmasterfile.xlsx** which is saved in the parent directory.
