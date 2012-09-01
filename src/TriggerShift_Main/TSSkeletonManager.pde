

class TSSkeletonManager {
  TSSkeleton []skeletons;
  int activeUserIndex;

  //----------------------------------
  TSSkeletonManager(int maxUsers) {
    skeletons = new TSSkeleton[maxUsers];
    for (int i=0; i<skeletons.length; i++) {
      skeletons[i] = new TSSkeleton(i);
    }
  }


  //----------------------------------
  void update() {
    float highestConfidence = -1;
    for (int i=0; i<skeletons.length; i++) {
      TSSkeleton s = skeletons[i];
      s.update();
      if (s.getConfidence() > highestConfidence) {
        highestConfidence = s.getConfidence();
        activeUserIndex = i;
      }
    }
  }  


  //----------------------------------
  TSSkeleton activeSkeleton() {
    //    return activeUserIndex >=0 ? skeletons[activeUserIndex] : null;
    return skeletons[activeUserIndex];
  }


  //----------------------------------
  void drawVelocities(float velMult) {
    for (int i=0; i<skeletons.length; i++) {
      TSSkeleton s = skeletons[i];
      s.drawVelocities(velMult);
    }
  }
  
  
  //----------------------------------
  void draw2d() {
    for (int i=0; i<skeletons.length; i++) {
      TSSkeleton s = skeletons[i];
      s.draw2d();
    }
  }


  //----------------------------------
  void draw3d() {
    for (int i=0; i<skeletons.length; i++) {
      TSSkeleton s = skeletons[i];
      s.draw3d();
    }
  }
};


TSSkeletonManager skeletonManager = new TSSkeletonManager(17);


