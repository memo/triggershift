class CharleneStory extends TSStoryBase {

  CharleneStory(PApplet ref) {
    storyName = "CharleneStory";
    println(storyName + "::" + storyName);
    
    addScene(new Scene_flickBook());
    addScene(new Scene_clock_hands());
    addScene(new Scene_throw_coffee(ref));
    addScene(new Scene_mortar_board_on_head());
    addScene(new Scene_vote_in_box());
    addScene(new Scene_zoom_from_space());
  }
}

class Scene_throw_coffee extends TSSceneBase {
  FWorld world;
  FMouseJoint joint;
  PApplet ref;
  PImage mug=loadImage("chardene/mugUpright.png");
  int wCup=50;
  int hCup=80;
  int wCupImage=3*wCup;
  int hCupImage=3*hCup;
  int timer=0;
  boolean cupIsGrabbed=false;
  boolean drawingHasStarted=false;
  PVector startPos;

  //the blobs of coffee
  int  numBlobs= 10;
  String[] words= new String[numBlobs];

  Scene_throw_coffee(PApplet _ref) {
    println("Charlene::Scene_throw_coffee");
    ref =_ref;
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("Charlene::Scene_throw_coffee::onStart");
    setupWorld();
    setupPhysicsObjects();
    words[1]="geography";
    words[2]="history";
    words[3]="ICT";
    words[4]="english";
    words[5]="R.E.";
    words[6]="algebrae";
    words[7]="study";
    words[8]="careers";
    words[9]="ignorance";
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector leftHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);

    if (getElapsedSeconds()>2000) {
      world.step();
      //tie the poly to the hand position
      PVector handMinusStartPos = new PVector((leftHand.x-(0.5*wCupImage))-startPos.x, (leftHand.y-(0.5*hCup))-startPos.y, 0);

      if (dist(startPos.x, startPos.y, leftHand.x-(0.5*wCupImage), leftHand.y)<50) {
        cupIsGrabbed=true;
      }
      if (cupIsGrabbed) {
        joint.setTarget(handMinusStartPos.x-(0.5*wCupImage), handMinusStartPos.y);
      }
      world.draw();
      image(mug, leftHand.x-wCupImage, leftHand.y-(0.5*hCupImage), wCupImage, hCupImage);
    }
    if ( getElapsedSeconds() >4000) {
      //get a list of bodies
      ArrayList bodies= world.getBodies();

      // println(bodies.size()+" "+words.length);
      for (int i=0;i<bodies.size();i+=20) {
        pushMatrix();
        FBody body = (FBody) bodies.get(i);
        //check it's not the cup
        try {
          FBody parent = body.getParent();

          String [] explodedBodyName = splitTokens(parent.getName(), "_");
          if (explodedBodyName[0].equals("coffee")) {

            //get position and rotation
            float x=body.getX();
            float y=body.getY();
            if (dist(x, y, leftHand.x, leftHand.y)>100) {
              float angle = atan2(body.getVelocityY(), body.getVelocityX());
              println(angle);
              fill(255);
              int index=int(explodedBodyName[1]);
              translate(x-(0.5*textWidth(words[index])), y);
              rotate(angle);
              text(words[index], 0, 0);
            }
          }
        }
        catch(Exception e) {
        }
        popMatrix();
      }
    }
  }
  void addShape(PVector [] vertices, PVector startPos) {
    FPoly l = new FPoly();
    for (int i=0;i<vertices.length;i++) {
      l.vertex(vertices[i].x, vertices[i].y);
    }
    l.setStatic(false);
    l.setFill(200);
    l.setFriction(0);
    l.setDensity(1);
    l.setName("cup");
    l.setGrabbable(false);
    l.setRotatable(false);
    world.add(l);
    joint =new FMouseJoint(l, 0, 0) ;
    joint.setAnchor(0, 0);
    joint.setStroke(0);
    joint.setDamping(0);
    joint.setDrawable(false);
    world.add(joint);
  }
  void setupWorld() {
    Fisica.init(ref);

    world = new FWorld();
    world.setGravity(0, 300);
  }
  void setupPhysicsObjects() {
    //  PVector startPos =new PVector(500,500);// skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);//
    // startPos = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);//
    startPos =     transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.7, 0));
    println("startPos "+startPos);
    float x;
    float y;
    int thickness=2;
    PVector [] mug;
    mug = new PVector[9];
    x=startPos.x;
    y=startPos.y-(0.5*wCup);
    //add a u shape to contain the particles
    //  x=0;
    // y=0;

    //original u shape = no lid
    mug[0]=new PVector(x, y);
    mug[1]=new PVector(x+thickness, y);
    mug[2]=new PVector(x+thickness, y+hCup-thickness);
    mug[3]=new PVector(x+wCup-thickness, y+hCup-thickness);
    mug[4]=new PVector(x+wCup-thickness, y);
    mug[5]=new PVector(x+wCup, y);
    mug[6]=new PVector(x+wCup, y+hCup);
    mug[7]=new PVector(x, y+hCup);
    mug[8]=new PVector(x, y);

    /* mug[0]=new PVector(x, y);
     mug[1]=new PVector(x+thickness, y);
     mug[2]=new PVector(x+thickness, y+hCup-thickness);
     mug[3]=new PVector(x+wCup-thickness, y+hCup-thickness);
     mug[4]=new PVector(x+wCup-thickness, y);
     mug[5]=new PVector(x, y);
     mug[6]=new PVector(x, y-thickness);
     mug[7]=new PVector(x+wCup, y-thickness);
     mug[8]=new PVector(x+wCup, y+hCup);
     mug[9]=new PVector(x, y+hCup);
     mug[10]=new PVector(x, y);*/

    //make a poly and add to world
    addShape(mug, startPos);

    println(x+" start pos of my "+y);
    for (int i=0;i<numBlobs;i++) {
      FBlob b = new FBlob();
      float bSize = random(10, 40);

      b.setAsCircle(x+ random(30, wCup-30), y+ random(30, hCup-30 ), bSize, 20);
      b.setNoStroke();
      b.setDensity(1);
      b.setFriction(0);
      b.setGrabbable(false);
      b.setName("coffee_"+str(i));
      //   b.setStrokeWeight(0);
      b.setFill(166, 129, 54);
      world.add(b);
    }
  }
};

//A mortar board flies from the sky and lands ont he head
class Scene_mortar_board_on_head extends TSSceneBase {
  PImage mortarBoard= loadImage("chardene/mortarboard.png");
  PVector startPos;
  float inc=0;
  float numFramesForAnimation = 50.0;
  float speed=1.0/numFramesForAnimation;

  //scale for imagee
  float w=120;
  float h=120;
  Scene_mortar_board_on_head() {
    println("Charlene::Scene_mortar_board_on_head");
    setTrigger(new KeyPressTrigger('w'));
    startPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.5, 0.0, 0));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {

    println("Charlene::Scene_mortar_board_on_head::onStart");
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


//A mortar board flies from the sky and lands ont he head
class Scene_vote_in_box extends TSSceneBase {
  PImage ballotBoxFront= loadImage("chardene/ballotboxFront.png");
  PImage ballotBoxBack= loadImage("chardene/ballotboxBack.png");
  PImage vote= loadImage("chardene/voteUpright.png");

  //is the centre of the vote card over the slot
  boolean inBox=false;
  //is this the first time this has happened? 
  boolean lock=false;

  //scale for imagee
  int wBallotBox=200;
  int hBallotBox=200;
  int wVote=120;
  int hVote=120;
  int yInc=0;
  //where the vote is when it first goes in the box
  PVector votePosAtStartOfAnimation;

  Scene_vote_in_box() {
    setTrigger(new KeyPressTrigger('e'));
    println("Charlene::Scene_vote_in_box");
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("Charlene::Scene_vote_in_box::onStart");
    ballotBoxFront.resize(wBallotBox, hBallotBox);
    ballotBoxBack.resize(wBallotBox, hBallotBox);
    vote.resize(wVote, hVote);
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector leftHand= skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector picturePos=transform2D.getWorldCoordsForInputNorm(new PVector(0.01, 0.5, 0));

    PVector centreOfVote= new PVector(leftHand.x - (0.5*vote.width), leftHand.y   );
    PVector slotPos = new PVector(picturePos.x+(ballotBoxFront.width * 0.2), picturePos.y+(ballotBoxFront.height * 0.1));
    float slotWidth= ballotBoxFront.width*0.5;
    float tolerance=10;
    //if the vote is near the slot and this is the first time
    if (getElapsedSeconds()>2000) {
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
//A mortar board flies from the sky and lands ont he head
class Scene_zoom_from_space extends TSSceneBase {

  PImage world= loadImage("chardene/world.png");
  PImage country= loadImage("chardene/country.png");
  PImage city= loadImage("chardene/city1.png");
  PImage blended = loadImage("chardene/world.png");

  int imageWidth = 200;
  int imageHeight = 200;

  Scene_zoom_from_space() {
    println("CelineStory::Scene_zoom_from_space");

    setTrigger(new KeyPressTrigger('w'));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("Charlene::Scene_zoom_from_space::onStart");
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


//A mortar board flies from the sky and lands ont he head
class Scene_flickBook extends TSSceneBase {
  int numPageCells=8;
  PImage [] book = new PImage[numPageCells];


  int imageWidth = 200;
  int imageHeight = 200;
  int frameIndex=0;

  Scene_flickBook() {
    println("Charlene::Scene_flickBook");
    for (int i=0;i<numPageCells;i++) {
      book[i]=loadImage("chardene/bookPage_"+str(i)+".png");
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


//A mortar board flies from the sky and lands ont he head
class Scene_clock_hands extends TSSceneBase {
  int bookImageWidth = 200;
  int bookImageHeight = 200;
  PImage hourHand=loadImage("chardene/hourHand.png");
  PImage minuteHand=loadImage("chardene/hourHand.png");
  PImage book = loadImage("chardene/bookPage_0.png");
  int imageWidth = 20;
  int imageHeight = 100;
  float angle=0.0;

  Scene_clock_hands() {
    println("Charlene::Scene_clock_hands");
    
    hourHand.resize(imageWidth, imageHeight);
    minuteHand.resize(int(0.8*imageWidth), int( 0.6*imageHeight));
    book.resize(bookImageWidth,bookImageHeight);
    
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
    image(hourHand,-0.5*hourHand.width,-hourHand.height);
    popMatrix();
    pushMatrix();
    translate(picturePos.x+(0.5*bookImageWidth), picturePos.y+(0.5*bookImageHeight));
    rotate(angle);
    image(minuteHand,-0.5*minuteHand.width,-minuteHand.height);
    popMatrix();
    pushStyle();
    fill(0);
    noStroke();
    ellipse(picturePos.x+(0.5*bookImageWidth), picturePos.y+(0.5*bookImageHeight),imageWidth/2,imageWidth/2);
    popStyle();
    angle+=0.005;
  }
};

