// Base class for power-ups with rotation and pulsing animation
abstract class PowerUp extends GameObject {
  float rotation;
  float rotationSpeed;
  float pulse;
  float pulseSpeed;
  
  PowerUp(float x, float y, float size, color c){
    super(x, y, size, c);
    this.rotation = 0;
    this.rotationSpeed = 0.05;
    this.pulse = 0;
    this.pulseSpeed = 0.1;
    velocity.y = 1;
  }
  
  void update(){
    velocity.y = 1 + gameSpeed;
    position.add(velocity);
    rotation += rotationSpeed;
    pulse += pulseSpeed;
  }
  
  // Render with pulsing glow effect and rotation
  void display(){
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);
    
    float pulseSize = size + sin(pulse) * 3;
    
    fill(objectColor, 100);
    noStroke();
    ellipse(0, 0, pulseSize * 2, pulseSize * 2);
    
    fill(objectColor);
    stroke(objectColor);
    strokeWeight(2);
    drawPowerUpShape(pulseSize);
    
    popMatrix();
  }
  
  abstract void drawPowerUpShape(float size);
  abstract void applyEffect(Player player);
  
  boolean checkCollision(GameObject other){
    if(other instanceof Player){
      float dist = distanceTo(other);
      float minDist = (size + other.size) / 2;
      return (dist < minDist);
    }
    return false;
  }
}

class ShieldPowerUp extends PowerUp{
  ShieldPowerUp(float x, float y){
    super(x, y, 15, #FFFF00);
  }
  
  void drawPowerUpShape(float size){
    ellipse(0, 0, size, size);
    strokeWeight(3);
    line(-size/3, 0, size/3, 0);
    line(0, -size/3, 0, size/3);
  }
  
  void applyEffect(Player player){
    player.activateShield(5.0);
  }
}

class RapidFirePowerUp extends PowerUp{
  RapidFirePowerUp(float x, float y){
    super(x, y, 15, #00FF00);
  }
  
  void drawPowerUpShape(float size){
    beginShape();
    vertex(0, -size/2);
    vertex(size/4, 0);
    vertex(-size/4, 0);
    vertex(0, size/2);
    endShape(CLOSE);
  }
  
  void applyEffect(Player player){
    player.activateRapidFire(7.0);
  }
}

class SlowMoPowerUp extends PowerUp{
  SlowMoPowerUp(float x, float y) {
    super(x, y, 15, #00FFFF);
  }
  
  void drawPowerUpShape(float size){
    ellipse(0, 0, size, size);
    strokeWeight(2);
    line(0, 0, 0, -size/3);
    line(0, 0, size/4, 0);
  }
  
  void applyEffect(Player player){}
}

class ScoreMultiplierPowerUp extends PowerUp{
  ScoreMultiplierPowerUp(float x, float y){
    super(x, y, 15, #FF00FF);
  }
  
  void drawPowerUpShape(float size){
    beginShape();
    for (int i = 0; i < 5; i++) {
      float angle = TWO_PI / 5 * i - HALF_PI;
      vertex(cos(angle) * size/2, sin(angle) * size/2);
      angle += TWO_PI / 10;
      vertex(cos(angle) * size/4, sin(angle) * size/4);
    }
    endShape(CLOSE);
  }
  
  void applyEffect(Player player){} 
}
