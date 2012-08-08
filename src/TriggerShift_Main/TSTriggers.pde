
// a generic interface for a Trigger
// a Trigger is a set of rules / interactions, that trigger another action (e.g. Scene change)
interface TSTriggerBaseI {
  boolean check();
};


//----------------------------------
class MouseAreaTrigger implements TSTriggerBaseI {
  float x1, y1, x2, y2;
  boolean requireMouseClick;

  MouseAreaTrigger(float _x1, float _y1, float _x2, float _y2, boolean _b) { 
    x1=_x1; 
    y1=_y1; 
    x2=_x2; 
    y2=_y2; 
    requireMouseClick=_b;
  }

  boolean check() {
    return (mouseX > x1 && mouseX < x2 && mouseY > y1 && mouseY < y2) && (mousePressed || !requireMouseClick);
  }
};

//----------------------------------
class MouseClickTrigger implements TSTriggerBaseI {
  boolean check() {
    return mousePressed;
  }
}


//----------------returns true if selected joint is in front of threshold position on z axis------------------
class ZAxisThreshTrigger implements TSTriggerBaseI {
  float zThresh;
  int jointType;
  ZAxisThreshTrigger(float _zThresh, int _jointType, TSSkeleton skeleton) { 
    zThresh = _zThresh;
    jointType = _jointType;
  }

  boolean check() {
    return skeleton.getWorldCoords(openNIContext, 1, jointType).z < zThresh;
  }
};


