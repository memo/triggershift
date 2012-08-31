class LornaStory extends TSStoryBase {
  //TODO paper mens start audio on touch  TODO 
  LornaStory() {
    storyName = "LornaStory";
    println(storyName + "::" + storyName);

    addScene(new Scene_Black_White());
    addScene(new Scene_Think_Straight());
    addScene(new Scene_maid());
    addScene(new Scene_colour_trees());
    addScene(new Scene_paper_chain());
    addScene(new Scene_dream());
    addScene(new Scene_reality());
    addScene(new Scene_rainbow());
    addScene(new Scene_shadow());
    addScene(new Scene_reach_for_stars());

    storyPlayer = minim.loadFile("lorna/lorna-melody-new.mp3");
    storyPlayer.loop();
  }

  //----------------------------------
}

// switch black and white from one side to the other (directly ripped off from JAmel prison bars
class Scene_Black_White extends TSSceneBase {
  float x1, x2;
  float maxArm;
  boolean lock;
  //TODO make the volume a base level and increase when arms are crossed
  Scene_Black_White() {
    sceneName = "Scene1 black and white";
    //println(storyName + "::" + sceneName);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
    x1 = 0;
    x2 = width;
    player = minim.loadFile("lorna/super8-loop.mp3");
    maxArm = getMaxArmLength();
    lock = false;
  }

  //----------------
  void onDraw(PImage userImage, TSSkeleton skeleton) {

    pushStyle();
    imageMode(CORNER);
    noStroke();
    float h = height;
    float w = width/2;//h / imgBars.height * width;

    //  x1 += (map(getLeftHand().x, getHip().x - getMaxArmLength()/2, getHip().x, 0, width) - x1) * 0.5;
    //  x2 += (map(getRightHand().x, getHip().x + getMaxArmLength()/2, getHip().x, width, 0) - x2) * 0.5;
    float leftExtent = getLeftHand().x - getHip().x;
    float rightExtent = getRightHand().x - getHip().x;
    x1=  map(leftExtent, 0, maxArm/2, 0, width);
    x2=  map(rightExtent, 0, maxArm/2, 0, width);
    int thresh=30;
    if (getLeftHand().x > getRightHand().x ) {

      player.play();
      lock =true;
    }

    stroke(255);
    strokeWeight(3);
    fill(0);
    rect(x2, 0, w, h);
    noStroke();
    fill(255);
    rect( x1, 0, w, h);
    popStyle();
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

// SCENE 2 can't think straight
class Scene_Think_Straight extends TSSceneBase {
  float x1, x2;
  int imageWidth=500;
  int imageHeight=300;
  boolean handsOverHead;
  boolean lock;
  //TODO add 2 audio samples straight and bent when ed makes them

  Scene_Think_Straight() {
    sceneName = "Scene1 think straight";
    //println(storyName + "::" + sceneName);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
    x1 = 0;
    x2 = width;
    //player.close();
    player = minim.loadFile("lorna/thinkstraight_sine.mp3");
    player.loop();
    handsOverHead=false;
    lock=false;
  }

  //----------------
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    stroke(0, 0, 255);
    strokeWeight(10);
    noFill();
    pushStyle();

    //if hand is over one image
    PVector leftHand=getLeftHand();
    PVector rightHand=getRightHand();
    PVector head=getHead();
    PVector leftShoulder=getLeftShoulder();
    PVector rightShoulder=getRightShoulder();

    if (rightHand.y < head.y && leftHand.y <head.y) {
      handsOverHead=true;
      if (!lock) {
        player.close();
        player = minim.loadFile("lorna/thinkstraight_wobbly.mp3");
        player.loop();
        lock=true;
      }
    }
    if (handsOverHead) {
      //draw triangular mask over left shoulder
      float hyp=imageHeight+imageWidth;
      //get angle between shoulder and hand
      float angle = atan2( leftHand.y-leftShoulder.y, leftHand.x - leftShoulder.x );
      pushMatrix();
      translate( leftShoulder.x, leftShoulder.y);
      rotate(angle);
      // noStroke();
      //SOHCAHTOA


      int numPoints = 10;
      beginShape();
      float x =0;
      float y=20;
      for (int i=0;i<numPoints;i++) {
        curveVertex(x, y);
        y*=-1;
        x+=hyp/numPoints;
      }
      endShape();
      popMatrix();
      //get angle between shoulder and hand
      angle = atan2( rightHand.y-rightShoulder.y, rightHand.x - rightShoulder.x );
      pushMatrix();
      translate( rightShoulder.x, rightShoulder.y);
      rotate(angle);

      beginShape();
      x =0;
      y=20;
      for (int i=0;i<numPoints;i++) {
        curveVertex(x, y);
        y*=-1;
        x+=hyp/numPoints;
      }
      endShape();

      popMatrix();
      popStyle();
    }
    //draw straight
    else {

      //draw triangular mask over left shoulder
      float hyp=imageHeight+imageWidth;
      //get angle between shoulder and hand
      float angle = atan2( leftHand.y-leftShoulder.y, leftHand.x - leftShoulder.x );
      pushMatrix();
      translate( leftShoulder.x, leftShoulder.y);
      // noStroke();
      //SOHCAHTOA

      float x=hyp*cos(angle);
      float y=hyp*sin  (angle);

      line(0, 0, x, y);

      popMatrix();


      //draw triangular mask over right shoulder
      //get angle between shoulder and hand
      angle = atan2( rightHand.y-rightShoulder.y, rightHand.x - rightShoulder.x );
      pushMatrix();
      translate( rightShoulder.x, rightShoulder.y);
      x=hyp*cos(angle);
      y=hyp*sin  (angle);
      line(0, 0, x, y);

      popMatrix();
      popStyle();
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



// Scene 5 hand (or maybe later crayon) colours background from b and white to colour
class Scene_maid extends TSSceneBase {

  PImage maid = loadImage("lorna/maidsoutfit.png");
  PImage cap = loadImage("lorna/maidscap.png");
  PImage duster = loadImage("lorna/featherduster.png");

  int imageWidth=80;
  int imageHeight=200;
  Scene_maid() {
    sceneName = "Scene5 maid";
    //println(storyName + "::" + sceneName);
    duster.resize(imageWidth, imageHeight);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
    //player.close();
    //possible switch to brush =sing triggered by sweepin gesture
    player = minim.loadFile("lorna/brushing.mp3");
    player.loop();
  }

  //----------------
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    drawMaskedUser();

    pushStyle();

    //if hand is over one image
    PVector leftHand=getLeftHand();
    PVector rightHand=getRightHand();
    PVector head = getHead();
    PVector waist = getHip();
    PVector leftElbow=getLeftElbow();
    PVector leftShoulder=getLeftShoulder();

    PVector rightShoulder=getRightShoulder();

    float rot = atan2(waist.y- head.y, waist.x-head.x );
    float h =1.5* ( waist.y-head.y);
    float w=2*( rightShoulder.x-leftShoulder.x );
    //image(maid, leftShoulder.x - (0.25*w), leftShoulder.y -(0.1*h), w, h);
    //TODO optimise this 


    //DRAW MAID BODY
    pushMatrix();
    imageMode(CENTER);
    translate(waist.x, waist.y);
    rotate(rot-(0.5*PI)  );
    image(maid, 0, 0, w, h);
    popMatrix();

    //DRAW CAP
    pushMatrix();

    float cw=0.7*(rightShoulder.x-leftShoulder.x  );
    float ch =cw/2;
    translate(head.x, head.y-(0.4*cap.height));
    image(cap, 0, 0, cw, ch);
    popMatrix();
    pushMatrix();
    imageMode(CORNER);

    float angle = atan2( leftHand.y-leftElbow.y, leftHand.x - leftElbow.x );
    translate(leftHand.x, leftHand.y);
    rotate(angle);
    image(duster, 0, 0);

    popMatrix();

    popStyle();
  }
  void onEnd() {
    try {
      player.close();
    }
    catch (Exception e) {
    }
  }
};

// Scene 5 hand (or maybe later crayon) colours background from b and white to colour
class Scene_colour_trees extends TSSceneBase {

  PImage colourTrees = loadImage("lorna/treescolour.png");
  PImage bandwTrees = loadImage("lorna/treesbw.png");
  PImage source = createImage(width, height, ARGB);
  PImage target = createImage(width, height, ARGB);
  PImage crayon = loadImage("lorna/crayon.png");
  int imageWidth=width;
  int imageHeight=height;

  Scene_colour_trees() {
    sceneName = "Scene5 colour trees";
    //println(storyName + "::" + sceneName);
    // colourTrees.resize(imageWidth, imageHeight);
    // bandwTrees.resize(imageWidth, imageHeight);
    float crayonLength=300;
    crayon.resize(int(crayonLength/5), int(crayonLength));
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
    //player.close();
    player = minim.loadFile("lorna/crayon chalk.mp3");
    player.loop();

    source.copy(colourTrees, 0, 0, colourTrees.width, colourTrees.height, 0, 0, width, height);
    target.copy(bandwTrees, 0, 0, colourTrees.width, colourTrees.height, 0, 0, width, height);
  }

  //----------------
  void onDraw(PImage userImage, TSSkeleton skeleton) {

    pushStyle();



    //if hand is over one image
    PVector leftHand=getLeftHand();
    PVector rightHand=getRightHand();

    source.loadPixels();
    target.loadPixels();
    int radius=40;
    int x=0;
    int y=0;

    ArrayList indices = new ArrayList();
    float thresh=0.01;
    imageMode(CENTER);

    //get pos of end of crayon



   

    //TODO optimise this 
    int boxSize=2*radius;
    int startPosX =int(leftHand.x - boxSize);
    int endPosX =int(leftHand.x + boxSize);
    int startPosY =int(leftHand.y- boxSize);
    int endPosY =int(leftHand.y + boxSize);
    for (int x1=startPosX; x1<endPosX; x1++) {
      for (int y1=startPosY; y1<endPosY; y1++) {

        int index = x1+ (source.width*y1);
        if (index< target.pixels.length &&index>0 ) {
          if (dist(x1, y1, leftHand.x, leftHand.y  )<radius) {
            //write into bandw image with colour data 
            target.pixels[index] = source.pixels[index];
          }
        }
      }
    }


    source.updatePixels();
    target.updatePixels();
    
     
    imageMode(CORNER);

    image(target, 0, 0, imageWidth, imageHeight);
    
    imageMode(CENTER);
    //image(crayon, leftHand.x, leftHand.y);
    popStyle();
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


// secne 6 leave paper cutout people
class Scene_paper_chain extends TSSceneBase {
  int numPeople=16;
  PImage [] chain = new PImage[numPeople];
  ArrayList pChain;
  boolean chainHasStarted;
  boolean isTouching;
  boolean pIsTouching;
  int touchCount;
  boolean chainExists;
  boolean fall;
  int imageWidth=60;
  int imageHeight=80;
  Scene_paper_chain() {
    sceneName = "Scene6 paper chain";
    //println(storyName + "::" + sceneName);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
    for (int i=0;i<chain.length;i++) {
      chain[i]=loadImage("lorna/paperfigure"+str(i+1)+".png");
      chain[i].resize(imageWidth, imageHeight);
    }
    chainHasStarted=false;
    chainExists=false;
    fall=false;
    touchCount=0;
    pChain=new ArrayList();
    //player.close();
    player = minim.loadFile("lorna/paper crumple loop-LITE.mp3");
    player.loop();
    player.pause();
  }

  //----------------
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    drawMaskedUser();

    PVector rightHand=getRightHand();
    PVector leftHand=getLeftHand();

    int minThresh=40;
    int maxThresh=500;

    pushStyle();
    if (dist(rightHand.x, rightHand.y, leftHand.x, leftHand.y)<minThresh) {
      isTouching=true;
    }
    else {
      isTouching=false;
    }
    //if the state has changed and hands are together
    if (isTouching!=pIsTouching && isTouching) {
      chainHasStarted=true;
      touchCount++;
      // player.rewind();
      player.loop();
      //if this is the second touch make the particles fall and restart everything
      if (touchCount>=2) {
        fall=true;
        chainHasStarted=false;
        touchCount=0;
        player.pause();
      }
    }

    if (fall) {
      for (int i=0;i<pChain.size();i++) {
        ShardParticle pchain=(ShardParticle) pChain.get(i);
        pchain.setPosVel(new PVector (random(-3, 3), 5, 0));
        pchain.setRotVel(random(-3, 3));
      }
      fall=false;
    }

    if (chainHasStarted) {
      chainExists=true;
      PVector vel = new PVector(0, 0, 0);
      ShardParticle chainP1=new ShardParticle(rightHand, vel, 0, 0, 20, 1.0, 1.0, 0.98);
      chainP1.setImageIndex(int(random(numPeople-1)));
      ShardParticle chainP2=new ShardParticle(leftHand, vel, 0, 0, 20, 1.0, 1.0, 0.98);
      chainP2.setImageIndex(int(random(numPeople-1)));
      pChain.add(chainP1);
      pChain.add(chainP2);
    }
    if (chainExists) {
      for (int i=0;i<pChain.size();i++) {
        ShardParticle pchain=(ShardParticle) pChain.get(i);
        pchain.draw( chain[pchain.imageIndex]  );
      }
    }

    //remove far away particles
    for (int i=0;i<pChain.size();i++) {
      ShardParticle pchain=(ShardParticle) pChain.get(i);
      if (dist(pchain.pos.x, pchain.pos.y, leftHand.x, leftHand.y)>maxThresh) {
        pChain.remove(i);
      }
    }
    popStyle();
    isTouching=pIsTouching;
  }
  void onEnd() {
    try {
      player.close();
    }
    catch (Exception e) {
    }
  }
};



// Scene 11 rainbow 
class Scene_rainbow extends TSSceneBase {

  PImage rainbow = loadImage("lorna/rainbow.png");

  int imageWidth=500;
  int imageHeight=300;
  boolean handsOverHead;
  boolean lock;
  Scene_rainbow() {
    sceneName = "Scene5 colour trees";
    //println(storyName + "::" + sceneName);
    rainbow.resize(imageWidth, imageHeight);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
    handsOverHead=false;
    //player.close();
    lock=false;
    player = minim.loadFile("lorna/rainbow.mp3");
  }

  //----------------
  void onDraw(PImage userImage, TSSkeleton skeleton) {



    pushStyle();

    //if hand is over one image
    PVector leftHand=getLeftHand();
    PVector rightHand=getRightHand();
    PVector head=getHead();
    PVector leftShoulder=getLeftShoulder();
    PVector rightShoulder=getRightShoulder();

    if (rightHand.y < head.y && leftHand.y <head.y) {
      handsOverHead=true;
    }
    if (handsOverHead) {
      if (!lock) {
        player.play();
        lock=true;
      }
      image( rainbow, head.x- (0.5*rainbow.width), head.y- (0.8*rainbow.height) );
      //draw triangular mask over left shoulder
      float hyp=imageHeight+imageWidth;
      //get angle between shoulder and hand
      float angle = atan2( leftHand.y-leftShoulder.y, leftHand.x - leftShoulder.x );
      pushMatrix();
      translate( leftShoulder.x, leftShoulder.y);
      float x=hyp*cos(angle);
      float y=hyp*sin  (angle);
      //line(0,0,x,y);
      noStroke();
      //SOHCAHTOA
      fill(0);
      beginShape();
      vertex(0, 0);
      vertex(x, y);
      vertex(-imageWidth, 0);
      vertex(0, 0);
      endShape();
      popMatrix();


      //draw triangular mask over right shoulder
      //get angle between shoulder and hand
      angle = atan2( rightHand.y-rightShoulder.y, rightHand.x - rightShoulder.x );
      pushMatrix();
      translate( rightShoulder.x, rightShoulder.y);
      x=hyp*cos(angle);
      y=hyp*sin  (angle);
      //line(0,0,x,y);
      noStroke();
      //SOHCAHTOA
      fill(0);
      beginShape();
      vertex(0, 0);
      vertex(x, y);
      vertex(imageWidth, 0);
      vertex(0, 0);
      endShape();
      popMatrix();
      popStyle();
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


// Scene 7
class Scene_dream extends TSSceneBase {

  PImage bubbles = loadImage("lorna/thoughtbubble.png");
  boolean dreamStarted;

  int imageWidth=300;
  int imageHeight=200;
  float wScale=0.0;
  float hScale=0.0;
  boolean lock;
  Scene_dream() {
    sceneName = "Scene7 bubbles";
    //println(storyName + "::" + sceneName);
    bubbles.resize(imageWidth, imageHeight);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
    //player.close();
    player = minim.loadFile("lorna/bubbles.mp3");

    dreamStarted=false;
    lock=false;
  }

  //----------------
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    drawMaskedUser();
    PVector head = getHead();
    PVector rightHand=getRightHand();

    pushStyle();
    pushMatrix();
    int thresh =80;
    //start dream by touching head
    if (dist(head.x, head.y, rightHand.x, rightHand.y)<thresh) dreamStarted = true;
    if (dreamStarted) {
      if (!lock) {
        player.play();
        lock=true;
      }
      image(bubbles, head.x, head.y-(bubbles.height * hScale), bubbles.width * wScale, bubbles.height * hScale);

      if (hScale<=1.0) {
        hScale+=0.05;
        wScale+=0.05;
      }
    }
    popMatrix();
    popStyle();
  }
  void onEnd() {
    try {
      player.close();
    }
    catch (Exception e) {
    }
  }
};


// Scene 10
class Scene_reality extends TSSceneBase {

  PImage bubbles = loadImage("lorna/thoughtbubble.png");
  boolean dreamStarted;

  int imageWidth=300;
  int imageHeight=200;
  float wScale=1.0;
  float hScale=1.0;
  float alpha;
  boolean isPopped;
  boolean lock;
  Scene_reality() {
    sceneName = "Scene7 reality";
    //println(storyName + "::" + sceneName);
    bubbles.resize(imageWidth, imageHeight);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
    player = minim.loadFile("lorna/wipeclouds.mp3");
    lock=false;
    alpha=255;
    isPopped=false;
  }

  //----------------
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    drawMaskedUser();
    PVector head = getHead();
    PVector rightHand=getRightHand();
    PVector centreOfImage= new PVector ( head.x +(bubbles.width*0.5), head.y -(bubbles.height*0.5));

    int thresh=50;
    if (dist(centreOfImage.x, centreOfImage.y, rightHand.x, rightHand.y )<thresh) isPopped=true;
    if (isPopped&&!lock) {
      player.play();
      lock=true;
    }
    pushStyle();
    pushMatrix();
    tint(255, alpha);
    image(bubbles, head.x, head.y-(bubbles.height), bubbles.width * wScale, bubbles.height);

    if (isPopped &&alpha>=0) alpha-=10;
    
    popMatrix();
    popStyle();
  }
  void onEnd() {
    player.close();
  }
};


class Scene_shadow extends TSSceneBase {

  PImage bubbles = loadImage("lorna/thoughtbubble.png");
  boolean dreamStarted;

  int imageWidth=300;
  int imageHeight=200;
  float wScale=1.0;
  float hScale=1.0;
  float alpha;
  boolean isShadow;
  boolean lock;
  Scene_shadow() {
    sceneName = "Scene7 shadow";
    //println(storyName + "::" + sceneName);
    bubbles.resize(imageWidth, imageHeight);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
    isShadow=false;
    alpha=0;
    lock=false;
    player =minim.loadFile("lorna/minorchord.mp3");
  }

  //----------------
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector head = getHead();

    if (head.x>width/2) {
      isShadow=true;
      if (!lock) {
        player.play(); 
        lock=true;
      }
    }

    if (!isShadow) {
      drawMaskedUser();
    }
    else {

      drawUserDepthPlane();
      fill(0);
      //tint(0, alpha);
      //rect(0,0,width,height);
      alpha+=2;
    }
    pushStyle();
    pushMatrix();

    popMatrix();
    popStyle();
  }
  void onEnd() {
    player.close();
  }
};

//SCENE 13 2 HANDS UP ATTACTS STAR PARTICLES
class Scene_reach_for_stars extends TSSceneBase {
  int numStars=30;
  StarParticle[] stars = new StarParticle[numStars];
  boolean startAttract;
  float amt;
  Scene_reach_for_stars() {
    sceneName="scene13 REACH FOR STARS";

    println("Lorna::Scene_reach_for_stars");
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    for (int i=0;i<stars.length;i++) {
      stars[i]= new StarParticle(new PVector(random(width), random(height/2)), new PVector (0, 0, 0), random(TWO_PI), 0, random(3, 10));
    }
    startAttract=false;
    println("Lorna::Scene_reach_for_stars::onStart");
    amt=0.0;
    //player.close();
    player = minim.loadFile("lorna/stars.mp3");
  }
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector head = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_HEAD, transform2D, openNIContext);
    //SKEL_WAIST is not working! 

    //if both arms go above the head start linking the image pos to hands

    if (leftHand.y<head.y && rightHand.y<head.y) startAttract = true;
    drawMaskedUser();
    pushStyle();
    pushMatrix();
    //attract half the stars to the left hand and half to the right
    if (startAttract) {
      player.play();
      for (int i=0;i<stars.length/2;i++) {
        stars[i].update(leftHand, amt);
        if (dist(stars[i].pos.x, stars[i].pos.y, leftHand.x, leftHand.y)<20) {
          stars[i].setAlive(false);
        }
      }
      for (int i=stars.length/2;i<stars.length;i++) {
        stars[i].update(rightHand, amt);
        if (dist(stars[i].pos.x, stars[i].pos.y, rightHand.x, rightHand.y)<20) {
          stars[i].setAlive(false);
        }
      }
      if (amt<1) {
        amt+=0.03;
      }
    }
    for (int i=0;i<stars.length;i++) {

      stars[i].draw();
    }

    popMatrix();
    popStyle();
  }
  void onEnd() {
    try {
      player.close();
    }
    catch (Exception e) {
    }
  }
};

