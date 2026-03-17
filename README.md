# 💀 Catacombs

Welcome to **Catacombs**, a top-down 2D pixel art dungeon crawler. This project is a dedicated learning environment for mastering the **Godot Engine** and the fundamentals of game development.

---

## 🕹️ Project Overview
The goal of Catacombs is to build a solid foundation in game architecture. From player movement and enemy AI to UI systems and procedural elements, this repository serves as a "living notebook" of progress in GDScript and game design.

## 🚀 Learning Objectives
This project focuses on several core pillars of game development:
* **State Management:** Implementing finite state machines for player states (Idle, Walk, Attack).
* **Physics & Collisions:** Handling 2D movement and environmental interactions.
* **Scene Composition:** Learning how to nest scenes and use signals for decoupled communication.
* **Asset Pipeline:** Integrating pixel art sprites, animations, and tilemaps effectively.
* **Game Loops:** Understanding the timing of input, physics, and rendering.

---

## 🛠️ Built With
* **Engine:** Godot 4.x
* **Language:** GDScript
* **Art Style:** 2D Pixel Art

---

### 📜 Roadmap

* [x] **Phase 1: Foundations**
    * [x] Basic Player Movement & Animations
    * [x] Tilemap Environment Setup
* [ ] **Phase 2: Camera & Feel**
    * [ ] **Smooth Follow Camera:** Set up a `Camera2D` that tracks the player with custom dead zones and position smoothing.
    * [ ] **Audio Integration:** Add spatial sound effects (SFX) for combat and ambient dungeon background music.
* [ ] **Phase 3: User Interface & Menus**
    * [ ] **Main Menu:** A polished start screen with "New Game" and "Exit" buttons.
    * [ ] **Escape Menu (Pause System):** An in-game overlay triggered by the `ESC` key featuring:
        * **Continue:** Unpause and return to gameplay.
        * **Save:** Persist current progress (player stats/position) to a local file.
        * **Exit:** Safely return to the Main Menu or Desktop.
* [ ] **Phase 4: Advanced Gameplay**
    * [ ] Enemy AI (Simple Follow/Attack behavior)
    * [ ] Procedural Room Generation (Randomized dungeon layouts)

--- 

**NOTE:** This is a hobbyist project meant for educational purposes. Feel free to poke around the code and see how things are wired!

---

For more functionality details checkout [Note.md](NOTE.md)
