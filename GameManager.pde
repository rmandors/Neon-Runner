class GameManager {
  Player player;
  ArrayList<Enemy> enemies;
  ArrayList<PowerUp> powerUps;
  ArrayList<Obstacle> obstacles;
  ParticleSystem particles;
  
  float gameSpeed = 1.0;
  float baseGameSpeed = 1.0;
  int score = 0;
  int highScore = 0;
  float difficultyTimer = 0;
  float difficultyInterval = 5.0;
  int currentLevel = 1;
  int levelNotification = 0;
  float levelNotificationTimer = 0;
  int comboKills = 0;
  float comboMultiplier = 1.0;
  float scoreMultiplier = 1.0;
  float scoreMultiplierTimer = 0;
  boolean slowMotion = false;
  float slowMotionTimer = 0;
  float survivalScoreInterval = 1.0;
  float survivalScoreTimer = 0.0;
  
  float enemySpawnTimer = 0;
  float powerUpSpawnTimer = 0;
  float obstacleSpawnTimer = 0;
  
  GameAudio audio;
  LeaderboardManager leaderboardManager;
  String currentPlayerUsername = "";
  
  GameManager(GameAudio audio, LeaderboardManager leaderboardManager){
    this.audio = audio;
    this.leaderboardManager = leaderboardManager;
    reset();
  }
  
  void setPlayerUsername(String username){
    this.currentPlayerUsername = username;
  }
  
  void reset(){
    player = new Player(width/2, height - 100);
    player.reset();
    enemies = new ArrayList<Enemy>();
    powerUps = new ArrayList<PowerUp>();
    obstacles = new ArrayList<Obstacle>();
    particles = new ParticleSystem();
    
    gameSpeed = 1.0;
    baseGameSpeed = 1.0;
    score = 0;
    difficultyTimer = 0;
    currentLevel = 1;
    levelNotification = 0;
    levelNotificationTimer = 0;
    comboKills = 0;
    comboMultiplier = 1.0;
    scoreMultiplier = 1.0;
    scoreMultiplierTimer = 0;
    slowMotion = false;
    slowMotionTimer = 0;
    
    enemySpawnTimer = 2.0;
    powerUpSpawnTimer = 8.0;
    obstacleSpawnTimer = 5.0;
    survivalScoreTimer = 0.0;
  }
  
  void update(){
    difficultyTimer += 1.0/60.0;
    
    if(difficultyTimer >= difficultyInterval){
      difficultyTimer = 0;
      int previousLevel = currentLevel;
      baseGameSpeed += 0.2;
      gameSpeed = baseGameSpeed;
      
      currentLevel = int(baseGameSpeed);
      if(currentLevel > previousLevel){
        levelNotification = currentLevel;
        levelNotificationTimer = 2.0;
      }
    }
    
    if(levelNotificationTimer > 0){
      levelNotificationTimer -= 1.0/60.0;
      if(levelNotificationTimer <= 0)
        levelNotification = 0;
    }
    
    if(slowMotion){
      gameSpeed = baseGameSpeed * 0.5;
      slowMotionTimer -= 1.0/60.0;
      if(slowMotionTimer <= 0){
        slowMotion = false;
        gameSpeed = baseGameSpeed;
      }
    }
    
    if(scoreMultiplierTimer > 0){
      scoreMultiplierTimer -= 1.0/60.0;
      if(scoreMultiplierTimer <= 0)
        scoreMultiplier = 1.0;
    }
    
    player.update();
    
    enemySpawnTimer -= 1.0/60.0;
    if(enemySpawnTimer <= 0){
      spawnEnemy();
      enemySpawnTimer = 2.0 / gameSpeed;
    }
    
    powerUpSpawnTimer -= 1.0/60.0;
    if(powerUpSpawnTimer <= 0){
      if(random(1) < 0.3)
        spawnPowerUp();
      powerUpSpawnTimer = 8.0;
    }
    
    obstacleSpawnTimer -= 1.0/60.0;
    if(obstacleSpawnTimer <= 0){
      if(random(1) < 0.4)
        spawnObstacle();
      obstacleSpawnTimer = 5.0;
    }
    
    for(int i = enemies.size() - 1; i >= 0; i--){
      Enemy e = enemies.get(i);
      e.movePattern();
      e.update();
      
      for(PlayerBullet bullet : player.getBullets()){
        if(e.checkCollision(bullet)){
          e.takeDamage(1);
          bullet.isActive = false;
          if(!e.isActive){
            addScore(e.points);
            comboKills++;
            particles.addExplosion(e.position.x, e.position.y, e.objectColor, 15);
            audio.playEnemyKilledSound();
          }
        }
      }
      
      if(player.checkCollision(e)){
        player.takeDamage();
        particles.addExplosion(e.position.x, e.position.y, e.objectColor, 20);
        e.isActive = false;
        audio.playCollisionSound();
      }
      
      for(EnemyBullet bullet : e.getBullets()){
        if(player.checkCollision(bullet)){
          player.takeDamage();
          bullet.isActive = false;
          particles.addExplosion(bullet.position.x, bullet.position.y, bullet.objectColor, 10);
          audio.playCollisionSound();
        }
      }
      
      if(e.isOutOfBounds() || !e.isActive)
        enemies.remove(i);
    }
    
    for(int i = powerUps.size() - 1; i >= 0; i--){
      PowerUp p = powerUps.get(i);
      p.update();
      
      if(p.checkCollision(player)){
        p.applyEffect(player);
        addScore(50);
        particles.addExplosion(p.position.x, p.position.y, p.objectColor, 10);
        
        if(p instanceof ShieldPowerUp){
          audio.playShieldPowerUpSound();
        } 
        else if(p instanceof RapidFirePowerUp){
          audio.playRapidFirePowerUpSound();
        } 
        else if(p instanceof SlowMoPowerUp){
          slowMotion = true;
          slowMotionTimer = 3.0;
          audio.playSlowMotionPowerUpSound();
        } 
        else if(p instanceof ScoreMultiplierPowerUp){
          scoreMultiplier = 2.0;
          scoreMultiplierTimer = 10.0;
          audio.playScoreMultiplierPowerUpSound();
        }
        
        powerUps.remove(i);
      } 
      else if(p.isOutOfBounds()){
        powerUps.remove(i);
      }
    }
    
    for(int i = obstacles.size() - 1; i >= 0; i--){
      Obstacle o = obstacles.get(i);
      o.update();
      
      if(o.checkCollision(player)){
        player.takeDamage();
        particles.addExplosion(o.position.x, o.position.y, o.objectColor, 15);
        obstacles.remove(i);
        audio.playCollisionSound();
      } 
      else if(o.isOutOfBounds()){
        obstacles.remove(i);
      }
    }
    
    particles.update();
    
    survivalScoreTimer += 1.0/60.0;
    if(survivalScoreTimer >= survivalScoreInterval){
      addScore(10);
      survivalScoreTimer = 0.0;
    }
    
    if(comboKills >= 5){
      comboMultiplier = 1.5;
      comboKills = 0;
    } 
    else{
      comboMultiplier = 1.0;
    }
  }
  
  void display(){
    for(Obstacle o : obstacles)
      o.display();
    
    for(Enemy e : enemies){
      e.display();
      for(EnemyBullet bullet : e.getBullets())
        bullet.display();
    }
    
    for(PowerUp p : powerUps)
      p.display();
    
    player.display();
    
    for(PlayerBullet bullet : player.getBullets())
      bullet.display();
    
    particles.display();
  }
  
  void spawnEnemy(){
    float x = random(50, width - 50);
    float y = -50;
    
    float rand = random(1);
    if(rand < 0.5)
      enemies.add(new BasicEnemy(x, y));
    else if(rand < 0.8)
      enemies.add(new FastEnemy(x, y));
    else
      enemies.add(new TankEnemy(x, y));
  }
  
  void spawnPowerUp(){
    float x = random(50, width - 50);
    float y = -50;
    
    float rand = random(1);
    if(rand < 0.3)
      powerUps.add(new ShieldPowerUp(x, y));
    else if(rand < 0.6)
      powerUps.add(new RapidFirePowerUp(x, y));
    else if(rand < 0.8)
      powerUps.add(new SlowMoPowerUp(x, y));
    else
      powerUps.add(new ScoreMultiplierPowerUp(x, y));
  }
  
  void spawnObstacle(){
    float x = random(50, width - 50);
    float y = -50;
    
    float rand = random(1);
    if(rand < 0.5){
      float w = random(30, 80);
      float h = random(20, 40);
      obstacles.add(new Wall(x, y, w, h));
    } 
    else{
      obstacles.add(new MovingObstacle(x, y, random(20, 35)));
    }
  }
  
  void addScore(int points){
    score += int(points * scoreMultiplier * comboMultiplier);
  }
  
  boolean checkGameOver(){
    if(!player.isActive){
      if(score > highScore)
        highScore = score;
      if(leaderboardManager != null)
        leaderboardManager.addScore(score, currentPlayerUsername);
      audio.playGameOverSound();
      return true;
    }
    return false;
  }
  
  float getGameSpeed(){ 
    return gameSpeed; 
  }

  int getScore(){ 
    return score; 
  }

  int getHighScore(){ 
    if(leaderboardManager != null)
      return leaderboardManager.getTopScore();
    return highScore; 
  }
  Player getPlayer(){ 
    return player; 
  }

  boolean isSlowMotion(){
     return slowMotion; 
  }
  float getSlowMotionTimer(){ 
    return slowMotionTimer; 
  }
  float getScoreMultiplier(){ 
    return scoreMultiplier; 
  }

  float getScoreMultiplierTimer(){ 
    return scoreMultiplierTimer; 
  }

  int getLevelNotification(){ 
    return levelNotification; 
  }

  float getLevelNotificationTimer(){ 
    return levelNotificationTimer; 
  }

  LeaderboardManager getLeaderboardManager(){ 
    return leaderboardManager; 
  }  
}
