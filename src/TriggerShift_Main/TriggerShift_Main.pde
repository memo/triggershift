import SimpleOpenNI.*;

SimpleOpenNI  context;

TSSceneManager sceneManager;
TSSkeleton skeleton;
TSTransform2D transform2D;
TSMasker masker;

PImage userImage;  // contains kinect color image, masked with usermask


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
void setupContext() {
  //setup openNI context
  context = new SimpleOpenNI(this);
  // enable depthMap generation 
  context.enableDepth();
  // enable camera image generation
  context.enableRGB();
    context.enableScene();

  context.setMirror(false);
  context.alternativeViewPointDepthToImage();
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
}

//----------------------------------
void setup() {
  size(1280, 800, P3D);

  // setup kinect context
  setupContext();

  // setup our scenes
  setupScenes();

  // create skeleton
  skeleton = new TSSkeleton();
  masker = new TSMasker();
  // create 2D Transformer to map kinect onto a smaller part of the screen
  //  transform2D = new TSTransform2D(new PVector(width, height), new PVector(context.depthWidth(), context.depthHeight()), new PVector(1, 1), new PVector(0.5, 0.5));


  stroke(255, 255, 255);
  smooth();

  //println("SimpleOpenNI.SKEL_RIGHT_HAND "+SimpleOpenNI.SKEL_RIGHT_HAND);
  // setup userImage
}


//----------------------------------
void draw() {
  background(0);
  // get kinect color image
  context.update();
  // scale to an arbitrary size and position (e.g. scale down 75%, and align to bottom / center)
  skeleton.updateSkeleton();
  // mask it with userMask (update userImage)
  // skeleton.drawAllSkeletons();
  /* image(context.depthImage(), 0, 0); 
   
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
  
  image(masker.getMask(), 0, 0);
  // draw current scene (pass the userImage and skeleton so we can draw the relevant graphics and track interaction)
  //sceneManager.draw(userImage, skeleton);
}


// ARE THESE NEEDED HERE?
//OPENNI CALLBACKS
void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");


  context.requestCalibrationSkeleton(userId, true);
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
    context.startTrackingSkeleton(userId);
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    context.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId)
{
  println("onStartdPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");

  context.stopPoseDetection(userId); 
  context.requestCalibrationSkeleton(userId, true);
}

void onEndPose(String pose, int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}

