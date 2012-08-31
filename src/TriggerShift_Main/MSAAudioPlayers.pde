class MSAAudioPlayers {
  MSAAudioPlayer []player;
  int currentIndex = 0;
  
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
    player[currentIndex].play();
  }
  
  void play(float fromTime) {
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
  
  
//  
//  void play(AudioEffect effect) {
//    player[currentIndex].addEffect(effect);
//    play();
//  }

  void setGain(float volume) {
    player[currentIndex].setGain(volume);
  }
  
  void close() {
    for(int i=0; i<player.length; i++) {
      player[i].close();
    }
  }
};
