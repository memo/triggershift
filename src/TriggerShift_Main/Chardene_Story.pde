class ChardeneStory extends TSStoryBase {

  ChardeneStory(PApplet ref) {
    println("ChardeneStory::ChardeneStory");
    addScene(new Scene_throw_coffee(ref));
  }
}


//flicking gesture throws water out of a cup
class Scene_throw_coffee extends TSSceneBase {
  FWorld world;
  FMouseJoint joint;
  PApplet ref;
  PImage mug=loadImage("mug.png");
  int wCup=50;
  int hCup=50;
  int wCupImage=3*wCup;
  int hCupImage=4*hCup;
  int timer=0;
  boolean drawingHasStarted=false;
  PVector startPos; 
  Scene_throw_coffee(PApplet _ref) {
    println("CelineStory::Scene_throw_coffee");
    ref =_ref;
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_throw_coffee::onStart");
    setupWorld();
    setupPhysicsObjects();
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector leftHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);

    if (timer>100) {
      world.step();
      //tie the poly to the hand position
      PVector handMinusStartPos = new PVector((leftHand.x-(0.5*wCupImage))-startPos.x, (leftHand.y-(0.5*hCup))-startPos.y, 0);
      joint.setTarget(handMinusStartPos.x, handMinusStartPos.y);
      world.draw();
      image(mug, leftHand.x-wCupImage, leftHand.y-(0.5*hCupImage), wCupImage, hCupImage);
    }
    timer++;
    //  }
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
    mug[0]=new PVector(x, y);
    mug[1]=new PVector(x+thickness, y);
    mug[2]=new PVector(x+thickness, y+hCup-thickness);
    mug[3]=new PVector(x+wCup-thickness, y+hCup-thickness);
    mug[4]=new PVector(x+wCup-thickness, y);
    mug[5]=new PVector(x+wCup, y);
    mug[6]=new PVector(x+wCup, y+hCup);
    mug[7]=new PVector(x, y+hCup);
    mug[8]=new PVector(x, y);

    //make a poly and add to world
    addShape(mug, startPos);
    int  numBlobs= 10;

    println(x+" start pos of my "+y);
    for (int i=0;i<numBlobs;i++) {
      FBlob b = new FBlob();
      float bSize = random(10, 40);

      b.setAsCircle(x+ random(30, wCup-30), y+ random(30, hCup-30 ), bSize, 20);
      b.setNoStroke();
      b.setDensity(1);
      b.setFriction(0);
      b.setGrabbable(false);
      //   b.setStrokeWeight(0);
      b.setFill(166, 129, 54);
      world.add(b);
    }
  }
};

