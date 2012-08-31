import codeanticode.syphon.*;

class TSSyphonSender {
  PImage img;
  SyphonServer server;

  TSSyphonSender(PApplet a, String s) {
    server = new SyphonServer(a, s);
  }
  
  void sendImage(PImage img) {
    server.sendImage(img);
  }
  
};

TSSyphonSender syphonSender = new TSSyphonSender(this, "TriggerShiftTracker");


