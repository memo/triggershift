

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
  return skeletonManager.activeSkeleton().getJointSmoothVel2d(SKEL_LEFT_HAND);
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
  return skeletonManager.activeSkeleton().getJointSmoothVel2d(SKEL_RIGHT_HAND);
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
PVector getLeftShoulder3D() {
  //  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeletonManager.activeSkeleton().getJointPos3d(SKEL_LEFT_SHOULDER);
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




void drawMaskedUser() {
  if (doDrawUsers && syphon != null) {
    if (syphon.img != null) image(syphon.img, 0, 0, width, height);
  }
  //  transform2D.drawImage(syphon.img);
}

//void drawMaskedUserGrey() {
//  if (doDrawUsers && syphon != null) {
//    syphon.update();
//  if (syphon.imgMask != null) image(syphon.imgMask, 0, 0, width, height);
//  }
//  //  transform2D.drawImage(syphon.img);
//}

//PImage getMaskedUser() {
//  PImage imageForReturn=null; 
//  if (doDrawUsers && syphon != null) {
////    syphon.update();
//    if (syphon.img != null) {
//      imageForReturn = syphon.img;
//    }
//  }
//  return imageForReturn;
//  //  transform2D.drawImage(syphon.img);
//}

//void drawUserDepthPlane() {
//  drawMaskedUser();
//  //  transform2D.drawImage( masker.getMask() );
//}

float getWithVariance(float f, float variance) {
  return random(f - variance, f + variance);
}

PVector getWithVariance(PVector v, float variance) {
  return new PVector(getWithVariance(v.x, variance), getWithVariance(v.y, variance), getWithVariance(v.z, variance));
}

PVector getWithVariance(PVector v, PVector variance) {
  return new PVector(getWithVariance(v.x, variance.x), getWithVariance(v.y, variance.x), getWithVariance(v.z, variance.x));
}


// convert pixel dimensions done on a 800 pixel high screen, to resolution independent
float units(float f) {
  return f/800 * height;
}



class FloatWithVariance {
  float base, variance;
  FloatWithVariance() {
    set(0, 0);
  }

  FloatWithVariance(float _base, float _variance) {
    set(_base, _variance);
  }

  void set(float _base, float _variance) {
    base = _base;
    variance = _variance;
  }

  float get() {
    return getWithVariance(base, variance);
  }
};



class VectorWithVariance {
  PVector base, variance;

  VectorWithVariance() {
    set(new PVector(), new PVector());
  }

  VectorWithVariance(PVector _base, PVector _variance) {
    set(_base, _variance);
  }

  void set(PVector _base, PVector _variance) {
    base = _base;
    variance = _variance;
  }

  PVector get() {
    return getWithVariance(base, variance);
  }
};

