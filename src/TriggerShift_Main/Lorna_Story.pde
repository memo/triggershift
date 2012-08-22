class LornaStory extends TSStoryBase {

  LornaStory() {
    storyName = "LornaStory";
    println(storyName + "::" + storyName);
    addScene(new Scene_maid());
    addScene(new Scene_Black_White());

    addScene(new Scene_rainbow());

    addScene(new Scene_colour_trees());

    addScene(new Scene_paper_chain());
    addScene(new Scene_reach_for_stars());
  }

  //----------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
  }
}

// switch black and white from one side to the other (directly ripped off from JAmel prison bars
class Scene_Black_White extends TSSceneBase {
  float x1, x2;

  Scene_Black_White() {
    sceneName = "Scene1 black and white";
    //println(storyName + "::" + sceneName);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
    x1 = 0;
    x2 = width;
  }

  //----------------
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    drawMaskedUser();

    pushStyle();
    imageMode(CORNER);
    float h = height;
    float w = width/2;//h / imgBars.height * width;

    x1 += (map(getLeftHand().x, getHip().x - getMaxArmLength()/2, getHip().x, 0, width) - x1) * 0.5;
    x2 += (map(getRightHand().x, getHip().x + getMaxArmLength()/2, getHip().x, width, width) - x2) * 0.5;
    fill(255);
    rect( x1 - w, 0, w, h);
    fill(0);
    rect(x2, 0, w, h);
    popStyle();
  }
};



//SCENE 13 2 HANDS UP ATTACTS STAR PARTICLES
class Scene_reach_for_stars extends TSSceneBase {
  int numStars=20;
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
      stars[i]= new StarParticle(new PVector(random(width), random(height/2)), new PVector (0, 0, 0), random(TWO_PI), 0, random(20, 30));
    }
    startAttract=false;
    println("Lorna::Scene_reach_for_stars::onStart");
    amt=0.0;
    //player.close();
    //player = minim.loadFile("LORNA/question.mp3");
    //player.loop();
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
};


// secne 6 leave paper cutout people
class Scene_paper_chain extends TSSceneBase {
  int numPeople=16;
  PImage [] chain = new PImage[numPeople];
  ArrayList pChain;
  boolean chainHasStarted;
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
    pChain=new ArrayList();
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
      chainHasStarted=true;
    }
    if (dist(rightHand.x, rightHand.y, leftHand.x, leftHand.y)>maxThresh) {
      chainHasStarted=false;
      fall=true;
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
  }
};

// Scene 5 hand (or maybe later crayon) colours background from b and white to colour
class Scene_colour_trees extends TSSceneBase {

  PImage colourTrees = loadImage("lorna/treescolour.png");
  PImage bandwTrees = loadImage("lorna/treesbw.png");

  int imageWidth=width;
  int imageHeight=height;

  Scene_colour_trees() {
    sceneName = "Scene5 colour trees";
    //println(storyName + "::" + sceneName);
    colourTrees.resize(imageWidth, imageHeight);
    bandwTrees.resize(imageWidth, imageHeight);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
  }

  //----------------
  void onDraw(PImage userImage, TSSkeleton skeleton) {

    pushStyle();

    //if hand is over one image
    PVector leftHand=getLeftHand();
    PVector rightHand=getRightHand();

    colourTrees.loadPixels();
    bandwTrees.loadPixels();
    int radius=40;
    int x=0;
    int y=0;

    //TODO optimise this 
    for (int i=0;i<colourTrees.pixels.length;i++) {
      //get pixels around it in a radius from colour image
      if (dist(x, y, leftHand.x, leftHand.y  )<radius || dist(x, y, rightHand.x, rightHand.y  )<radius) {
        //write into bandw image with colour data 
        bandwTrees.pixels[i] = colourTrees.pixels[i];
      }
      x++;
      if (x>=colourTrees.width) {
        x=0;
        y++;
      }
    }
    colourTrees.updatePixels();
    bandwTrees.updatePixels();

    image(bandwTrees, 0, 0);
    popStyle();
    drawMaskedUser();
  }
};


// Scene 11 rainbow 
class Scene_rainbow extends TSSceneBase {

  PImage rainbow = loadImage("lorna/rainbow.png");

  int imageWidth=500;
  int imageHeight=300;
  boolean handsOverHead;
  Scene_rainbow() {
    sceneName = "Scene5 colour trees";
    //println(storyName + "::" + sceneName);
    rainbow.resize(imageWidth, imageHeight);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
    handsOverHead=false;
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
};


// Scene 5 hand (or maybe later crayon) colours background from b and white to colour
class Scene_maid extends TSSceneBase {

  PImage maid = loadImage("lorna/maidsoutfit.png");
   PImage hat = loadImage("lorna/maidscap.png");

  int imageWidth=width;
  int imageHeight=height;

  Scene_maid() {
    sceneName = "Scene5 maid";
    //println(storyName + "::" + sceneName);
    //maid.resize(imageWidth, imageHeight);
  }

  //----------------
  void onStart() {
    //println(storyName + "::" + sceneName + "::onStart");
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
    PVector leftShoulder=getLeftShoulder();
    PVector rightShoulder=getRightShoulder();
    
   
    float h =1.5* ( waist.y-head.y);
    float w=2*( rightShoulder.x-leftShoulder.x );
     println(h+" "+w);
    image(maid,leftShoulder.x - (0.25*w), leftShoulder.y -(0.1*h), w, h);
    //TODO optimise this 


    popStyle();
  }
};

