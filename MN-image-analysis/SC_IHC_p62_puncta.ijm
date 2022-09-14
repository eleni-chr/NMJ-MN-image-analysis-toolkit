//Macro written by Eleni Christoforidou

currentDir=getDir("Choose a Directory");
open("MAX_C3_grey.tif");
open("ManualROIs.zip");
run("Auto Threshold", "method=MaxEntropy white");
saveAs("Tiff", currentDir+"/MAX_C3_grey_Thresh.tif");

//DECLARE FUNCTIONS

//Assign indices to ROIs
function findIndexByName(title) {
	count=roiManager("count");
	index=-1;
	for (i=0; i<count; i++){
		roiManager("select", i);
		if (getInfo("selection.name")==title){
			index=i;
		}
	}
	return index;
}

//Give a name to all the ROIs in the ROI Manager
function renameROIs() {
	count=roiManager("count");
	for (i=0; i<count; i++){
		roiManager("select", i);
		if (i%2==0){
			roiManager("Rename", "nucleus"+(i/2)+1)
		}
		else {
			roiManager("Rename", "cell"+Math.floor(i/2)+1)
		}
	}
}

//Create a new ROI outlining the cytoplasm, excluding the nucleus
function createCytoplasm(i) {
	roiManager("Select", newArray(findIndexByName("nucleus"+i),findIndexByName("cell"+i)));
	roiManager("XOR");
	roiManager("Add");
	roiManager("Select", roiManager("count")-1);
	roiManager("Rename", "cytoplasm"+i);
}

//Calculate the puncta parameters of the cytoplasm ROIs
function calculatePunctaCytoplasm(i) {
	roiManager("Select", findIndexByName("cytoplasm"+i));
	run("Set Measurements...", "area integrated redirect=None decimal=3");
	run("Analyze Particles...", "size=2-Infinity pixel display exclude");
	saveAs("Results", currentDir+"/p62puncta_"+i+".csv");
	close("Results");
}

//Flatten ROIs
function flattenROIs(i) {
	roiManager("Select", findIndexByName("cytoplasm"+i));
	run("Flatten");
}

//Create new ROI Manager with only cytoplasm ROIs
function cytoplasmROIs(i){
	roiManager("Select", findIndexByName("nucleus"+i));
	roiManager("Delete");
	roiManager("Select", findIndexByName("cell"+i));
	roiManager("Delete");
	roiManager("Select", findIndexByName("perinucleus"+i));
	roiManager("Delete");
}

//CALL FUNCTIONS
renameROIs();
cellCount=roiManager("count")/2;
for (i=0; i<cellCount; i++) {
	createCytoplasm(i+1);
	}
	
for (i=0; i<cellCount; i++) {
	calculatePunctaCytoplasm(i+1);
	}

close("Results");
close();
selectWindow("ROI Manager");
run("Close");

open("MAX_C3_grey_Thresh.tif");
open("ROIs.zip");
for (i=0; i<cellCount; i++) {
	flattenROIs(i+1);
	}
saveAs("Tiff", currentDir+"/Flat of MAX_C3_grey_Thresh.tif");
close("*");
selectWindow("ROI Manager");
run("Close");

open("MAX_C3_grey_Thresh.tif");
open("ROIs.zip");
if (cellCount>1) {
	for (i=0; i<cellCount; i++) {
		cytoplasmROIs(i+1);
		}
	roiManager("Combine");
	close("*");
	open("MAX_C3_grey_Thresh.tif");
	roiManager("Select", 0);
}
else{
	roiManager("Select", findIndexByName("cytoplasm1"));
}

run("Analyze Particles...", "size=2-Infinity pixel show=Masks display exclude");
selectWindow("Mask of MAX_C3_grey_Thresh.tif");
run("Invert");
roiManager("Select", findIndexByName("cytoplasm1"));
run("Flatten");
saveAs("Tiff", currentDir+"/Mask of MAX_C3_grey.tif");
close("Results");
close("*");
selectWindow("ROI Manager");
run("Close");