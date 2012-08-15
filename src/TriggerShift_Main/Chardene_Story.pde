class ChardeneStory extends TSStoryBase {

  ChardeneStory(PApplet ref) {
    println("ChardeneStory::ChardeneStory");
    //addScene(new Scene_mortar_board_on_head());
    addScene(new Scene_throw_coffee(ref));
  }
}


//flicking gesture throws water out of a cup
class Scene_throw_coffee extends TSSceneBase {
  FWorld world;
  FMouseJoint joint;
  PApplet ref;
  PFont font=loadFont("AdobeGothicStd-Bold-14.vlw");
  PImage mug=loadImage("mug.png");
  int wCup=50;
  int hCup=50;
  int wCupImage=3*wCup;
  int hCupImage=4*hCup;
  PVector startPos; 
  //the blobs of coffee
  int  numBlobs= 10;
  String[] words= new String[numBlobs];



  Scene_throw_coffee(PApplet _ref) {
    println("CelineStory::Scene_throw_coffee");
    ref =_ref;
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_throw_coffee::onStart");

    words[1]="geography";
    words[2]="history";
    words[3]="ICT";
    words[4]="english";
    words[5]="R.E.";
    words[6]="algebrae";
    words[7]="study";
    words[8]="careers";
    words[9]="ignorance";
    textFont(font, 14);
    setupWorld();
    setupPhysicsObjects();
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector leftHand = openNIContext != null ? skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext) : new PVector();

    if (getElapsedSeconds() >2000) {
      //tie the poly to the hand position
      PVector handMinusStartPos = new PVector((leftHand.x-(0.5*wCupImage))-startPos.x, (leftHand.y-(0.5*hCup))-startPos.y, 0);
      joint.setTarget(handMinusStartPos.x, handMinusStartPos.y);
      world.draw();
      image(mug, leftHand.x-wCupImage, leftHand.y-(0.5*hCupImage), wCupImage, hCupImage);
    }
    /*if ( getElapsedSeconds() >10000) {
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
            
            float angle = PI-atan2(body.getVelocityY(), body.getVelocityX());
            println(angle);

            int index=int(explodedBodyName[1]);
            translate(x-(0.5*textWidth(words[index])), y);
            rotate(angle);
            text(words[index], 0, 0);
          }
        }
        catch(Exception e) {
        }
        popMatrix();
      }
    }*/
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
    //      PVector startPos = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);//
    startPos =transform2D.getWorldCoordsForInputNorm(new PVector(0.3, 0.7, 0));
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
    //a simple u with no thinkness doesn't seem to work - causes assertion errors - i think becasue it's squashing the shapes into much
   /* mug[0]=new PVector(x, y);
    mug[1]=new PVector(x, y+hCup);
    mug[2]=new PVector(x+wCup, y+hCup);
    mug[3]=new PVector(x+wCup, y);
    */
    mug[0]=new PVector(x, y);
    mug[1]=new PVector(x+thickness, y);
    mug[2]=new PVector(x+thickness, y+hCup-thickness);
    mug[3]=new PVector(x+wCup-thickness, y+hCup-thickness);
    mug[4]=new PVector(x+wCup-thickness, y);
    mug[5]=new PVector(x+wCup, y);
    mug[6]=new PVector(x+wCup, y+hCup);
    mug[7]=new PVector(x, y+hCup);
    mug[8]=new PVector(x, y);
    //a thin top
  //  mug[9]=new PVector(x+wCup, y);

    //make a poly and add to world
    addShape(mug, startPos);
   
    println(x+" start pos of my "+y);
    int gridX=0;
    int gridY=0;
    for (int i=0;i<numBlobs;i++) {
      FBlob b = new FBlob();
      float bSize = random(10, 20);

      b.setAsCircle(x+ random(20, wCup-20), y+ random(20, hCup-20 ), bSize, 20);
      b.setNoStroke();
      b.setDensity(1);
      b.setFriction(0);
      b.setName("coffee_"+str(i));
      b.setGrabbable(false);
      //   b.setStrokeWeight(0);
      b.setFill(166, 129, 54);
      world.add(b);
    }
  }
};
//A mortar board flies from the sky and lands ont he head
class Scene_mortar_board_on_head extends TSSceneBase {
  PImage mortarBoard= loadImage("mortarboard.png");
  PVector startPos;
  float inc=0;
  float numFramesForAnimation = 50.0;
  float speed=1.0/numFramesForAnimation;

  //scale for imagee
  float w=120;
  float h=120;
  Scene_mortar_board_on_head() {
    println("CelineStory::Scene_mortar_board_on_head");
    startPos=transform2D.getWorldCoordsForInputNorm(new PVector(0.5, 0.0, 0));
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {

    println("CelineStory::Scene_mortar_board_on_head::onStart");
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector endPos= skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_HEAD, transform2D, openNIContext);

    float currentX = lerp(startPos.x, endPos.x, inc);
    float currentY = lerp(startPos.y, endPos.y, inc);

    image(mortarBoard, currentX-(0.5*w), currentY-(0.7*h), w, h);
    if (inc<1.0) {
      inc+=speed;
    }
  }
};

