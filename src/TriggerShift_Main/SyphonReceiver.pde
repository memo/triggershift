import codeanticode.syphon.*;

class TSSyphonReceiver {
  PImage img;
  PImage imgMask;
  PImage imgReceived;
  SyphonClient client;
  int lastUpdateMillis = -1000;

  TSSyphonReceiver(PApplet a, String s) {
    client = new SyphonClient(a, s);
  }

  void update() {  
    if (client.available()) {
      lastUpdateMillis = millis();
      // The first time getImage() is called with 
      // a null argument, it will initialize the PImage
      // object with the correct size.
      //img = client.getImage(img, false); // load the pixels array with the updated image info (slow)
      imgReceived = client.getImage(imgReceived, true);
      //      img = imgReceived;
      //imgMask= imgReceived;
      if (img == null || img.width != imgReceived.width || img.height != imgReceived.height) {
        img = createImage(imgReceived.width, imgReceived.height, ARGB);
        imgMask = createImage(imgReceived.width, imgReceived.height, RGB);
      }

      // HACK TO MAKE IT TRANSPARENT BECAUSE SYPHON IN PROCESSING DOESN"T RESPECT ALPHA
      img.loadPixels();
      imgMask.loadPixels();
      imgReceived.loadPixels();
      for (int i=0; i<img.width; i++) {
        for (int j=0; j<img.height; j++) {
          int i1 = j*img.width + i;
          int i2 = (img.height-1-j)*img.width + i;
          if (imgReceived.pixels[i1] == color(0, 0, 0)) {
            img.pixels[i2] = color(0, 0, 0, 0);
            imgMask.pixels[i2] = color(0, 0, 0);
          } 
          else {
            img.pixels[i2] = imgReceived.pixels[i1];
            imgMask.pixels[i2] = color(255, 255, 255);
          }
        }
      }
      img.updatePixels();
      imgMask.updatePixels();
    } 
    else {
      if (millis() - lastUpdateMillis > 1000) {
        lastUpdateMillis = millis();
        img = null;
      }
    }
  }
};

TSSyphonReceiver syphon = new TSSyphonReceiver(this, "TSKinectTracker");

