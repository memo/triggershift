import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

import processing.opengl.*;
//import fisica.*;

//import SimpleOpenNI.*;
import controlP5.*;

// SET THIS TO TRUE OR FALSE
//boolean useOpenNI = false;

// SET THIS TO TRUE OR FALSE
// IN INSTALLATION MODE, AUTOADVANCE, AND DISABLE SOME SCENES 
boolean useInstallationMode = false;


// params
boolean doDrawUsers = true;
boolean doDrawKinectRGB = false;
boolean doDrawKinectDepth = false;
boolean doDrawKinectMasked = false;
boolean doDrawSkeletons = false;
boolean doDrawDebugInfo = false;
boolean doShowGUI = false;

int maskBlurAmount = 0;
float videoSizeX = 1;
float videoSizeY = 1;
float videoPosX = 0.5;
float videoPosY = 0.5;
float spreadArmExtent = 300.0;
float imageRotateAngle = 6.156;
float leftShift = 0.7;
float upShift = 0.7;

// vars
ControlP5 cp5 = null;
//SimpleOpenNI  openNIContext = null;
//TSTransform2D transform2D = null;
//TSMasker masker = null;
Minim minim;
AudioPlayer player;
AudioPlayer player1;
AudioPlayer storyPlayer;
MSAAudioPlayer working;
MSAAudioPlayer happy;

//int lastUserId = 1;

//for printing debug info to screen
PFont debugFont;
PFont smallFont;

float lastFrameMillis = 0;
float secondsSinceLastFrame = 1;

// Stories
TSStoryBase currentStory = null;
int currentStoryIndex = 0;
int numStorys = 6; // including test story
//ArrayList stories = new ArrayList();

void setupAudio() {
  minim = new Minim(this);
  //a default song to load - if we don't have this calling .close() gives null pointer
  player = minim.loadFile("song1.mp3");
  player1 = minim.loadFile("song1.mp3");
  //  player1.play();
  player.printControls();
  working = new MSAAudioPlayer("intro-working-tune-edit.mp3");
  happy =  new MSAAudioPlayer("lorna-hugs-section.mp3");
}
//----------------------------------
void setupUI() {
  cp5 = new ControlP5(this);

  cp5.addTab("Display");
  cp5.addToggle("doDrawKinectRGB").linebreak().moveTo("Display");
  cp5.addToggle("doDrawKinectDepth").linebreak().moveTo("Display");
  cp5.addToggle("doDrawKinectMasked").linebreak().moveTo("Display");
  cp5.addToggle("doDrawSkeletons").linebreak().moveTo("Display");
  cp5.addToggle("doDrawDebugInfo").linebreak().moveTo("Display");

  cp5.addSlider("maskBlurAmount", 0, 10).linebreak().moveTo("Display");
  cp5.addSlider("videoSizeX", 0, 1).linebreak().moveTo("Display");
  cp5.addSlider("videoSizeY", 0, 1).linebreak().moveTo("Display");
  cp5.addSlider("videoPosX", 0, 1).linebreak().moveTo("Display");
  cp5.addSlider("videoPosY", 0, 1).linebreak().moveTo("Display");
  cp5.addSlider("spreadArmExtent", 0, 500).linebreak().moveTo("Display");
  cp5.addSlider("imageRotateAngle", 0, TWO_PI).linebreak().moveTo("Display");
  cp5.addSlider("leftShift", -500, 500).linebreak().moveTo("Display");
  cp5.addSlider("upShift", -  500, 500).linebreak().moveTo("Display");
}


//----------------------------------
void setStory(int i) {
  if (currentStory != null) currentStory.endStory();

  switch(i) {
  case 0: 
    currentStory = new StoryTest(); 
    break;
  case 1: 
    currentStory = new ManiStory(); 
    break;
  case 2: 
    currentStory = new LornaStory(); 
    break;
  case 3: 
    currentStory = new JamelStory(); 
    break;
  case 4: 
    currentStory = new CelineStory(); 
    break;
  case 5: 
    currentStory = new CharleneStory(this); 
    break;
  case 6:
    currentStory = new AudioReactiveStory();
  }

  currentStoryIndex = i;
  currentStory.startStory();
}

void nextStory() {
  println("nextStory");
  currentStoryIndex++;
  if (currentStoryIndex>5) currentStoryIndex = 1;
  setStory(currentStoryIndex);
}

//----------------------------------
void setupStories() {
  setStory(0);//useInstallationMode ? 1 : 0);  // use keyboard 0-5 to choose story
//  if(useInstallationMode) setStory(1);
}

//----------------------------------
//void setupOpenNI() {
//  //setup openNI context
//  openNIContext = new SimpleOpenNI(this);
//
//  openNIContext.enableDepth();
//  openNIContext.enableRGB();
//  openNIContext.enableScene();
//  openNIContext.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
//
//  openNIContext.setMirror(true);
//  openNIContext.alternativeViewPointDepthToImage();
//}


//----------------------------------
void setup() {
  size(1280, 768, OPENGL);

  frameRate(60);
  //  masker = new TSMasker();
  //  transform2D = new TSTransform2D();

  //  if (useOpenNI) setupOpenNI();
  setupStories();

  setupUI();
  debugFont=loadFont("AlBayan-48.vlw");
  smallFont = loadFont("AdobeGothicStd-Bold-14.vlw");
  textFont(smallFont);

  setupAudio();
  stroke(255, 255, 255);

  hint(DISABLE_DEPTH_TEST);

  println("\n\n\n*** READY TO GO!!!!****\n");
  // smooth();
}


//----------------------------------
void draw() {
  // update timing
  secondsSinceLastFrame = (millis() - lastFrameMillis) * 0.001;
  lastFrameMillis = millis();

  background(0, 0, 0);
  
  syphon.update();


  //drawMaskedUser();

  // get kinect color image
  //  if (openNIContext != null) {
  //    openNIContext.update();

  // apply mask
  //    masker.update(openNIContext, maskBlurAmount);

  // update skeleton
  //    skeleton.update(openNIContext);
  skeletonManager.update();
  updateSkeletonStats();

  // update transform2d
  //    transform2D.inputSizePixels = new PVector(depthWidth, depthHeight);
  //  }

  //  transform2D.outputSizePixels = new PVector(width, height);
  //  transform2D.targetSize = new PVector(videoSizeX, videoSizeY);
  //  transform2D.targetCenter = new PVector(videoPosX, videoPosY);
  //  transform2D.update();

  if (currentStory != null) currentStory.draw();

  //  if (openNIContext != null) {
  //    if (doDrawKinectRGB) transform2D.drawImage( openNIContext.rgbImage() );
  //    if (doDrawKinectDepth) transform2D.drawImage( openNIContext.depthImage() );
  //    if (doDrawKinectMasked) transform2D.drawImage( masker.getImage() );
  //    if (doDrawSkeletons) skeletonManager.draw2d();
  //  }

  //  pushMatrix();
  //  scale(width, height, 1);
  if (doDrawSkeletons) {
    skeletonManager.draw2d();
    skeletonManager.drawVelocities(30);
  }
  //  popMatrix();

  if (doShowGUI) cp5.draw();

  if (doDrawDebugInfo) {
    pushStyle();
    textFont(smallFont);
    fill(255);
    String s = "";
    s += "fps: " + str(frameRate) + "\n";
    s += "secondsSinceLastFrame: " + str(secondsSinceLastFrame) + "\n";
    s += currentStory.getString() + "\n";
    s += "getHead: " + getHead() + "\n";
    s += "getHip: " + getHip() + "\n";
    s += "getLeftHand: " + getLeftHand() + "\n";
    s += "getRightHand: " + getRightHand() + "\n";
    s += "getLeftElbow: " + getLeftElbow() + "\n";
    s += "getRightElbow: " + getRightElbow() + "\n";
    s += "getLeftShoulder: " + getLeftShoulder() + "\n";
    s += "getRightShoulder: " + getRightShoulder() + "\n";
    s += "getLeftArm: " + getLeftArm() + "\n";
    s += "getRightArm: " + getRightArm() + "\n";
    s += "getMaxArmLength: " + str(getMaxArmLength()) + "\n";
    s += "getLeftHandVelocity: " + PVector.mult(getLeftHandVelocity(), 100) + "%\n";
    s += "getRightHandVelocity: " + PVector.mult(getRightHandVelocity(), 100) + "%\n";
    s += "getLeftHandSpeed: " + str(getLeftHandVelocity().mag() * 100) + "%\n";
    s += "getRightHandSpeed: " + str(getRightHandVelocity().mag() * 100) + "%\n";
    text(s, 10, 40); 

    popStyle();
  }
}


//----------------------------------
void keyPressed() {
  switch(key) {
  case '0': 
    setStory(0); 
    break;
  case '1': 
    setStory(1); 
    break;
  case '2': 
    setStory(2); 
    break;
  case '3': 
    setStory(3); 
    break;
  case '4': 
    setStory(4); 
    break;
  case '5': 
    setStory(5); 
    break;
  case '6':
    setStory(6);
    break;
  case ' ': 
    currentStory.nextScene(); 
    break;
  case ',': 
    currentStory.prevScene(); 
    break;
  case 'r': 
    currentStory.startStory(); 
    break;

  case 'n':
    nextStory();
    break;
    
  case 'u':
    doDrawUsers ^= true;
    break;

  case 's': 
    doDrawSkeletons ^= true; 
    break;
  case 'c': 
    doDrawKinectRGB ^= true; 
    break;
  case 'd': 
    doDrawDebugInfo ^= true; 
    break;
  case 'g':
    doShowGUI ^= true;
    break;
  case 'w':
    if (working.isPlaying()) {
      working.pause();
    }
    else {
      working.loop();
    }
    break;
  case 'h':
    if (happy.isPlaying()) {
      happy.pause();
    }
    else {
      happy.loop();
    }
    break;
  }
}


//----------------------------------
//----------------------------------
//----------------------------------


////OPENNI CALLBACKS
//void onNewUser(int userId)
//{
//  println("onNewUser - userId: " + userId);
//
//  openNIContext.requestCalibrationSkeleton(userId, true);
//  resetSkeletonStats();
//}
//
//void onLostUser(int userId)
//{
//  println("onLostUser - userId: " + userId);
//  resetSkeletonStats();
//}
//
//void onExitUser(int userId)
//{
//  println("onExitUser - userId: " + userId);
//  resetSkeletonStats();
//}
//
//void onReEnterUser(int userId)
//{
//  println("onReEnterUser - userId: " + userId);
//  resetSkeletonStats();
//}
//
//
//void onStartCalibration(int userId)
//{
//  println("onStartCalibration - userId: " + userId);
//  resetSkeletonStats();
//}
//
//void onEndCalibration(int userId, boolean successfull)
//{
//  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
//
//  if (successfull) 
//  { 
//    println("  User calibrated !!!");
//    openNIContext.startTrackingSkeleton(userId);
//  } 
//  else 
//  { 
//    println("  Failed to calibrate user !!!");
//    println("  Start pose detection");
//    openNIContext.startPoseDetection("Psi", userId);
//  }
//  resetSkeletonStats();
//}
//
//void onStartPose(String pose, int userId)
//{
//  println("onStartdPose - userId: " + userId + ", pose: " + pose);
//  println(" stop pose detection");
//
//  openNIContext.stopPoseDetection(userId); 
//  openNIContext.requestCalibrationSkeleton(userId, true);
//}
//
//void onEndPose(String pose, int userId)
//{
//  println("onEndPose - userId: " + userId + ", pose: " + pose);
//}


void stop()
{
  // the AudioPlayer you got from Minim.loadFile()
  player.close();
  // the AudioInput you got from Minim.getLineIn()
  minim.stop();
  // this calls the stop method that
  // you are overriding by defining your own
  // it must be called so that your application
  // can do all the cleanup it would normally do
  super.stop();
}

//void mouseMoved() {
//  float volume = map(mouseX, 0, width, -80.0, -13.9794);
//  try {
//    storyPlayer.setGain(volume);
//  }
//  catch(Exception e) {
//  }
//}

