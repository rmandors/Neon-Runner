abstract class Obstacle extends GameObject {
  Obstacle(float x, float y, float size, color c){
    super(x, y, size, c);
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
    drawObstacleShape();
    
    fill(objectColor, 80);
    noStroke();
    ellipse(0, 0, size * 1.2, size * 1.2);
    
    popMatrix();
  }
  
  abstract void drawObstacleShape();
  
  boolean checkCollision(GameObject other){
    if(other instanceof Player){
      float dist = distanceTo(other);
      float minDist = (size + other.size) / 2;
      return (dist < minDist);
    }
    return false;
  }
}

// Rectangular wall obstacle with axis-aligned bounding box collision
class Wall extends Obstacle {
  float width;
  float height;
  
  Wall(float x, float y, float w, float h){
    super(x, y, max(w, h), #FF00FF);
    this.width = w;
    this.height = h;
    velocity.y = 2;
  }
  
  void update(){
    super.update();
    velocity.y = 2 + gameSpeed;
  }
  
  void drawObstacleShape(){
    rectMode(CENTER);
    rect(0, 0, width, height);
  }
  
  // Collision detection for rectangular wall
  boolean checkCollision(GameObject other){
    if(other instanceof Player){
      float playerX = other.position.x;
      float playerY = other.position.y;
      float playerSize = other.size;
      
      return (playerX + playerSize/2 > position.x - width/2 &&
              playerX - playerSize/2 < position.x + width/2 &&
              playerY + playerSize/2 > position.y - height/2 &&
              playerY - playerSize/2 < position.y + height/2);
    }
    return false;
  }
}

// Moving obstacle that oscillates horizontally while falling
class MovingObstacle extends Obstacle {
  float angle;
  float angleSpeed;
  float radius;
  
  MovingObstacle(float x, float y, float size){
    super(x, y, size, #FFFF00); 
    velocity.y = 2;
    angle = 0;
    angleSpeed = 0.05;
    radius = size;
  }
  
  void update(){
    super.update();
    velocity.y = 2 + gameSpeed;
    angle += angleSpeed;
    position.x += sin(angle) * 0.5;
  }
  
  // Triangular shape that rotates
  void drawObstacleShape(){
    rotate(angle);
    beginShape();
    vertex(0, -radius);
    vertex(-radius * 0.866, radius/2);
    vertex(radius * 0.866, radius/2);
    endShape(CLOSE);
  }
}
