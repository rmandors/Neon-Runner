# Neon Runner

A top-down space shooter game built in Processing, featuring a vibrant neon aesthetic, power-ups, progressive difficulty, and a leaderboard system.

## Features

- **Neon Aesthetic**: Immersive visual design with glowing neon colors and particle effects
- **Progressive Difficulty**: Game speed and enemy spawn rates increase as you survive longer
- **Power-Up System**: Collect various power-ups including:
  - Shield protection
  - Rapid fire mode
  - Slow motion
  - Score multiplier
- **Leaderboard**: Track your top 10 scores with usernames and dates
- **Multiple Enemy Types**: Face off against basic, fast, and tank enemies with unique behaviors
- **Dynamic Obstacles**: Navigate through walls and moving obstacles
- **Audio System**: Background music and sound effects with adjustable volume controls
- **Combo System**: Chain kills together for bonus points

## Screenshots

### Home Screen
<img width="400" height="300" alt="Screenshot 2025-12-11 at 9 55 03 PM" src="https://github.com/user-attachments/assets/d6f179f3-1925-4920-b242-e60516de9627" />

### Leaderboards
<img width="400" height="300" alt="Screenshot 2025-12-11 at 9 55 24 PM" src="https://github.com/user-attachments/assets/5f3ebcc1-6369-45fa-bd38-dd7637d9a5d8" />

### Gameplay
<img width="400" height="300" alt="Screenshot 2025-12-11 at 10 05 25 PM" src="https://github.com/user-attachments/assets/405d63b8-3d97-40d7-97d3-1b7d22eb18df" />

### Game Over
<img width="400" height="300" alt="Screenshot 2025-12-11 at 9 56 51 PM" src="https://github.com/user-attachments/assets/c9a243a8-be68-4cbd-b51e-e350b7404974" />


## Requirements

- [Processing](https://processing.org/download/) (version 3.0 or later)
- Minim audio library (included with Processing)

## Installation

1. Clone or download this repository
2. Open `NeonRunner.pde` in Processing
3. Ensure all `.pde` files are in the same folder
4. Run the sketch

## How to Play

1. Enter your username when prompted
2. Use WASD or arrow keys to move your ship
3. Press SPACE to shoot
4. Avoid enemies and obstacles
5. Collect power-ups to gain advantages
6. Survive as long as possible to achieve a high score!

## Controls

- **Movement**: WASD or Arrow Keys
- **Shoot**: SPACE
- **Menu Navigation**: UP/DOWN Arrow Keys
- **Select**: ENTER
- **Back/Exit**: ESC
- **Restart (Game Over)**: R

## Project Structure

The game is built using OOP principles with a clear class hierarchy:

- **Core**: `NeonRunner.pde` (main entry point), `GameManager.pde`, `GameObject.pde`
- **Entities**: `Player.pde`, `Enemy.pde`, `Obstacle.pde`, `PowerUp.pde`, `Projectile.pde`
- **Managers**: `MenuManager.pde`, `LeaderboardManager.pde`, `GameAudio.pde`, `UIManager.pde`
- **Utilities**: `BackgroundGrid.pde`, `ParticleSystem.pde`
