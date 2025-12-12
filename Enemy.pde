abstract class Enemy extends GameObject {
  int health;
  int maxHealth;
  int points;
  float shootCooldown;
  float shootTimer;
  ArrayList<EnemyBullet> bullets;
  
  Enemy(float x, float y, float size, color c, int health, int points){
    super(x, y, size, c);
    this.health = health;
    this.maxHealth = health;
    this.points = points;
    this.shootCooldown = 2.0;
    this.shootTimer = random(shootCooldown);
    this.bullets = new ArrayList<EnemyBullet>();
  }
  
  void update(){
    position.add(velocity);
    
    if(shootTimer > 0)
      shootTimer -= 1.0/60.0;
    
    for(int i = bullets.size() - 1; i >= 0; i--){
      EnemyBullet b = bullets.get(i);
      b.update();
      if(b.isOutOfBounds() || !b.isActive)
        bullets.remove(i);
    }
    
    if(shootTimer <= 0 && position.y > 0){
      shoot();
      shootTimer = shootCooldown;
    }
  }
  
  void shoot(){
    gameAudio.playEnemyShotSound();
    shootImpl();
  }
  
  abstract void shootImpl();
  abstract void movePattern();
  
  void display(){
    pushMatrix();
    translate(position.x, position.y);
    
    fill(objectColor);
    stroke(objectColor);
    strokeWeight(2);
    drawEnemyShape();
    
    if(health < maxHealth){
      float barWidth = size * 2;
      float barHeight = 5;
      fill(#FF0000);
      rect(-barWidth/2, -size - 15, barWidth, barHeight);
      fill(#00FF00);
      rect(-barWidth/2, -size - 15, barWidth * (float(health)/maxHealth), barHeight);
    }
    
    fill(objectColor, 80);
    noStroke();
    ellipse(0, 0, size * 1.3, size * 1.3);
    
    popMatrix();
  }
  
  abstract void drawEnemyShape();
  
  boolean checkCollision(GameObject other){
    if(other instanceof PlayerBullet){
      float dist = distanceTo(other);
      float minDist = (size + other.size) / 2;
      return (dist < minDist);
    }
    return false;
  }
  
  void takeDamage(int damage){
    health -= damage;
    if(health <= 0)
      isActive = false;
  }
  
  ArrayList<EnemyBullet> getBullets(){
    return bullets;
  }
}

class BasicEnemy extends Enemy{
  BasicEnemy(float x, float y){
    super(x, y, 15, #FF00FF, 1, 100);
    velocity.y = 2;
  }
  
  void movePattern(){
    velocity.y = 2 + gameSpeed;
  }
  
  void shootImpl(){
    bullets.add(new EnemyBullet(position.x, position.y + size/2));
  }
  
  void drawEnemyShape(){
    rectMode(CENTER);
    rect(0, 0, size, size);
  }
}

class FastEnemy extends Enemy{
  float angle;
  float angleSpeed;
  
  FastEnemy(float x, float y){
    super(x, y, 12, #FFFF00, 1, 150);
    velocity.y = 3;
    angle = 0;
    angleSpeed = 0.1;
  }
  
  void movePattern(){
    angle += angleSpeed;
    velocity.y = 3 + gameSpeed;
    velocity.x = sin(angle) * 2;
  }
  
  void shootImpl(){
    bullets.add(new EnemyBullet(position.x, position.y + size/2));
  }
  
  void drawEnemyShape(){
    beginShape();
    vertex(0, -size/2);
    vertex(size/2, 0);
    vertex(0, size/2);
    vertex(-size/2, 0);
    endShape(CLOSE);
  }
}

class TankEnemy extends Enemy {
  TankEnemy(float x, float y){
    super(x, y, 25, #FF6600, 3, 250);
    velocity.y = 1;
    shootCooldown = 1.5;
  }
  
  void movePattern(){
    velocity.y = 1 + gameSpeed * 0.5;
  }
  
  void shootImpl(){
    bullets.add(new EnemyBullet(position.x - size/3, position.y + size/2));
    bullets.add(new EnemyBullet(position.x + size/3, position.y + size/2));
  }
  
  void drawEnemyShape(){
    beginShape();
    for (int i = 0; i < 6; i++) {
      float angle = TWO_PI / 6 * i;
      vertex(cos(angle) * size/2, sin(angle) * size/2);
    }
    endShape(CLOSE);
  }
}
