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
             File.makeDirectory(dir+"Binary endplates");
             processFile(path, list[i]);
          }
      }
  }

  function processFile(path,filename) {
       if (endsWith(path, ".tif")) {
           open(path);
           fname=dir+"Binary endplates\\"+filename;
           run("Set Scale...", "distance=1 known=0.1803751711 unit=um");
           run("Enhance Contrast...", "saturated=0.2 normalize equalize");
		   run("Despeckle");
           setOption("BlackBackground", true);
           run("Make Binary");
           setAutoThreshold("Huang dark");
           run("Despeckle");
           if (getPixel(1,1)==255){
           	run("Invert");
           }  
           saveAs("Tiff", fname);
           close();
      }
  }
