class TSMasker {
  PImage tsMask;
  
  TSMasker() {
  }
PImage getMask() { 
    PImage rgbImage;

    int[] map = context.sceneMap();
    rgbImage=context.rgbImage();
    rgbImage.loadPixels();
    for (int i=0;i<map.length;i++) {
      if (map[i] > 0) {
        //if there's a user pixel at this index leave it as it is
      }
      else {
        //otherwise paint it out
        rgbImage.pixels[i]=color(0, 0, 0);
      }
    }
      rgbImage.updatePixels();

    return rgbImage;
  }
  
/*  PImage blurMask() {
    return PImage anImage;
  }*/
};

