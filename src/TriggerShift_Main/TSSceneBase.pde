
// a generic base class for a Scene
// A Scene is a single unit of a story, it has a way of displaying itself, and an interaction to trigger the next scene
// extend this class to create new scenes

class TSSceneBase {
  protected int startTime = 0;
  protected TSTriggerBaseI trigger;
  
  public String sceneName = "TSSceneBase";  // fill this in with correct name in subclass

  //----------------------------------
  // OVERRIDE THIS FUNCTION
  void onStart() {
    println("Override TSSceneBase::onStart");
  }

  //----------------------------------
  // OVERRIDE THIS FUNCTION
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    println("Override TSSceneBase::onDraw");
  }


  //----------------------------------
  TSSceneBase() {
    // set default trigger to spacebar
//    setTrigger(new KeyPressTrigger(' '));
  }
  
  //----------------------------------
  void startScene() {
    println("--------------------");
    println(sceneName + "::startScene");
    startTime = millis();
    onStart();
  }

  //----------------------------------
  float getElapsedSeconds() {
    return (millis() - startTime);
  }

  //----------------------------------
  void setTrigger(TSTriggerBaseI t) {
    println(sceneName + "::setTrigger " + t);
    trigger = t;
  }

  //----------------------------------
  boolean checkTrigger() {
    return trigger != null ? trigger.check() : false;
  }
};

