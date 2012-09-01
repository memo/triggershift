import codeanticode.syphon.*;

class TSSyphonReceiver {
  PImage img;
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
      img = imgReceived;
      if(img == null || img.width != imgReceived.width || img.height != imgReceived.height) {
        img = createImage(imgReceived.width, imgReceived.height, ARGB);
      }
      
      // HACK TO MAKE IT TRANSPARENT BECAUSE SYPHON IN PROCESSING DOESN"T RESPECT ALPHA
      img.loadPixels();
      imgReceived.loadPixels();
      for(int i=0; i<img.width * img.height; i++) {
        if(imgReceived.pixels[i] == color(0, 0, 0)) img.pixels[i] = color(0, 0, 0, 0);
//          img.pixels[i] = imgReceived.pixels[i];
      }
      img.updatePixels();
    } else {
      if(millis() - lastUpdateMillis > 1000) {
        lastUpdateMillis = millis();
        img = null;
      }
    }
  }
};

TSSyphonReceiver syphon = new TSSyphonReceiver(this, "TSKinectTracker");

