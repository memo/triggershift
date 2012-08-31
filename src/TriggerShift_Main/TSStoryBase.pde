
// a generic base class for a Story
// a Story is a sequence of Scenes that tell an interactive story
// extend this class to create new stories


class TSStoryBase {

  protected ArrayList scenes = new ArrayList();
  protected int currentSceneIndex;
  protected TSSceneBase currentScene = null;
  protected boolean reachedEnd = false;
  
  public String storyName = "TSStoryBase";  // fill this in with correct name in subclass
  //----------------------------------
  // OVERRIDE THIS FUNCTION
  void onEnd() {
    println("TSStoryBase::onEnd");
     try{
      storyPlayer.close();
    }
    catch (Exception e){
      
    }
  }
  
  //----------------------------------
  void addScene(TSSceneBase s) {
    scenes.add(s);
  }

  //----------------------------------
  void endStory() {
    println(storyName + "::endStory");
    onEnd();
    if(currentScene != null) currentScene.endScene();
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
    reachedEnd = false;
    setSceneIndex(0);
    resetSkeletonStats();
  }

  //----------------------------------
  void setSceneIndex(int i) {
    println(storyName + "::setSceneIndex: " + i);
    reachedEnd = false;
    if (i >= scenes.size()) {
      // reached end, do something
      println(storyName + "::setSceneIndex: reached end");
      reachedEnd = true;
      if(useInstallationMode) nextStory();
      return;
    } else if(i<0) {
      println(storyName + "::setSceneIndex: reached start");
      return;
    }

    if(currentScene != null) currentScene.endScene();
    
    currentSceneIndex = i;
    currentScene = (TSSceneBase) scenes.get(i);
    currentScene.startScene();
  }
  
  
  //----------------------------------
  int getSceneIndex() {
    return currentSceneIndex;
  }
  
  
  String getString() {
    String s = "STORY:  " + storyName;
    if (currentScene != null) s += "\nSCENE: " + str(currentSceneIndex+1) + "/" + str(scenes.size()) + " (" + currentScene.sceneName + ")";
    if(reachedEnd) s += " FINISHED!";
    return s;
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
    if(useInstallationMode && currentScene.getElapsedSeconds() > 20) nextScene();
  }
};

