

class TSMasker {
  PImage rgbImage;    // rgb masked image
  PImage maskImage;   // grayscale mask image
  
  //----------------------------------
  // update images form openni context
  void update(SimpleOpenNI context) {
    
    // get color image from context
    rgbImage = context.rgbImage();
    
    // if dimensions don't match, allocate new image for mask
    if(maskImage == null || maskImage.width != rgbImage.width || maskImage.height != rgbImage.height) {
      maskImage = createImage(rgbImage.width, rgbImage.height, ALPHA);
    }

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

