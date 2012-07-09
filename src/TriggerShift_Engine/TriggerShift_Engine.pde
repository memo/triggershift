

TSSceneManager sceneManager;
TSSkeleton skeleton;
PImage userImage;

//----------------------------------
void setup() {
  TSScene s;
  TSTrigger t;
  sceneManager.addScene(s, t);
  
}


//----------------------------------
void draw() {
  // get kinect color image
  
  // mask it with userMask
  
  // get skeleton
  
  // fill our TSSkeleton class
  
  // draw current scene
  sceneManager.draw(userImage, skeleton);
  
}
