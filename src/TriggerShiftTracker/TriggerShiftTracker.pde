import oscP5.*;
import netP5.*;
import SimpleOpenNI.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

SimpleOpenNI  openNIContext = null;
int lastUserId;
int userCount;
int numJoints = 24;

void setup() {
  size(1280, 768, P3D);

  oscP5 = new OscP5(this, 1000);
  myRemoteLocation = new NetAddress("127.0.0.1", 7000);
  setupOpenNI();
}

void draw() {
  if (openNIContext != null) {
    openNIContext.update();
  }
  update(openNIContext);
  image(openNIContext.rgbImage(), 0, 0, width, height);
}

void setupOpenNI() {
  //setup openNI context
  openNIContext = new SimpleOpenNI(this);

  openNIContext.enableDepth();
  openNIContext.enableRGB();
  openNIContext.enableScene();
  openNIContext.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  openNIContext.setMirror(true);
  openNIContext.alternativeViewPointDepthToImage();
}

void update(SimpleOpenNI context) {
  lastUserId = findMostConfidentSkeleton(context);

  if (context != null) {
    userCount = context.getNumberOfUsers();


    int[] userList = context.getUsers();

    //for each user
    // for (int i=0;i<userList.length;i++) {
    //if there is a valid skeleton
    if (context.isTrackingSkeleton(lastUserId)) {
      //for each joint on that skeleton
      for (int j=0;j<numJoints;j++) {
        PVector jointPos = new PVector();
        //get real world coords
        context.getJointPositionSkeleton(lastUserId, j, jointPos);
        PVector jointPos_Proj = new PVector(); 
        //convert to screen coords
        println(jointPos);
        context.convertRealWorldToProjective(jointPos, jointPos_Proj);
        sendJointMessage(j, jointPos, "jointPos");
        sendJointMessage(j, jointPos_Proj, "projectivePos");
      }
    }
  }
  else {
    println("no valid context");
  }
}


int findMostConfidentSkeleton(SimpleOpenNI context) {
  int mostConfident = 0;
  float maxConfidence = 0;
  PVector p = new PVector();
  int[] userList = context.getUsers();
  for (int i=0; i<userList.length; i++) {
    float c = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_HEAD, p);
    if (c > maxConfidence) {
      maxConfidence = c;
      mostConfident = userList[i];
    }
  }
  return mostConfident;
}   

void sendJointMessage(int jointId, PVector pos, String type) {
  OscMessage myMessage = new OscMessage("/"+type+"/"+str(jointId));
  //myMessage.add(jointId);
  myMessage.add(pos.x);
  myMessage.add(pos.y);
  myMessage.add(pos.z);
  oscP5.send(myMessage, myRemoteLocation);
}


//OPENNI CALLBACKS
void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);

  openNIContext.requestCalibrationSkeleton(userId, true);
  //resetSkeletonStats();
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
  //resetSkeletonStats();
}

void onExitUser(int userId)
{
  println("onExitUser - userId: " + userId);
  //resetSkeletonStats();
}

void onReEnterUser(int userId)
{
  println("onReEnterUser - userId: " + userId);
  //resetSkeletonStats();
}


void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
  //resetSkeletonStats();
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);

  if (successfull) 
  { 
    println("  User calibrated !!!");
    openNIContext.startTrackingSkeleton(userId);
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    openNIContext.startPoseDetection("Psi", userId);
  }
  //resetSkeletonStats();
}

void onStartPose(String pose, int userId)
{
  println("onStartdPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");

  openNIContext.stopPoseDetection(userId); 
  openNIContext.requestCalibrationSkeleton(userId, true);
}

void onEndPose(String pose, int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}

