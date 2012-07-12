
// manages all scenes and triggers

class TSSceneManager {

  protected ArrayList scenes;
  protected ArrayList triggers;

  int currentSceneIndex = 0;
  TSIScene currentScene = null;
  TSITrigger currentTrigger = null;

  //----------------------------------
  public void addScene(TSIScene s, TSITrigger t) {
    scenes.add(s);
    triggers.add(t);
  }

  //----------------------------------
  public void start() {
    setCurrentSceneIndex(0);
  }

  //----------------------------------
  public void setCurrentSceneIndex(int i) {
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

