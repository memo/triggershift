class MSAAudioPlayers {
  MSAAudioPlayer []player;
  int currentIndex = 0;
  float minIntervalTime = 0.2;  // minimum time (Seconds) between triggers
  float lastTriggerTime = -1000;
  
  MSAAudioPlayers(String s, int count) {
    player = new MSAAudioPlayer[count];
    for(int i=0; i<count; i++) {
      player[i] = new MSAAudioPlayer(s);
    }
  }

  MSAAudioPlayers(String []s) {
    player = new MSAAudioPlayer[s.length];
    for(int i=0; i<s.length; i++) player[i] = new MSAAudioPlayer(s[i]);
  }
  
//  MSAAudioPlayers(String []s, int count, boolean doRandom) {
//    player = new MSAAudioPlayer[count];
//    for(int i=0; i<count; i++) {
//      int sampleIndex = doRandom ? (int)floor(random(s.length)) : i % s.length;
//      player[i] = new MSAAudioPlayer(s[sampleIndex]);
//    }
//  }
  
  void nextIndex() {
    currentIndex = (currentIndex + 1) % player.length;
  }
  
  void randomIndex() {
    currentIndex = floor(random(0, player.length));
  }
  
  void play() {
    if(millis()*0.001 -lastTriggerTime <  minIntervalTime) return;
    lastTriggerTime = millis() * 0.001;
    player[currentIndex].play();
  }
  
  void play(float fromTime) {
    if(millis()*0.001 -lastTriggerTime <  minIntervalTime) return;
    lastTriggerTime = millis() * 0.001;
    player[currentIndex].play(fromTime);
  }
  
  void playIndex(int i) {
    currentIndex = i;
    play();
  }

  void playIndex(int i, float fromTime) {
    currentIndex = i;
    play(fromTime);
  }
  
  void playRandomIndex() {
    randomIndex();
    play(0);
  }
  
  boolean isPlaying() {
    return player[currentIndex].isPlaying();
  }
  
//  
//  void play(AudioEffect effect) {
//    player[currentIndex].addEffect(effect);
//    play();
//  }

  void setGain(float volume) {
    player[currentIndex].setGain(volume);
  }
  
  void randomGain() {
    setGain(random(0.3, 1));
  }
  
  void close() {
    for(int i=0; i<player.length; i++) {
      player[i].close();
    }
  }
};
