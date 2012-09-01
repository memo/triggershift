class CelineStory extends TSStoryBase {
  //TODO sound effect are too low - Ed? rip at wrong poitn - old to new is quiet  - page flick for images crashes on exit
  CelineStory() {
    storyName = "The Questioner";
    println(storyName + "::" + storyName);

    //    if (useInstallationMode) {
    //      addScene(new Scene_turn_cards());
    //    }
    //    else {

    addScene(new Scene_big_buildings());
    addScene(new Scene_ripPaper());
    addScene(new Scene_fade_in_colour());
    addScene(new Scene_shrink_grow_image());
    addScene(new Scene_turn_cards());
    addScene(new Scene_flick_through_images());
    //    }
    storyPlayer = minim.loadFile("celine/celine-melody.mp3");
    storyPlayer.loop();
  }

  ///SCENE 1
  class Scene_big_buildings extends TSSceneBase {
    PImage easel = loadImage("celine/easel.png");
    PImage picture = loadImage("celine/skyscraper1.png");  
    int imageWidth=150;
    int imageHeight=262;
    PVector picturePos = new PVector(0.3 * width, 0.65 * height, 0);//transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.65, 0));

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

    void onDraw() {
      image(easel, picturePos.x- (easel.width*0.85), picturePos.y-(easel.height*0.66));  // FIX
      pushMatrix();
      translate(picturePos.x, picturePos.y); // FIX

      rotate(imageRotateAngle);
      translate(-picture.width, -picture.height);

      image(picture, 0, 0);
      popMatrix();
      //drawMaskedUser();
    }
    void onEnd() {
    }
  };

  //SCENE 2
  class Scene_ripPaper extends TSSceneBase {
    PImage easel = loadImage("celine/easel.png");
    //the picture underneath
    PImage picture = loadImage("celine/skyscraper1.png");
    PImage bigPicture = loadImage("celine/skyscraper1.png");
    PImage leftHalf = loadImage("celine/left.png");
    PImage rightHalf= loadImage("celine/right.png");

    ShardParticle leftP;
    ShardParticle rightP;

    boolean lock;

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
    PVector rightHalfPos = new PVector(0.3 * width, 0.65 * height, 0);//transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.65, 0));

    PVector picturePos = new PVector(0.3 * width, 0.65 * height, 0);//transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.65, 0));

    PVector  leftHalfPos= new PVector(rightHalfPos.x, rightHalfPos.y, rightHalfPos.z) ;
    PVector axis;
    PVector axis1;
    float yPos;
    Scene_ripPaper() {
      sceneName = "Scene2 RIP PAPER";
      //println(storyName + "::" + sceneName + "::onStart");
      leftHalf.resize(imageWidth/2, imageHeight);
      rightHalf.resize(imageWidth/2, imageHeight);
      easel.resize(int(2.2*imageWidth), int(2.8*imageHeight));
      bigPicture.resize(imageWidth, imageHeight);
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println("CelineStory::Scene_ripPaper::onStart");

      lock = false;
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
      yPos=0;
      player = minim.loadFile("celine/rip.mp3");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw() {
      //      println("StoryTest::Scene1::onDraw");      
      //   pushMatrix();
      PVector rightHand = getRightHand();
      PVector rightElbow = getRightElbow();
      PVector leftHand = getLeftHand();
      PVector leftElbow = getLeftElbow();
      PVector head= getHead();
      PVector waist= getHip();
      //draw the easel behind the 2 halves of the image


      float distBetweenHands = dist( rightHand.x, rightHand.y, leftHand.x, leftHand.y);

      if (rightHand.y < head.y) startToFlyAway =true;


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
      //draw small picture
      image(picture, 0, 0, sW, sH);
      pushMatrix();
      image(bigPicture, 0, yPos);

      if (startToFlyAway ) {
        if (!lock) {
          player.play();
          lock=true;
        }
        float maxRange = waist.y-head.y;
        //float newY = map (leftHand.y-head.y, 0, maxRange, (height/2), height+(height/2));
        //yPos = newY;
        // if (newY<height) {
        // }
        yPos+=10;
      }

      popMatrix();
      popMatrix();

      imageMode(CORNER);
      // drawMaskedUser();  //FIX
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

    PImage source = createImage(imageWidth/2, imageHeight/2, ARGB);
    PImage target = createImage(imageWidth/2, imageHeight/2, ARGB);

    float angle;
    MSAAudioPlayer msaPlayer;
    MSAAudioPlayer msaPlayer1;

    Scene_fade_in_colour() {
      sceneName = "Scene3 FADE IN COLOUR";
      //println(storyName + "::" + sceneName + "::onStart");

      source.copy(picture, 0, 0, picture.width, picture.height, 0, 0, imageWidth/2, imageHeight/2);
      target.copy(sepia, 0, 0, sepia.width, sepia.height, 0, 0, imageWidth/2, imageHeight/2);
      target.filter(GRAY);
      // picture.resize(imageWidth, imageHeight);
      // sepia.resize(imageWidth, imageHeight);
      easel.resize(int(2.2*imageWidth), int(2.8*imageHeight));
      //println("finsihed constructor");
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println("CelineStory::Scene_fade_in_colour::onStart");



      angle=0;

      msaPlayer = new MSAAudioPlayer("celine/projectors.mp3");
      msaPlayer.loop();

      //player1.close();
      msaPlayer1 =new MSAAudioPlayer("celine/phonetones.mp3");
      msaPlayer1.loop();
    }

    void onDraw() {

      pushStyle();

      PVector rightHand = getRightHand();// skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
      PVector leftHand = getLeftHand();//skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
      PVector picturePos = new PVector(0.3 * width, 0.65 * height, 0);//transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.65, 0));

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

      image(source, 0, 0, sW, sH);

      //tint a sepia -ish colour
      tint(232, 222, 48, alp);
      target.loadPixels();
      for (int i=0;i<target.pixels.length;i++) {
        target.pixels[i]=color(red(source.pixels[i]), green(source.pixels[i] ), blue( source.pixels[i] ), alp ) ;
      }
      target.updatePixels();

      image(target, 0, 0, sW, sH);
      popMatrix();

      popStyle();

      float volume1 = map(distBetweenHands, 0, maxDist, 0.0, 1.0);
      float volume2 = map(distBetweenHands, 0, maxDist, 0.0, 1.0);
      volume1=constrain(volume1, 0.0, 1.0);
      volume2=constrain(volume2, 0.0, 1.0);
      msaPlayer.setGain(volume1);
      msaPlayer1.setGain(1.0f-volume2);

      //  drawMaskedUser(); //FIX
    }
    void onEnd() {
      msaPlayer.close();
      msaPlayer1.close();
    }
  };

  //SCENE 4controls size of image with distance between hands
  class Scene_shrink_grow_image extends TSSceneBase {
    PImage easel = loadImage("celine/easel.png");
    PImage picture = loadImage("celine/skyscraper1.png");
    int imageWidth=150;
    int imageHeight=262;
    MSAAudioPlayer msaPlayer;

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
      msaPlayer = new MSAAudioPlayer("celine/zoom-loop.mp3");
      msaPlayer.loop();
    }

    void onDraw() {
      //imageMode(CORNER);
      PVector rightHand = getRightHand();//skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
      PVector leftHand = getLeftHand();//skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
      PVector picturePos = new PVector(0.3 * width, 0.65 * height, 0);//transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.65, 0));
      //PVector easelPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.2, 0.5, 0));

      float distBetweenHands = dist( rightHand.x, rightHand.y, leftHand.x, leftHand.y);
      float maxDist= 300;

      float volume1 = map(distBetweenHands, 0, maxDist, 0.0, 1.0);
      volume1=constrain(volume1, 0.0, 1.0);
      msaPlayer.setGain(volume1);


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
      // drawMaskedUser(); //FIX
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

    void onDraw() {
      // loop all skeletons
      for (int j=0; j<skeletonManager.skeletons.length; j++) {
        TSSkeleton skeleton = skeletonManager.skeletons[j];

        // is skeleton is alive
        if (skeleton.isAlive()) {

          // loop joints (in this case, the hands)
          //for (int k=0; k<SKEL_HANDS.length; k++) {
            
          
            PVector leftHand = skeleton.getJointPos2d(SKEL_LEFT_HAND);//getHighestHand();//skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);

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
         // }
        }
      }
      //scale the image according to the mapped distance between hands
      // drawMaskedUser();  //FIX
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
    int pFrameIndex=0;
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

      frameIndex=0;
      pFrameIndex=0;
      topImageXShift=0;
      counter=timeOutThresh+1;
      boolean firstTime=true;
      //TODO replace with single hit thing when ed has made it
      player = minim.loadFile("celine/page-flick.mp3");
    }
    void onDraw() {

      PVector leftHand = getLeftHand();//skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
      PVector picturePos = new PVector(0.1 * width, 0.1 * height, 0);//transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.1, 0));

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

      float thresh=1.0;//0.01;

      //if the left hand is moving to the right and its a little while since we did this...
      if (-getRightHandVelocity().x >thresh && counter>timeOutThresh) {
        float numSteps= 5.0;
        float speed = refImage.width/numSteps;
        //don't move past the left edge of where we want the image to go
        if (topImageXShift<refImage.width ) {
          topImageXShift+=speed;
        }
        else {
          player.rewind();
          player.play();

          frameIndex++;
          topImageXShift=0;
          counter=0;
        }
      }
      counter++;
      if (pFrameIndex!=frameIndex &&frameIndex==0) {
        //      player.play();
      }
      pFrameIndex=frameIndex;
      if (frameIndex>=images.length) {
        // frameIndex=0; //
        frameIndex=images.length-1;
      }
      //  drawMaskedUser(); //FIX
    }
    void onEnd() {
      try {
        player.close();
      }
      catch (Exception e) {
      }
    }
  }
}

