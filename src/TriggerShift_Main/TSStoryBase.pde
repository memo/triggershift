
// a generic base class for a Story
// a Story is a sequence of Scenes that tell an interactive story
// extend this class to create new stories


class TSStoryBase {

  protected ArrayList scenes = new ArrayList();
  protected int currentSceneIndex = 0;
  protected TSSceneBase currentScene = null;


  //----------------------------------
  void addScene(TSSceneBase s) {
    scenes.add(s);
  }

  //----------------------------------
  void startStory() {
    println("TSStoryBase::startStory");
    setCurrentSceneIndex(0);
  }

  //----------------------------------
  void setCurrentSceneIndex(int i) {
    println("TSStoryBase::setCurrentSceneIndex: " + i);
    if (i >= scenes.size()) {
      // reached end, do something
      println("TSStoryBase::setCurrentSceneIndex: reached end");
      return;
    }

    currentSceneIndex = i;
    currentScene = (TSSceneBase) scenes.get(i);
    currentScene.startScene();
  }


  //----------------------------------
  void draw(PImage userImage, TSSkeleton skeleton) {
    if (currentScene==null) return;

    // check trigger
    if (currentScene.checkTrigger()) setCurrentSceneIndex(currentSceneIndex+1);

    // draw current scene
    currentScene.onDraw(userImage, skeleton);
  }
};

