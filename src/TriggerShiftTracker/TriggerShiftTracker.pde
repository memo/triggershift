import oscP5.*;
import netP5.*;
import SimpleOpenNI.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

SimpleOpenNI  openNIContext = null;
int lastUserId;
int userCount;
int numJoints = 24; 
int max_users=17;

TSJoint[][] tsjoints;

void setup() {
  size(1280, 768, P3D);

  oscP5 = new OscP5(this, 1000);
  myRemoteLocation = new NetAddress("127.0.0.1", 7000);
  setupOpenNI();

  tsjoints= new TSJoint[max_users][numJoints];
  //set all initial previous joint positions and velocities to 0
  for (int i=0;i<max_users;i++) {
    for (int j=0;j<tsjoints.length;j++) {
      tsjoints[i][j]=new TSJoint(20);
    }
  }
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

  if (context != null) {
    int[] userList = context.getUsers();

    //for each user
    for (int i=0;i<userList.length;i++) {
      PVector p = new PVector();
      float c = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_HEAD, p);
      sendConfidenceMessage(userList[i], c);
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

          sendPos2DMessage(userList[i], j, jointPos_Proj);
          sendPos3DMessage(userList[i], j, jointPos);
          sendVel2DMessage(userList[i], j, tsjoints[userList[i]][j].velocity);
          sendSmoothVel2DMessage(userList[i], j, tsjoints[userList[i]][j].smoothedVelocity);
        }
      }
    }
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

void sendConfidenceMessage(int userId, float confidence) {
  OscMessage myMessage = new OscMessage("/skeleton/"+str(userId)+"/confidence");
  myMessage.add(confidence);
  oscP5.send(myMessage, myRemoteLocation);
}
void sendPos2DMessage(int userId, int jointId, PVector pos2D) {
  OscMessage myMessage = new OscMessage("/skeleton/"+str(userId)+"/joint/"+str(jointId)+"/pos2d");

  myMessage.add(pos2D.x);
  myMessage.add(pos2D.y);

  oscP5.send(myMessage, myRemoteLocation);
}
void sendPos3DMessage(int userId, int jointId, PVector pos3D) {
  OscMessage myMessage = new OscMessage("/skeleton/"+str(userId)+"/joint/"+str(jointId)+"/pos3d");

  myMessage.add(pos3D.x);
  myMessage.add(pos3D.y);
  myMessage.add(pos3D.z);

  oscP5.send(myMessage, myRemoteLocation);
}
void sendVel2DMessage(int userId, int jointId, PVector vel2D) {
  OscMessage myMessage = new OscMessage("/skeleton/"+str(userId)+"/joint/"+str(jointId)+"/vel2d");

  myMessage.add(vel2D.x);
  myMessage.add(vel2D.y);

  oscP5.send(myMessage, myRemoteLocation);
}
void sendSmoothVel2DMessage(int userId, int jointId, PVector vel2D) {
  OscMessage myMessage = new OscMessage("/skeleton/"+str(userId)+"/joint/"+str(jointId)+"/vel2d");

  myMessage.add(vel2D.x);
  myMessage.add(vel2D.y);

  oscP5.send(myMessage, myRemoteLocation);
}

/*skeleton/1/confidence [float]
 
 skeleton/1/joint/1/pos2d [float] [float] 
 skeleton/1/joint/1/pos3d [float] [float] [float]
 skeleton/1/joint/1/vel2d [float] [float]
 skeleton/1/joint/1/smoothvel2d [float] [float]
 
 skeleton/1/joint/2/pos2d [float] [float] 
 skeleton/1/joint/2/pos3d [float] [float] [float]
 skeleton/1/joint/2/vel2d [float] [float] 
 skeleton/1/joint/2/smoothvel2d [float] [float]]
 
 
 
 skeleton/2/confidence [float]
 
 skeleton/2/joint/1/pos2d [float] [float] 
 skeleton/2/joint/1/pos3d [float] [float] [float]
 skeleton/2/joint/1/vel2d [float] [float] 
 skeleton/2/joint/1/smoothvel2d [float] [float] 
 
 skeleton/2/joint/2/pos2d [float] [float] 
 skeleton/2/joint/2/pos3d [float] [float] [float]
 skeleton/2/joint/2/vel2d [float] [float] 
 skeleton/2/joint/2/smoothvel2d [float] [float] 
 */



void sendJointMessage(int jointId, PVector pos, String type) {
  OscMessage myMessage = new OscMessage("/"+type+"/"+str(jointId));
  //myMessage.add(jointId);
  myMessage.add(pos.x);
  myMessage.add(pos.y);
  myMessage.add(pos.z);
  oscP5.send(myMessage, myRemoteLocation);
}

void sendSkeletonMessage() {
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

