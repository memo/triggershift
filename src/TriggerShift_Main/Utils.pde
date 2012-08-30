float kAudioMax = -13.9794;
float kAudioMin = -80.0;

// volume: 0...1
void setGain(AudioPlayer p, float volume) {
  volume = 1 - volume;
  volume *= volume * volume * volume * volume * volume;
  volume = 1 - volume;
  p.setGain(map(volume, 0, 1, kAudioMin, kAudioMax));
}


PVector getHead() {
  if (skeleton == null) return new PVector(width * 0.5, height * 0.25, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_HEAD, transform2D, openNIContext);
}

PVector getHip() {
  if (skeleton == null) return new PVector(width * 0.5, height * 0.5, 0);
  return PVector.mult( PVector.add(skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HIP, transform2D, openNIContext), skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HIP, transform2D, openNIContext)), 0.5);
}


PVector getLeftHand() {
  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
}

PVector getLeftHand3D() {
  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeleton.getJointCoords(openNIContext, lastUserId, SimpleOpenNI.SKEL_LEFT_HAND);
}


PVector getLeftHandVelocity() {
  if (skeleton == null) return new PVector((mouseX - pmouseX) * secondsSinceLastFrame, (mouseY - pmouseY) * secondsSinceLastFrame, 0);
  return PVector.mult(skeleton.getJointSmoothedVelocity(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext), 1.0/secondsSinceLastFrame);
}

PVector getRightHand() {
  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
}

PVector getRightHand3D() {
  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeleton.getJointCoords(openNIContext, lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND);
}


PVector getRightHandVelocity() {
  if (skeleton == null) return new PVector((mouseX - pmouseX) * secondsSinceLastFrame, (mouseY - pmouseY) * secondsSinceLastFrame, 0);
  return PVector.mult(skeleton.getJointSmoothedVelocity(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext), 1.0/secondsSinceLastFrame);
}


PVector getHand(int i) {
  return i == 0 ? getLeftHand() : getRightHand();
}

PVector getHandVelocity(int i) {
  return i == 0 ? getLeftHandVelocity() : getRightHandVelocity();
}



PVector getLeftElbow() {
  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_ELBOW, transform2D, openNIContext);
}

PVector getRightElbow() {
  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_ELBOW, transform2D, openNIContext);
}

PVector getLeftShoulder() {
  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_SHOULDER, transform2D, openNIContext);
}

PVector getRightShoulder() {
  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, transform2D, openNIContext);
}

PVector getLeftArm() {
  return PVector.sub(getLeftHand(), getLeftShoulder());
}

PVector getRightArm() {
  return PVector.sub(getRightHand(), getRightShoulder());
}


PVector getLeftFoot() {
  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_FOOT, transform2D, openNIContext);
}

PVector getRightFoot() {
  if (skeleton == null) return new PVector(mouseX, mouseY, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_FOOT, transform2D, openNIContext);
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
  transform2D.drawImage( masker.getImage() );
}

void drawUserDepthPlane() {
  transform2D.drawImage( masker.getMask() );
}

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

