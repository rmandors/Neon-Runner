// Manages leaderboard data persistence and sorting
class LeaderboardManager {
  String leaderboardFile = "data/leaderboard.csv";
  ArrayList<LeaderboardEntry> leaderboard;
  int maxEntries = 10;
  String lastAddedUsername = "";
  int lastAddedScore = 0;
  
  LeaderboardManager(){
    leaderboard = new ArrayList<LeaderboardEntry>();
    loadLeaderboard();
  }
  
  // Load leaderboard from CSV file, handling different formats
  void loadLeaderboard(){
    leaderboard.clear();
    
    String[] lines = loadStrings(leaderboardFile);
    if(lines == null || lines.length == 0){
      saveLeaderboard();
      return;
    }
    
    // Parse CSV entries, skip headers
    for(int i = 0; i < lines.length; i++){
      String line = lines[i].trim();
      if(line.length() == 0 || line.startsWith("Username") || line.startsWith("Score,Date"))
        continue;
      
      String[] parts = split(line, ',');
      if(parts.length >= 3){
        try{
          String username = parts[0].trim().toUpperCase();
          int score = int(parts[1].trim());
          String date = parts[2].trim();
          leaderboard.add(new LeaderboardEntry(username, score, date));
        } 
        catch(NumberFormatException e){
        }
      } 
      else if(parts.length == 2){
        try{
          int score = int(parts[0].trim());
          String date = parts[1].trim();
          leaderboard.add(new LeaderboardEntry("Player", score, date));
        } 
        catch (NumberFormatException e){
        }
      }
    }
    
    sortLeaderboard();
  }
  
  void saveLeaderboard(){
    String[] lines = new String[leaderboard.size() + 1];
    lines[0] = "Username,Score,Date";
    
    for(int i = 0; i < leaderboard.size(); i++){
      LeaderboardEntry entry = leaderboard.get(i);
      lines[i + 1] = entry.username + "," + entry.score + "," + entry.date;
    }
    
    saveStrings(leaderboardFile, lines);
  }
  
  // Add new score if it qualifies (beats lowest score or list not full)
  boolean addScore(int score, String username){
    if(score <= 0)
      return false;
    
    if(username == null || username.trim().length() == 0)
      username = "PLAYER";
    username = username.toUpperCase();
    
    if(leaderboard.size() < maxEntries || score > leaderboard.get(leaderboard.size() - 1).score){
      String date = getCurrentDate();
      LeaderboardEntry newEntry = new LeaderboardEntry(username, score, date);
      
      leaderboard.add(newEntry);
      sortLeaderboard();
      
      lastAddedUsername = username;
      lastAddedScore = score;
      
      // Trim to max entries after sorting
      while(leaderboard.size() > maxEntries)
        leaderboard.remove(leaderboard.size() - 1);
      
      saveLeaderboard();
      return true;
    }
    
    return false;
  }
  
  boolean addScore(int score){
    return addScore(score, "Player");
  }
  
  void sortLeaderboard(){
    // Simple bubble sort algorithm
    for(int i = 0; i < leaderboard.size() - 1; i++){
      for(int j = i + 1; j < leaderboard.size(); j++){
        if(leaderboard.get(i).score < leaderboard.get(j).score){
          LeaderboardEntry temp = leaderboard.get(i);
          leaderboard.set(i, leaderboard.get(j));
          leaderboard.set(j, temp);
        }
      }
    }
  }
  
  String getCurrentDate(){
    int year = year();
    int month = month();
    int day = day();
    return (year + "-" + nf(month, 2) + "-" + nf(day, 2));
  }
  
  ArrayList<LeaderboardEntry> getLeaderboard(){
    return leaderboard;
  }
  
  int getTopScore(){
    if(leaderboard.size() > 0)
      return leaderboard.get(0).score;
    return 0;
  }
  
  boolean isNewHighScore(int score){
    if(leaderboard.size() == 0)
      return score > 0;
    return score > leaderboard.get(0).score;
  }
  
  String getLastAddedUsername(){
    return lastAddedUsername;
  }
  
  int getLastAddedScore(){
    return lastAddedScore;
  }
}

class LeaderboardEntry {
  String username;
  int score;
  String date;
  
  LeaderboardEntry(String username, int score, String date){
    this.username = username;
    this.score = score;
    this.date = date;
  }
  
  LeaderboardEntry(int score, String date) {
    this("Player", score, date);
  }
}
