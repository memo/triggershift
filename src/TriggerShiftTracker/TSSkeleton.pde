
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
  };


  private Joint[] joints;
  private float confidence;
  private int userIndex;
  private int lastUpdateMillis;


  //----------------------------------
  TSSkeleton(int _userIndex) {
    userIndex = _userIndex;
    joints= new Joint[numJoints+1];
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
  void setJointPos2d(int jointType, PVector p) {
    joints[jointType].pos2d.set(p);
    println("setJointPos2d: " + userIndex + " " + jointType + " " + p + "\n");
    lastUpdateMillis = millis();
  }


  //----------------------------------
  void setJointPos3d(int jointType, PVector p) {
    joints[jointType].pos2d.set(p);
    lastUpdateMillis = millis();
  }


  //----------------------------------
  void setJointVel(int jointType, PVector p) {
    joints[jointType].vel2d.set(p);
    lastUpdateMillis = millis();
  }


  //----------------------------------
  void setJointSmoothVel(int jointType, PVector p) {
    joints[jointType].smoothVel2d.set(p);
    lastUpdateMillis = millis();
  }


  //----------------------------------
  float getConfidence() {
    return confidence;
  }


  //----------------------------------
  PVector getJointPos3d(int jointType) {
    return joints[jointType].pos3d;
  }


  //----------------------------------
  PVector getJointPos2d(int jointType) {
    return joints[jointType].pos2d;
  }


  //----------------------------------
  PVector getJointVel(int jointType) {
    return joints[jointType].vel2d;
  }


  //----------------------------------
  PVector getJointSmoothVel(int jointType) {
    return joints[jointType].smoothVel2d;
  }


  //----------------------------------
  void drawLimb2d(int jointType1, int jointType2) {
    PVector p1 = getJointPos2d(jointType1);
    PVector p2 = getJointPos2d(jointType2);
    stroke(255, 0, 0, confidence * 200 + 55);
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  }


  //----------------------------------
  void drawLimb3d(int jointType1, int jointType2) {
    PVector p1 = getJointPos3d(jointType1);
    PVector p2 = getJointPos3d(jointType2);
    stroke(255, 0, 0, confidence * 200 + 55);
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  }


  //----------------------------------
  void draw2d() {
    pushStyle();
    strokeWeight(3);
    pushMatrix();
    translate(width/2, height/2, 0);
    rotateX(PI);
    scale(0.5);
    translate(0, 0, -1000);
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

