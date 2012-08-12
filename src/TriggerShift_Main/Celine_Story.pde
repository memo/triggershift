class CelineStory extends TSStoryBase {

  CelineStory() {
    println("CelineStory::CelineStory");
    addScene(new Scene_shrink_grow_image());
    addScene(new Scene_fade_in_colour());
  }
}

//
class Scene_ripPaper extends TSSceneBase {
  PImage easel = loadImage("mug.png");
  PImage leftHalf = loadImage("left.png");
  PImage rightHalf= loadImage("right.png");

  Scene_ripPaper() {
    println("CelineStory::Scene_ripPaper");
    setTrigger(new MouseAreaTrigger(0, 0, 250, 250, false));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_ripPaper::onStart");
  }

  // this is the scenes draw function
  // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    //      println("StoryTest::Scene1::onDraw");      

    PVector rightHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector rightElbow = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_RIGHT_ELBOW, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector leftElbow = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_ELBOW, transform2D, openNIContext);

    PVector easelPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.2, 0.5, 0));
    PVector leftHalfPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.2, 0.5, 0));
    PVector rightHalfPos= new PVector(leftHalfPos.x+(leftHalf.width), leftHalfPos.y, leftHalfPos.z) ;


    ///get the angle between hand and elbow
    leftHand.sub(leftElbow);
    leftHand.normalize();

    pushMatrix();
    PVector imageOrientation = new PVector(1, 0, 0);

    //get the dot and cross products
    float angle = acos(imageOrientation.dot(leftHand));
    PVector axis = imageOrientation.cross(leftHand);

    //translate to the place we want to draw the image
    translate(leftHalfPos.x, leftHalfPos.y, leftHalfPos.z);

    //rotate by joint orientation of forearm
    rotate(angle, axis.x, axis.y, -axis.z);

    //shift up so it rotates around bottom left
    translate(0, -leftHalf.height, 0);
    image(leftHalf, 0, 0);
    popMatrix();

    rightHand.sub(rightElbow);
    rightHand.normalize();

    pushMatrix();
    imageOrientation = new PVector(1, 0, 0);
    angle = acos(imageOrientation.dot(rightHand));
    axis = imageOrientation.cross(rightHand);
    translate(rightHalfPos.x-rightHalf.width, rightHalfPos.y, rightHalfPos.z);
    rotateZ(PI);
    rotate(angle, axis.x, axis.y, -axis.z);


    translate(-rightHalf.width, -rightHalf.height, 0);
    image(rightHalf, 0, 0);
    popMatrix();
  }
};


//fades an image from 'sepia' to colour with distance between hands
class Scene_fade_in_colour extends TSSceneBase {
  PImage easel = loadImage("mug.png");
  PImage picture = loadImage("mug.png");
  PImage sepia = loadImage("mug.png");
  float imageWidth = 100;
  float imageHeight = 100;
  Scene_fade_in_colour() {
    println("CelineStory::Scene_fade_in_colour");
    setTrigger(new MouseClickTrigger());
    sepia.filter(GRAY);
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_fade_in_colour::onStart");
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector rightHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector easelPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.2, 0.5, 0));
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.02, 0.5, 0));
    
    //get the distance between hands
    float distBetweenHands = dist( rightHand.x, rightHand.y, leftHand.x, leftHand.y);
    //this is an estimate, empiracly obtained
    float maxDist= 300;
    //the alpha value 
    float alp =  map(distBetweenHands, 0, maxDist, 0.0, 255);
    //draw the colour image under the sepia one - we are going to make the top layer semi-transparent
    image(picture, picturePos.x, picturePos.y, imageWidth, imageHeight);

    pushStyle();
    //tint a sepia -ish colour
    tint(232, 222, 48, alp);
    sepia.loadPixels();
    for (int i=0;i<sepia.pixels.length;i++) {
      sepia.pixels[i]=color(red(sepia.pixels[i]), green(sepia.pixels[i] ), blue( sepia.pixels[i] ), alp ) ;
    }
    sepia.updatePixels();
    image(sepia, picturePos.x, picturePos.y, imageWidth, imageHeight);
    popStyle();
  }
};

//controls alpha of
class Scene_shrink_grow_image extends TSSceneBase {
  PImage easel = loadImage("mug.png");
  PImage picture = loadImage("mug.png");
  float imageWidth = 200;
  float imageHeight = 100;
  Scene_shrink_grow_image() {
    println("CelineStory::Scene_shrink_grow_image");
    setTrigger(new MouseClickTrigger());
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_shrink_grow_image::onStart");
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector rightHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector easelPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.2, 0.5, 0));
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.02, 0.5, 0));

    float distBetweenHands = dist( rightHand.x, rightHand.y, leftHand.x, leftHand.y);
    float maxDist= 300;
    //scale the image according to the mapped distance between hands
    float imageScale =  map(distBetweenHands, 0, maxDist, 0.0, 1);
    
    image(picture, picturePos.x, picturePos.y, imageWidth*imageScale, imageHeight*imageScale);
  }
};

