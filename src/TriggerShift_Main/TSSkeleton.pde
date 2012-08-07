
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

  public void updateSkeleton() {
    userCount = context.getNumberOfUsers();
    updateVelocities();
  }
  //for debugging purposes
  public void drawAllSkeletons() {
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
  public void drawSkeleton(int userId) {
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

  //////////////GIVEN A JOINT ID THIS WILL GIVE THE POSITION RELATIVE TO DEPTH MAP SIZE (640*480)///////////////////////////////
  public PVector getScreenCoords(int userId, int jointType) {
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
  //////////////GIVEN A JOINT ID A POSITION THIS WILL RETURN A MAPPED POSITION USING SETTINGS IN TSTRANSFORM2D///////////////////////////////
  public PVector getTransformedJointCoords(int userId, int jointType, TSTransform2D transform2D, SimpleOpenNI  context) {
    //JOINT POS IN WORLD SIZE IE MM
    PVector jointPos = new PVector();
    //JOINT POS IN SCEEN SIZE IE PIXELS
    PVector jointPos_Proj = new PVector(); 

    //first get the screen coordinates as opposed to world coordinates
    context.getJointPositionSkeleton(userId, jointType, jointPos);

    if (context.isTrackingSkeleton(userId)) {
      context.convertRealWorldToProjective(jointPos, jointPos_Proj);
    }

    PVector transformedCoords = transform2D.getWorldCoordsForInputPixels(jointPos_Proj);

    return transformedCoords;
  }
  public PVector getWorldCoords(int userId, int jointType) {
    //JOINT POS IN WORLD SIZE IE MM
    PVector jointPos = new PVector();
    context.getJointPositionSkeleton(userId, jointType, jointPos);

    return(jointPos);
  }
  //from simpleOPENNI examples/ credits to http://code.google.com/p/simple-openni
  public void drawLimb(int userId, int jointType1, int jointType2)
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

 
  private void updateVelocities() {
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
