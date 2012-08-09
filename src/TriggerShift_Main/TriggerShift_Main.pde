import processing.opengl.*;

import SimpleOpenNI.*;
import controlP5.*;

// params
boolean doDrawKinectRGB = false;
boolean doDrawKinectDepth = true;
boolean doDrawKinectMasked = true;
boolean doDrawSkeletons = true;
boolean doDrawDebugInfo = true;
int maskBlurAmount = 0;
float videoSizeX = 0.5;
float videoSizeY = 0.5;
float videoPosX = 0.5;
float videoPosY = 0.75;


// vars
ControlP5 cp5;
SimpleOpenNI  openNIContext;
TSSkeleton skeleton;
TSTransform2D transform2D;
TSMasker masker;

// Stories
TSStoryBase currentStory;
ArrayList stories = new ArrayList();

//----------------------------------
void setupUI() {
  cp5 = new ControlP5(this);

  cp5.addSlider("fps", 0, 60).linebreak();

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
}


//----------------------------------
void setupStories() {
  stories.add(new StoryTest());
  currentStory = (TSStoryBase) stories.get(0);
}

//----------------------------------
void setupOpenNI() {
  //setup openNI context
  openNIContext = new SimpleOpenNI(this);

  openNIContext.enableDepth();
  openNIContext.enableRGB();
  openNIContext.enableScene();
  openNIContext.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  openNIContext.setMirror(false);
  openNIContext.alternativeViewPointDepthToImage();
}


//----------------------------------
void setup() {
  size(1280, 800, P3D);

  setupOpenNI();
  setupStories();

  skeleton = new TSSkeleton();
  masker = new TSMasker();
  transform2D = new TSTransform2D();

  setupUI();

  currentStory.startStory();

  stroke(255, 255, 255);
  smooth();
}


//----------------------------------
void draw() {
  cp5.getController("fps").setValue(frameRate);

  background(80, 0, 0);

  // get kinect color image
  openNIContext.update();

  // apply mask
  if (doDrawKinectMasked) masker.update(openNIContext, maskBlurAmount);

  // update transform2d
  transform2D.outputSizePixels = new PVector(width, height);
  transform2D.inputSizePixels = new PVector(openNIContext.depthImage().width, openNIContext.depthImage().height);
  transform2D.targetSize = new PVector(videoSizeX, videoSizeY);
  transform2D.targetCenter = new PVector(videoPosX, videoPosY);
  transform2D.update();

  // update skeleton
  skeleton.update(openNIContext);

  if (doDrawKinectRGB) transform2D.drawImage( openNIContext.rgbImage() );
  if (doDrawKinectDepth) transform2D.drawImage( openNIContext.depthImage() );
  if (doDrawKinectMasked) transform2D.drawImage( masker.getImage() );
  if (doDrawSkeletons) skeleton.drawAllSkeletons( openNIContext,transform2D);
  if (doDrawDebugInfo) skeleton.drawDebugInfo(openNIContext);
  /* 
   PVector rHand = skeleton.getScreenCoords(1, SimpleOpenNI.SKEL_RIGHT_HAND) ;
   PVector lHand = skeleton.getScreenCoords(1, SimpleOpenNI.SKEL_LEFT_HAND) ;
   fill(255, 0, 0);
   ellipse(rHand.x, rHand.y, 20, 20);
   ellipse(lHand.x, lHand.y, 20, 20);
   
   image(context.depthImage(), 640, 0, 320, 240); 
   rHand = skeleton.getMappedCoords(1, SimpleOpenNI.SKEL_RIGHT_HAND, 640, 0, 320, 240 ) ;
   lHand = skeleton.getMappedCoords(1, SimpleOpenNI.SKEL_LEFT_HAND, 640, 0, 320, 240) ;
   fill(255, 0, 0);
   ellipse(rHand.x, rHand.y, 20, 20);
   ellipse(lHand.x, lHand.y, 20, 20);
   */


  currentStory.draw(masker.getImage(), skeleton);

  cp5.draw();
}



//----------------------------------
//----------------------------------
//----------------------------------

// ARE THESE NEEDED HERE?
//OPENNI CALLBACKS
void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");


  openNIContext.requestCalibrationSkeleton(userId, true);
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

void onExitUser(int userId)
{
  println("onExitUser - userId: " + userId);
}

void onReEnterUser(int userId)
{
  println("onReEnterUser - userId: " + userId);
}


void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
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
