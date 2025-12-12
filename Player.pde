// Player character with movement, shooting, power-ups, and visual trail
class Player extends GameObject {
  float speed;
  float shootCooldown;
  float shootTimer;
  boolean hasShield;
  float shieldTimer;
  boolean rapidFire;
  float rapidFireTimer;
  ArrayList<PlayerBullet> bullets;
  float trailLength;
  ArrayList<PVector> trail;
  int framesSinceReset = 0;
  
  boolean moveUp, moveDown, moveLeft, moveRight, shootHeld;
  
  Player(float x, float y){
    super(x, y, 20, #00FFFF); 
    this.speed = 5;
    this.shootCooldown = 0.3; 
    this.shootTimer = 0;
    this.hasShield = false;
    this.shieldTimer = 0;
    this.rapidFire = false;
    this.rapidFireTimer = 0;
    this.bullets = new ArrayList<PlayerBullet>();
    this.trailLength = 10;
    this.trail = new ArrayList<PVector>();
    this.framesSinceReset = 0;
  }
  
  void update(){
    framesSinceReset++;
    handleInput();
    
    position.add(velocity);
    
    // Keep player within screen bounds
    position.x = constrain(position.x, size/2, width - size/2);
    position.y = constrain(position.y, size/2, height - size/2);
    
    // Update timers for shooting and power-ups
    if(shootTimer > 0) 
      shootTimer -= 1.0/60.0;
      
    if(shieldTimer > 0){
      shieldTimer -= 1.0/60.0;
      if(shieldTimer <= 0) 
        hasShield = false;
    }
    
    if(rapidFireTimer > 0){
      rapidFireTimer -= 1.0/60.0;
      if(rapidFireTimer <= 0) 
        rapidFire = false;
    }
    
    // Update and clean up bullets
    for(int i = bullets.size() - 1; i >= 0; i--){
      PlayerBullet b = bullets.get(i);
      b.update();
      if(b.isOutOfBounds() || !b.isActive)
        bullets.remove(i);
    }
    
    // Maintain visual trail effect
    trail.add(new PVector(position.x, position.y));
    if(trail.size() > trailLength)
      trail.remove(0);
    
    velocity.mult(0);
  }
  
  void reset(){
    framesSinceReset = 0;
    velocity.set(0, 0);
    moveUp = moveDown = moveLeft = moveRight = shootHeld = false;
  }
  
  // Process movement and shooting input
  void handleInput(){
    if(framesSinceReset <= 1)
      return;
    
    if(moveUp)
      velocity.y = -speed;
    if(moveDown)
      velocity.y = speed;
    if(moveLeft)
      velocity.x = -speed;
    if(moveRight)
      velocity.x = speed;
    
    // Shooting with rapid fire power-up support
    if(shootHeld && shootTimer <= 0){
      shoot();
      float cooldown = rapidFire? shootCooldown * 0.3 : shootCooldown;
      shootTimer = cooldown;
    }
  }
  
  void handleKeyPressed(char key, int keyCode){
    if(key == 'w' || key == 'W' || keyCode == UP) 
      moveUp = true;
    if(key == 's' || key == 'S' || keyCode == DOWN) 
      moveDown = true;
    if(key == 'a' || key == 'A' || keyCode == LEFT) 
      moveLeft = true;
    if(key == 'd' || key == 'D' || keyCode == RIGHT) 
      moveRight = true;
    if(key == ' ') 
      shootHeld = true;
  }
  
  void handleKeyReleased(char key, int keyCode){
    if(key == 'w' || key == 'W' || keyCode == UP) 
      moveUp = false;
    if(key == 's' || key == 'S' || keyCode == DOWN) 
      moveDown = false;
    if(key == 'a' || key == 'A' || keyCode == LEFT) 
      moveLeft = false;
    if(key == 'd' || key == 'D' || keyCode == RIGHT) 
      moveRight = false;
    if(key == ' ') 
      shootHeld = false;
  }
  
  void shoot(){
    bullets.add(new PlayerBullet(position.x, position.y - size/2));
    gameAudio.playPlayerShotSound();
  }
  
  // Render player with trail effect and shield indicator
  void display(){
    pushMatrix();
    translate(position.x, position.y);
    
    // Draw fading trail effect
    for(int i = 0; i < trail.size(); i++){
      float alpha = map(i, 0, trail.size(), 0, 255);
      stroke(objectColor, alpha);
      strokeWeight(2);
      if(i > 0){
        line(trail.get(i-1).x - position.x, trail.get(i-1).y - position.y,
             trail.get(i).x - position.x, trail.get(i).y - position.y);
      }
    }
    
    // Shield visual indicator
    if(hasShield){
      noFill();
      stroke(#FFFF00, 150); 
      strokeWeight(3);
      ellipse(0, 0, size * 2.5, size * 2.5);
    }
    
    // Player ship 
    fill(objectColor);
    stroke(objectColor);
    strokeWeight(2);
    beginShape();
    vertex(0, -size);
    vertex(-size/2, size/2);
    vertex(size/2, size/2);
    endShape(CLOSE);
    
    fill(objectColor, 100);
    noStroke();
    ellipse(0, 0, size * 1.5, size * 1.5);
    
    popMatrix();
  }
  
  boolean checkCollision(GameObject other){
    if(other instanceof Enemy || other instanceof Obstacle || other instanceof EnemyBullet){
      float dist = distanceTo(other);
      float minDist = (size + other.size) / 2;
      return (dist < minDist);
    }
    return false;
  }
  
  void activateShield(float duration){
    hasShield = true;
    shieldTimer = duration;
  }
  
  void activateRapidFire(float duration){
    rapidFire = true;
    rapidFireTimer = duration;
  }
  
  // Handle damage, shield absorbs one hit, otherwise player dies
  void takeDamage(){
    if(!hasShield)
      isActive = false;
    else{
      hasShield = false;
      shieldTimer = 0;
    }
  }
  
  ArrayList<PlayerBullet> getBullets(){
    return bullets;
  }
}
