class CharleneStory extends TSStoryBase {
  //TODO change scene names
  CharleneStory(PApplet ref) {
    storyName = "CharleneStory";
    println(storyName + "::" + storyName);
    addScene(new Scene_flickBook());

    addScene(new Scene_clock_hands());
    addScene(new Scene_throw_coffee(ref));
    addScene(new Scene_mortar_board_on_head());
    addScene(new Scene_zoom_from_space());
    addScene(new Scene_vote_in_box());
    addScene(new Scene_power_hands());
    addScene(new Scene_spin_right_wrong());
    addScene(new Scene_shatter_image());
    addScene(new Scene_drop_set());
  }
}
// SCENE 1
class Scene_flickBook extends TSSceneBase {
  int numPageCells=8;
  PImage [] book = new PImage[numPageCells];


  int imageWidth = 200;
  int imageHeight = 200;
  int frameIndex=0;

  Scene_flickBook() {
    sceneName = "scene1 FLICK THROUGH PAGES";
    println("Charlene::Scene_flickBook");
    for (int i=0;i<numPageCells;i++) {
      book[i]=loadImage("charlene/bookPage_"+str(i)+".png");
    }
    setTrigger(new KeyPressTrigger('w'));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("Charlene::Scene_flickBook::onStart");
    for (int i=0;i<numPageCells;i++) {
      book[i].resize(imageWidth, imageHeight);
    }
  }
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.2, 0));
    image(book[frameIndex], picturePos.x, picturePos.y);

    float thresh=0.01;

    //if the left hand is moving to the right increment the page index
    if (skeleton.getJointVelocity(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext).x >0+thresh) {
      frameIndex++;
    }
    if (frameIndex>=book.length) {
      frameIndex=0; // frameIndex=book.length-1;
    }
  }
};


//SCENE 2Animated clock hands are superimposed over book
class Scene_clock_hands extends TSSceneBase {
  int bookImageWidth = 200;
  int bookImageHeight = 200;
  PImage hourHand=loadImage("charlene/hourHand.png");
  PImage minuteHand=loadImage("charlene/hourHand.png");
  PImage book = loadImage("charlene/bookPage_0.png");
  int imageWidth = 20;
  int imageHeight = 100;
  float angle=0.0;

  Scene_clock_hands() {
    sceneName = "scene2 CLOCK HANDS";

    println("Charlene::Scene_clock_hands");

    hourHand.resize(imageWidth, imageHeight);
    minuteHand.resize(int(0.8*imageWidth), int( 0.6*imageHeight));
    book.resize(bookImageWidth, bookImageHeight);

    setTrigger(new KeyPressTrigger('w'));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("Charlene::Scene_flickBook::onStart");
  }
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.2, 0));
    image(book, picturePos.x, picturePos.y);
    pushMatrix();
    translate(picturePos.x+(0.5*bookImageWidth), picturePos.y+(0.5*bookImageHeight));
    rotate(angle*60.0);
    image(hourHand, -0.5*hourHand.width, -hourHand.height);
    popMatrix();
    pushMatrix();
    translate(picturePos.x+(0.5*bookImageWidth), picturePos.y+(0.5*bookImageHeight));
    rotate(angle);
    image(minuteHand, -0.5*minuteHand.width, -minuteHand.height);
    popMatrix();
    pushStyle();
    fill(0);
    noStroke();
    ellipse(picturePos.x+(0.5*bookImageWidth), picturePos.y+(0.5*bookImageHeight), imageWidth/2, imageWidth/2);
    popStyle();
    angle+=0.005;
  }
};
//SCENE 3 THROW COFFEE
class Scene_throw_coffee extends TSSceneBase {
  FWorld world;
  FMouseJoint joint;
  PApplet ref;
  PImage mug=loadImage("charlene/mugUpright.png");
  PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.01, 0.5, 0));
  int imageWidth;
  int imageHeight;

  PVector startPos;

  //the blobs of coffee
  int  numBlobs= 30;
  String[] words= new String[numBlobs];
  ShardParticle [] blobs = new ShardParticle[numBlobs];
  boolean isThrown;
  boolean lock;
  Scene_throw_coffee(PApplet _ref) {
    sceneName="scene3 THROW COFFEE";
    println("Charlene::Scene_throw_coffee");
    ref =_ref;
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {

    println("Charlene::Scene_throw_coffee::onStart");

    imageWidth = 200;
    imageHeight = 200;
    isThrown=false;
    lock=false;
    mug.resize(imageWidth, imageHeight);
    //  setupWorld();
    //   setupPhysicsObjects();
    words[0]="biology";
    words[1]="geography";
    words[2]="history";
    words[3]="ICT";
    words[4]="english";
    words[5]="R.E.";
    words[6]="algebrae";
    words[7]="study";
    words[8]="careers";
    words[9]="ignorance";


    int index=0;
    for (int i=0;i<numBlobs;i++) {
      blobs[i]= new ShardParticle(picturePos, new PVector(0, 0, 0), 0.0, 0.0, imageWidth/6, 255, 0, 0);
      blobs[i].setWord(words[index]);
      index++;
      if (index>=10) {
        index=0;
      }
    }
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    //PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_HEAD, transform2D, openNIContext);

    pushMatrix();
    //if leftHand vector is up fast, then add an upward velocity to particles
    //if the left hand is moving to the right increment the page index
    float thresh=0.02;
    fill(166, 129, 54);
    if (getElapsedSeconds()>4) {
      if (skeleton.getJointVelocity(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext).y >thresh && !lock ) {
        isThrown=true;
      }
      if (isThrown) {
        if (!lock) {
          for (int i=0;i<blobs.length;i++) {
            blobs[i].setPosVel(new PVector(random(-3, 3), random(-2, -8), 0));
            blobs[i].setRotVel(random(-3, 3));
            float distThresh= 50;
            if (dist(blobs[i].pos.x, blobs[i].pos.y, leftHand.x, leftHand.y )>distThresh) {
              blobs[i].showWord=true;
            }
          } 
          lock=true;
        }
      }
      else {
        for (int i=0;i<blobs.length;i++) {
          blobs[i].setPos(new PVector(leftHand.x-(0.4*mug.width), leftHand.y, 0)  );
        }
      }
      for (int i=0;i<blobs.length;i++) {
        blobs[i].draw();
      }
      //if particle distance is a little away from the mug
      //turn the particles into words
      //ellipse(leftHand.x, leftHand.y, 20, 20);
    }
    image(mug, leftHand.x-(0.7*mug.width), leftHand.y-(0.7*mug.height));

    popMatrix();
    text(str(isThrown), 100, 100);
  }
};

//SCENE 4 A mortar board flies from the sky and lands ont he head
class Scene_mortar_board_on_head extends TSSceneBase {
  PImage mortarBoard= loadImage("charlene/mortarboard.png");
  PVector startPos;
  float inc;
  float numFramesForAnimation;
  float speed;

  //scale for imagee
  float w;
  float h;
  Scene_mortar_board_on_head() {
    sceneName="scene4 MORTAR BOARD ON HEAD";
    println("Charlene::Scene_mortar_board_on_head");
    setTrigger(new KeyPressTrigger('w'));
    startPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.5, 0.0, 0));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {

    println("Charlene::Scene_mortar_board_on_head::onStart");
    inc=0;
    numFramesForAnimation = 50.0;
    speed=1.0/numFramesForAnimation;
    //scale for imagee
    w=120;
    h=120;
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector endPos= skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_HEAD, transform2D, openNIContext);

    float currentX = lerp(startPos.x, endPos.x, inc);
    float currentY = lerp(startPos.y, endPos.y, inc);

    image(mortarBoard, currentX-(0.5*w), currentY-(0.7*h), w, h);
    if (inc<1.0) {
      inc+=speed;
    }
  }
};

//SCENE 5
class Scene_zoom_from_space extends TSSceneBase {

  PImage world= loadImage("charlene/world.png");
  PImage country= loadImage("charlene/country.png");
  PImage city= loadImage("charlene/city1.png");
  PImage blended = loadImage("charlene/world.png");

  int imageWidth;
  int imageHeight;

  Scene_zoom_from_space() {
    sceneName="scene5 ZOOM FROM SPACE";

    println("CelineStory::Scene_zoom_from_space");

    setTrigger(new KeyPressTrigger('w'));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("Charlene::Scene_zoom_from_space::onStart");

    imageWidth = 200;
    imageHeight = 200;
    country.resize(imageWidth, imageHeight);
    world.resize(imageWidth, imageHeight);
    city.resize(imageWidth, imageHeight);
    blended.resize(imageWidth, imageHeight);
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.2, 0));

    float distBetweenHands = dist( rightHand.x, rightHand.y, leftHand.x, leftHand.y);
    float maxDist= 300;
    //scale the image according to the mapped distance between hands
    float imageScale =  map(distBetweenHands, 0, maxDist, 0.0, 1);
    imageScale=constrain(imageScale, 0.01, 0.96);

    if (imageScale >= 0.0 && imageScale < 0.5 ) {
      blended= lerpImage(city, country, imageScale *map(imageScale, 0.0, 0.5, 0, 1)   );
    }
    else if (imageScale >= 0.5 && imageScale < 1.0) {
      blended= lerpImage(country, world, imageScale *map(imageScale, 0.5, 1.0, 0, 1) );
    }

    image(blended, picturePos.x, picturePos.y);
  }

  PImage lerpImage(PImage image1, PImage image2, float amt) {
    PImage blendImage= createImage(image1.width, image1.height, ARGB);
    image1.loadPixels();
    image2.loadPixels();
    blendImage.loadPixels();
    for (int i =0 ;i< image1.pixels.length ;i++) {
      color a = image1.pixels[i];
      color b = image2.pixels[i];
      blendImage.pixels[i]= lerpColor(a, b, amt);
    }

    image1.updatePixels();
    image2.updatePixels();
    blendImage.updatePixels();
    return blendImage;
  }
};

//SCENE 6
class Scene_vote_in_box extends TSSceneBase {
  PImage ballotBoxFront= loadImage("charlene/ballotboxFront.png");
  PImage ballotBoxBack= loadImage("charlene/ballotboxBack.png");
  PImage vote= loadImage("charlene/voteUpright.png");

  //is the centre of the vote card over the slot
  boolean inBox;
  //is this the first time this has happened? 
  boolean lock;

  //scale for imagee
  int wBallotBox;
  int hBallotBox;
  int wVote;
  int hVote;
  int yInc;
  //where the vote is when it first goes in the box
  PVector votePosAtStartOfAnimation;

  Scene_vote_in_box() {
    sceneName="scene6 VOTE IN BOX";

    setTrigger(new KeyPressTrigger('e'));
    println("Charlene::Scene_vote_in_box");
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("Charlene::Scene_vote_in_box::onStart");
    wBallotBox=200;
    hBallotBox=200;
    wVote=120;
    hVote=120;
    ballotBoxFront.resize(wBallotBox, hBallotBox);
    ballotBoxBack.resize(wBallotBox, hBallotBox);
    vote.resize(wVote, hVote);

    //is the centre of the vote card over the slot
    inBox=false;
    //is this the first time this has happened? 
    lock=false;

    //scale for imagee

      yInc=0;
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector leftHand= skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.01, 0.5, 0));

    PVector centreOfVote= new PVector(leftHand.x - (0.5*vote.width), leftHand.y   );
    PVector slotPos = new PVector(picturePos.x+(ballotBoxFront.width * 0.2), picturePos.y+(ballotBoxFront.height * 0.1));
    float slotWidth= ballotBoxFront.width*0.5;
    float tolerance=10;
    //if the vote is near the slot and this is the first time
    if (getElapsedSeconds()>2) {
      if (centreOfVote.x > slotPos.x && centreOfVote.x < slotPos.x + slotWidth && centreOfVote.y > slotPos.y && ! lock ) {
        inBox=true; 
        votePosAtStartOfAnimation = new PVector(leftHand.x-vote.width, leftHand.y-(0.5*vote.height));
        lock=true;
      }
    }
    //if we are in the box take control away from the hand and animate a drop down into the box
    if (inBox) {
      image(ballotBoxBack, picturePos.x, picturePos.y);
      image(vote, votePosAtStartOfAnimation.x, votePosAtStartOfAnimation.y+yInc);
      image(ballotBoxFront, picturePos.x, picturePos.y);

      if (votePosAtStartOfAnimation.y+yInc+(vote.height) <picturePos.y+ ballotBoxFront.height) {
        yInc+=2;
      }
    }
    else {
      image(ballotBoxBack, picturePos.x, picturePos.y);
      image(vote, leftHand.x-vote.width, leftHand.y-(0.5*vote.height));
      image(ballotBoxFront, picturePos.x, picturePos.y);
    }
  }
};

//SCENE 7 circling left hand gesture above the shoulder rotates one image to another on the flip side
class Scene_power_hands extends TSSceneBase {

  int imageWidth = 200;
  int imageHeight = 200;

  PImage orb=loadImage("charlene/glowingorb.png");
  float alpha;
  float inc;
  float rot;
  Scene_power_hands() {
    sceneName="scene7 POWER HANDS";

    println("Charlene::Scene_power_hands");
    orb.resize(imageWidth, imageHeight);

    setTrigger(new KeyPressTrigger('w'));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("Charlene::Scene_power_hands::onStart");
    alpha=0;
    inc=2;
    rot=0;
  }
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    pushStyle();
    pushMatrix();
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    //add some pulsing glow
    tint(255, 100+alpha);

    //width is the distance between hands
    float _width=rightHand.x-leftHand.x;
    //get the height in proportion so we don't squash the image
    float proportion = _width/imageWidth;
    float _height=imageHeight*proportion;
    //translate to drawing point
    translate(leftHand.x, leftHand.y-(0.5*_height));
    //tranlsate to rotation point
    translate(_width/2, _height/2, -(0.5*_height));
    //rotate
    rotate(rot);
    //tranlsate back from rotation point
    translate(-_width/2, -_height/2, (0.5*_height));
    image(orb, 0, 0, _width, _height );
    alpha+=inc;
    rot+=0.05;
    if (alpha>=155||alpha<0) {
      inc*=-1;
    }
    popMatrix();
    popStyle();
  }
};


//SCENE 8 circling left hand gesture above the shoulder rotates one image to another on the flip side
class Scene_spin_right_wrong extends TSSceneBase {

  int imageWidth = 200;
  int imageHeight = 200;

  PImage right=loadImage("charlene/right.png");
  PImage wrong=loadImage("charlene/wrong.png");

  Scene_spin_right_wrong() {
    sceneName="scene8 SPING RIGHT OR WRONG";

    println("Charlene::Scene_spin_right_wrong");
    right.resize(imageWidth, imageHeight);
    wrong.resize(imageWidth, imageHeight);

    setTrigger(new KeyPressTrigger('w'));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("Charlene::Scene_spin_right_wrong::onStart");
  }
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    pushMatrix();
    PVector leftHand = skeleton.getJointCoords(openNIContext, lastUserId, SimpleOpenNI.SKEL_LEFT_HAND);
    PVector leftShoulder = skeleton.getJointCoords(openNIContext, lastUserId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.2, 0));
    //get the angle between the left shoulder and the left hand as if looking down from above ie at the x z plane
    float angle = atan2( leftShoulder.z- leftHand.z, leftShoulder.x- leftHand.x);
    translate(picturePos.x+(0.5*imageWidth), picturePos.y);
    //draw the front
    pushMatrix();
    rotateY(angle);
    translate(-0.5*imageWidth, 0, 0);
    rect(0, 0, imageWidth, imageHeight);
    translate(0, 0, 1);
    image(right, 0, 0);
    popMatrix();
    //draw the back
    pushMatrix();

    rotateY(angle+PI);
    translate(0, 0, 2);

    translate(-0.5*imageWidth, 0, 0);
    image(wrong, 0, 0);
    popMatrix();
    popMatrix();
  }
};



//SCENE 9 
class Scene_shatter_image extends TSSceneBase {

  int imageWidth = 200;
  int imageHeight = 200;
  int numShards=10;
  float angle=0.0;
  boolean moveShards=false;
  ShardParticle [] shards = new ShardParticle[numShards];
  PImage [] shardImages = new PImage[numShards];
  boolean handOver;
  PVector picturePos;

  Scene_shatter_image() {
    sceneName="scene9 SHATTER IMAGE";

    println("Charlene::Scene_shatter_image");
    int x=0;
    int y=0;
    float rowLength=4.0;
    picturePos =transform2D.getWorldCoordsForInputNorm(new PVector(0.1, 0.2, 0));
    for (int i=0;i<numShards;i++) {
      shardImages[i]=loadImage("charlene/shard"+str(i+1)+".png");
      shardImages[i].resize(imageWidth, imageHeight);
      shards[i]= new ShardParticle(picturePos, new PVector(0, 0, 0), 0.0, 0.0, imageWidth/2, 255, 0, 0); 
      shards[i].setOffset(new PVector (x*(imageWidth/rowLength), y*(0.333*imageHeight)));
      x++;
      if (x>=rowLength) {
        y++;
      }
    }
    setTrigger(new KeyPressTrigger('w'));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("Charlene::Scene_shatter_image::onStart");
    handOver=false;
    player.close();
    player = minim.loadFile("song2.mp3");
  }
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    player.play();
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    if (leftHand.x>picturePos.x && leftHand.x<picturePos.x+imageWidth && leftHand.y>picturePos.y && leftHand.y<picturePos.y+imageHeight) {
      handOver=true;
    }

    if (handOver&&!moveShards) {
      println("reset");
      for (int i=0;i<numShards;i++) {
        shards[i].posVel=new PVector(random(-3, 3), random(4, 8), 0  );
        shards[i].rotVel=  random(-3, 3);
      }
      moveShards=true;
    }
    for (int i=0;i<numShards;i++) {
      shards[i].draw(shardImages[i]);
    }
  }
};



//SCENE 10 two arms dropping down makes curtain fall
class Scene_drop_set extends TSSceneBase {

  int imageWidth = width;
  int imageHeight = height;
  PVector picturePos;
  PImage theatre=loadImage("charlene/theatre.png");
  boolean startDrop;
  boolean endDrop;

  Scene_drop_set() {
    sceneName="scene10 DROP SET";
    
        println("Charlene::Scene_drop_set");
        theatre.resize(imageWidth, imageHeight);
    
        setTrigger(new KeyPressTrigger('w'));
      }
    
      // this is called when the scene starts (i.e. is triggered)
      void onStart() {
        println("Charlene::Scene_drop_set::onStart");
        startDrop=false;
        endDrop=false;
        player.close();
        player = minim.loadFile("song1.mp3");
      }
      void onDraw(PImage userImage, TSSkeleton skeleton) {
        player.play();
        pushStyle();
        pushMatrix();
        PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
        PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
        PVector head = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_HEAD, transform2D, openNIContext);
        //SKEL_WAIST is not working! 
        PVector waist = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HIP, transform2D, openNIContext);
    
        float maxRange = waist.y-head.y;
        println(maxRange+" "+waist.y+" "+head.y);
        //if both arms go above the head start linking the image pos to hands
    
        if (leftHand.y<head.y && rightHand.y<head.y) startDrop = true;
    
        if (startDrop) {
          if (!endDrop) {
            float mappedY = map (leftHand.y-head.y, 0, maxRange, 0, height+50);
            picturePos= new PVector(0, mappedY);
          }
          if (picturePos.y>height) {
            endDrop=true;
          }
        }
        else {
          picturePos= new PVector(0, 0);
        }
        image(theatre, picturePos.x, picturePos.y);
    
        popMatrix();
        popStyle();
      }
}
