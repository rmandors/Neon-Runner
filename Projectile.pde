abstract class Projectile extends GameObject{
  float speed;
  
  Projectile(float x, float y, float size, color c, float speed){
    super(x, y, size, c);
    this.speed = speed;
  }
  
  void update(){
    position.add(velocity);
  }
  
  void display(){
    pushMatrix();
    translate(position.x, position.y);
    
    fill(objectColor);
    stroke(objectColor);
    strokeWeight(2);
    ellipse(0, 0, size, size);
    
    fill(objectColor, 150);
    noStroke();
    ellipse(0, 0, size * 1.5, size * 1.5);
    
    popMatrix();
  }
  
  boolean checkCollision(GameObject other){
    float dist = distanceTo(other);
    float minDist = (size + other.size) / 2;
    return (dist < minDist);
  }
}

class PlayerBullet extends Projectile{
  PlayerBullet(float x, float y){
    super(x, y, 5, #00FFFF, 8); 
    velocity.y = -speed;
  }
  
  void update(){
    super.update();
  }
}

class EnemyBullet extends Projectile{
  EnemyBullet(float x, float y){
    super(x, y, 6, #FF00FF, 4); 
    velocity.y = speed;
  }
  
  void update(){
    // enemy bullets get faster as game speeds up
    velocity.y = speed + 1 + gameSpeed;
    super.update();
  } 
}
