

PVector getLeftHand() {
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
}

PVector getRightHand() {
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
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
  return skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HIP, transform2D, openNIContext);
}

