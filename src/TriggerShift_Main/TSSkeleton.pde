
static int  SKEL_HEAD;
static int  SKEL_LEFT_ANKLE; 
static int  SKEL_LEFT_COLLAR; 
static int  SKEL_LEFT_ELBOW ;
static int  SKEL_LEFT_FINGERTIP; 
static int  SKEL_LEFT_FOOT; 
static int  SKEL_LEFT_HAND; 
static int  SKEL_LEFT_HIP; 
static int  SKEL_LEFT_KNEE; 
static int  SKEL_LEFT_SHOULDER; 
static int  SKEL_LEFT_WRIST;
static int  SKEL_NECK ;
static int  SKEL_RIGHT_ANKLE; 
static int  SKEL_RIGHT_COLLAR ;
static int  SKEL_RIGHT_ELBOW ;
static int  SKEL_RIGHT_FINGERTIP; 
static int  SKEL_RIGHT_FOOT ;
static int  SKEL_RIGHT_HAND ;
static int  SKEL_RIGHT_HIP ;
static int  SKEL_RIGHT_KNEE ;
static int  SKEL_RIGHT_SHOULDER; 
static int  SKEL_RIGHT_WRIST ;
static int  SKEL_TORSO ;
static int  SKEL_WAIST ;

  static int numJoints = 24;

class TSSkeleton {

  class Joint {
    PVector pos3d;        // 3d coordinates (in mm)
    PVector pos2d;        // 2d coordinates (normalized)
    PVector vel2d;        // 2d velocity (normalized)
    PVector smoothVel2d;  // smoothed 2d velocity (normalized)
  };


  private Joint[] joints;
  private float confidence;
  private int userIndex;
  private int lastUpdateMillis;


  //----------------------------------
  TSSkeleton(int _userIndex) {
    userIndex = _userIndex;
    joints= new Joint[numJoints];
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
    joints[jointType].pos2d = p;
    lastUpdateMillis = millis();
  }


  //----------------------------------
  void setJointPos3d(int jointType, PVector p) {
    joints[jointType].pos2d = p;
    lastUpdateMillis = millis();
  }


  //----------------------------------
  void setJointVel(int jointType, PVector p) {
    joints[jointType].vel2d = p;
    lastUpdateMillis = millis();
  }


  //----------------------------------
  void setJointSmoothVel(int jointType, PVector p) {
    joints[jointType].smoothVel2d = p;
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
    strokeWeight(3);
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
  }


  //----------------------------------
  void draw3d() {
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
  }

};

