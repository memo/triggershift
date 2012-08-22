


PVector getHead() {
  if (skeleton == null) return new PVector(width*0.5, height*0.25, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_HEAD, transform2D, openNIContext);
}

PVector getHip() {
  if (skeleton == null) return new PVector(width*0.5, height*0.5, 0);
  return PVector.mult( PVector.add(skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HIP, transform2D, openNIContext), skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HIP, transform2D, openNIContext)), 0.5);
}


PVector getLeftHand() {
  if (skeleton == null) return new PVector(width*0.25, height*0.5, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
}

PVector getLeftHandVelocity() {
  if (skeleton == null) return new PVector(0, 0, 0);
  return skeleton.getJointSmoothedVelocity(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
}

PVector getRightHand() {
  if (skeleton == null) return new PVector(width*0.75, height*0.5, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
}

PVector getRightHandVelocity() {
  if (skeleton == null) return new PVector(0, 0, 0);
  return skeleton.getJointSmoothedVelocity(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
}


PVector getHand(int i) {
  return i == 0 ? getLeftHand() : getRightHand();
}

PVector getHandVelocity(int i) {
  return i == 0 ? getLeftHandVelocity() : getRightHandVelocity();
}



PVector getLeftElbow() {
  if (skeleton == null) return new PVector(width*0.35, height*0.4, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_ELBOW, transform2D, openNIContext);
}

PVector getRightElbow() {
  if (skeleton == null) return new PVector(width*0.65, height*0.4, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_ELBOW, transform2D, openNIContext);
}

PVector getLeftShoulder() {
  if (skeleton == null) return new PVector(width*0.4, height*0.3, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_SHOULDER, transform2D, openNIContext);
}

PVector getRightShoulder() {
  if (skeleton == null) return new PVector(width*0.6, height*0.3, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, transform2D, openNIContext);
}

PVector getLeftArm() {
  return PVector.sub(getLeftHand(), getLeftShoulder());
}

PVector getRightArm() {
  return PVector.sub(getRightHand(), getRightShoulder());
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

float getValueWithVariance(float f, float variance) {
  return random(f - variance, f + variance);
}

PVector getVectorWithVariance(PVector v, float variance) {
  return new PVector(getValueWithVariance(v.x, variance), getValueWithVariance(v.y, variance), getValueWithVariance(v.z, variance));
}

PVector getVectorWithVariance(PVector v, PVector variance) {
  return new PVector(getValueWithVariance(v.x, variance.x), getValueWithVariance(v.y, variance.x), getValueWithVariance(v.z, variance.x));
}


// convert pixel dimensions done on a 800 pixel high screen, to resolution independent
float units(float f) {
  return f/800 * height;
}
