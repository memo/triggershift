import codeanticode.syphon.*;

class TSSyphonReceiver {
  PImage img;
  SyphonClient client;
  int lastUpdateMillis;

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
      img = client.getImage(img, false); // does not load the pixels array (faster)
    } else {
      if(millis() - lastUpdateMillis > 1000) {
        lastUpdateMillis = millis();
        img = null;
      }
    }
  }
};

TSSyphonReceiver syphon = new TSSyphonReceiver(this, "TSKinectTracker");

