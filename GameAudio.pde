import ddf.minim.*;

class GameAudio {
  Minim minim;
  AudioPlayer titleScreenTrack;
  AudioPlayer gameplayTrack;
  AudioPlayer selectionSound;
  AudioPlayer playerShotSound;
  AudioPlayer enemyShotSound;
  AudioPlayer enemyKilledSound;
  AudioPlayer collisionSound;
  AudioPlayer gameOverSound;
  AudioPlayer shieldPowerUpSound;
  AudioPlayer rapidFirePowerUpSound;
  AudioPlayer slowMotionPowerUpSound;
  AudioPlayer scoreMultiplierPowerUpSound;
  
  boolean musicEnabled = true;
  boolean sfxEnabled = true;
  float musicVolume = 1.0;
  float sfxVolume = 1.0;
  
  GameAudio(PApplet parent){
    minim = new Minim(parent);
    loadAudio();
  }
  
  void loadAudio(){
    titleScreenTrack = minim.loadFile("data/audio/music/Tittle_screen_track.mp3");
    gameplayTrack = minim.loadFile("data/audio/music/Gameplay_track.mp3");
    selectionSound = minim.loadFile("data/audio/sounds/Selection_sound.mp3");
    playerShotSound = minim.loadFile("data/audio/sounds/Player_shot_sound.mp3");
    enemyShotSound = minim.loadFile("data/audio/sounds/Enemy_shot_sound.mp3");
    enemyKilledSound = minim.loadFile("data/audio/sounds/Enemy_killed_sound.mp3");
    collisionSound = minim.loadFile("data/audio/sounds/Collision_sound.mp3");
    gameOverSound = minim.loadFile("data/audio/sounds/GameOver_sound.mp3");
    shieldPowerUpSound = minim.loadFile("data/audio/sounds/Shield_PowerUp_sound.mp3");
    rapidFirePowerUpSound = minim.loadFile("data/audio/sounds/RapidFire_PowerUp_sound.mp3");
    slowMotionPowerUpSound = minim.loadFile("data/audio/sounds/SlowMotion_PowerUp_sound.mp3");
    scoreMultiplierPowerUpSound = minim.loadFile("data/audio/sounds/ScoreMultiplier_PowerUp_sound.mp3");
    
    titleScreenTrack.loop();
  }
  
  void updateMusic(GameState state){
    if(!musicEnabled){
      if(titleScreenTrack.isPlaying())
        titleScreenTrack.pause();
      if(gameplayTrack.isPlaying())
        gameplayTrack.pause();
      return;
    }
    
    if(state == GameState.MENU || state == GameState.LEADERBOARDS || 
       state == GameState.INSTRUCTIONS || state == GameState.SETTINGS){
      if(!titleScreenTrack.isPlaying()){
        titleScreenTrack.rewind();
        titleScreenTrack.loop();
      }
      if(gameplayTrack.isPlaying())
        gameplayTrack.pause();
    } 
    else if(state == GameState.PLAYING){
      if(titleScreenTrack.isPlaying())
        titleScreenTrack.pause();
      if(!gameplayTrack.isPlaying()){
        gameplayTrack.rewind();
        gameplayTrack.loop();
      }
    } 
    else{
      if(titleScreenTrack.isPlaying())
        titleScreenTrack.pause();
      if(gameplayTrack.isPlaying())
        gameplayTrack.pause();
    }
  }
  
  void playSelectionSound(){
    if(!sfxEnabled) return;
    selectionSound.rewind();
    selectionSound.play();
  }
  
  void playPlayerShotSound(){
    if(!sfxEnabled) return;
    playerShotSound.rewind();
    playerShotSound.play();
  }
  
  void playEnemyShotSound(){
    if(!sfxEnabled) return;
    enemyShotSound.rewind();
    enemyShotSound.play();
  }
  
  void playEnemyKilledSound() {
    if(!sfxEnabled) return;
    enemyKilledSound.rewind();
    enemyKilledSound.play();
  }
  
  void playCollisionSound(){
    if(!sfxEnabled) return;
    collisionSound.rewind();
    collisionSound.play();
  }
  
  void playGameOverSound(){
    if(!sfxEnabled) return;
    gameOverSound.rewind();
    gameOverSound.play();
  }
  
  void playShieldPowerUpSound(){
    if(!sfxEnabled) return;
    shieldPowerUpSound.rewind();
    shieldPowerUpSound.play();
  }
  
  void playRapidFirePowerUpSound(){
    if(!sfxEnabled) return;
    rapidFirePowerUpSound.rewind();
    rapidFirePowerUpSound.play();
  }
  
  void playSlowMotionPowerUpSound(){
    if(!sfxEnabled) return;
    slowMotionPowerUpSound.rewind();
    slowMotionPowerUpSound.play();
  }
  
  void playScoreMultiplierPowerUpSound(){
    if(!sfxEnabled) return;
    scoreMultiplierPowerUpSound.rewind();
    scoreMultiplierPowerUpSound.play();
  }
  
  void setMusicEnabled(boolean enabled){
    musicEnabled = enabled;
    if(!musicEnabled){
      if(titleScreenTrack.isPlaying())
        titleScreenTrack.pause();
      if(gameplayTrack.isPlaying())
        gameplayTrack.pause();
    }
  }
  
  void setSfxEnabled(boolean enabled){
    sfxEnabled = enabled;
  }
  
  void setMusicVolume(float volumePercent){
    musicVolume = volumePercent / 100.0;
    float normalized = volumePercent / 100.0;
    float gain = -40.0 * (1.0 - sqrt(normalized));
    if(volumePercent <= 0) 
      gain = -40.0;
    titleScreenTrack.setGain(gain);
    gameplayTrack.setGain(gain);
  }
  
  void setSfxVolume(float volumePercent){
    sfxVolume = volumePercent / 100.0;
    AudioPlayer[] sfxSounds = {selectionSound, playerShotSound, enemyShotSound, 
                               enemyKilledSound, collisionSound, gameOverSound,
                               shieldPowerUpSound, rapidFirePowerUpSound, 
                               slowMotionPowerUpSound, scoreMultiplierPowerUpSound};
    
    float normalized = volumePercent / 100.0;
    float gain = -40.0 * (1.0 - sqrt(normalized));
    if (volumePercent <= 0) 
      gain = -40.0;
    
    for(AudioPlayer sound : sfxSounds)
      sound.setGain(gain);
  }
  
  boolean isMusicEnabled(){
    return musicEnabled;
  }

  boolean isSfxEnabled(){
    return sfxEnabled;
  }
  
  void cleanup(){
    titleScreenTrack.close();
    gameplayTrack.close();
    selectionSound.close();
    playerShotSound.close();
    enemyShotSound.close();
    enemyKilledSound.close();
    collisionSound.close();
    gameOverSound.close();
    shieldPowerUpSound.close();
    rapidFirePowerUpSound.close();
    slowMotionPowerUpSound.close();
    scoreMultiplierPowerUpSound.close();
    minim.stop();
  }
}
