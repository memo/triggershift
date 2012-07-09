

TSSceneManager sceneManager;
TSSkeleton skeleton;

PImage userImage;  // contains kinect color image, masked with usermask


//----------------------------------
void setupScenes() {
  TSScene s;
  TSTrigger t;
  
// s = new scene
// t = new trigger
  sceneManager.addScene(s, t);
  
  // repeat above
}

//----------------------------------
void setup() {
  // setup our scenes
  setupScenes();
  
  // setup userImage
  
}


//----------------------------------
void draw() {
  // get kinect color image
  
  // scale to an arbitrary size and position (e.g. scale down 75%, and align to bottom / center)
  
  // mask it with userMask (update userImage)
  
  
  
  // get skeleton from openNI

  // scale to an arbitrary size and position (e.g. scale down 75%, and align to bottom / center)
  
  // fill our TSSkeleton class
  
  
  // draw current scene (pass the userImage and skeleton so we can draw the relevant graphics and track interaction)
  sceneManager.draw(userImage, skeleton);
  
}
