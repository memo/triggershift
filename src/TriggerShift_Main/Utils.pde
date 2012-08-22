

PVector getHead() {
  if(skeleton == null) return new PVector(width/2, height/2, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_HEAD, transform2D, openNIContext);
}

PVector getHip() {
  if(skeleton == null) return new PVector(width/2, height/2, 0);
  return PVector.mult( PVector.add(skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HIP, transform2D, openNIContext), skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HIP, transform2D, openNIContext)), 0.5);
}


PVector getLeftHand() {
  if(skeleton == null) return new PVector(width/2, height/2, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
}

PVector getLeftHandVelocity() {
  if(skeleton == null) return new PVector(0, 0, 0);
  return skeleton.getJointSmoothedVelocity(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
}

PVector getRightHand() {
  if(skeleton == null) return new PVector(width/2, height/2, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
}

PVector getRightHandVelocity() {
  if(skeleton == null) return new PVector(0, 0, 0);
  return skeleton.getJointSmoothedVelocity(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
}


PVector getLeftElbow() {
  if(skeleton == null) return new PVector(width/2, height/2, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_ELBOW, transform2D, openNIContext);
}

PVector getRightElbow() {
  if(skeleton == null) return new PVector(width/2, height/2, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_ELBOW, transform2D, openNIContext);
}

PVector getLeftShoulder() {
  if(skeleton == null) return new PVector(width/2, height/2, 0);
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_SHOULDER, transform2D, openNIContext);
}

PVector getRightShoulder() {
  if(skeleton == null) return new PVector(width/2, height/2, 0);
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
  if(leftArmLen > maxArmLength) maxArmLength = leftArmLen;

  float rightArmLen = getRightArm().mag();
  if(rightArmLen > maxArmLength) maxArmLength = rightArmLen;
}


float getMaxArmLength() {
  return maxArmLength;
}


void drawMaskedUser() {
   transform2D.drawImage( masker.getImage() );
}
