class Particle {
  PVector position;
  PVector velocity;
  color particleColor;
  float life;
  float maxLife;
  float size;
  
  Particle(float x, float y, color c){
    this.position = new PVector(x, y);
    this.velocity = new PVector(random(-2, 2), random(-2, 2));
    this.particleColor = c;
    this.maxLife = 1.0;
    this.life = maxLife;
    this.size = random(3, 8);
  }
  
  void update(){
    position.add(velocity);
    velocity.mult(0.98);
    life -= 0.02;
  }
  
  void display(){
    float alpha = map(life, 0, maxLife, 0, 255);
    fill(particleColor, alpha);
    noStroke();
    ellipse(position.x, position.y, size, size);
  }
  
  boolean isDead(){
    return (life <= 0);
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  
  ParticleSystem(){
    particles = new ArrayList<Particle>();
  }
  
  void addExplosion(float x, float y, color c, int count){
    for(int i = 0; i < count; i++)
      particles.add(new Particle(x, y, c));
  }
  
  void update(){
    for(int i = particles.size() - 1; i >= 0; i--){
      Particle p = particles.get(i);
      p.update();
      if(p.isDead())
        particles.remove(i);
    }
  }
  
  void display(){
    for(Particle p : particles)
      p.display();
  }
}
