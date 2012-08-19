class CelineStory extends TSStoryBase {

  CelineStory() {
    storyName = "CelineStory";
    println(storyName + "::" + storyName);
    addScene(new Scene_flick_through_images());
    addScene(new Scene_shrink_grow_image());
    addScene(new Scene_ripPaper());
    addScene(new Scene_fade_in_colour());
    addScene(new Scene_turn_cards());
  }
}

//
class Scene_ripPaper extends TSSceneBase {
  PImage easel = loadImage("celine/easel.png");
  PImage leftHalf = loadImage("celine/left.png");
  PImage rightHalf= loadImage("celine/right.png");

  int imageWidth=120;
  int imageHeight=200;
  float angle;
  float angle1;
  //to lerp distance when halves are thrown away
  float lerpAmt;
  float angleInc;
  //set to true if the 2 halves get past about 20 degrees
  boolean startToFlyAway;

  Scene_ripPaper() {
    println("CelineStory::Scene_ripPaper");
    setTrigger(new KeyPressTrigger('q'));
    leftHalf.resize(imageWidth/2, imageHeight);
    rightHalf.resize(imageWidth/2, imageHeight);
    easel.resize(int(2.2*imageWidth), int(2.8*imageHeight));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_ripPaper::onStart");

    imageWidth = 120;
    imageHeight = 200;
    angle=0;
    angle1=0;
    //to lerp distance when halves are thrown away
    lerpAmt=0;
    angleInc=0;
    //set to true if the 2 halves get past about 20 degrees
    startToFlyAway=false;
  }

  // this is the scenes draw function
  // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    //      println("StoryTest::Scene1::onDraw");      

    PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector rightElbow = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_ELBOW, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector leftElbow = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_ELBOW, transform2D, openNIContext);
    PVector leftHalfPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.2, 0));
    PVector rightHalfPos= new PVector(leftHalfPos.x+(leftHalf.width), leftHalfPos.y, leftHalfPos.z) ;

    if (getElapsedSeconds()>8) {
      ///get the angle between hand and elbow
      leftHand.sub(leftElbow);
      leftHand.normalize();

      if (!startToFlyAway) {
        // image(easel, leftHalfPos.x- (easel.width*0.7575), leftHalfPos.y-(easel.height*0.6868));

        pushMatrix();
        PVector imageOrientation = new PVector(1, 0, 0);

        //get the dot and cross products
        angle = acos(imageOrientation.dot(leftHand));
        PVector axis = imageOrientation.cross(leftHand);
        text(str(angle), 100, 100);
        //>0.5
        //translate to the place we want to draw the image
        translate(leftHalfPos.x, leftHalfPos.y, leftHalfPos.z);

        //draw the easel behind the 2 halves of the image
        image(easel, -(easel.width*0.7575), -(easel.height*0.6868));
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
        angle1 = acos(imageOrientation.dot(rightHand));
        //<2.0
        text(str(angle1), 100, 150);
        axis = imageOrientation.cross(rightHand);
        translate(rightHalfPos.x-rightHalf.width, rightHalfPos.y, rightHalfPos.z);
        rotateZ(PI);
        rotate(angle1, axis.x, axis.y, -axis.z);


        translate(-rightHalf.width, -rightHalf.height, 0);
        image(rightHalf, 0, 0);
        popMatrix();

        if (angle>0.5 && angle1<2.0) {
          startToFlyAway=true;
        }
        else {
          startToFlyAway=false;
        }
        text(str(startToFlyAway), 100, 200);
      }
      //if the paper has been ripped, start to spin the pieces away
      else {
        PVector targetPosLeft=new PVector(-110.0, height/2, 0);//transform2D.getWorldCoordsForInputNorm(new PVector(0.0, 0.2, 0));
        PVector targetPosRight=new PVector(width+110.0, height/2, 0 );//transform2D.getWorldCoordsForInputNorm(new PVector(1.0, 0.2, 0));
        ellipse(targetPosLeft.x, targetPosLeft.y, 20, 20);
        ellipse(targetPosRight.x, targetPosRight.y, 20, 20);

        //draw the easel
        pushMatrix();
        translate(leftHalfPos.x, leftHalfPos.y, leftHalfPos.z);
        image(easel, -(easel.width*0.7575), -(easel.height*0.6868));
        popMatrix();
        //draw the left
        pushMatrix();
        PVector imageOrientation = new PVector(1, 0, 0);
        PVector axis = imageOrientation.cross(leftHand);

        float lerpedX = lerp (leftHalfPos.x, targetPosLeft.x, lerpAmt);
        float lerpedY = lerp (leftHalfPos.y, targetPosLeft.y, lerpAmt);
        //translate to the place we want to draw the image
        // translate(leftHalfPos.x, leftHalfPos.y, leftHalfPos.z);
        translate(lerpedX, lerpedY, leftHalfPos.z);
        //draw the easel behind the 2 halves of the image
        //rotate by joint orientation of forearm
        rotateZ(angleInc);
        rotate(angle, axis.x, axis.y, -axis.z);

        //shift up so it rotates around bottom left
        translate(-leftHalf.height*0.2, -leftHalf.height, 0);
        image(leftHalf, 0, 0);
        popMatrix();

        rightHand.sub(rightElbow);
        rightHand.normalize();

        pushMatrix();
        imageOrientation = new PVector(1, 0, 0);
        angle1 = acos(imageOrientation.dot(rightHand));
        //<2.0
        text(str(angle1), 100, 150);
        axis = imageOrientation.cross(rightHand);

        lerpedX = lerp (rightHalfPos.x, targetPosRight.x, lerpAmt);
        lerpedY = lerp (rightHalfPos.y, targetPosRight.y, lerpAmt);

        translate(lerpedX-rightHalf.width, lerpedY, rightHalfPos.z);

        rotateZ(PI-angleInc);
        rotate(angle1, axis.x, axis.y, -axis.z);


        translate(-rightHalf.width, -rightHalf.height, 0);
        image(rightHalf, 0, 0);
        popMatrix();
        angleInc+=0.05;
        lerpAmt+=0.05;
      }
    }
  }
};


//fades an image from 'sepia' to colour with distance between hands //TODO cut around sepia image!
class Scene_fade_in_colour extends TSSceneBase {
  PImage easel = loadImage("celine/easel.png");
  PImage picture = loadImage("celine/skyscraper1.png");
  PImage sepia = loadImage("celine/skyscraper1.png");
  int imageWidth=120;
  int imageHeight=200;
  float angle;
  Scene_fade_in_colour() {
    println("CelineStory::Scene_fade_in_colour");
    setTrigger(new KeyPressTrigger('w'));
    sepia.filter(GRAY);
    picture.resize(imageWidth, imageHeight);
    sepia.resize(imageWidth, imageHeight);
    easel.resize(int(2.2*imageWidth), int(2.8*imageHeight));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_fade_in_colour::onStart");
    imageWidth = 120;
    imageHeight = 200;
    angle=0;
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.2, 0));

    //get the distance between hands
    float distBetweenHands = dist( rightHand.x, rightHand.y, leftHand.x, leftHand.y);
    //this is an estimate, empiracly obtained
    float maxDist= 300;
    //the alpha value 
    float alp =  map(distBetweenHands, 0, maxDist, 0.0, 255);
    //draw the colour image under the sepia one - we are going to make the top layer semi-transparent
    image(easel, picturePos.x- (easel.width*0.7575), picturePos.y-(easel.height*0.6868));
    pushMatrix();
    translate(picturePos.x-picture.width, picturePos.y-picture.height);
    rotate(imageRotateAngle);
    angle+=0.05;
    image(picture, 0, 0);
    popMatrix();
    pushStyle();
    //tint a sepia -ish colour
    tint(232, 222, 48, alp);
    sepia.loadPixels();
    for (int i=0;i<sepia.pixels.length;i++) {
      sepia.pixels[i]=color(red(sepia.pixels[i]), green(sepia.pixels[i] ), blue( sepia.pixels[i] ), alp ) ;
    }
    sepia.updatePixels();
    pushMatrix();
    translate(picturePos.x-picture.width, picturePos.y-picture.height);
    rotate(imageRotateAngle);
    image(sepia, 0, 0);
    popMatrix();
    popStyle();
  }
};

//controls size of image with distance between hands
class Scene_shrink_grow_image extends TSSceneBase {
  PImage easel = loadImage("celine/easel.png");
  PImage picture = loadImage("celine/skyscraper1.png");
  int imageWidth=120;
  int imageHeight=200;

  Scene_shrink_grow_image() {
    println("CelineStory::Scene_shrink_grow_image");
    setTrigger(new MouseClickTrigger());
    picture.resize(imageWidth, imageHeight);
    easel.resize(int(2.2*imageWidth), int(2.8*imageHeight));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_shrink_grow_image::onStart");

    imageWidth = 120;
    imageHeight = 200;
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.2, 0));
    //PVector easelPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.2, 0.5, 0));

    float distBetweenHands = dist( rightHand.x, rightHand.y, leftHand.x, leftHand.y);
    float maxDist= 300;
    //scale the image according to the mapped distance between hands
    float imageScale =  map(distBetweenHands, 0, maxDist, 0.0, 1);
    imageScale = constrain(imageScale, 0.0, 1.0);
    image(easel, picturePos.x- (easel.width*0.7575), picturePos.y-(easel.height*0.6868));
    pushMatrix();
    translate(picturePos.x-picture.width, picturePos.y-picture.height);
    rotate(imageRotateAngle);
    image(picture, 0, 0, picture.width*imageScale, picture.height*imageScale );
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
      cards[i] = new Card( 60, 100, "celine/playingcards"+str(index)+".png", "celine/back"+str(index)+".png" );
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

    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);

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

//A mortar board flies from the sky and lands ont he head
class Scene_flick_through_images extends TSSceneBase {
  int numImages=8;
  PImage [] images = new PImage[numImages];

  int imageWidth = 200;
  int imageHeight = 200;
  int frameIndex=0;
  int topImageXShift=0;
  int timeOutThresh=30;
  int counter=timeOutThresh+1;
  boolean firstTime=true;
  Scene_flick_through_images() {
    println("Celine::Scene_flickBook");
    for (int i=0;i<numImages;i++) {
      //TODO replace with correct image url
      images[i]=loadImage("charlene/bookPage_"+str(i)+".png");
    }
    setTrigger(new KeyPressTrigger('w'));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("Celine::Scene_flickBook::onStart");
    for (int i=0;i<numImages;i++) {
      images[i].resize(imageWidth, imageHeight);
    }
    topImageXShift=0;
  }
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.2, 0));
    image(images[frameIndex], picturePos.x, picturePos.y);

    PImage section =images[frameIndex+1].get(0, 0, topImageXShift, height);
    image(section, picturePos.x+images[frameIndex+1].width-topImageXShift, picturePos.y);

    float thresh=0.01;
    //if(timeOut>
    //if the left hand is moving to the right and its a little while since we did this...
    if (skeleton.getJointVelocity(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext).x >0+thresh && counter>timeOutThresh) {
      float numSteps= 5.0;
      float speed = images[frameIndex+1].width/numSteps;
      //don't move past the left edge of where we want the image to go
      if (topImageXShift<images[frameIndex+1].width ) {
        topImageXShift+=speed;
      }
      else {
        frameIndex++;
        topImageXShift=0;
        counter=0;
      }
    }
    counter++;

    if (counter>60) {
    }
    if (frameIndex>=images.length-1) {
      frameIndex=0; // frameIndex=images.length-1;
    }
  }
};

