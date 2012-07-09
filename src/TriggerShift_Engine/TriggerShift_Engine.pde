

TSSceneManager sceneManager;
TSSkeleton skeleton;

PImage userImage;  // contains kinect color image, masked with usermask

//----------------------------------
void setup() {
  TSScene s;
  TSTrigger t;
  
// s = new scene
// t = new trigger
  sceneManager.addScene(s, t);
  
  // repeat above
  
}


//----------------------------------
void draw() {
  // get kinect color image
  
  // mask it with userMask (update userImage)
  
  
  
  // get skeleton from openNI
  
  // fill our TSSkeleton class
  
  
  // draw current scene
  sceneManager.draw(userImage, skeleton);
  
}
