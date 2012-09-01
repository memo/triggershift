import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import SimpleOpenNI.*; 
import codeanticode.syphon.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class TSKinectTracker extends PApplet {







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

public void setup() {
  size(640, 480, P3D);

  oscP5 = new OscP5(this, 1000);
  myRemoteLocation = new NetAddress("127.0.0.1", 7000);
  setupOpenNI();


  tsjoints= new PointSmoother[max_users][numJoints+1];
  //set all initial previous joint positions and velocities to 0
  for (int i=0;i<max_users;i++) {
    for (int j=0;j<tsjoints[i].length;j++) {
      tsjoints[i][j]=new PointSmoother(0.2f);
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



public void draw() {
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



public void keyPressed() {
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


public void setupOpenNI() {
  //setup openNI context
  openNIContext = new SimpleOpenNI(this);

  openNIContext.enableDepth();
  openNIContext.enableRGB();
  openNIContext.enableScene();
  openNIContext.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  openNIContext.setMirror(true);
  openNIContext.alternativeViewPointDepthToImage();
}



public void update(SimpleOpenNI context) {

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
          jointPos_Proj.x *= 1.0f/context.depthImage().width;
          jointPos_Proj.y *= 1.0f/context.depthImage().height;
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

public void sendConfidenceMessage(int userId, float confidence) {
  OscMessage myMessage = new OscMessage("/skeleton/"+str(userId)+"/confidence");
  myMessage.add(confidence);
  oscP5.send(myMessage, myRemoteLocation);
}
public void sendPos2DMessage(int userId, int jointId, PVector pos2D) {
  OscMessage myMessage = new OscMessage("/skeleton/"+str(userId)+"/joint/"+str(jointId)+"/pos2d");

  myMessage.add(pos2D.x);
  myMessage.add(pos2D.y);

  oscP5.send(myMessage, myRemoteLocation);
}
public void sendPos3DMessage(int userId, int jointId, PVector pos3D) {
  OscMessage myMessage = new OscMessage("/skeleton/"+str(userId)+"/joint/"+str(jointId)+"/pos3d");

  myMessage.add(pos3D.x);
  myMessage.add(pos3D.y);
  myMessage.add(pos3D.z);

  oscP5.send(myMessage, myRemoteLocation);
}
public void sendVel2DMessage(int userId, int jointId, PVector vel2D) {
  OscMessage myMessage = new OscMessage("/skeleton/"+str(userId)+"/joint/"+str(jointId)+"/vel2d");

  myMessage.add(vel2D.x);
  myMessage.add(vel2D.y);

  oscP5.send(myMessage, myRemoteLocation);
}
public void sendSmoothVel2DMessage(int userId, int jointId, PVector vel2D) {
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



public void sendJointMessage(int jointId, PVector pos, String type) {
  OscMessage myMessage = new OscMessage("/"+type+"/"+str(jointId));
  //myMessage.add(jointId);
  myMessage.add(pos.x);
  myMessage.add(pos.y);
  myMessage.add(pos.z);
  oscP5.send(myMessage, myRemoteLocation);
}

public void sendSkeletonMessage() {
}


//OPENNI CALLBACKS
public void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);

  openNIContext.requestCalibrationSkeleton(userId, true);
  //resetSkeletonStats();
}

public void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
  //resetSkeletonStats();
}

public void onExitUser(int userId)
{
  println("onExitUser - userId: " + userId);
  //resetSkeletonStats();
}

public void onReEnterUser(int userId)
{
  println("onReEnterUser - userId: " + userId);
  //resetSkeletonStats();
}


public void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
  //resetSkeletonStats();
}

public void onEndCalibration(int userId, boolean successfull)
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

public void onStartPose(String pose, int userId)
{
  println("onStartdPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");

  openNIContext.stopPoseDetection(userId); 
  openNIContext.requestCalibrationSkeleton(userId, true);
}

public void onEndPose(String pose, int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}


class PointSmoother {
  //----------------------------------
  PVector currentPos;
  PVector prevPos;
  PVector velocity;
  PVector smoothedVelocity;

  int lastUpdateTimeStamp;
  float smoothingAmount;

  //----------------------------------
  PointSmoother(float _smoothingAmount) {
    velocity=new PVector(0, 0, 0);
    currentPos=new PVector(0, 0, 0);
    prevPos = null;
    smoothedVelocity=new PVector(0, 0, 0);
    smoothingAmount = _smoothingAmount;
  }


  //----------------------------------
  public void update(PVector newPos) {
    // get time since last update (for velocity)
    float secondsSinceLastUpdate = (millis() - lastUpdateTimeStamp) * 0.001f;
    lastUpdateTimeStamp = millis();

    //update current joint position
    currentPos = newPos;
    if (prevPos != null) {
      // calculate velocity
      velocity = PVector.sub(newPos, prevPos);
      velocity.mult(secondsSinceLastUpdate);

      // smoothvel += (vel - smoothvel) * smoothingAmount
      smoothedVelocity.add(PVector.mult( PVector.sub(velocity, smoothedVelocity), smoothingAmount));
    }
    prevPos = newPos.get();
  }
};


// a class which takes an OpenNI context, and applys the user mask as an alpha mask to the RGB image (optionally blurring it)

class TSMasker {
  protected PImage rgbImage;    // rgb masked image
  protected PImage maskImage;   // grayscale mask image

    //----------------------------------
  // update images form openni context
  public void update(SimpleOpenNI context) {
    int w = context.rgbImage().width;
    int h = context.rgbImage().height;
    
//    if (rgbImage == null || rgbImage.width != w || rgbImage.height != h) rgbImage = createImage(w, h, ARGB);
    if (rgbImage == null || rgbImage.width != w || rgbImage.height != h) rgbImage = createImage(w, h, RGB);

    int[] map = context.sceneMap();
    rgbImage.loadPixels();
      // HACK TO MAKE IT TRANSPARENT BECAUSE SYPHON IN PROCESSING DOESN"T RESPECT ALPHA
    for (int i=0;i<map.length;i++) {
      if (map[i] == 0) rgbImage.pixels[i] = color(0, 0, 0);
      else if(context.rgbImage().pixels[i] == color(0, 0, 0)) rgbImage.pixels[i] = color(1, 1, 1);
      else rgbImage.pixels[i] = context.rgbImage().pixels[i];
    }
    rgbImage.updatePixels();
  }



  // update images form openni context
  public void updateOLD (SimpleOpenNI context, int maskBlurAmount) {
    int w = context.rgbImage().width;
    int h = context.rgbImage().height;

    // init maskImage
    if (maskImage == null || maskImage.width != w || maskImage.height != h) maskImage = createImage(w, h, RGB);

    // init rgbImage
    if (rgbImage == null || rgbImage.width != w || rgbImage.height != h) rgbImage = createImage(w, h, ARGB);

    // get color image from context
    rgbImage.copy(context.rgbImage(), 0, 0, w, h, 0, 0, w, h);

    // create a mask image 
    int[] map = context.sceneMap();
    maskImage.loadPixels();
    for (int i=0;i<map.length;i++) {
      if (map[i] > 0) {
        maskImage.pixels[i] = color(255);
      } 
      else {
        maskImage.pixels[i] = color(0);
      }
    }
    maskImage.updatePixels();

    // blur mask (quite slow)
    if (maskBlurAmount>0) maskImage.filter(BLUR, maskBlurAmount);

    // apply mask
    rgbImage.mask(maskImage);
  }


  //----------------------------------
  // return image
  public PImage getImage() { 
    return rgbImage;
  }
    // return image
  public PImage getMask() { 
    return maskImage;
  }
};
TSMasker masker = new TSMasker();


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

static int[] SKEL_HANDS = { 
  SKEL_LEFT_HAND, SKEL_RIGHT_HAND
};
static int[] SKEL_FEET = { 
  SKEL_LEFT_FOOT, SKEL_RIGHT_FOOT
};
static int[] SKEL_HANDS_AND_FEET = { 
  SKEL_LEFT_HAND, SKEL_RIGHT_HAND, SKEL_LEFT_FOOT, SKEL_RIGHT_FOOT
};
static int[] SKEL_HANDS_FEET_AND_HEAD = { 
  SKEL_LEFT_HAND, SKEL_RIGHT_HAND, SKEL_LEFT_FOOT, SKEL_RIGHT_FOOT, SKEL_HEAD
};



class TSSkeleton {
  class Joint {
    private PVector _pos3d = new PVector();        // 3d coordinates (in mm)
    private PVector _pos2d = new PVector();        // 2d coordinates (normalized)
    private PVector _vel2d = new PVector();        // 2d velocity (normalized)
    private PVector _smoothVel2d = new PVector();  // smoothed 2d velocity (normalized)ivate amp;

    //----------------------------------
    public void setPos3d(PVector v) {
      _pos3d.set(v);
    }

    //----------------------------------
    public void setPos2d(PVector v) {
      _pos2d.set(v);
    }

    //----------------------------------
    public void setVel2d(PVector v) {
      _vel2d.set(v);
    }

    //----------------------------------
    public void setSmoothVel2d(PVector v) {
      _smoothVel2d.set(v);
    }

    //----------------------------------
    public PVector pos3d() {
      return _pos3d.get();
    }

    //----------------------------------
    public PVector pos2d() {
      return _pos2d.get();
    }

    //----------------------------------
    public PVector vel2d() {
      return _vel2d.get();
    }

    //----------------------------------
    public PVector smoothVel2d() {
      return _smoothVel2d.get();
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
  public void update() {
    // if not updated recently, set confidence to 0
    if (millis() - lastUpdateMillis > 2000) confidence = 0;
  }


  //----------------------------------
  public boolean isAlive() {
    return getConfidence() > 0;
  }


  //----------------------------------
  public void setConfidence(float f) {
    confidence = f;
    lastUpdateMillis = millis();
  }


  //----------------------------------
  public void setJointPos2d(int jointIndex, PVector v) {
    joints[jointIndex].setPos2d(v);
    //    if(jointIndex == SKEL_RIGHT_HAND) println("setJointPos2d: " + userIndex + " " + jointIndex + " " + p + "\n");
    lastUpdateMillis = millis();
  }


  //----------------------------------
  public void setJointPos3d(int jointIndex, PVector v) {
    joints[jointIndex].setPos3d(v);
    lastUpdateMillis = millis();
  }


  //----------------------------------
  public void setJointVel2d(int jointIndex, PVector v) {
    joints[jointIndex].setVel2d(v);
    //    if(jointIndex == SKEL_RIGHT_HAND) println("setJointVel2d: " + userIndex + " " + jointIndex + " " + p + "\n");
    lastUpdateMillis = millis();
  }


  //----------------------------------
  public void setJointSmoothVel2d(int jointIndex, PVector v) {
    joints[jointIndex].setSmoothVel2d(v);
    lastUpdateMillis = millis();
  }


  //----------------------------------
  public Joint getJoint(int jointIndex) {
    return joints[jointIndex];
  }



  //----------------------------------
  public float getConfidence() {
    return confidence;
  }

  //----------------------------------
  public PVector getJointPos3d(int jointIndex) {
    return joints[jointIndex].pos3d();
  }


  //----------------------------------
  public PVector getJointPos2d(int jointIndex) {
    return joints[jointIndex].pos2d();
  }


  //----------------------------------
  public PVector getJointVel2d(int jointIndex) {
    return joints[jointIndex].vel2d();
  }


  //----------------------------------
  public PVector getJointSmoothVel2d(int jointIndex) {
    return joints[jointIndex].smoothVel2d();
  }


  //----------------------------------
  public void drawJointVelocity(int jointIndex, float velMult) {
    PVector p = getJointPos2d(jointIndex);
    PVector v = getJointVel2d(jointIndex);
    PVector vs = getJointSmoothVel2d(jointIndex);
    float a = confidence * 255;

    strokeWeight(1);
    stroke(0, 0, 255, a);
    line(p.x, p.y, p.x - v.x * velMult, p.y - v.y * velMult);

    strokeWeight(1);
    stroke(0, 255, 0, a);
    line(p.x, p.y, p.x - vs.x * velMult, p.y - vs.y * velMult);
  }


  //----------------------------------
  public void drawLimb2d(int jointIndex1, int jointIndex2) {
    PVector p1 = getJointPos2d(jointIndex1);
    PVector p2 = getJointPos2d(jointIndex2);
    stroke(255, 0, 0, confidence * 255);
    line(p1.x, p1.y, p2.x, p2.y);
  }


  //----------------------------------
  public void drawLimb3d(int jointIndex1, int jointIndex2) {
    PVector p1 = getJointPos3d(jointIndex1);
    PVector p2 = getJointPos3d(jointIndex2);
    stroke(255, 0, 0, confidence * 255);
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  }



  //----------------------------------
  public void drawVelocities(float velMult) {
    if(!isAlive()) return;

    pushStyle();
    for (int i=0; i<joints.length; i++) {
      drawJointVelocity(i, velMult);
    }
    popStyle();
  }


  //----------------------------------
  public void draw2d() {
    if(!isAlive()) return;
    
    pushStyle();
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
    popStyle();
  }


  //----------------------------------
  public void draw3d() {
    if(!isAlive()) return;

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



class TSSkeletonManager {
  TSSkeleton []skeletons;
  int activeUserIndex;

  //----------------------------------
  TSSkeletonManager(int maxUsers) {
    skeletons = new TSSkeleton[maxUsers];
    for (int i=0; i<skeletons.length; i++) {
      skeletons[i] = new TSSkeleton(i);
    }
  }


  //----------------------------------
  public void update() {
    float highestConfidence = -1;
    for (int i=0; i<skeletons.length; i++) {
      TSSkeleton s = skeletons[i];
      s.update();
      if (s.getConfidence() > highestConfidence) {
        highestConfidence = s.getConfidence();
        activeUserIndex = i;
      }
    }
  }  


  //----------------------------------
  public TSSkeleton activeSkeleton() {
    //    return activeUserIndex >=0 ? skeletons[activeUserIndex] : null;
    return skeletons[activeUserIndex];
  }


  //----------------------------------
  public void drawVelocities(float velMult) {
    for (int i=0; i<skeletons.length; i++) {
      TSSkeleton s = skeletons[i];
      s.drawVelocities(velMult);
    }
  }
  
  
  //----------------------------------
  public void draw2d() {
    for (int i=0; i<skeletons.length; i++) {
      TSSkeleton s = skeletons[i];
      s.draw2d();
    }
  }


  //----------------------------------
  public void draw3d() {
    for (int i=0; i<skeletons.length; i++) {
      TSSkeleton s = skeletons[i];
      s.draw3d();
    }
  }
};


TSSkeletonManager skeletonManager = new TSSkeletonManager(10);


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TSKinectTracker" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
