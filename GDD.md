# GDD: Project "Neural Swap" (Provisional Title)

## 1. Genre and Camera Definition
* **Genre**: Hybrid of Auto-battler and Tactical Strategy.
* **Perspective**: 2D.
* **Combat Visual Style**: "Visual Hack 'n Slash". Frenetic action, blood/particle effects, and high speed driven by auto-battling AI. The player manages the "logic" while the entities execute the "action".

## 2. Gameplay Mechanics

### 2.1 The Virus and Logic Slots
* **Indirect Control**: The player (the virus) does **not** gain direct control (WASD/Click-to-move) of the host. The entity continues to act autonomously based on its current logic slots.
* **Slot Structure**: Every entity has a fixed number of Logic Slots (default: 3).
    * **Slot 1: Combat** (e.g., Heavy Attack, Weak Attack, Ranged).
    * **Slot 2: Behavior** (e.g., Aggressive, Cowardly, Protective).
    * **Slot 3: Movement Pattern** (e.g., Patrol, Stationary, Random Wander).
* **Temporal Swaps**: Any logic slot exchanged by the player is **temporary**. After a certain duration, the swap reverts, and the slots return to their original owners.

### 2.2 The "Neural Swapping" Flow
* **Virus Displacement**: The virus inhabits entities (NPCs or objects) to manipulate their logic.
* **Jumping**: The player can jump between entities. Unlike earlier drafts, a jump does **not** strictly require a slot exchange, allowing for tactical repositioning.
* **Static Objects (Bridges)**: Objects like lamps or furniture serve as jump stations. They often have "useless" or stationary logic (e.g., "Movement: Stationary") that can be harvested to neutralize enemies.
* **Static Vulnerability**: Inhabiting an object removes the ability to flee, making the virus vulnerable to being "trapped" if the object is destroyed.

### 2.3 The "VIP Host" (The Good Guy)
* **Priority Protection**: The VIP is present in every room/level. Their death triggers an immediate "Game Over".
* **Remote Synergy**: The core loop involves jumping into enemies to steal powerful logic slots (like a "Heavy Attack") and bringing them back to the VIP to buff them, or replacing an enemy's "Aggressive" behavior with a "Lamp's Stationary" behavior.

### 2.4 Roguelike Structure & Win Conditions
* **Fresh Starts**: Each run is independent with empirical learning (discovery of slot contents).
* **Variable Win Conditions**:
    * **Extermination**: Clear all enemies in the room.
    * **Assassination**: Defeat a specific "Boss" or target entity.
    * **Escort/Survival**: Protect the VIP for a duration or until they reach an exit.

## 3. History and Narrative
* *TODO: Define the nature of the Virus and the identity of the VIP.*

## 4. Artistic Style 
* *TODO: Define pixel art style, color palettes, and visual effects for "Neural Swapping".*

## 5. User Interface (UI) and User Experience (UX)
* *TODO: Define how slot swapping is visualized (drag-and-drop vs. menu) and how the temporal countdown is shown.*
