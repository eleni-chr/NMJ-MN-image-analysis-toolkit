dir = getDirectory("Choose a Directory ");
setBatchMode(true);
count = 0;
countFiles(dir);
n = 0;
processFiles(dir);

function countFiles(dir) {
  list = getFileList(dir);
  for (i=0; i<list.length; i++) {
      if (endsWith(list[i], "/"))
          countFiles(""+dir+list[i]);
      else
          count++;
  }
}

function processFiles(dir) {
  list = getFileList(dir);
  for (i=0; i<list.length; i++) {
      if (!endsWith(list[i], "/")){
         showProgress(n++, count);
         path = dir+list[i];
         File.makeDirectory(dir+"Fragments");
         processFile(path, list[i]);
      }
  }
}

function processFile(path, filename) {
   if (endsWith(path, ".tif")) {
       open(path);
       fname=dir+"Fragments\\"+filename;
       run("Analyze Particles...", "size=2-Infinity show=Outlines add");
       saveAs("Tiff",fname);
       nROIs=roiManager("count");
       roiManager("Delete");
       newname=substring(filename,0,lengthOf(filename)-4);
       print(nROIs+","+newname);
       close();
  }
}
selectWindow("Log");
saveAs("Text", dir+"Endplate_fragments.csv");
selectWindow("Log");
run("Close");