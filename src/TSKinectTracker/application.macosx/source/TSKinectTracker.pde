import oscP5.*;
import netP5.*;
import SimpleOpenNI.*;
import codeanticode.syphon.*;


OscP5 oscP5;
NetAddress myRemoteLocation;

SimpleOpenNI  openNIContext = null;
int lastUserId;
int userCount;
//int numJoints = 24; 
int max_users=17;

int imageIndex=1;

PointSmoother[][] tsjoints;

boolean useSyphon = true;

SyphonServer syphonServer;

PFont smallFont;

void setup() {
  size(640, 480, P3D);

  oscP5 = new OscP5(this, 1000);
  myRemoteLocation = new NetAddress("127.0.0.1", 7000);
  setupOpenNI();


  tsjoints= new PointSmoother[max_users][numJoints+1];
  //set all initial previous joint positions and velocities to 0
  for (int i=0;i<max_users;i++) {
    for (int j=0;j<tsjoints[i].length;j++) {
      tsjoints[i][j]=new PointSmoother(0.2);
    }
  }

  syphonServer = new SyphonServer(this, "TSKinectTracker");

  hint(DISABLE_DEPTH_TEST);

  println("static int SKEL_HEAD = " + SimpleOpenNI.SKEL_HEAD + ";");
  println("static int SKEL_LEFT_ANKLE = " + SimpleOpenNI.SKEL_LEFT_ANKLE + ";"); 
  println("static int SKEL_LEFT_COLLAR = " + SimpleOpenNI.SKEL_LEFT_COLLAR + ";"); 
  println("static int SKEL_LEFT_ELBOW  = " + SimpleOpenNI.SKEL_LEFT_ELBOW + ";");
  println("static int SKEL_LEFT_FINGERTIP = " + SimpleOpenNI.SKEL_LEFT_FINGERTIP + ";"); 
  println("static int SKEL_LEFT_FOOT = " + SimpleOpenNI.SKEL_LEFT_FOOT + ";"); 
  println("static int SKEL_LEFT_HAND = " + SimpleOpenNI.SKEL_LEFT_HAND + ";"); 
  println("static int SKEL_LEFT_HIP = " + SimpleOpenNI.SKEL_LEFT_HIP + ";"); 
  println("static int SKEL_LEFT_KNEE = " + SimpleOpenNI.SKEL_LEFT_KNEE + ";"); 
  println("static int SKEL_LEFT_SHOULDER = " + SimpleOpenNI.SKEL_LEFT_SHOULDER + ";"); 
  println("static int SKEL_LEFT_WRIST = " + SimpleOpenNI.SKEL_LEFT_WRIST + ";");
  println("static int SKEL_NECK  = " + SimpleOpenNI.SKEL_NECK + ";");
  println("static int SKEL_RIGHT_ANKLE = " + SimpleOpenNI.SKEL_RIGHT_ANKLE + ";"); 
  println("static int SKEL_RIGHT_COLLAR  = " + SimpleOpenNI.SKEL_RIGHT_COLLAR + ";");
  println("static int SKEL_RIGHT_ELBOW  = " + SimpleOpenNI.SKEL_RIGHT_ELBOW + ";");
  println("static int SKEL_RIGHT_FINGERTIP = " + SimpleOpenNI.SKEL_RIGHT_FINGERTIP + ";"); 
  println("static int SKEL_RIGHT_FOOT  = " + SimpleOpenNI.SKEL_RIGHT_FOOT + ";");
  println("static int SKEL_RIGHT_HAND  = " + SimpleOpenNI.SKEL_RIGHT_HAND + ";");
  println("static int SKEL_RIGHT_HIP  = " + SimpleOpenNI.SKEL_RIGHT_HIP + ";");
  println("static int SKEL_RIGHT_KNEE  = " + SimpleOpenNI.SKEL_RIGHT_KNEE + ";");
  println("static int SKEL_RIGHT_SHOULDER = " + SimpleOpenNI.SKEL_RIGHT_SHOULDER + ";"); 
  println("static int SKEL_RIGHT_WRIST  = " + SimpleOpenNI.SKEL_RIGHT_WRIST + ";");
  println("static int SKEL_TORSO  = " + SimpleOpenNI.SKEL_TORSO + ";");
  println("static int SKEL_WAIST  = " + SimpleOpenNI.SKEL_WAIST + ";");
  
  smallFont = loadFont("AdobeGothicStd-Bold-14.vlw");
}



void draw() {
  background(0);


  PImage img = null;
  if (openNIContext != null) {

    openNIContext.update();
    update(openNIContext);
    masker.update(openNIContext);

    switch(imageIndex) {
    case 2:
      img = openNIContext.depthImage();
      break;
    case 3:
      img = masker.getImage();
      break;
    case 4:
      img = masker.getMask();
      break;
    default:
      img = openNIContext.rgbImage();
    }
  } 


  if (img != null) {
    image(img, 0, 0);
  }
  if (useSyphon && syphonServer!= null) syphonServer.sendImage(masker.getImage());

  pushMatrix();
  scale(width, height, 1);
  skeletonManager.draw2d();
  skeletonManager.drawVelocities(30);
  popMatrix();


  pushStyle();
  textFont(smallFont);
  fill(255);
  String s = "";
  s += "fps: " + str(frameRate) + "\n";
  text(s, 10, 40);
  popStyle();
}



void keyPressed() {
  switch(key) {
  case '1':
    imageIndex = 1;
    break;
  case '2':
    imageIndex = 2;
    break;
  case '3':
    imageIndex = 3;
    break;
  case '4':
    imageIndex = 4;
    break;

  case 's':
    useSyphon ^= true;
    break;
  }
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
      int userIndex = userList[i] % 10;
      println("updating user : " + userIndex);
      PVector p = new PVector();
      float c = context.getJointPositionSkeleton(userIndex, SimpleOpenNI.SKEL_HEAD, p);
      sendConfidenceMessage(userIndex, c);
      skeletonManager.skeletons[userIndex].setConfidence(c);

      //if there is a valid skeleton
      if (context.isTrackingSkeleton(userIndex)) {
        //for each joint on that skeleton
        for (int j=0; j<tsjoints[i].length; j++) {
          //get real world coords
          PVector jointPos = new PVector();
          context.getJointPositionSkeleton(userIndex, j, jointPos);

          //convert to screen coords
          PVector jointPos_Proj = new PVector(); 
          context.convertRealWorldToProjective(jointPos, jointPos_Proj);

          // normalize
          jointPos_Proj.x *= 1.0/context.depthImage().width;
          jointPos_Proj.y *= 1.0/context.depthImage().height;
          jointPos_Proj.z = 0;

          tsjoints[userIndex][j].update(jointPos_Proj);


          skeletonManager.skeletons[userIndex].setJointPos2d(j, jointPos_Proj);
          skeletonManager.skeletons[userIndex].setJointPos3d(j, jointPos);
          skeletonManager.skeletons[userIndex].setJointVel2d(j, tsjoints[userIndex][j].velocity);
          skeletonManager.skeletons[userIndex].setJointSmoothVel2d(j, tsjoints[userIndex][j].smoothedVelocity);

          sendPos2DMessage(userIndex, j, jointPos_Proj);
          sendPos3DMessage(userIndex, j, jointPos);
          sendVel2DMessage(userIndex, j, tsjoints[userIndex][j].velocity);
          sendSmoothVel2DMessage(userIndex, j, tsjoints[userIndex][j].smoothedVelocity);
        }
      }
    }
  }
}



//int findMostConfidentSkeleton(SimpleOpenNI context) {
//  int mostConfident = 0;
//  float maxConfidence = 0;
//  PVector p = new PVector();
//  int[] userList = context.getUsers();
//  for (int i=0; i<userList.length; i++) {
//    float c = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_HEAD, p);
//    if (c > maxConfidence) {
//      maxConfidence = c;
//      mostConfident = userList[i];
//    }
//  }
//  return mostConfident;
//}   

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
  OscMessage myMessage = new OscMessage("/skeleton/"+str(userId)+"/joint/"+str(jointId)+"/smoothvel2d");

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

