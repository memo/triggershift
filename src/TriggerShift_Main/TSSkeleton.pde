
class TSSkeleton {

  // a skeleton
  // store positions and velocities, scaled and mapped to screen space (in case we have scaled down the kinect input)
  //openni kinect capture / scale / skeleton 
  int userCount;
  PFont debugFont;
  //first dimension is users, second dimension is all velocity and positions for each joint
  TSJoint[][] tsjoints;
  //24 joints are tracked according to documentation, can't find a constant that represents this.
  int numJoints = 24;
  int max_users=17;

  PVector test=new PVector(0, 0, 0);
  //----------------------------------

  TSSkeleton() {
    
    userCount=0;
    debugFont=loadFont("AlBayan-48.vlw");

    tsjoints= new TSJoint[max_users][numJoints];
    //set all initial previous joint positions and velocities to 0
    for (int i=0;i<max_users;i++) {
      for (int j=0;j<tsjoints.length;j++) {
        tsjoints[i][j]=new TSJoint(20);
      }
    }
  }

  void updateSkeleton() {
    userCount = context.getNumberOfUsers();
    updateVelocities();
  }
  //for debugging purposes
  void drawAllSkeletons() {
    pushMatrix();
    translate(width/2, height/2, 0);
    //openni draws upside down
    rotateX(PI);
    scale(0.5f);
    translate(0, 0, -1000); 
    stroke(100); 

    int[] userList = context.getUsers();
    for (int i=0;i<userList.length;i++)
    {
      if (context.isTrackingSkeleton(userList[i]))
        drawSkeleton(userList[i]);
    }
    popMatrix();
  }

  //from simpleOPENNI examples/ credits to http://code.google.com/p/simple-openni
  void drawSkeleton(int userId) {
    strokeWeight(3);

    // to get the 3d joint data
    drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

    drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

    drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

    drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

    drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

    drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  }
  //from simpleOPENNI examples/ credits to http://code.google.com/p/simple-openni
  void drawLimb(int userId, int jointType1, int jointType2)
  {
    PVector jointPos1 = new PVector();
    PVector jointPos2 = new PVector();
    float  confidence;

    // draw the joint position
    confidence = context.getJointPositionSkeleton(userId, jointType1, jointPos1);
    confidence = context.getJointPositionSkeleton(userId, jointType2, jointPos2);

    stroke(255, 0, 0, confidence * 200 + 55);
    line(jointPos1.x, jointPos1.y, jointPos1.z, 
    jointPos2.x, jointPos2.y, jointPos2.z);
  }
  //////////////GIVEN A JOINT ID THIS WILL GIVE THE POSITION RELATIVE TO DEPTH MAP SIZE (640*480)///////////////////////////////
  PVector getScreenCoords(int userId, int jointType) {
    //JOINT POS IN WORLD SIZE IE MM
    PVector jointPos = new PVector();
    //JOINT POS IN SCEEN SIZE IE PIXELS
    PVector jointPos_Proj = new PVector(); 
    context.getJointPositionSkeleton(userId, jointType, jointPos);
    if (context.isTrackingSkeleton(userId)) {
      context.convertRealWorldToProjective(jointPos, jointPos_Proj);
    }
    return(jointPos_Proj);
  }
  //////////////GIVEN A JOINT ID A POSITION AND A NEW WIDTH AND HEIGH THIS WILL GIVE THE POSITION RELATIVE TO THAT NEW SIZE///////////////////////////////
  PVector getMappedCoords(int userId, int jointType, int x, int y, int w, int h) {
    //JOINT POS IN WORLD SIZE IE MM
    PVector jointPos = new PVector();
    //JOINT POS IN SCEEN SIZE IE PIXELS
    PVector jointPos_Proj = new PVector(); 
    context.getJointPositionSkeleton(userId, jointType, jointPos);
    if (context.isTrackingSkeleton(userId)) {
      context.convertRealWorldToProjective(jointPos, jointPos_Proj);
    }
    float xm, ym, zm;
    xm=x+map(jointPos_Proj.x, 0, context.depthWidth(), 0, w);
    ym=y+map(jointPos_Proj.y, 0, context.depthHeight(), 0, h);
    zm=jointPos_Proj.z;

    return(new PVector(xm, ym, zm));
  }
  PVector getWorldCoords(int userId, int jointType) {
    //JOINT POS IN WORLD SIZE IE MM
    PVector jointPos = new PVector();
    context.getJointPositionSkeleton(userId, jointType, jointPos);

    return(jointPos);
  }
  //am example to test velocity data
  void drawDebugInfo() {
    fill(255);
    textFont(debugFont, 48);
    int[] userList = context.getUsers();
    if (userList.length>0) {
      for (int i=0;i<userList.length;i++) {

        // for (int i=0;i<20;i++) {
        PVector jointPos1 = new PVector();

        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, jointPos1);

        if (context.isTrackingSkeleton(userList[i])) {
          PVector jointPos_Proj = new PVector(); 
          context.convertRealWorldToProjective(jointPos1, jointPos_Proj);
          try {
            text("right hand_VEL_X "+tsjoints[userList[i]][SimpleOpenNI.SKEL_RIGHT_HAND].smoothedVelocity.x, 100, height- 150);
            if (tsjoints[userList[i]][SimpleOpenNI.SKEL_RIGHT_HAND].smoothedVelocity.x>0) {
              text("right hand going LEFT ", 100, height- 50);
            }
            else {
              text("right hand going RIGHT ", 100, height- 50);
            }
            if (  tsjoints[userList[i]][SimpleOpenNI.SKEL_RIGHT_HAND].smoothedVelocity.y<0) {
              text("right hand going UP ", 100, height- 100);
            }
            else {
              text("right hand going DOWN ", 100, height-100);
            }
          }
          catch(Exception e) {
            println(e);
          }
        }
      }
    }
  }
  void updateVelocities() {
    int[] userList = context.getUsers();

    //for each user
    for (int i=0;i<userList.length;i++) {
      //if there is a valid skeleton
      if (context.isTrackingSkeleton(userList[i])) {
        //for each joint on that skeleton
        for (int j=0;j<tsjoints.length;j++) {
          PVector jointPos = new PVector();
          //get real world coords
          context.getJointPositionSkeleton(userList[i], j, jointPos);
          PVector jointPos_Proj = new PVector(); 
          //convert to screen coords
          context.convertRealWorldToProjective(jointPos, jointPos_Proj);

          tsjoints[userList[i]][j].updateAll(jointPos_Proj);
        }
      }
    }
  }
};

/*static int	SKEL_HEAD 
 static int	SKEL_LEFT_ANKLE 
 static int	SKEL_LEFT_COLLAR 
 static int	SKEL_LEFT_ELBOW 
 static int	SKEL_LEFT_FINGERTIP 
 static int	SKEL_LEFT_FOOT 
 static int	SKEL_LEFT_HAND 
 static int	SKEL_LEFT_HIP 
 static int	SKEL_LEFT_KNEE 
 static int	SKEL_LEFT_SHOULDER 
 static int	SKEL_LEFT_WRIST 
 static int	SKEL_NECK 
 static int	SKEL_RIGHT_ANKLE 
 static int	SKEL_RIGHT_COLLAR 
 static int	SKEL_RIGHT_ELBOW 
 static int	SKEL_RIGHT_FINGERTIP 
 static int	SKEL_RIGHT_FOOT 
 static int	SKEL_RIGHT_HAND 
 static int	SKEL_RIGHT_HIP 
 static int	SKEL_RIGHT_KNEE 
 static int	SKEL_RIGHT_SHOULDER 
 static int	SKEL_RIGHT_WRIST 
 static int	SKEL_TORSO 
 static int	SKEL_WAIST */
