
class TSSkeleton {

  // a skeleton
  // store positions and velocities, scaled and mapped to screen space (in case we have scaled down the kinect input)
  //openni kinect capture / scale / skeleton 
  private int userCount;
  private PFont debugFont;
  //first dimension is users, second dimension is all velocity and positions for each joint
  private TSJoint[][] tsjoints;
  //24 joints are tracked according to documentation, can't find a constant that represents this.
  private int numJoints = 24;
  private int max_users=17;

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

  //----------------------------------
  void update(SimpleOpenNI context) {
    userCount = context.getNumberOfUsers();
    updateVelocities(context);
  }

  //----------------------------------
  void updateVelocities(SimpleOpenNI context) {
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

          tsjoints[userList[i]][j].update(context, jointPos_Proj);
        }
      }
    }
  }


  //----------------------------------
  //for debugging purposes
  void drawAllSkeletons(SimpleOpenNI context, TSTransform2D transform2D) {
    pushMatrix();
    // translate(width/2, height/2, 0);
    //openni draws upside down
    // rotateX(PI);
    //translate(-width/2, -height/2, 0);
    //scale(0.5f);
    //translate(0, 0, -1000); 
    stroke(100); 

    int[] userList = context.getUsers();
    for (int i=0;i<userList.length;i++)
    {
      if (context.isTrackingSkeleton(userList[i]))
        drawSkeleton(transform2D, context, userList[i]);
    }
    popMatrix();
  }

  //----------------------------------
  //from simpleOPENNI examples/ credits to http://code.google.com/p/simple-openni
  void drawSkeleton(TSTransform2D transform2D, SimpleOpenNI context, int userId) {
    strokeWeight(3);
    
    
    boolean drawInWorld=true;
    // to get the 3d joint data
    //this is roughly scaled following simpleOpenNI example
    if (!drawInWorld) {
      pushMatrix();
      translate(width/2, height/2, 0);
      //openni draws upside down
      rotateX(PI);
      scale(0.5f);
      translate(0, 0, -1000); 
      drawLimb(context, userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

      drawLimb(context, userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
      drawLimb(context, userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
      drawLimb(context, userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

      drawLimb(context, userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
      drawLimb(context, userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
      drawLimb(context, userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

      drawLimb(context, userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
      drawLimb(context, userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

      drawLimb(context, userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
      drawLimb(context, userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
      drawLimb(context, userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

      drawLimb(context, userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
      drawLimb(context, userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
      drawLimb(context, userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
      popMatrix();
    }
    ///this is the real deal - usess transform2D to map joints to our world coords
    else {
      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
      drawLimbInWorld(context, userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
    }

  }


  //----------------------------------
  //from simpleOPENNI examples/ credits to http://code.google.com/p/simple-openni
  void drawLimb(SimpleOpenNI context, int userId, int jointType1, int jointType2)
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
  //----------------------------------
  //from simpleOPENNI examples/ credits to http://code.google.com/p/simple-openni
  void drawLimbInWorld(SimpleOpenNI context, int userId, int jointType1, int jointType2)
  {
    PVector jointPos1 = new PVector();
    PVector jointPos2 = new PVector();
    float  confidence;

    // draw the joint position
    confidence = context.getJointPositionSkeleton(userId, jointType1, jointPos1);
    confidence = context.getJointPositionSkeleton(userId, jointType2, jointPos2);

    PVector jointPos_Proj1 = new PVector();
    PVector jointPos_Proj2 = new PVector(); 


    if (context.isTrackingSkeleton(userId)) {
      context.convertRealWorldToProjective(jointPos1, jointPos_Proj1);
      context.convertRealWorldToProjective(jointPos2, jointPos_Proj2);
    }

    PVector transformedCoords1 = transform2D.getWorldCoordsForInputPixels(jointPos_Proj1);
    PVector transformedCoords2 = transform2D.getWorldCoordsForInputPixels(jointPos_Proj2);

    stroke(255, 0, 0, confidence * 200 + 55);
    line(transformedCoords1.x, transformedCoords1.y, transformedCoords1.z, transformedCoords2.x, transformedCoords2.y, transformedCoords2.z);
  }

  //----------------------------------
  //////////////GIVEN A JOINT ID THIS WILL GIVE THE POSITION RELATIVE TO DEPTH MAP SIZE (640*480)///////////////////////////////
  PVector getScreenCoords(SimpleOpenNI context, int userId, int jointType) {
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
  public PVector getJointCoordsInWorld(int userId, int jointType, TSTransform2D transform2D, SimpleOpenNI  context) {
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

  //----------------------------------
  PVector getWorldCoords(SimpleOpenNI context, int userId, int jointType) {
    //JOINT POS IN WORLD SIZE IE MM
    PVector jointPos = new PVector();
    context.getJointPositionSkeleton(userId, jointType, jointPos);

    return(jointPos);
  }

  //----------------------------------
  //am example to test velocity data
  void drawDebugInfo(SimpleOpenNI context) {
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

