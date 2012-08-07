import SimpleOpenNI.*;
import controlP5.*;


// params
boolean doDrawKinectRGB = false;
boolean doDrawKinectDepth = true;
boolean doDrawKinectMasked = true;
int maskBlurAmount = 0;
float videoSizeX = 0.5;
float videoSizeY = 0.5;
float videoPosX = 0.5;
float videoPosY = 0.75;



// vars
ControlP5 cp5;
SimpleOpenNI  openNIContext;
TSSceneManager sceneManager;
TSSkeleton skeleton;
TSTransform2D transform2D;
TSMasker masker;



//----------------------------------
void setupUI() {
  cp5 = new ControlP5(this);
  cp5.addTab("Display");
  cp5.addToggle("doDrawKinectRGB").linebreak().moveTo("Display");
  cp5.addToggle("doDrawKinectDepth").linebreak().moveTo("Display");
  cp5.addToggle("doDrawKinectMasked").linebreak().moveTo("Display");
  cp5.addSlider("maskBlurAmount", 0, 10).linebreak().moveTo("Display");
  cp5.addSlider("videoSizeX", 0, 1).linebreak().moveTo("Display");
  cp5.addSlider("videoSizeY", 0, 1).linebreak().moveTo("Display");
  cp5.addSlider("videoPosX", 0, 1).linebreak().moveTo("Display");
  cp5.addSlider("videoPosY", 0, 1).linebreak().moveTo("Display");
}


//----------------------------------
void setupScenes() {
  TSIScene s;
  TSITrigger t;
  // s = new scene;
  // t = new trigger;
  //  sceneManager.addScene(s, t);

  // repeat above
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
  size(1280, 800);

  setupOpenNI();
  setupScenes();

  skeleton = new TSSkeleton();
  masker = new TSMasker();
  transform2D = new TSTransform2D();
  
  setupUI();

  stroke(255, 255, 255);
  smooth();
}


//----------------------------------
void draw() {
  background(255, 0, 0);
  
  // get kinect color image
  openNIContext.update();
  
  // apply mask
  if(doDrawKinectMasked) masker.update(openNIContext, maskBlurAmount);
  
  // update transform2d
  transform2D.outputSizePixels = new PVector(width, height);
  transform2D.inputSizePixels = new PVector(openNIContext.depthImage().width, openNIContext.depthImage().height);
  transform2D.targetSize = new PVector(videoSizeX, videoSizeY);
  transform2D.targetCenter = new PVector(videoPosX, videoPosY);
  transform2D.update();
  
  // update skeleton
  skeleton.update(openNIContext);
  
  
  // skeleton.drawAllSkeletons();
//  image(openNIContext.depthImage(), 0, 0, 320, 240); 
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
   skeleton.drawDebugInfo();*/


  // get skeleton from openNI

  // scale to an arbitrary size and position (e.g. scale down 75%, and align to bottom / center)

  // fill our TSSkeleton class
  
  if(doDrawKinectRGB) transform2D.drawImage( openNIContext.rgbImage() );
  if(doDrawKinectDepth) transform2D.drawImage( openNIContext.depthImage() );
  if(doDrawKinectMasked) transform2D.drawImage( masker.getImage() );
  
  //sceneManager.draw(userImage, skeleton);
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

