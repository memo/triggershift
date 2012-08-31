class CelineStory extends TSStoryBase {
//TODO sound effect are too low - Ed? rip at wrong poitn - old to new is quiet  - page flick for images crashes on exit
  CelineStory() {
    storyName = "CelineStory";
    println(storyName + "::" + storyName);
    addScene(new Scene_big_buildings());
    addScene(new Scene_ripPaper());
    addScene(new Scene_fade_in_colour());
    addScene(new Scene_shrink_grow_image());
    addScene(new Scene_turn_cards());
    addScene(new Scene_flick_through_images());
    
    storyPlayer = minim.loadFile("celine/celine-melody.mp3");
    storyPlayer.loop();
  }
}
///SCENE 1
class Scene_big_buildings extends TSSceneBase {
  PImage easel = loadImage("celine/easel.png");
  PImage picture = loadImage("celine/skyscraper1.png");  
  int imageWidth=150;
  int imageHeight=262;
  PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.65, 0));

  Scene_big_buildings() {
    sceneName = "Scene1 BIG BUILDINGS";
    //println(storyName + "::" + sceneName + "::onStart");
    picture.resize(imageWidth, imageHeight);
    easel.resize(int(2.2*imageWidth), int(2.8*imageHeight));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_big_buildings::onStart");
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {
    image(easel, picturePos.x- (easel.width*0.85), picturePos.y-(easel.height*0.66));
    pushMatrix();
    translate(picturePos.x, picturePos.y);

    rotate(imageRotateAngle);
    translate(-picture.width, -picture.height);

    image(picture, 0, 0);
    popMatrix();
    drawMaskedUser();
  }
  void onEnd() {
  }
};

//SCENE 2
class Scene_ripPaper extends TSSceneBase {
  PImage easel = loadImage("celine/easel.png");
  //the picture underneath
  PImage picture = loadImage("celine/skyscraper1.png");

  PImage leftHalf = loadImage("celine/left.png");
  PImage rightHalf= loadImage("celine/right.png");

  ShardParticle leftP;
  ShardParticle rightP;

  int imageWidth=150;
  int imageHeight=262;
  float angle;
  float angle1;
  //to lerp distance when halves are thrown away
  float lerpAmt;
  float angleInc;
  //set to true if the 2 halves get past about 20 degrees
  boolean startToFlyAway;
  //the top left of the skyscraper image : the easel is drawn above and left of this to aligh
  PVector rightHalfPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.65, 0));

  PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.65, 0));

  PVector  leftHalfPos= new PVector(rightHalfPos.x, rightHalfPos.y, rightHalfPos.z) ;
  PVector axis;
  PVector axis1;

  Scene_ripPaper() {
    sceneName = "Scene2 RIP PAPER";
    //println(storyName + "::" + sceneName + "::onStart");
    leftHalf.resize(imageWidth/2, imageHeight);
    rightHalf.resize(imageWidth/2, imageHeight);
    easel.resize(int(2.2*imageWidth), int(2.8*imageHeight));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_ripPaper::onStart");


    angle=0;
    angle1=0;
    //to lerp distance when halves are thrown away
    lerpAmt=0;
    angleInc=0;
    //set to true if the 2 halves get past about 20 degrees
    startToFlyAway=false;
    leftP = new ShardParticle(new PVector(0, 0, 0), new PVector(0, 0, 0), 0, 0, 0, 1, 0, 1);
    rightP = new ShardParticle(new PVector(0, 0, 0), new PVector(0, 0, 0), 0, 0, 0, 1, 0, 1);

    //close player 2 in case we toggle back to this one

    player = minim.loadFile("celine/rip.mp3");
  }

  // this is the scenes draw function
  // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    //      println("StoryTest::Scene1::onDraw");      
    //   pushMatrix();
    PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector rightElbow = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_ELBOW, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector leftElbow = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_ELBOW, transform2D, openNIContext);

    //draw the easel behind the 2 halves of the image



    pushMatrix();
    image(easel, picturePos.x- (easel.width*0.85), picturePos.y-(easel.height*0.66));
    popMatrix();



    // if (getElapsedSeconds()>1) {


    pushMatrix();
    imageMode(CENTER);
    translate(picturePos.x, picturePos.y, picturePos.z);
    rotate(imageRotateAngle);
    float sW=imageWidth*0.5;
    float sH=imageHeight*0.5;

    translate(-imageWidth*0.5, -imageHeight*0.5);

    image(picture, 0, 0, sW, sH);


    popMatrix();

    imageMode(CORNER);


    player.play();
    ///get the angle between hand and elbow
    leftHand.sub(leftElbow);
    leftHand.normalize();

    PVector imageOrientation = new PVector(1, 0, 0);


    //before we reach the critical angle tie the drawing to the forearms orientation
    if (!startToFlyAway) {
      // image(easel, leftHalfPos.x- (easel.width*0.7575), leftHalfPos.y-(easel.height*0.6868));

      //RIGHT HALF
      pushMatrix();
      //get the dot and cross products
      angle = acos(imageOrientation.dot(leftHand));
      axis = imageOrientation.cross(leftHand);
      //translate to the place we want to draw the image

      translate(rightHalfPos.x, rightHalfPos.y, rightHalfPos.z);


      //translate(-rightHalf.width*0.5, -rightHalf.height, 0);
      //translate rotation point to bottom left of image
      // translate(0, rightHalf.height, 0);
      //rotate by joint orientation of forearm
      rotate(angle, axis.x, axis.y, -axis.z);
      //rotate by easel angle
      rotate(imageRotateAngle);

      translate(-rightHalf.width, -rightHalf.height, 0);
      //translate back up to draw
      // translate(-rightHalf.width*0.2, -rightHalf.height, 0);
      rightP.draw(rightHalf);
      popMatrix();

      rightHand.sub(rightElbow);
      rightHand.normalize();


      //LEFT HALF
      pushMatrix();
      //get the dot and cross products
      angle1 = acos(imageOrientation.dot(rightHand));

      axis1 = imageOrientation.cross(rightHand);

      translate(rightHalfPos.x, rightHalfPos.y, rightHalfPos.z);

      rotate(imageRotateAngle);

      translate(-rightHalf.width*0.8, 0);

      rotate(-angle1, axis1.x, axis1.y, axis1.z);
      rotate(PI+imageRotateAngle);
      translate(-leftHalf.width, -leftHalf.height, 0);
      leftP.draw(leftHalf);
      popMatrix();


      if (angle>0.5 && angle1<2.0) {
        startToFlyAway=true;
        rightP.setRotVel(3);
        leftP.setRotVel(-3);
        rightP.setPosVel(new PVector(-5, 5, 0));
        leftP.setPosVel(new PVector(5, 5, 0));
      }
      else {
        startToFlyAway=false;
      }
    }
    //if we are flying away then...
    else {


      //RIGHT HALF
      pushMatrix();
      //get the dot and cross products
      //angle = acos(imageOrientation.dot(leftHand));
      // axis = imageOrientation.cross(leftHand);
      //translate to the place we want to draw the image
      translate(rightHalfPos.x+rightP.pos.x, rightHalfPos.y+rightP.pos.y, rightHalfPos.z);
      translate(-rightHalf.width*0.5, -rightHalf.height, 0);
      //translate rotation point to bottom left of image
      translate(0, rightHalf.height, 0);
      //rotate by joint orientation of forearm
      rotate(angle, axis.x, axis.y, -axis.z);
      //rotate by easel angle
      rotate(imageRotateAngle);
      //translate back up to draw
      translate(-rightHalf.width*0.2, -rightHalf.height, 0);
      rightP.drawWithoutTranslation(rightHalf);
      popMatrix();

      rightHand.sub(rightElbow);
      rightHand.normalize();


      //LEFT HALF
      pushMatrix();
      //get the dot and cross products
      //angle1 = acos(imageOrientation.dot(rightHand));
      //axis1 = imageOrientation.cross(rightHand);
      //translate to the place we want to draw the image
      translate(leftHalfPos.x+leftP.pos.x, leftHalfPos.y+leftP.pos.y, leftHalfPos.z);
      translate(-leftHalf.width*0.5, -leftHalf.height, 0);
      //translate rotation point to bottom left of image
      translate(0, leftHalf.height, 0);
      //rotate by joint orientation of forearm
      rotate(-angle1, axis1.x, axis1.y, axis1.z);
      //rotate by easel angle
      rotate(PI+imageRotateAngle);
      //translate back up to draw
      translate(-leftHalf.width, -leftHalf.height, 0);
      leftP.drawWithoutTranslation(leftHalf);
      popMatrix();
    }
    //}
    drawMaskedUser();
  }
  void onEnd() {
    try {
      player.close();
    }
    catch (Exception e) {
    }
  }
};


//SCENE 3 IS IT OLD IS IT NEW? fades an image from 'sepia' to colour with distance between hands //TODO cut around sepia image!
class Scene_fade_in_colour extends TSSceneBase {
  PImage easel = loadImage("celine/easel.png");
  PImage picture = loadImage("celine/skyscraper1.png");
  PImage sepia = loadImage("celine/skyscraper1.png");
  int imageWidth=150;
  int imageHeight=262;
  float angle;
  Scene_fade_in_colour() {
    sceneName = "Scene3 FADE IN COLOUR";
    //println(storyName + "::" + sceneName + "::onStart");
    sepia.filter(GRAY);
    picture.resize(imageWidth, imageHeight);
    sepia.resize(imageWidth, imageHeight);
    easel.resize(int(2.2*imageWidth), int(2.8*imageHeight));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_fade_in_colour::onStart");

    angle=0;

    player = minim.loadFile("celine/projectors.mp3");
    player.loop();

    //player1.close();
    player1 = minim.loadFile("celine/phonetones.mp3");
    player1.loop();
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    pushStyle();

    PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.65, 0));

    //get the distance between hands
    float distBetweenHands = dist( rightHand.x, rightHand.y, leftHand.x, leftHand.y);
    //this is an estimate, empiracly obtained
    float maxDist= 300;
    //the alpha value 
    float alp =  map(distBetweenHands, 0, maxDist, 0.0, 255);
    //draw the colour image under the sepia one - we are going to make the top layer semi-transparent
    image(easel, picturePos.x- (easel.width*0.85), picturePos.y-(easel.height*0.66));


    pushMatrix();


    imageMode(CENTER);
    translate(picturePos.x, picturePos.y, picturePos.z);
    rotate(imageRotateAngle);
    float sW=imageWidth*0.5;
    float sH=imageHeight*0.5;

    translate(-imageWidth*0.5, -imageHeight*0.5);

    image(picture, 0, 0, sW, sH);

    //tint a sepia -ish colour
    tint(232, 222, 48, alp);
    sepia.loadPixels();
    for (int i=0;i<sepia.pixels.length;i++) {
      sepia.pixels[i]=color(red(sepia.pixels[i]), green(sepia.pixels[i] ), blue( sepia.pixels[i] ), alp ) ;
    }
    sepia.updatePixels();

    image(sepia, 0, 0, sW, sH);
    popMatrix();

    popStyle();

    float volume1 = map(distBetweenHands, 0, maxDist, -80.0, -13.9794);
    float volume2 = map(distBetweenHands, 0, maxDist, -13.9794, -80.0);
    volume1=constrain(volume1, -80.0, -13.9794);
    volume2=constrain(volume2, -80.0, -13.9794);
    player.setGain(volume1);
    player1.setGain(volume2);

    println(volume1+" "+volume2);
    drawMaskedUser();
  }
  void onEnd() {
    try {
      player.close();
    }
    catch (Exception e) {
    }
    try {
      player1.close();
    }
    catch (Exception e) {
    }
  }
};

//SCENE 4controls size of image with distance between hands
class Scene_shrink_grow_image extends TSSceneBase {
  PImage easel = loadImage("celine/easel.png");
  PImage picture = loadImage("celine/skyscraper1.png");
  int imageWidth=150;
  int imageHeight=262;

  Scene_shrink_grow_image() {
    sceneName = "Scene4 SHRINK AND GROW IMAGE";

    //println(storyName + "::" + sceneName + "::onStart");
    picture.resize(imageWidth, imageHeight);
    easel.resize(int(2.2*imageWidth), int(2.8*imageHeight));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_shrink_grow_image::onStart");

    //player.close();
    player = minim.loadFile("celine/zoom-loop.mp3");
    player.loop();
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {
    //imageMode(CORNER);
    PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.65, 0));
    //PVector easelPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.2, 0.5, 0));

    float distBetweenHands = dist( rightHand.x, rightHand.y, leftHand.x, leftHand.y);
    float maxDist= 300;
    //scale the image according to the mapped distance between hands
    float imageScale =map(distBetweenHands, 0, maxDist, 0.0, 1);
    imageScale = constrain(imageScale, 0.0, 1.0);
    image(easel, picturePos.x- (easel.width*0.85), picturePos.y-(easel.height*0.66));



    pushMatrix();
    translate(picturePos.x, picturePos.y );
    rotate(imageRotateAngle);
    translate(-(0.5* picture.width), 0);//picturePos.y + (0.2* picture.width));
    translate( -(0.5*imageScale*picture.width), -picture.height*imageScale  );
    image(picture, 0, 0, picture.width*imageScale, picture.height*imageScale );
    popMatrix();
    drawMaskedUser();
  }
  void onEnd() {
    try {
      player.close();
    }
    catch (Exception e) {
    }
  }
};


//SCENE 5 TURN CARDS controls size of image with distance between hands
class Scene_turn_cards extends TSSceneBase {

  Card [] cards;
  int [] timers;
  int numCards=8;
  int pWhichHand;
  int whichHand=0;
  Scene_turn_cards() {
    sceneName = "Scene5 TURN CARDS";

    //println(storyName + "::" + sceneName + "::onStart");
    cards= new Card[numCards];
    //TODO -replace with card images
    int index=1;
    for (int i=0;i<cards.length;i++) {
      //TODO update to use back of image file names
      cards[i] = new Card( 120, 200, "celine/playingcards"+str(index)+".png", "celine/back"+str(index)+".png" );
      index++;
      if (index>=5) {
        index=1;
      }
    }
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_turn_cards::onStart");
    //player.close();
    player = minim.loadFile("celine/cardflick-a.mp3");
    pWhichHand=0;
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);

    int x=0;
    int y=0;

    boolean aHandIsOver=false;

    //TO DO move setPos into constructor 
    for (int i=0;i<cards.length;i++) {
      float interval = width / 5;// (1+(cards.length/2));
      PVector picturePos=  new PVector(interval+ (interval*x)-60, y*(height/2), 0  );//     transform2D.getWorldCoordsForInputNorm(new PVector(0.2+(0.2*x), 0.5*y, 0));

      cards[i].setPos(picturePos);
      cards[i].check(leftHand);
      cards[i].draw();

      if (cards[i].handIsOverCard(leftHand)) {
        aHandIsOver=true;
        whichHand=i;
      }
      x++;
      if (x>=4) {
        x=0;
        y++;
      }
    }
    if (aHandIsOver && pWhichHand!=whichHand) {
      player.rewind();
    }
    if (aHandIsOver) {
      player.play();
    }
    pWhichHand=whichHand;
    //scale the image according to the mapped distance between hands
    drawMaskedUser();
  }
  void onEnd() {
    try {
      player.close();
    }
    catch (Exception e) {
    }
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

//SCENE 6 flick through images with left hand
class Scene_flick_through_images extends TSSceneBase {
  int numImages=6;
  PImage [] images = new PImage[numImages];

  int imageWidth = 400;
  int frameIndex=0;
  int topImageXShift=0;
  int timeOutThresh=30;
  int counter=timeOutThresh+1;
  boolean firstTime=true;
  Scene_flick_through_images() {
    //println(storyName + "::" + sceneName + "::onStart");
    images[0]=loadImage("celine/house.png");
    images[1]=loadImage("celine/bubbles.png");
    images[2]=loadImage("celine/banker.png");
    images[3]=loadImage("celine/beach.png");
    images[4]=loadImage("celine/atm.png");
    images[5]=loadImage("celine/money.png");

    for (int i=0;i<numImages;i++) {
      //get the longest dimension
      //if its wider than it is tall
      float proportion = images[i].width/images[i].height;
      images[i].resize (imageWidth, int( images[i].height * proportion) );
    }
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    sceneName = "Scene6 FLICK THROUGH IMAGES";

    println("Celine::Scene_flickBook::onStart");
    for (int i=0;i<numImages;i++) {
      //images[i].resize(imageWidth, imageHeight);
    }
    topImageXShift=0;
    //player.close();
    //TODO replace with single hit thing when ed has made it
    player = minim.loadFile("celine/whyisitinteresting.mp3");
    player.loop();
  }
  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.1, 0));

    image(images[frameIndex], picturePos.x, picturePos.y);
    // text("BLAH BALH ",picturePos.x+(images[frameIndex].width/2), picturePos.y+(images[frameIndex].height/2));
    PImage topImage;
    PImage refImage;
    if (frameIndex<images.length-1) {
      topImage =images[frameIndex+1].get(0, 0, topImageXShift, height);
      refImage = images[frameIndex+1];
    }
    else {
      topImage =images[0].get(0, 0, topImageXShift, height);
      refImage = images[0];
    }
    //println(frameIndex+" "+images.length);
    image(topImage, picturePos.x+refImage.width-topImageXShift, picturePos.y);

    float thresh=0.01;

    //if the left hand is moving to the right and its a little while since we did this...
    if (skeleton.getJointVelocity(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext).x >0+thresh && counter>timeOutThresh) {
      float numSteps= 5.0;
      float speed = refImage.width/numSteps;
      //don't move past the left edge of where we want the image to go
      if (topImageXShift<refImage.width ) {
        topImageXShift+=speed;
      }
      else {
        println("new frame");
        frameIndex++;
        topImageXShift=0;
        counter=0;
      }
    }
    counter++;

    if (frameIndex>=images.length) {
      // frameIndex=0; //
      frameIndex=images.length-1;
    }
    drawMaskedUser();
  }
  void onEnd() {
    try {
      player.close();
    }
    catch (Exception e) {
    }
  }
};

