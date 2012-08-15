class LornaStory extends TSStoryBase {

  LornaStory() {
    storyName = "LornaStory";
    println(storyName + "::" + storyName);
  }

  //----------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
  }
}
