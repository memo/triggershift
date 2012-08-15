class ManiStory extends TSStoryBase {

  ManiStory() {
    storyName = "ManiStory";
    println(storyName + "::" + storyName);
  }

  //----------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
  }

}
