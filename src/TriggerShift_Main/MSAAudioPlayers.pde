class MSAAudioPlayers {
  MSAAudioPlayer []player;
  int currentIndex = 0;
  
  MSAAudioPlayers(String s, int count) {
    player = new MSAAudioPlayer[count];
    for(int i=0; i<count; i++) {
      player[i] = new MSAAudioPlayer(s);
    }
  }
  
  MSAAudioPlayers(String []s, int count) {
    player = new MSAAudioPlayer[count];
    for(int i=0; i<count; i++) {
      player[i] = new MSAAudioPlayer(s[(int)floor(random(s.length))]);
    }
  }
  
  void play() {
    player[currentIndex].play();
    currentIndex = (currentIndex + 1) % player.length;
  }
  
  void play(float f) {
    player[currentIndex].play(f);
    currentIndex = (currentIndex + 1) % player.length;
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
