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
      println("pos2d_");
    }
    else if (exploded[exploded.length-1].equals("pos3d") ) {
    }
    else if (exploded[exploded.length-1].equals("vel2d") ) {
    }
    else if (exploded[exploded.length-1].equals("pos3d") ) {
    }
    else if (exploded[exploded.length-1].equals("confidence") ) {
    }
    println(address);
  }
}

TS_OSC_Receiver tsReceiver = new TS_OSC_Receiver();

