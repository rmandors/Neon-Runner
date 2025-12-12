class BackgroundGrid {
  ArrayList<PVector> gridLines;
  
  BackgroundGrid(){
    initializeGrid();
  }
  
  void initializeGrid(){
    gridLines = new ArrayList<PVector>();
    for(int i = 0; i < 20; i++)
      gridLines.add(new PVector(random(width), -height + i * 100));
  }
  
  void update(float gameSpeed){
    for(int i = gridLines.size() - 1; i >= 0; i--){
      PVector line = gridLines.get(i);
      line.y += gameSpeed * 3;
      
      if(line.y > height){
        line.y = -100;
        line.x = random(width);
      }
    }
  }
  
  void display(){
    stroke(#00FFFF, 30);
    strokeWeight(1);
    noFill();
    
    for(PVector line : gridLines){
      // Fake perspective effect, lines get wider as they approach
      float perspective = map(line.y, -100, height, 0.3, 1.0);
      float lineWidth = width * perspective;
      float x = line.x;
      
      line(x - lineWidth/2, line.y, x + lineWidth/2, line.y);
    }
  } 
}
