# Tetris Game Specification

Tetris is a classic puzzle video game that has become one of the most recognized and influential video games of all time. This document provides a comprehensive specification for implementing a standard Tetris game, following the official Tetris Guidelines established by The Tetris Company.

## 1. Core Game Concepts

### 1.1 Game Objective

The objective of Tetris is to score points by clearing horizontal lines of blocks. The player must rotate, move, and drop differently shaped pieces (Tetriminos) that fall into the playing field. Complete lines are cleared, creating more space on the field. The game ends when the pieces stack up to the top of the playing field and no new pieces can enter.

### 1.2 Basic Terminology

- **Tetrimino**: One of seven geometric shapes composed of four square blocks connected along their edges[^9][^14].
- **Matrix/Playfield**: The game area where Tetriminos fall and stack[^4][^14].
- **Line Clear**: When a horizontal line of blocks is filled completely, triggering its removal[^14].
- **Lock Down**: When a Tetrimino can no longer fall and becomes part of the stack[^3].


## 2. Game Engine Specifications

### 2.1 Playfield Dimensions

- Standard playfield dimensions: 10 columns wide by 20 rows tall (visible)[^3][^4][^14].
- Additional 20-row buffer zone above the visible playfield for piece spawning and manipulation[^3][^4].
- Playfield is enclosed by boundaries on the left, right, and bottom[^3].


### 2.2 Tetrimino Specifications

#### 2.2.1 Standard Set of Tetriminos

Seven standard Tetriminos, each composed of four square blocks[^3][^9][^14]:

- **I-Tetrimino** (light blue): Four blocks in a straight line
- **O-Tetrimino** (yellow): Four blocks in a 2×2 square
- **T-Tetrimino** (purple): A row of three blocks with one added above the center
- **S-Tetrimino** (green): Two blocks with two more offset above
- **Z-Tetrimino** (red): Similar to S-Tetrimino but mirrored
- **J-Tetrimino** (blue): A row of three blocks with one added above the left block
- **L-Tetrimino** (orange): A row of three blocks with one added above the right block


#### 2.2.2 Tetrimino Colors

Each Tetrimino has a distinct color as listed above for easy identification[^14].

### 2.3 Game Loop and Timing

- Implement a fixed-time-step game loop to ensure consistent updates regardless of system performance[^3].
- Target approximately 60 updates per second for logic updates[^3].
- Separate game state updates from rendering for smooth movement and consistent input handling[^3].


### 2.4 Movement Mechanics

#### 2.4.1 Basic Movement

- Tetriminos can move horizontally (left and right) within the boundaries of the playfield[^3].
- Tetriminos automatically fall downward at a rate determined by the current level[^3][^14].
- Movement must respect collision detection with walls, floor, and other settled blocks[^3].


#### 2.4.2 Gravity and Fall Speed

- Initial fall speed at Level 1 should be approximately one cell every 0.8 seconds[^3].
- Fall speed increases with each level, following a predefined progression[^14].
- At very high levels, fall speed approaches one cell per update (maximum difficulty)[^3].


### 2.5 Rotation Systems

Implement one of two rotation systems as configurable options[^3]:

#### 2.5.1 Simple Rotation System

- Tetriminos rotate 90° clockwise around a reference point[^3].
- If rotation would cause collision with walls or other blocks, the rotation is blocked[^3].
- Minimal or no "wall kicks" in this mode (classic NES-style rotation)[^3].


#### 2.5.2 Super Rotation System (SRS)

- Modern Tetris Guideline rotation system with advanced wall kicks[^3][^4][^8].
- When normal rotation is obstructed, attempt a sequence of offset moves to allow the rotation[^3][^4].
- Implement specific kick tables for each piece and orientation change (I-Tetrimino has unique kick data)[^3][^4].
- All rotations must be reversible[^3].


### 2.6 Collision Detection

- Implement boundary checks to prevent Tetriminos from moving outside the 10×20 playfield[^3].
- Check for collisions with settled blocks before allowing any movement or rotation[^3].
- Detect collisions with the floor (bottom of the 20th row) to trigger lock delay[^3].


### 2.7 Lock Delay System

- Implement a lock delay of approximately 0.5 seconds between a piece touching down and locking in place[^3].
- During this delay, the player can still move or rotate the piece[^3].
- If the piece is moved or rotated such that it no longer touches the ground, reset the lock delay timer[^3].
- To prevent infinite stalling, limit the number of moves or total time that lock delay can be reset[^3][^4].


### 2.8 Line Clearing Mechanics

- When a horizontal line of the playfield is completely filled with blocks, it is cleared[^3][^9].
- All blocks above the cleared line(s) fall down to fill the gap[^3].
- Different point values are awarded based on the number of lines cleared simultaneously[^3][^14].


### 2.9 Randomization System

- Implement a "7-bag" randomizer system where each of the seven Tetriminos appears exactly once before any is repeated[^9].
- This ensures a fair distribution of pieces and prevents long droughts of specific pieces[^9].


### 2.10 Game Over Conditions

- The game ends when a new Tetrimino cannot enter the playfield without collision ("block out" or "top-out")[^3].
- Another game over scenario is when a piece locks into place with part of it above the visible playfield ("lock out")[^3].


## 3. Scoring System

### 3.1 Line Clear Scoring

Standard scoring values multiplied by the current level (Level + 1)[^14]:

- Single line clear: 100 points
- Double line clear: 300 points
- Triple line clear: 500 points
- Tetris (four lines): 800 points


### 3.2 T-Spin Scoring

Additional points for special T-Tetrimino maneuvers[^14]:

- T-Spin (no line clear): 400 × Level
- T-Spin Single: 800 × Level
- T-Spin Double: 1200 × Level
- T-Spin Triple: 1600 × Level
- Mini T-Spin: 100 × Level
- Mini T-Spin Single: 200 × Level


### 3.3 Combo Bonuses

- Award additional points for consecutive line clears[^3][^14].
- Start combo counter at 0, increment each time a piece clears any lines, reset when a piece is placed without clearing a line[^3].
- Award bonus points (e.g., 50 × combo count × level) for each increase in combo counter[^3].


### 3.4 Back-to-Back Bonus

- Apply a 50% bonus to the score when performing certain difficult moves consecutively (Tetrises or T-Spin line clears)[^14].


### 3.5 Drop Bonuses

- Soft Drop: 1 point per cell dropped[^3][^14].
- Hard Drop: 2 points per cell dropped[^3][^14].


## 4. Level Progression

### 4.1 Leveling System

Two possible progression systems[^14]:

1. **Fixed Goal System**: Level increases every 10 lines cleared.
2. **Variable Goal System**: Level 1 requires 5 lines, Level 2 requires 10 lines, Level 3 requires 15 lines, etc. (adding 5 lines per level).

### 4.2 Level Effects

- Each level increase speeds up the falling rate of Tetriminos[^3][^14].
- Higher levels multiply the points awarded for actions[^14].


## 5. Game Controls

### 5.1 Standard Control Scheme

- **Left Arrow**: Move the current piece one cell to the left[^3].
- **Right Arrow**: Move the current piece one cell to the right[^3].
- **Down Arrow** (Soft Drop): Increase fall speed while held[^3].
- **Up Arrow** (Rotate): Rotate the current piece 90 degrees clockwise[^3].
- **Spacebar** (Hard Drop): Immediately drop the piece to the lowest possible position and lock it in place[^3].
- **C or Hold Key**: Store the current piece for later use (optional feature)[^9].
- **P or Esc**: Pause the game[^3].


### 5.2 Input Handling

- Allow key repeat for left/right movement after an initial delay (Delayed Auto Shift)[^4][^8].
- For soft drop, increase gravity by approximately 10× normal speed[^3].
- Hard drop should skip the lock delay and immediately lock the piece[^3].


## 6. User Interface

### 6.1 Playfield Display

- Render the 10×20 playfield with grid lines to separate cells[^14].
- Display a border around the playfield[^14].
- If hardware permits, show a sliver of the 21st row to aid player's visibility for high stacks[^4].


### 6.2 Information Display

The interface should display the following information[^14]:

- Current score
- Level
- Lines cleared
- Goal (lines needed for next level)
- Optional statistics: Tetrises, T-Spins, etc.


### 6.3 Next Queue

- Display a preview of upcoming Tetriminos (ideally the next 3-6 pieces)[^14].
- The queue should be positioned near the top-right of the Matrix[^14].
- Tetriminos in the queue must be shown in their spawn orientation[^14].


### 6.4 Hold Queue

- Display the currently held piece (if the hold feature is implemented)[^9].
- Position the hold queue on the left side of the playfield[^14].


### 6.5 Ghost Piece

- Optionally display a ghost or shadow piece at the lowest possible position where the current piece would land[^5].
- Use a transparent or outlined version of the current piece for the ghost[^5].


## 7. Audio Specifications

### 7.1 Music

- Implement background music that increases in tempo as the level increases[^6][^10].
- The classic Tetris theme (Korobeiniki) is recommended but not required[^6].


### 7.2 Sound Effects

Implement sound effects for the following actions:

- Piece movement/rotation
- Piece locking
- Line clear (with special effects for Tetris)
- Level up
- Game over


## 8. Additional Features

### 8.1 Hold Piece

- Allow the player to store the current Tetrimino for later use[^9].
- Only one piece can be held at a time[^9].
- After using the held piece, the player must place another piece before using hold again[^9].


### 8.2 Ghost Piece

- Display a ghost or shadow at the position where the current piece would land if dropped[^5].
- This aids the player in positioning pieces accurately[^5].


### 8.3 Wall Kicks

- For the Super Rotation System, implement wall kicks to allow pieces to rotate even when initially blocked[^3][^4].
- Follow the specific kick tables for each piece type and rotation state[^3][^4].


### 8.4 T-Spin Detection

- Implement detection for T-Spin moves (when a T-Tetrimino is rotated into a position that would normally be inaccessible)[^14].
- Award bonus points for successful T-Spins[^14].


## 9. Persistence

### 9.1 High Score Saving

- Maintain a record of high scores, storing at least the top score[^3].
- Save additional information such as level reached, lines cleared, and timestamp[^3].
- Store this information in a file that persists between game sessions[^3].


### 9.2 Settings Storage

- Save user settings such as preferred rotation system, control configuration, and starting level[^3].
- Use a standard format (JSON, TOML, or similar) for configuration files[^3].


## 10. Implementation Considerations

### 10.1 Error Handling

- Handle unexpected situations gracefully, such as terminal resizing or unsupported keys[^3].
- Ensure the game exits cleanly and restores terminal state if applicable[^3].


### 10.2 Testing Recommendations

Test the following critical aspects:

- Rotation and wall kick behavior
- Collision detection with walls and other pieces
- Line clearing mechanics
- Scoring calculations
- Level progression
- Input handling


## 11. Conclusion

This specification provides a comprehensive guide for implementing a standard Tetris game that adheres to The Tetris Company's guidelines. The implementation should result in a game that is recognizable as Tetris while allowing for platform-specific optimizations and optional features.

By following this specification, a programmer from another planet should be able to create a functional and authentic Tetris game that captures the essence and mechanics of this classic puzzle game.
