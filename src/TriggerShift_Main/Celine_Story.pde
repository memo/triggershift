class CelineStory extends TSStoryBase {

  CelineStory() {
    storyName = "CelineStory";
    println(storyName + "::" + storyName);
    
    addScene(new Scene_fade_in_colour());
    addScene(new Scene_turn_cards());
  }
}

//
class Scene_ripPaper extends TSSceneBase {
  PImage easel = loadImage("easel.png");
  PImage leftHalf = loadImage("left.png");
  PImage rightHalf= loadImage("right.png");

  int imageWidth = 80;
  int imageHeight = 200;



  Scene_ripPaper() {
    println("CelineStory::Scene_ripPaper");
    setTrigger(new KeyPressTrigger('q'));
    leftHalf.resize(imageWidth, imageHeight);
    rightHalf.resize(imageWidth, imageHeight);
    easel.resize(3*imageWidth, 3*imageHeight);
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
    PVector leftHalfPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.2, 0));
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

    //draw the easel behind the 2 halves of the image
    image(easel, -(easel.width*0.7), -(easel.height*0.66));
    //rotate by joint orientation of forearm
    rotate(angle, axis.x, axis.y, -axis.z);

    //shift up so it rotates around bottom left
    translate(-leftHalf.height*0.2, -leftHalf.height, 0);
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


//fades an image from 'sepia' to colour with distance between hands //TODO cut around sepia image!
class Scene_fade_in_colour extends TSSceneBase {
  PImage easel = loadImage("easel.png");
  PImage picture = loadImage("skyscraper1.png");
  PImage sepia = loadImage("skyscraper1.png");
  int imageWidth = 80;
  int imageHeight = 200;
  Scene_fade_in_colour() {
    println("CelineStory::Scene_fade_in_colour");
    setTrigger(new KeyPressTrigger('w'));
    sepia.filter(GRAY);
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_fade_in_colour::onStart");
    picture.resize(imageWidth, imageHeight);
    sepia.resize(imageWidth, imageHeight);

    easel.resize(3*imageWidth, 3*imageHeight);
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector rightHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.2, 0));

    //get the distance between hands
    float distBetweenHands = dist( rightHand.x, rightHand.y, leftHand.x, leftHand.y);
    //this is an estimate, empiracly obtained
    float maxDist= 300;
    //the alpha value 
    float alp =  map(distBetweenHands, 0, maxDist, 0.0, 255);
    //draw the colour image under the sepia one - we are going to make the top layer semi-transparent
    pushMatrix();
    image(easel, picturePos.x- (easel.width*0.7), picturePos.y-(easel.height*0.66));
    image(picture, picturePos.x-picture.width, picturePos.y-picture.height);
    popMatrix();
    pushStyle();
    //tint a sepia -ish colour
    tint(232, 222, 48, 255-alp);
    sepia.loadPixels();
    for (int i=0;i<sepia.pixels.length;i++) {
      sepia.pixels[i]=color(red(sepia.pixels[i]), green(sepia.pixels[i] ), blue( sepia.pixels[i] ), 255-alp ) ;
    }
    sepia.updatePixels();
    image(sepia, picturePos.x-picture.width, picturePos.y-picture.height);
    popStyle();
  }
};

//controls size of image with distance between hands
class Scene_shrink_grow_image extends TSSceneBase {
  PImage easel = loadImage("easel.png");
  PImage picture = loadImage("skyscraper1.png");
  int imageWidth = 80;
  int imageHeight = 200;
  Scene_shrink_grow_image() {
    println("CelineStory::Scene_shrink_grow_image");
    setTrigger(new MouseClickTrigger());
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_shrink_grow_image::onStart");
    picture.resize(imageWidth, imageHeight);
    easel.resize(3*imageWidth, 3*imageHeight);
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector rightHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.2, 0));
    //PVector easelPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.2, 0.5, 0));

    float distBetweenHands = dist( rightHand.x, rightHand.y, leftHand.x, leftHand.y);
    float maxDist= 300;
    //scale the image according to the mapped distance between hands
    float imageScale =  map(distBetweenHands, 0, maxDist, 0.0, 1);
    pushMatrix();
    image(easel, picturePos.x- (easel.width*0.7), picturePos.y-(easel.height*0.66));
    image(picture, picturePos.x-picture.width, picturePos.y-picture.height, picture.width*imageScale, picture.height*imageScale);
    popMatrix();
  }
};


//controls size of image with distance between hands
class Scene_turn_cards extends TSSceneBase {

  Card [] cards;
  int [] timers;
  int numCards=8;


  Scene_turn_cards() {
    println("CelineStory::Scene_turn_cards");
    setTrigger(new MouseClickTrigger());
    cards= new Card[numCards];
    //TODO -replace with card images
    int index=1;
    for (int i=0;i<cards.length;i++) {
      //TODO update to use back of image file names
      cards[i] = new Card( 60, 100, "playingcards"+str(index)+".png", "back"+str(index)+".png" );
      index++;
      if (index>=5) {
        index=1;
      }
    }
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_turn_cards::onStart");
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector leftHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);

    int x=0;
    int y=0;
    //TO DO move setPos into constructor 
    for (int i=0;i<cards.length;i++) {
      PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.2*x, 0.5*y, 0));
      cards[i].setPos(picturePos);
      cards[i].check(leftHand);
      cards[i].draw();
      x++;
      if (x>=4) {
        x=0;
        y++;
      }
    }
    //scale the image according to the mapped distance between hands
  }
};
//a class for cards which turn over when a joint passes over them and stay in that position until next time a joint passes over them
class Card {
  PVector pos;
  boolean isFaceDown=true;
  boolean pHandIsOverCard=false;
  PImage face;
  PImage back;
  float cWidth;
  float cHeight;

  int timer=0;
  int timeThreshold = 30; //the cards will toggle immediately the first time a hand is over but we want to leave them in their new position
  //ie not toggle back when the hand isn't over the card anymore
  Card( float w, float h, String faceFilename, String backFilename) {
    cWidth=w;
    cHeight=h;
    face =loadImage(faceFilename);
    back=loadImage(backFilename);
  }
  //TODO this would obviously be better in the constructor but the transform2D object is made after this class = TODO use local class instance of transofrm2D
  void setPos(PVector _pos) {
    pos=_pos;
  }
  void draw() {
    if (isFaceDown) {
      image( back, pos.x, pos.y, cWidth, cHeight);
    }
    else {
      image( face, pos.x, pos.y, cWidth, cHeight);
    }
  }
  void check(PVector handPos) {
    //if this hand is over the card
    if (pHandIsOverCard!= handIsOverCard( handPos) ) {
      boolean tooSoon=false;

      if (timer<timeThreshold) {
        tooSoon=true;
      }
      if (!tooSoon) {
        isFaceDown=!isFaceDown;
      }
      timer=0;
    }
    timer++;
    pHandIsOverCard = handIsOverCard( handPos);
  }
  boolean handIsOverCard(PVector handPos) {
    if (handPos.x> pos.x && handPos.x < pos.x+cWidth && handPos.y> pos.y && handPos.y< pos.y+cHeight) {
      return true;
    }
    else {
      return false;
    }
  }
};

