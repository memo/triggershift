
static int SKEL_HEAD = 1;
static int SKEL_LEFT_ANKLE = 19;
static int SKEL_LEFT_COLLAR = 5;
static int SKEL_LEFT_ELBOW  = 7;
static int SKEL_LEFT_FINGERTIP = 10;
static int SKEL_LEFT_FOOT = 20;
static int SKEL_LEFT_HAND = 9;
static int SKEL_LEFT_HIP = 17;
static int SKEL_LEFT_KNEE = 18;
static int SKEL_LEFT_SHOULDER = 6;
static int SKEL_LEFT_WRIST = 8;
static int SKEL_NECK  = 2;
static int SKEL_RIGHT_ANKLE = 23;
static int SKEL_RIGHT_COLLAR  = 11;
static int SKEL_RIGHT_ELBOW  = 13;
static int SKEL_RIGHT_FINGERTIP = 16;
static int SKEL_RIGHT_FOOT  = 24;
static int SKEL_RIGHT_HAND  = 15;
static int SKEL_RIGHT_HIP  = 21;
static int SKEL_RIGHT_KNEE  = 22;
static int SKEL_RIGHT_SHOULDER = 12;
static int SKEL_RIGHT_WRIST  = 14;
static int SKEL_TORSO  = 3;
static int SKEL_WAIST  = 4;

static int numJoints = 24;

class TSSkeleton {

  class Joint {
    PVector pos3d = new PVector();        // 3d coordinates (in mm)
    PVector pos2d = new PVector();        // 2d coordinates (normalized)
    PVector vel2d = new PVector();        // 2d velocity (normalized)
    PVector smoothVel2d = new PVector();  // smoothed 2d velocity (normalized)
    
    void calculateJointVelocity() {
      
    }
  };


  private Joint[] joints;
  private float confidence;
  private int userIndex;
  private int lastUpdateMillis;


  //----------------------------------
  TSSkeleton(int _userIndex) {
    userIndex = _userIndex;
    joints = new Joint[numJoints+1];
    for (int i=0; i<joints.length; i++) joints[i] = new Joint();
  }


  //----------------------------------
  void update() {
    // if not updated recently, set confidence to 0
    if(millis() - lastUpdateMillis > 2000) confidence = 0;
  }


  //----------------------------------
  void setConfidence(float f) {
    confidence = f;
    lastUpdateMillis = millis();
  }


  //----------------------------------
  void setJointPos2d(int jointIndex, PVector p) {
    joints[jointIndex].pos2d.set(p);
//    if(jointIndex == SKEL_RIGHT_HAND) println("setJointPos2d: " + userIndex + " " + jointIndex + " " + p + "\n");
    lastUpdateMillis = millis();
  }


  //----------------------------------
  void setJointPos3d(int jointIndex, PVector p) {
    joints[jointIndex].pos3d.set(p);
    lastUpdateMillis = millis();
  }


  //----------------------------------
  void setJointVel2d(int jointIndex, PVector p) {
    joints[jointIndex].vel2d.set(p);
//    if(jointIndex == SKEL_RIGHT_HAND) println("setJointVel2d: " + userIndex + " " + jointIndex + " " + p + "\n");
    lastUpdateMillis = millis();
  }


  //----------------------------------
  void setJointSmoothVel2d(int jointIndex, PVector p) {
    joints[jointIndex].smoothVel2d.set(p);
    lastUpdateMillis = millis();
  }


  //----------------------------------
  float getConfidence() {
    return confidence;
  }


  //----------------------------------
  PVector getJointPos3d(int jointIndex) {
    return joints[jointIndex].pos3d;
  }


  //----------------------------------
  PVector getJointPos2d(int jointIndex) {
    return joints[jointIndex].pos2d;
  }


  //----------------------------------
  PVector getJointVel2d(int jointIndex) {
    return joints[jointIndex].vel2d;
  }


  //----------------------------------
  PVector getJointSmoothVel2d(int jointIndex) {
    return joints[jointIndex].smoothVel2d;
  }

  //----------------------------------
  void calculateJointVelocities(float smoothingAmount) {
  }

  //----------------------------------
  void drawJoint2d(int jointIndex, float rx, float ry, float velMult) {
//    Joint j = joints[jointIndex];
    PVector p = getJointPos2d(jointIndex);
    PVector v = getJointVel2d(jointIndex);
    PVector vs = getJointSmoothVel2d(jointIndex);
    float a = confidence * 200 + 55;
    fill(255, 0, 0, a);
    noStroke();
    ellipse(p.x, p.y, rx, ry);
    
    stroke(0, 255, 0, a);
    line(p.x, p.y, p.x - v.x * velMult, p.y - v.y * velMult);
    
    stroke(0, 0, 255, a);
    line(p.x, p.y, p.x - vs.x * velMult, p.y - vs.y * velMult);
  }


  //----------------------------------
  void drawLimb2d(int jointIndex1, int jointIndex2) {
    PVector p1 = getJointPos2d(jointIndex1);
    PVector p2 = getJointPos2d(jointIndex2);
    stroke(255, 0, 0, confidence * 200 + 55);
    line(p1.x, p1.y, p2.x, p2.y);
  }


  //----------------------------------
  void drawLimb3d(int jointIndex1, int jointIndex2) {
    PVector p1 = getJointPos3d(jointIndex1);
    PVector p2 = getJointPos3d(jointIndex2);
    stroke(255, 0, 0, confidence * 200 + 55);
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  }

  
  //----------------------------------
  void draw2d(float x, float y, float w, float h) {
    pushStyle();
    strokeWeight(3);
    pushMatrix();
    scale(w, h, 1);
    drawLimb2d(SKEL_HEAD, SKEL_NECK);

    drawLimb2d(SKEL_NECK, SKEL_LEFT_SHOULDER);
    drawLimb2d(SKEL_LEFT_SHOULDER, SKEL_LEFT_ELBOW);
    drawLimb2d(SKEL_LEFT_ELBOW, SKEL_LEFT_HAND);

    drawLimb2d(SKEL_NECK, SKEL_RIGHT_SHOULDER);
    drawLimb2d(SKEL_RIGHT_SHOULDER, SKEL_RIGHT_ELBOW);
    drawLimb2d(SKEL_RIGHT_ELBOW, SKEL_RIGHT_HAND);

    drawLimb2d(SKEL_LEFT_SHOULDER, SKEL_TORSO);
    drawLimb2d(SKEL_RIGHT_SHOULDER, SKEL_TORSO);

    drawLimb2d(SKEL_TORSO, SKEL_LEFT_HIP);
    drawLimb2d(SKEL_LEFT_HIP, SKEL_LEFT_KNEE);
    drawLimb2d(SKEL_LEFT_KNEE, SKEL_LEFT_FOOT);

    drawLimb2d(SKEL_TORSO, SKEL_RIGHT_HIP);
    drawLimb2d(SKEL_RIGHT_HIP, SKEL_RIGHT_KNEE);
    drawLimb2d(SKEL_RIGHT_KNEE, SKEL_RIGHT_FOOT);

    strokeWeight(1);
    for(int i=0; i<joints.length; i++) {
      drawJoint2d(i, 10/w, 10/h, 60);
    }
    
    popMatrix();
    popStyle();
  }


  //----------------------------------
  void draw3d() {
    pushStyle();
    strokeWeight(3);
    drawLimb3d(SKEL_HEAD, SKEL_NECK);

    drawLimb3d(SKEL_NECK, SKEL_LEFT_SHOULDER);
    drawLimb3d(SKEL_LEFT_SHOULDER, SKEL_LEFT_ELBOW);
    drawLimb3d(SKEL_LEFT_ELBOW, SKEL_LEFT_HAND);

    drawLimb3d(SKEL_NECK, SKEL_RIGHT_SHOULDER);
    drawLimb3d(SKEL_RIGHT_SHOULDER, SKEL_RIGHT_ELBOW);
    drawLimb3d(SKEL_RIGHT_ELBOW, SKEL_RIGHT_HAND);

    drawLimb3d(SKEL_LEFT_SHOULDER, SKEL_TORSO);
    drawLimb3d(SKEL_RIGHT_SHOULDER, SKEL_TORSO);

    drawLimb3d(SKEL_TORSO, SKEL_LEFT_HIP);
    drawLimb3d(SKEL_LEFT_HIP, SKEL_LEFT_KNEE);
    drawLimb3d(SKEL_LEFT_KNEE, SKEL_LEFT_FOOT);

    drawLimb3d(SKEL_TORSO, SKEL_RIGHT_HIP);
    drawLimb3d(SKEL_RIGHT_HIP, SKEL_RIGHT_KNEE);
    drawLimb3d(SKEL_RIGHT_KNEE, SKEL_RIGHT_FOOT);
    popStyle();
  }

};

