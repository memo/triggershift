import oscP5.*;
import netP5.*;

class TS_OSC_Receiver {

  OscP5 oscP5;
  TS_OSC_Receiver() {
    oscP5 = new OscP5(this, 7000);
  }
  void oscEvent(OscMessage theOscMessage) {

    String address = theOscMessage.addrPattern();
    String [] exploded = splitTokens(address, "/");

    if (exploded[exploded.length-1].equals("pos2d") ) {
      skeletonManager.skeletons[int(exploded[1])].setJointPos2d(int(exploded[3]), new PVector (width * theOscMessage.get(0).floatValue(), height * theOscMessage.get(1).floatValue()));
    }
    else if (exploded[exploded.length-1].equals("pos3d") ) {
      skeletonManager.skeletons[int(exploded[1])].setJointPos3d(int(exploded[3]), new PVector (theOscMessage.get(0).floatValue(), theOscMessage.get(1).floatValue(), theOscMessage.get(2).floatValue()));
    }
    else if (exploded[exploded.length-1].equals("vel2d") ) {
      skeletonManager.skeletons[int(exploded[1])].setJointVel2d(int(exploded[3]), new PVector (width * theOscMessage.get(0).floatValue(), height * theOscMessage.get(1).floatValue()));
    }
    else if (exploded[exploded.length-1].equals("smoothvel2d") ) {
        skeletonManager.skeletons[int(exploded[1])].setJointSmoothVel2d(int(exploded[3]), new PVector (width * theOscMessage.get(0).floatValue(), height * theOscMessage.get(1).floatValue()));
    }
    else if (exploded[exploded.length-1].equals("confidence") ) {     
      skeletonManager.skeletons[int(exploded[1])].setConfidence(theOscMessage.get(0).floatValue());
    }
  }
}

TS_OSC_Receiver tsReceiver = new TS_OSC_Receiver();

