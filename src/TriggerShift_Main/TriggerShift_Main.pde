  import processing.opengl.*;
import fisica.*;

import SimpleOpenNI.*;
import controlP5.*;

// SET THIS TO TRUE OR FALSE
boolean useOpenNI = true;

// params
boolean doDrawKinectRGB = false;
boolean doDrawKinectDepth = false;
boolean doDrawKinectMasked = true;
boolean doDrawSkeletons = true;
boolean doDrawDebugInfo = false;
int maskBlurAmount = 0;
float videoSizeX = 0.5;
float videoSizeY = 0.5;
float videoPosX = 0.5;
float videoPosY = 0.75;


// vars
ControlP5 cp5 = null;
SimpleOpenNI  openNIContext = null;
TSSkeleton skeleton = null;
TSTransform2D transform2D = null;
TSMasker masker = null;

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
void setStory(int i) {
  if(i >= stories.size()) i = stories.size();
  currentStory = (TSStoryBase) stories.get(i);
  currentStory.startStory();
}

//----------------------------------
void setupStories() {
  stories.add(new StoryTest());  // 0
  stories.add(new ChardeneStory(this));  // 1
  stories.add(new CelineStory());  // 2
  stories.add(new JamelStory());  // 3
  stories.add(new LornaStory());  // 4
  stories.add(new ManiStory());  // 5
  
  setStory(0);  // use keyboard 0-5 to choose story
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
  size(1280, 800, OPENGL);
  skeleton = new TSSkeleton();
  masker = new TSMasker();
  transform2D = new TSTransform2D();

  if (useOpenNI) setupOpenNI();
  setupStories();

  setupUI();

  stroke(255, 255, 255);
  smooth();
}


//----------------------------------
void draw() {
  cp5.getController("fps").setValue(frameRate);

  background(80, 0, 0);

  // get kinect color image
  if (openNIContext != null) {
    openNIContext.update();

    // apply mask
    if (doDrawKinectMasked) masker.update(openNIContext, maskBlurAmount);

    // update skeleton
    skeleton.update(openNIContext);

    // update transform2d
    transform2D.inputSizePixels = new PVector(openNIContext.depthImage().width, openNIContext.depthImage().height);
  }

  transform2D.outputSizePixels = new PVector(width, height);
  transform2D.targetSize = new PVector(videoSizeX, videoSizeY);
  transform2D.targetCenter = new PVector(videoPosX, videoPosY);
  transform2D.update();

  if (openNIContext != null) {
    if (doDrawKinectRGB) transform2D.drawImage( openNIContext.rgbImage() );
    if (doDrawKinectDepth) transform2D.drawImage( openNIContext.depthImage() );
    if (doDrawKinectMasked) transform2D.drawImage( masker.getImage() );
    if (doDrawSkeletons) skeleton.drawAllSkeletons( openNIContext, transform2D);
    if (doDrawDebugInfo) skeleton.drawDebugInfo(openNIContext);
  }
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
void keyPressed() {
  switch(key) {
    case '0': setStory(0); break;
    case '1': setStory(1); break;
    case '2': setStory(2); break;
    case '3': setStory(3); break;
    case '4': setStory(4); break;
    case '5': setStory(5); break;
    case '.': currentStory.nextScene(); break;
    case ',': currentStory.prevScene(); break;
    case 'r': currentStory.startStory(); break;
    
  }
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

