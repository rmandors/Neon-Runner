// Manages all menu screens, navigation, and user input
class MenuManager {
  PImage titleScreen;
  PImage gameOverScreen;
  PImage handSelection;
  PImage handSelection2;
  PImage instructionsScreen;
  PImage leaderboardsScreen;
  PImage settingsScreen;
  
  int menuSelection = 0;
  int totalMenuOptions = 4;
  
  private String usernameInput = "";
  int maxUsernameLength = 10;
  boolean usernameReady = false;
  
  int settingsSelection = 0;
  boolean musicEnabled = true;
  boolean sfxEnabled = true;
  int musicVolume = 100;
  int sfxVolume = 100;
  int totalSettingsOptions = 4;
  
  String getUsernameInput(){
    return usernameInput;
  }
  
  MenuManager(){
    loadImages();
  }
  
  void loadImages(){
    titleScreen = loadImage("data/images/Tittle_screen.png");
    gameOverScreen = loadImage("data/images/GameOver_screen.png");
    handSelection = loadImage("data/images/Hand_selection.png");
    handSelection2 = loadImage("data/images/Hand_selection2.png");
    instructionsScreen = loadImage("data/images/Instructions_screen.png");
    leaderboardsScreen = loadImage("data/images/Leaderboards_screen.png");
    settingsScreen = loadImage("data/images/Settings_screen.png");
  }
  
  // Displays main menu with selection indicators
  void displayMenu(){
    background(#000033);
    
    image(titleScreen, 0, 0, width, height);
    
    // Position selection hand icons based on current menu selection
    float iconX = width/2 - 255;
    float iconY = height/2 + 60;
    float iconXRight = iconX + 435;
    
    if(menuSelection == 1){
      iconX = width/2 - 200;
      iconY = height/2 + 125;
      iconXRight = iconX + 325;
    } 
    else if(menuSelection == 2){
      iconX = width/2 - 185;
      iconY = height/2 + 168;
      iconXRight = iconX + 295;
    } 
    else if(menuSelection == 3){
      iconX = width/2 - 150;
      iconY = height/2 + 210;
      iconXRight = iconX + 225;
    }
    
    image(handSelection, iconX, iconY, 70, 45);
    image(handSelection2, iconXRight, iconY, 70, 45);
  }
  
  // Displays game over screen with score and achievement notifications
  void displayGameOver(int score, int highScore, LeaderboardManager leaderboardManager){
    image(gameOverScreen, 0, 0, width, height);
    
    float scoreX = width/2 + 25;
    float scoreY = height/2 + 145;
    
    fill(#FFFFFF);
    textSize(28);
    textAlign(LEFT, CENTER);
    text(int(score), scoreX, scoreY);
    
    // Check for achievements (new high score or leaderboard entry)
    boolean isNewHighScore = false;
    if(leaderboardManager != null){
      isNewHighScore = leaderboardManager.isNewHighScore(score);
      ArrayList<LeaderboardEntry> entries = leaderboardManager.getLeaderboard();
      boolean madeLeaderboard = false;
      for(LeaderboardEntry entry : entries){
        if(entry.score == score){
          madeLeaderboard = true;
          break;
        }
      }
      
      if(isNewHighScore){
        fill(#FFFF00);
        textSize(24);
        textAlign(CENTER, CENTER);
        text("NEW HIGH SCORE!", width/2, height/2 + 80);
      } 
      else if(madeLeaderboard && score > 0){
        fill(#00FF00);
        textSize(20);
        textAlign(CENTER, CENTER);
        text("MADE IT TO LEADERBOARD!", width/2, height/2 + 80);
      }
    } 
    else if(score == highScore && score > 0){
      fill(#FFFF00);
      textSize(24);
      textAlign(CENTER, CENTER);
      text("NEW HIGH SCORE!", width/2, height/2 + 80);
    }
  }
  
  void displayLeaderboards(int highScore, int score){}
  
  // Displays leaderboard entries with highlighting for recently added scores
  void displayLeaderboardEntries(LeaderboardManager leaderboardManager, int currentScore){
    ArrayList<LeaderboardEntry> entries = leaderboardManager.getLeaderboard();
    pushStyle();
    rectMode(CORNER);
    
    image(leaderboardsScreen, 0, 0, width, height);
    
    fill(0, 0, 51, 140);
    noStroke();
    rect(width/2 - 310, 185, 630, 340, 12);
    
    String lastAddedUsername = leaderboardManager.getLastAddedUsername();
    int lastAddedScore = leaderboardManager.getLastAddedScore();
    
    fill(#FFFFFF);
    textSize(20);
    int startY = 200;
    int lineHeight = 34;
    int maxDisplay = min(10, entries.size());
    
    // Display top 10 entries, highlight newly added entry
    for(int i = 0; i < maxDisplay; i++){
      LeaderboardEntry entry = entries.get(i);
      int yPos = startY + (i * lineHeight);
      
      if(entry.score == lastAddedScore && 
         entry.username.equals(lastAddedUsername) && lastAddedScore > 0)
        fill(#00FF00);
      else
        fill(#FFFFFF);
      
      textAlign(LEFT, CENTER);
      text("#" + (i + 1), width/2 - 270, yPos);
      
      textAlign(LEFT, CENTER);
      String displayUsername = entry.username;
      text(displayUsername, width/2 - 135, yPos);
      
      text(nf(entry.score, 0), width/2 + 75, yPos);
      
      text(entry.date, width/2 + 215, yPos);
    }
    
    if(entries.size() == 0){
      fill(#FFFFFF);
      textSize(24);
      textAlign(CENTER, CENTER);
      text("No scores yet!", width/2, height/2);
      text("Play a game to set your first score!", width/2, height/2 + 40);
    }
    
    popStyle();
  }
  
  void displayInstructions(){
    pushStyle();
    rectMode(CORNER);
    
    image(instructionsScreen, 0, 0, width, height);
    
    fill(0, 0, 0, 180);
    noStroke();
    rect(width/2 - 290, 110, 590, 400, 12);
    
    fill(#00FFFF);
    textSize(32);
    textAlign(LEFT, TOP);
    float textX = width/2 - 250;
    float textY = 130;
    text("CONTROLS:", textX, textY);
    
    fill(#FFFFFF);
    textSize(18);
    textAlign(LEFT, TOP);
    textY += 36;
    float lineH = 24;
    
    text("• WASD or Arrow Keys: Move", textX, textY);
    textY += lineH;
    text("• SPACE: Shoot", textX, textY);
    textY += lineH * 1.8;
    
    fill(#00FFFF);
    textSize(28);
    textAlign(LEFT, TOP);
    text("POWER-UPS:", textX, textY);
    textY += lineH * 1.5;
    
    textSize(18);
    textAlign(LEFT, TOP);
    
    fill(#FFFF00);
    text("• Shield (Yellow): Protection (5s)", textX, textY);
    textY += lineH;
    
    fill(#00FF00);
    text("• Rapid Fire (Green): Faster shooting (7s)", textX, textY);
    textY += lineH;
    
    fill(#00FFFF);
    text("• Slow Motion (Cyan): Slow time (3s)", textX, textY);
    textY += lineH;
    
    fill(#FF00FF);
    text("• Score Multiplier (Magenta): 2x points (10s)", textX, textY);
    textY += lineH * 1.8;
    
    fill(#00FFFF);
    textSize(28);
    textAlign(LEFT, TOP);
    text("SCORING:", textX, textY);
    textY += lineH * 1.5;
    
    fill(#FFFFFF);
    textSize(18);
    textAlign(LEFT, TOP);
    text("• Survival: 10 points/second", textX, textY);
    textY += lineH;
    text("• Enemy kills: 100-250 points", textX, textY);
    textY += lineH;
    text("• Combo bonus: 1.5x for 5 kills", textX, textY);
    
    popStyle();
  }
  
  void displaySettings(){
    pushStyle();
    rectMode(CORNER);
    
    image(settingsScreen, 0, 0, width, height);
    
    fill(0, 0, 0, 180);
    noStroke();
    rect(width/2 - 250, 140, 500, 340, 12);
    
    textSize(22);
    int startY = 180;
    int lineH = 40;
    
    fill(#00FFFF);
    textSize(26);
    textAlign(LEFT, CENTER);
    text("MUSIC", width/2 - 180, startY);
    
    textSize(22);
    for(int i = 0; i < 2; i++){
      boolean isSelected = (i == settingsSelection);
      if(isSelected)
        fill(#00FFFF);
      else
        fill(#FFFFFF);
      
      String label = "";
      if(i == 0)
        label = "Music: " + (musicEnabled? "ON" : "OFF");
      else if(i == 1)
        label = "Music Volume: " + musicVolume + "%";
      
      textAlign(LEFT, CENTER);
      text(label, width/2 - 180, startY + 35 + i * lineH);
    }
    
    fill(#00FFFF);
    textSize(26);
    textAlign(LEFT, CENTER);
    text("SFX", width/2 - 180, startY + 35 + 2 * lineH + 20);
    
    textSize(22);
    for(int i = 2; i < totalSettingsOptions; i++){
      boolean isSelected = (i == settingsSelection);
      if(isSelected)
        fill(#00FFFF);
      else
        fill(#FFFFFF);
      
      String label = "";
      if(i == 2)
        label = "SFX: " + (sfxEnabled? "ON" : "OFF");
      else if(i == 3)
        label = "SFX Volume: " + sfxVolume + "%";
      
      textAlign(LEFT, CENTER);
      text(label, width/2 - 180, startY + 35 + 2 * lineH + 20 + 35 + (i - 2) * lineH);
    }
    
    popStyle();
  }
  
  void navigateUp(){
    menuSelection = (menuSelection - 1 + totalMenuOptions) % totalMenuOptions;
  }
  
  void navigateDown(){
    menuSelection = (menuSelection + 1) % totalMenuOptions;
  }
  
  void navigateSettingsUp(){
    settingsSelection = (settingsSelection - 1 + totalSettingsOptions) % totalSettingsOptions;
  }
  
  void navigateSettingsDown(){
    settingsSelection = (settingsSelection + 1) % totalSettingsOptions;
  }
  
  void toggleSelectedSetting(){
    if(settingsSelection == 0)
      musicEnabled = !musicEnabled;
    else if(settingsSelection == 2)
      sfxEnabled = !sfxEnabled;
  }
  
  boolean isToggleableSetting(){
    return (settingsSelection == 0 || settingsSelection == 2);
  }
  
  void adjustVolume(int direction){
    if(settingsSelection == 1){
      musicVolume += direction * 10;
      if(musicVolume < 0) 
        musicVolume = 0;
      if(musicVolume > 100) 
        musicVolume = 100;
    } 
    else if(settingsSelection == 3){
      sfxVolume += direction * 10;
      if(sfxVolume < 0) 
        sfxVolume = 0;
      if(sfxVolume > 100) 
        sfxVolume = 100;
    }
  }
  
  boolean isMusicEnabled(){ 
    return musicEnabled; 
  }

  boolean isSfxEnabled(){ 
    return sfxEnabled; 
  }

  int getMusicVolume(){ 
    return musicVolume; 
  }

  int getSfxVolume(){ 
    return sfxVolume; 
  }

  int getSettingsSelection(){
    return settingsSelection; 
  }
  
  int getSelection(){
    return menuSelection;
  }
  
  GameState selectOption(){
    switch(menuSelection){
      case 0:
        return GameState.PLAYING;
      case 1:
        return GameState.LEADERBOARDS;
      case 2:
        return GameState.INSTRUCTIONS;
      case 3:
        return GameState.SETTINGS;
      default:
        return GameState.MENU;
    }
  }
  
  // Displays username input screen with blinking cursor
  void displayUsernameInput(String currentUsername){
    pushStyle();
    
    background(0);
    
    rectMode(CORNER);
    textAlign(LEFT, BASELINE);
    noStroke();
    
    fill(#00FFFF);
    textSize(36);
    textAlign(CENTER, CENTER);
    text("ENTER YOUR USERNAME", width/2, height/2 - 100);
    
    float boxX = width/2 - 200;
    float boxY = height/2 - 20;
    float boxW = 400;
    float boxH = 50;
    
    fill(20, 20, 20);
    stroke(#00FFFF);
    strokeWeight(2);
    rect(boxX, boxY, boxW, boxH);
    noStroke();
    
    fill(#FFFFFF);
    textSize(24);
    textAlign(LEFT, CENTER);
    
    String displayText = currentUsername;
    boolean isEmpty = (currentUsername.length() == 0);
    
    if(isEmpty){
      fill(100, 100, 100);
      displayText = "Type your username...";
    }
    
    float textX = boxX + 10;
    float textY = boxY + boxH / 2;
    
    text(displayText, textX, textY);
    
    // Blinking cursor animation
    if(!isEmpty && frameCount % 60 < 30 && currentUsername.length() < maxUsernameLength){
      stroke(#00FFFF);
      strokeWeight(2);
      float cursorX = textX + textWidth(currentUsername);
      float cursorYTop = boxY + 10;
      float cursorYBottom = boxY + boxH - 10;
      line(cursorX, cursorYTop, cursorX, cursorYBottom);
      noStroke();
    }
    
    fill(#00FFFF);
    textSize(18);
    textAlign(CENTER, CENTER);
    text("Max " + maxUsernameLength + " characters", width/2, height/2 + 60);
    
    textAlign(LEFT, BASELINE);
    
    popStyle();
  }
  
  // Handles keyboard input for username entry (uppercase, max length enforced)
  void handleUsernameInput(char key, int keyCode){
    if(keyCode == BACKSPACE){
      if(usernameInput.length() > 0)
        usernameInput = usernameInput.substring(0, usernameInput.length() - 1);
    } 
    else if(keyCode == ENTER || keyCode == RETURN){
      if(usernameInput.length() > 0)
        usernameReady = true;
    } 
    else if(keyCode == ESC){
      usernameInput = "";
      usernameReady = false;
    } 
    else if(key >= 32 && key <= 126){
      if(usernameInput.length() < maxUsernameLength)
        usernameInput += Character.toUpperCase(key);
    }
  }
  
  boolean isUsernameReady(){
    return usernameReady;
  }
  
  String getUsername(){
    return usernameInput.trim().toUpperCase();
  }
  
  void clearUsernameInput(){
    usernameInput = "";
    usernameReady = false;
  }  
}
