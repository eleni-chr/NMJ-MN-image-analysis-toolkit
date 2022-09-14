dir = getDirectory("Choose a Directory ");
   setBatchMode(true);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   saveAs("results",dir+"ConvexHull_area.csv");
   close("Results");
   
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
             File.makeDirectory(dir+"Convex hull area");
             processFile(path, list[i]);
          }
      }
  }

  function processFile(path, filename) {
       if (endsWith(path, ".tif")) {
           open(path);
           fname=dir+"Convex hull area\\"+filename;
           run("Subtract Background...", "rolling=50 light create");
           setOption("BlackBackground", true);
           run("Make Binary");
           run("Invert");
           setAutoThreshold("Huang dark");
           run("Despeckle");
           if (getPixel(1,1)==255){
           	run("Invert");
           }
           run("Create Selection");
           run("Set Measurements...", "area display add redirect=None decimal=3");
           run("Measure");
           saveAs("Tiff",fname);
           close();
      }
  }
