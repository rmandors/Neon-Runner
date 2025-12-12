import ddf.minim.*;

// Game state machine for managing different screens
enum GameState {
  MENU,
  USERNAME_INPUT,
  PLAYING,
  GAME_OVER,
  LEADERBOARDS,
  INSTRUCTIONS,
  SETTINGS
}

GameState gameState = GameState.MENU;

GameAudio gameAudio;
LeaderboardManager leaderboardManager;
GameManager gameManager;
MenuManager menuManager;
BackgroundGrid backgroundGrid;
UIManager uiManager;

float gameSpeed = 1.0;

String currentPlayerUsername = "";
boolean hasUsername = false;

void setup(){
  size(800, 600);
  frameRate(60);
  
  gameAudio = new GameAudio(this);
  leaderboardManager = new LeaderboardManager();
  gameManager = new GameManager(gameAudio, leaderboardManager);
  menuManager = new MenuManager();
  backgroundGrid = new BackgroundGrid();
  uiManager = new UIManager();
  
  gameAudio.setMusicVolume(menuManager.getMusicVolume());
  gameAudio.setSfxVolume(menuManager.getSfxVolume());
  
  gameSpeed = gameManager.getGameSpeed();
}

// Main game loop, handles rendering for all game states
void draw(){
  gameAudio.updateMusic(gameState);
  gameSpeed = gameManager.getGameSpeed();
  
  switch(gameState){
    case MENU:
      menuManager.displayMenu();
      break;
    case USERNAME_INPUT:
      menuManager.displayUsernameInput(menuManager.getUsernameInput());
      break;
    case PLAYING:
      background(#000033);
      gameManager.update();
      backgroundGrid.update(gameSpeed);
      backgroundGrid.display();
      gameManager.display();
      uiManager.display(gameManager.getScore(), gameSpeed, gameManager.getPlayer(),
                        gameManager.isSlowMotion(), gameManager.getSlowMotionTimer(),
                        gameManager.getScoreMultiplier(), gameManager.getScoreMultiplierTimer(),
                        gameManager.getLevelNotification(), gameManager.getLevelNotificationTimer());     
      if(gameManager.checkGameOver())
        gameState = GameState.GAME_OVER;
      break;
    case GAME_OVER:
      background(#000033);
      menuManager.displayGameOver(gameManager.getScore(), gameManager.getHighScore(), leaderboardManager);
      break;
    case LEADERBOARDS:
      background(#000033);
      menuManager.displayLeaderboardEntries(leaderboardManager, gameManager.getScore());
      break;
    case INSTRUCTIONS:
      background(#000033);
      menuManager.displayInstructions();
      break;
    case SETTINGS:
      background(#000033);
      menuManager.displaySettings();
      break;
  }
}

// Handles keyboard input for all game states
void keyPressed(){
  if(gameState == GameState.MENU){
    if(keyCode == DOWN){
      menuManager.navigateDown();
      gameAudio.playSelectionSound();
    } 
    else if(keyCode == UP){
      menuManager.navigateUp();
      gameAudio.playSelectionSound();
    } 
    else if(key == ENTER || key == RETURN){
      GameState newState = menuManager.selectOption();
      if(newState == GameState.PLAYING){
        // Require username before starting game
        if(!hasUsername){
          gameState = GameState.USERNAME_INPUT;
          currentPlayerUsername = "";
        } 
        else{
          startGame();
        }
      } 
      else{
        gameState = newState;
      }
    }
  }
  else if(gameState == GameState.USERNAME_INPUT){
    menuManager.handleUsernameInput(key, keyCode);
    if(menuManager.isUsernameReady()){
      currentPlayerUsername = menuManager.getUsername();
      hasUsername = true;
      menuManager.clearUsernameInput();
      startGame();
    } 
    else if(keyCode == ESC){
      menuManager.clearUsernameInput();
      gameState = GameState.MENU;
      key = 0;
    }
  }
  else if(gameState == GameState.GAME_OVER){
    if(key == 'r' || key == 'R'){
      key = 0;
      keyCode = 0;
      startGame();
    } 
    else if(key == ESC){
      gameState = GameState.MENU;
      hasUsername = false;
      key = 0;
    }
  } 
  else if(gameState == GameState.PLAYING){
    gameManager.getPlayer().handleKeyPressed(key, keyCode);
  }
  else if(gameState == GameState.LEADERBOARDS || 
          gameState == GameState.INSTRUCTIONS) {
    if(key == ESC){
      gameState = GameState.MENU;
      key = 0; 
    }
  }
  else if(gameState == GameState.SETTINGS){
    if(keyCode == DOWN){
      menuManager.navigateSettingsDown();
      gameAudio.playSelectionSound();
    } 
    else if(keyCode == UP){
      menuManager.navigateSettingsUp();
      gameAudio.playSelectionSound();
    } 
    else if(keyCode == LEFT){
      menuManager.adjustVolume(-1);
      gameAudio.setMusicVolume(menuManager.getMusicVolume());
      gameAudio.setSfxVolume(menuManager.getSfxVolume());
      gameAudio.playSelectionSound();
    } 
    else if(keyCode == RIGHT){
      menuManager.adjustVolume(1);
      gameAudio.setMusicVolume(menuManager.getMusicVolume());
      gameAudio.setSfxVolume(menuManager.getSfxVolume());
      gameAudio.playSelectionSound();
    } 
    else if(key == ENTER || key == RETURN){
      if(menuManager.isToggleableSetting()){
        menuManager.toggleSelectedSetting();
        gameAudio.setMusicEnabled(menuManager.isMusicEnabled());
        gameAudio.setSfxEnabled(menuManager.isSfxEnabled());
        gameAudio.updateMusic(gameState);
        gameAudio.playSelectionSound();
      }
    } 
    else if(key == ESC){
      gameState = GameState.MENU;
      key = 0; 
    }
  }
}

void keyReleased(){
  if(gameState == GameState.PLAYING)
    gameManager.getPlayer().handleKeyReleased(key, keyCode);
}

void startGame(){
  gameManager.setPlayerUsername(currentPlayerUsername);
  gameManager.reset();
  gameState = GameState.PLAYING;
}

void stop(){
  gameAudio.cleanup();
  super.stop();
}
