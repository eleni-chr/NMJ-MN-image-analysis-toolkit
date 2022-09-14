//Macro written by Eleni Christoforidou.

currentDir=getDir("Choose a Directory");
open("MAX_C3_grey.tif");
open("BackgroundROIsDYN.zip");

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
		roiManager("Rename", "background"+(i+1))
		}
		}

//Calculate the integrated density of the background ROIs
function calculateIntDenBackground(i) {
	roiManager("Select", findIndexByName("background"+i));
	run("Set Measurements...", "area integrated redirect=None decimal=3");
	run("Measure");
}

//CALL FUNCTIONS
renameROIs();
cellCount=roiManager("count");

for (i=0; i<cellCount; i++) {
	calculateIntDenBackground(i+1);
}
saveAs("Results", currentDir+"/BackgroundIntDenDYN.csv");
close("Results");
selectWindow("ROI Manager");
run("Close");
close();