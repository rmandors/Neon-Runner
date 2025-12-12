class UIManager {
  void display(int score, float gameSpeed, Player player, boolean slowMotion, 
               float slowMotionTimer, float scoreMultiplier, float scoreMultiplierTimer,
               int levelNotification, float levelNotificationTimer){
    fill(#FFFFFF);
    textSize(24);
    textAlign(LEFT, TOP);
    text("Score: " + int(score), 20, 20);
    
    textSize(16);
    text("Speed: " + nf(gameSpeed, 1, 1) + "x", 20, 50);
    
    int yOffset = 80;
    if(player.hasShield){
      fill(#FFFF00);
      text("SHIELD: " + nf(player.shieldTimer, 1, 1) + "s", 20, yOffset);
      yOffset += 25;
    }
    if(player.rapidFire){
      fill(#00FF00);
      text("RAPID FIRE: " + nf(player.rapidFireTimer, 1, 1) + "s", 20, yOffset);
      yOffset += 25;
    }
    if(slowMotion){
      fill(#00FFFF);
      text("SLOW MOTION: " + nf(slowMotionTimer, 1, 1) + "s", 20, yOffset);
      yOffset += 25;
    }
    if(scoreMultiplier > 1.0){
      fill(#FF00FF);
      text("SCORE x" + scoreMultiplier + ": " + nf(scoreMultiplierTimer, 1, 1) + "s", 20, yOffset);
    }
    
    if(levelNotification > 0 && levelNotificationTimer > 0){
      float progress = levelNotificationTimer / 2.0;
      float alpha = 255;
      float scale = 1.0;
      
      if(progress > 0.85)
        alpha = map(progress, 0.85, 1.0, 255, 0);
      else if(progress < 0.15){
        alpha = map(progress, 0.0, 0.15, 0, 255);
        scale = map(progress, 0.0, 0.15, 0.8, 1.0);
      }
      
      pushStyle();
      pushMatrix();
      
      translate(width/2, height/2);
      scale(scale);
      
      fill(0, 0, 51, alpha * 0.7);
      noStroke();
      rectMode(CENTER);
      rect(0, 0, 400, 150, 15);
      
      fill(#00FFFF, alpha);
      textSize(72);
      textAlign(CENTER, CENTER);
      text("LEVEL " + levelNotification, 0, 0);
      
      // Glow effect with multiple layers
      for(int i = 0; i < 3; i++){
        fill(#00FFFF, alpha * (0.3 - i * 0.1));
        textSize(72 + i * 4);
        text("LEVEL " + levelNotification, 0, 0);
      }
      
      fill(#00FFFF, alpha);
      textSize(72);
      text("LEVEL " + levelNotification, 0, 0);
      
      popMatrix();
      popStyle();
    }
  } 
}
