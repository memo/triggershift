

PVector getLeftHand() {
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
}

PVector getRightHand() {
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
}

PVector getLeftElbow() {
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_ELBOW, transform2D, openNIContext);
}

PVector getRightElbow() {
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_ELBOW, transform2D, openNIContext);
}

PVector getLeftShoulder() {
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_SHOULDER, transform2D, openNIContext);
}

PVector getRightShoulder() {
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


PVector getLowestHand() {
  PVector rightHand = getRightHand();
  PVector leftHand = getLeftHand();
  return leftHand.y > rightHand.y ? leftHand : rightHand;
}


PVector getHead() {
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_HEAD, transform2D, openNIContext);
}

PVector getHip() {
  return PVector.mult( PVector.add(skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HIP, transform2D, openNIContext), skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HIP, transform2D, openNIContext)), 0.5);
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
