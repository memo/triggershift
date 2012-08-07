

class TSMasker {
  PImage rgbImage;    // rgb masked image
  PImage maskImage;   // grayscale mask image
  
  //----------------------------------
  // update images form openni context
  void update(SimpleOpenNI context) {
    int w = context.rgbImage().width;
    int h = context.rgbImage().height;

    // init maskImage
    if(maskImage == null || maskImage.width != w || maskImage.height != h) maskImage = createImage(w, h, ALPHA);
    
    // init rgbImage
    if(rgbImage == null || rgbImage.width != w || rgbImage.height != h) rgbImage = createImage(w, h, RGB);

    // get color image from context
    rgbImage.copy(context.rgbImage(), 0, 0, w, h, 0, 0, w, h);
    
    // create a mask image 
    int[] map = context.sceneMap();
    maskImage.loadPixels();
    for (int i=0;i<map.length;i++) {
      if (map[i] > 0) {
        maskImage.pixels[i] = 255;
      } else {
        maskImage.pixels[i] = 0;
      }
    }
    maskImage.updatePixels();
    
    // blur mask (too slow)
    //    maskImage.filter(BLUR, mouseX *10.0/width); // too slow

    // apply mask
    rgbImage.mask(maskImage);
  }
  
  
  //----------------------------------
  // return image
  PImage getImage() { 
    return rgbImage;
  }

};

