class CelineStory extends TSStoryBase {

  CelineStory() {
    println("CelineStory::CelineStory");
  }
}

//
 class Scene_ripPaper extends TSSceneBase {
    Scene_ripPaper() {
      println("CelineStory::Scene_ripPaper");
      setTrigger(new MouseAreaTrigger(0, 0, 250, 250, false));
    }

    // this is called when the scene starts (i.e. is triggered)
    void onStart() {
      println("CelineStory::Scene_ripPaper::onStart");
    }

    // this is the scenes draw function
    // use getElapsedSeconds() to see how long the scene has been running (useful for transitions)
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      //      println("StoryTest::Scene1::onDraw");
      fill(255, 0, 0);
      
      
      
      
      
    }
  };
