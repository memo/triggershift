
// base class for a Story
// a Story is a sequence of Scenes & Triggers that tell an interactive story
// extend this class to create new stories


class TSStory {

  protected ArrayList scenes;
  protected ArrayList triggers;

  protected int currentSceneIndex = 0;
  protected TSIScene currentScene = null;
  protected TSITrigger currentTrigger = null;


  //----------------------------------
  public void setup() {
    println("OVERRIDE THIS FUNCTION");
  }
  

  //----------------------------------
  protected void addScene(TSIScene s, TSITrigger t) {
    scenes.add(s);
    triggers.add(t);
  }

  //----------------------------------
  public void start() {
    setCurrentSceneIndex(0);
  }

  //----------------------------------
  protected void setCurrentSceneIndex(int i) {
    if (i >= scenes.size()) {
      // reached end, do something
      return;
    }

    currentSceneIndex = i;

    currentScene = (TSIScene) scenes.get(i);
    currentTrigger = (TSITrigger) triggers.get(i);

    currentScene.start();
  }


  //----------------------------------
  public void draw(PImage userImage, TSSkeleton skeleton) {
   if (currentScene==null) return;
   
   // check trigger
   if (currentTrigger.check()) setCurrentSceneIndex(currentSceneIndex+1);
   
   // draw current scene
   currentScene.draw(userImage, skeleton);
   }
};

