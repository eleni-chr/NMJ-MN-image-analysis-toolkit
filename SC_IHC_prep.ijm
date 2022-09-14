//Macro written by Eleni Christoforidou.

//CHANGE THE VARIABLE "path1" TO THE INPUT FOLDER

fname=getTitle;
newname=substring(fname,22,lengthOf(fname));
path1="C:/Users/...";
outpath=path1+newname;
run("Set Scale...", "distance=1 known=0.18 unit=micron");
run("Channels Tool...");
Stack.setDisplayMode("color");
Stack.setChannel(1);
run("Blue");
Stack.setChannel(2);
run("Green");
Stack.setChannel(3);
run("Yellow");
Stack.setChannel(4);
run("Red");
saveAs("Tiff", outpath+"/masterfile.tif");
run("Close");

selectWindow("masterfile.tif");
run("Split Channels");
selectWindow("C4-masterfile.tif");
saveAs("Tiff", outpath+"/C4.tif");
selectWindow("C3-masterfile.tif");
saveAs("Tiff", outpath+"/C3.tif");
selectWindow("C2-masterfile.tif");
saveAs("Tiff", outpath+"/C2.tif");
selectWindow("C1-masterfile.tif");
saveAs("Tiff", outpath+"/C1.tif");

selectWindow("C1.tif");
run("Z Project...", "projection=[Max Intensity]");
saveAs("Tiff", outpath+"/MAX_C1.tif");
selectWindow("C1.tif");
close();
selectWindow("C2.tif");
run("Z Project...", "projection=[Max Intensity]");
saveAs("Tiff", outpath+"/MAX_C2.tif");
selectWindow("C2.tif");
close();
selectWindow("C3.tif");
run("Z Project...", "projection=[Max Intensity]");
saveAs("Tiff", outpath+"/MAX_C3.tif");
selectWindow("C3.tif");
close();
selectWindow("C4.tif");
run("Z Project...", "projection=[Max Intensity]");
saveAs("Tiff", outpath+"/MAX_C4.tif");
selectWindow("C4.tif");
close();

selectWindow("MAX_C4.tif");
run("8-bit");
saveAs("Tiff", outpath+"/MAX_C4_grey.tif");
close();
selectWindow("MAX_C3.tif");
run("8-bit");
saveAs("Tiff", outpath+"/MAX_C3_grey.tif");
close();
selectWindow("MAX_C2.tif");
run("8-bit");
saveAs("Tiff", outpath+"/MAX_C2_grey.tif");
close();
selectWindow("MAX_C1.tif");
run("8-bit");
saveAs("Tiff", outpath+"/MAX_C1_grey.tif");
close();