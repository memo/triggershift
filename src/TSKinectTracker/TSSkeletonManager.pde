

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
    for (int i=0; i<skeletons.length; i++) {
      TSSkeleton s = skeletons[i];
      s.update();
    }
  }  


  //----------------------------------
  TSSkeleton activeSkeleton() {
    //    return activeUserIndex >=0 ? skeletons[activeUserIndex] : null;
    return skeletons[activeUserIndex];
  }


  //----------------------------------
  void draw2d(float x, float y, float w, float h) {
    for (int i=0; i<skeletons.length; i++) {
      TSSkeleton s = skeletons[i];
      s.draw2d(x, y, w, h);
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



