abstract class GameObject {
  PVector position;
  PVector velocity;
  float size;
  color objectColor;
  boolean isActive;
  
  GameObject(float x, float y, float size, color c){
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.size = size;
    this.objectColor = c;
    this.isActive = true;
  }
  
  abstract void update();
  abstract void display();
  abstract boolean checkCollision(GameObject other);
  
  boolean isOutOfBounds(){
    return (position.x < -100 || position.x > width + 100 || 
            position.y < -100 || position.y > height + 100);
  }
  
  float distanceTo(GameObject other){
    return PVector.dist(position, other.position);
  }
}
