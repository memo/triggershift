

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




PVector getHead() {
//  if (skeleton == null) return new PVector(width * 0.5, height * 0.25, 0);
  return skeletonManager.activeSkeleton().getJointPos2d(SKEL_HEAD);
}

PVector getHip() {
//  if (skeleton == null) return new PVector(width * 0.5, height * 0.5, 0);
  return PVector.mult( PVector.add(skeletonManager.activeSkeleton().getJointPos2d(SKEL_LEFT_HIP), skeletonManager.activeSkeleton().getJointPos2d(SKEL_RIGHT_HIP)), 0.5);
}


PVector getLeftHand() {
//  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeletonManager.activeSkeleton().getJointPos2d(SKEL_LEFT_HAND);
}

PVector getLeftHand3D() {
//  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeletonManager.activeSkeleton().getJointPos3d(SKEL_LEFT_HAND);
}


PVector getLeftHandVelocity() {
//  if (skeleton == null) return new PVector((mouseX - pmouseX) * secondsSinceLastFrame, (mouseY - pmouseY) * secondsSinceLastFrame, 0);
  return skeletonManager.activeSkeleton().getJointVel(SKEL_LEFT_HAND);
}

PVector getRightHand() {
//  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeletonManager.activeSkeleton().getJointPos2d(SKEL_RIGHT_HAND);
}

PVector getRightHand3D() {
//  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeletonManager.activeSkeleton().getJointPos3d(SKEL_RIGHT_HAND);
}


PVector getRightHandVelocity() {
//  if (skeleton == null) return new PVector((mouseX - pmouseX) * secondsSinceLastFrame, (mouseY - pmouseY) * secondsSinceLastFrame, 0);
  return skeletonManager.activeSkeleton().getJointVel(SKEL_RIGHT_HAND);
}


PVector getHand(int i) {
  return i == 0 ? getLeftHand() : getRightHand();
}

PVector getHandVelocity(int i) {
  return i == 0 ? getLeftHandVelocity() : getRightHandVelocity();
}



PVector getLeftElbow() {
//  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeletonManager.activeSkeleton().getJointPos2d(SKEL_LEFT_ELBOW);
}

PVector getRightElbow() {
//  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeletonManager.activeSkeleton().getJointPos2d(SKEL_RIGHT_ELBOW);
}

PVector getLeftShoulder() {
//  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeletonManager.activeSkeleton().getJointPos2d(SKEL_LEFT_SHOULDER);
}

PVector getRightShoulder() {
//  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeletonManager.activeSkeleton().getJointPos2d(SKEL_RIGHT_SHOULDER);
}

PVector getLeftArm() {
  return PVector.sub(getLeftHand(), getLeftShoulder());
}

PVector getRightArm() {
  return PVector.sub(getRightHand(), getRightShoulder());
}


PVector getLeftFoot() {
//  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeletonManager.activeSkeleton().getJointPos2d(SKEL_LEFT_FOOT);
}

PVector getRightFoot() {
//  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeletonManager.activeSkeleton().getJointPos2d(SKEL_RIGHT_FOOT);
}



PVector getHighestHand() {
  PVector rightHand = getRightHand();
  PVector leftHand = getLeftHand();
  return leftHand.y < rightHand.y ? leftHand : rightHand;
}

PVector getHighestHandVelocity() {
  PVector rightHand = getRightHand();
  PVector leftHand = getLeftHand();
  return leftHand.y < rightHand.y ? getLeftHandVelocity() : getRightHandVelocity();
}

PVector getLowestHand() {
  PVector rightHand = getRightHand();
  PVector leftHand = getLeftHand();
  return leftHand.y > rightHand.y ? leftHand : rightHand;
}

PVector getLowestHandVelocity() {
  PVector rightHand = getRightHand();
  PVector leftHand = getLeftHand();
  return leftHand.y > rightHand.y ? getLeftHandVelocity() : getRightHandVelocity();
}


float maxArmLength = 0;

void resetSkeletonStats() {
  maxArmLength = 0;
}

void updateSkeletonStats() {
  float leftArmLen = getLeftArm().mag();
  if (leftArmLen > maxArmLength) maxArmLength = leftArmLen;

  float rightArmLen = getRightArm().mag();
  if (rightArmLen > maxArmLength) maxArmLength = rightArmLen;
}


float getMaxArmLength() {
  return maxArmLength;
}

