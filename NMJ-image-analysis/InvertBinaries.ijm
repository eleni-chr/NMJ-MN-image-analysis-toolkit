//Macro written by Eleni Christoforidou.

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
             File.makeDirectory(dir+"Inverted binaries");
             processFile(path, list[i]);
          }
      }
  }

  function processFile(path,filename) {
       if (endsWith(path, ".tif")) {
           open(path);
           fname=dir+"Inverted binaries\\"+filename;
           run("Invert");
           saveAs("Tiff", fname);
           close();
      }
  }
