
// a generic base class for a Story
// a Story is a sequence of Scenes that tell an interactive story
// extend this class to create new stories


class TSStoryBase {

  protected ArrayList scenes = new ArrayList();
  protected int currentSceneIndex = 0;
  protected TSSceneBase currentScene = null;
  
  public String storyName = "TSStoryBase";  // fill this in with correct name in subclass

  //----------------------------------
  // OVERRIDE THIS FUNCTION
  void onEnd() {
    println("TSStoryBase::onEnd");
  }
  
  //----------------------------------
  void addScene(TSSceneBase s) {
    scenes.add(s);
  }

  //----------------------------------
  void endStory() {
    println(storyName + "::endStory");
    onEnd();
    println("-------------------------------------------------");
    println("-------------------------------------------------");
    println(" ");
  }


  //----------------------------------
  void startStory() {
    println(" ");
    println("-------------------------------------------------");
    println("-------------------------------------------------");
    println(storyName + "::startStory");
    setSceneIndex(0);
    resetSkeletonStats();
  }

  //----------------------------------
  void setSceneIndex(int i) {
    println(storyName + "::setSceneIndex: " + i);
    if (i >= scenes.size()) {
      // reached end, do something
      println(storyName + "::setSceneIndex: reached end");
      return;
    } else if(i<0) {
      println(storyName + "::setSceneIndex: reached start");
      return;
    }

    currentSceneIndex = i;
    currentScene = (TSSceneBase) scenes.get(i);
    currentScene.startScene();
  }
  
  
  //----------------------------------
  int getSceneIndex() {
    return currentSceneIndex;
  }


  //----------------------------------
  void nextScene() {
    println(storyName + "::nextScene");
    setSceneIndex(currentSceneIndex+1);
  }

      //----------------------------------
  void prevScene() {
    println(storyName + "::prevScene");
    setSceneIndex(currentSceneIndex-1);
  }



  //----------------------------------
  void draw(PImage userImage, TSSkeleton skeleton) {
    if (currentScene==null) return;

    // check trigger
    if (currentScene.checkTrigger()) nextScene();

    // draw current scene
    currentScene.onDraw(userImage, skeleton);
  }
};

