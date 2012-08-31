
// a class which takes an OpenNI context, and applys the user mask as an alpha mask to the RGB image (optionally blurring it)

class TSMasker {
  protected PImage rgbImage;    // rgb masked image
  protected PImage maskImage;   // grayscale mask image

    //----------------------------------
  // update images form openni context
  void update(SimpleOpenNI context, int maskBlurAmount) {
    int w = context.rgbImage().width;
    int h = context.rgbImage().height;

    // init maskImage
    if (maskImage == null || maskImage.width != w || maskImage.height != h) maskImage = createImage(w, h, ALPHA);

    // init rgbImage
    if (rgbImage == null || rgbImage.width != w || rgbImage.height != h) rgbImage = createImage(w, h, RGB);

    // get color image from context
    rgbImage.copy(context.rgbImage(), 0, 0, w, h, 0, 0, w, h);

    // create a mask image 
    int[] map = context.sceneMap();
    maskImage.loadPixels();
    for (int i=0;i<map.length;i++) {
      if (map[i] > 0) {
        maskImage.pixels[i] = 255;
      } 
      else {
        maskImage.pixels[i] = 0;
      }
    }
    maskImage.updatePixels();

    // blur mask (quite slow)
    if (maskBlurAmount>0) maskImage.filter(BLUR, maskBlurAmount);

    // apply mask
    rgbImage.mask(maskImage);
  }


  //----------------------------------
  // return image
  PImage getImage() { 
    return rgbImage;
  }
    // return image
  PImage getMask() { 
    return maskImage;
  }
};
TSMasker masker = new TSMasker();

