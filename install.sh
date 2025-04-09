#!/bin/bash

# This script creates the Tetris game files (HTML, CSS, JS) and the sounds directory.
# Run this script in the directory where you want the game files to be created.

echo "Creating Tetris game structure..."

# Create the sounds directory
mkdir -p sounds
echo "Created directory: sounds/"
echo "NOTE: You still need to add the actual sound files (.wav, .mp3) to the 'sounds/' directory."
echo "Required sound files: move.wav, rotate.wav, lock.wav, clear.wav, tetris.wav, levelup.wav, gameover.wav, hold.wav, harddrop.wav, tspin.wav, korobeiniki.mp3"

# Create index.html
echo "Creating index.html..."
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tetris</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="game-container">
        <div class="left-panel">
            <div class="info-box hold-box">
                <h2>HOLD</h2>
                <canvas id="hold-canvas" width="120" height="120"></canvas>
            </div>
             <div class="info-box stats-box">
                <h2>STATS</h2>
                <p>T-Spins: <span id="t-spins">0</span></p>
                <p>Tetrises: <span id="tetrises">0</span></p>
                <p>Combo: <span id="combo">0</span>x</p>
                <p>B2B: <span id="b2b">0</span>x</p>
            </div>
        </div>

        <div class="playfield-container">
            <canvas id="game-canvas" width="300" height="600"></canvas>
             <div id="message-overlay" class="message-overlay" style="display: none;">
                <p id="message-text"></p>
                <button id="restart-button" style="display: none;">Play Again</button>
            </div>
        </div>

        <div class="right-panel">
            <div class="info-box score-box">
                <h2>SCORE</h2>
                <p id="score">0</p>
            </div>
            <div class="info-box level-box">
                <h2>LEVEL</h2>
                <p id="level">1</p>
            </div>
             <div class="info-box lines-box">
                <h2>LINES</h2>
                <p id="lines">0</p>
                <p class="goal-text">Goal: <span id="goal">10</span></p>
            </div>
            <div class="info-box next-box">
                <h2>NEXT</h2>
                <canvas id="next-canvas" width="120" height="360"></canvas> <!-- Adjusted height for multiple previews -->
            </div>
        </div>
    </div>

    <!-- Audio Elements -->
    <audio id="move-sound" src="sounds/move.wav" preload="auto"></audio>
    <audio id="rotate-sound" src="sounds/rotate.wav" preload="auto"></audio>
    <audio id="lock-sound" src="sounds/lock.wav" preload="auto"></audio>
    <audio id="clear-line-sound" src="sounds/clear.wav" preload="auto"></audio>
    <audio id="tetris-sound" src="sounds/tetris.wav" preload="auto"></audio>
    <audio id="level-up-sound" src="sounds/levelup.wav" preload="auto"></audio>
    <audio id="game-over-sound" src="sounds/gameover.wav" preload="auto"></audio>
    <audio id="hold-sound" src="sounds/hold.wav" preload="auto"></audio>
    <audio id="hard-drop-sound" src="sounds/harddrop.wav" preload="auto"></audio>
    <audio id="tspin-sound" src="sounds/tspin.wav" preload="auto"></audio>
    <audio id="bgm" src="sounds/korobeiniki.mp3" loop preload="auto"></audio>

    <script src="script.js"></script>
</body>
</html>
EOF
echo "Created index.html"

# Create style.css
echo "Creating style.css..."
cat << 'EOF' > style.css
body {
    font-family: 'Arial', sans-serif;
    background-color: #2c3e50;
    color: #ecf0f1;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    margin: 0;
    overflow: hidden; /* Prevent scrollbars */
}

.game-container {
    display: flex;
    gap: 20px;
    align-items: flex-start; /* Align tops */
    background-color: #34495e;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
}

.left-panel, .right-panel {
    display: flex;
    flex-direction: column;
    gap: 15px;
    width: 150px; /* Adjusted width */
}

.playfield-container {
    position: relative; /* For overlay positioning */
}

#game-canvas {
    border: 3px solid #7f8c8d;
    background-color: #1a252f; /* Dark background for playfield */
    display: block; /* Remove extra space below canvas */
}

.info-box {
    background-color: #4a627a;
    padding: 10px 15px;
    border-radius: 5px;
    text-align: center;
    box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
}

.info-box h2 {
    margin: 0 0 10px 0;
    font-size: 1em;
    color: #bdc3c7;
    text-transform: uppercase;
    border-bottom: 1px solid #7f8c8d;
    padding-bottom: 5px;
}

.info-box p {
    margin: 5px 0;
    font-size: 1.2em;
    font-weight: bold;
    color: #ecf0f1;
}

.info-box .goal-text {
    font-size: 0.9em;
    font-weight: normal;
    color: #bdc3c7;
}

#hold-canvas, #next-canvas {
    background-color: #1a252f;
    border-radius: 3px;
    display: block;
    margin: 5px auto 0; /* Center canvases */
}

.message-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.75);
    color: white;
    display: flex; /* Use flexbox for centering */
    flex-direction: column; /* Stack text and button vertically */
    justify-content: center;
    align-items: center;
    text-align: center;
    font-size: 2em;
    font-weight: bold;
    z-index: 10;
}

.message-overlay p {
    margin-bottom: 20px; /* Space between text and button */
}

#restart-button {
    padding: 10px 20px;
    font-size: 0.8em;
    cursor: pointer;
    background-color: #e67e22;
    color: white;
    border: none;
    border-radius: 5px;
    transition: background-color 0.3s ease;
}

#restart-button:hover {
    background-color: #d35400;
}

/* Tetrimino Block Styling (applied via JS) */
/* Example - actual colors set in JS */
/* .block {
    width: 30px;
    height: 30px;
    border: 1px solid rgba(0, 0, 0, 0.2);
    box-sizing: border-box;
} */
EOF
echo "Created style.css"

# Create script.js
echo "Creating script.js..."
cat << 'EOF' > script.js
// --- DOM Elements ---
const canvas = document.getElementById('game-canvas');
const context = canvas.getContext('2d');
const nextCanvas = document.getElementById('next-canvas');
const nextContext = nextCanvas.getContext('2d');
const holdCanvas = document.getElementById('hold-canvas');
const holdContext = holdCanvas.getContext('2d');

const scoreElement = document.getElementById('score');
const levelElement = document.getElementById('level');
const linesElement = document.getElementById('lines');
const goalElement = document.getElementById('goal');
const messageOverlay = document.getElementById('message-overlay');
const messageText = document.getElementById('message-text');
const restartButton = document.getElementById('restart-button');

const tSpinsElement = document.getElementById('t-spins');
const tetrisesElement = document.getElementById('tetrises');
const comboElement = document.getElementById('combo');
const b2bElement = document.getElementById('b2b');

// --- Audio Elements ---
const sounds = {
    move: document.getElementById('move-sound'),
    rotate: document.getElementById('rotate-sound'),
    lock: document.getElementById('lock-sound'),
    clear: document.getElementById('clear-line-sound'),
    tetris: document.getElementById('tetris-sound'),
    levelUp: document.getElementById('level-up-sound'),
    gameOver: document.getElementById('game-over-sound'),
    hold: document.getElementById('hold-sound'),
    hardDrop: document.getElementById('hard-drop-sound'),
    tSpin: document.getElementById('tspin-sound'),
    bgm: document.getElementById('bgm')
};

// Function to safely play audio
function playSound(sound) {
    if (sound && sound.readyState >= 3) { // HAVE_FUTURE_DATA or more
        sound.currentTime = 0; // Rewind to start
        sound.play().catch(e => console.log("Audio play failed:", e)); // Play and catch errors
    } else {
        // console.log("Sound not ready or not found:", sound);
    }
}

// --- Game Constants ---
const COLS = 10;
const ROWS = 20;
const BUFFER_ROWS = 20; // Hidden rows above visible area
const TOTAL_ROWS = ROWS + BUFFER_ROWS;
const BLOCK_SIZE = 30; // Pixel size of a single block
const NEXT_QUEUE_SIZE = 5; // Number of pieces to show in the next queue
const LOCK_DELAY = 500; // ms
const LOCK_DELAY_LIMIT_MOVES = 15; // Limit resets by moves/rotations
const DAS_DELAY = 160; // ms (Delayed Auto Shift initial delay)
const DAS_INTERVAL = 50; // ms (DAS repeat rate)
const SOFT_DROP_MULTIPLIER = 10; // Gravity multiplier for soft drop

const TETROMINOS = {
    'I': {
        shape: [[0, 0, 0, 0], [1, 1, 1, 1], [0, 0, 0, 0], [0, 0, 0, 0]],
        color: '#00FFFF', // Light Blue
    },
    'O': {
        shape: [[1, 1], [1, 1]],
        color: '#FFFF00', // Yellow
    },
    'T': {
        shape: [[0, 1, 0], [1, 1, 1], [0, 0, 0]],
        color: '#800080', // Purple
    },
    'S': {
        shape: [[0, 1, 1], [1, 1, 0], [0, 0, 0]],
        color: '#00FF00', // Green
    },
    'Z': {
        shape: [[1, 1, 0], [0, 1, 1], [0, 0, 0]],
        color: '#FF0000', // Red
    },
    'J': {
        shape: [[1, 0, 0], [1, 1, 1], [0, 0, 0]],
        color: '#0000FF', // Blue
    },
    'L': {
        shape: [[0, 0, 1], [1, 1, 1], [0, 0, 0]],
        color: '#FFA500', // Orange
    }
};

const TETROMINO_KEYS = Object.keys(TETROMINOS);

// SRS Kick Data (Wall Kicks)
// Format: [from_orientation][to_orientation] -> array of [x, y] offsets
// 0: Initial state, R: Rotated right, 2: Rotated 180, L: Rotated left
// Based on https://tetris.wiki/Super_Rotation_System#Wall_Kicks
const KICK_DATA_JLSTZ = {
    '0R': [[0, 0], [-1, 0], [-1, 1], [0, -2], [-1, -2]],
    'R0': [[0, 0], [1, 0], [1, -1], [0, 2], [1, 2]],
    'R2': [[0, 0], [1, 0], [1, -1], [0, 2], [1, 2]],
    '2R': [[0, 0], [-1, 0], [-1, 1], [0, -2], [-1, -2]],
    '2L': [[0, 0], [1, 0], [1, 1], [0, -2], [1, -2]],
    'L2': [[0, 0], [-1, 0], [-1, -1], [0, 2], [-1, 2]],
    'L0': [[0, 0], [-1, 0], [-1, -1], [0, 2], [-1, 2]],
    '0L': [[0, 0], [1, 0], [1, 1], [0, -2], [1, -2]]
};

const KICK_DATA_I = {
    '0R': [[0, 0], [-2, 0], [1, 0], [-2, -1], [1, 2]],
    'R0': [[0, 0], [2, 0], [-1, 0], [2, 1], [-1, -2]],
    'R2': [[0, 0], [-1, 0], [2, 0], [-1, 2], [2, -1]],
    '2R': [[0, 0], [1, 0], [-2, 0], [1, -2], [-2, 1]],
    '2L': [[0, 0], [2, 0], [-1, 0], [2, 1], [-1, -2]],
    'L2': [[0, 0], [-2, 0], [1, 0], [-2, -1], [1, 2]],
    'L0': [[0, 0], [1, 0], [-2, 0], [1, -2], [-2, 1]],
    '0L': [[0, 0], [-1, 0], [2, 0], [-1, 2], [2, -1]]
};

const KICK_DATA_O = { // O piece doesn't kick
    '0R': [[0, 0]], 'R0': [[0, 0]], 'R2': [[0, 0]], '2R': [[0, 0]],
    '2L': [[0, 0]], 'L2': [[0, 0]], 'L0': [[0, 0]], '0L': [[0, 0]]
};

const rotationMap = { 0: '0', 1: 'R', 2: '2', 3: 'L' };

// --- Game State ---
let playfield;
let currentPiece;
let currentX, currentY, currentRotation;
let nextPieces = [];
let currentBag = [];
let heldPiece = null;
let canHold = true;
let score = 0;
let level = 1;
let linesCleared = 0;
let goalLines = 10; // Fixed Goal System: 10 lines per level
let isGameOver = false;
let isPaused = false;
let gravityIntervalId = null;
let gameLoopRequestId = null;
let lockDelayTimeoutId = null;
let lockDelayResets = 0;
let comboCount = -1; // Start at -1, first clear makes it 0
let backToBack = 0; // 0 = none, 1 = eligible, >1 = active B2B chain
let lastClearWasDifficult = false; // For B2B bonus tracking
let softDropActive = false;
let hardDropUsed = false;
let lastMoveWasRotation = false; // For T-spin detection
let tSpinStatus = 'none'; // 'none', 'mini', 'tspin'

// Stats
let tSpinCount = 0;
let tetrisCount = 0;

// Input Handling State
let dasLeftTimeout = null;
let dasRightTimeout = null;
let dasLeftInterval = null;
let dasRightInterval = null;
let keys = {};

// --- Game Functions ---

function createEmptyPlayfield() {
    return Array.from({ length: TOTAL_ROWS }, () => Array(COLS).fill(null)); // null means empty
}

// 7-Bag Randomizer
function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]]; // Swap elements
    }
}

function generateBag() {
    currentBag = [...TETROMINO_KEYS];
    shuffleArray(currentBag);
}

function getNextPieceType() {
    if (currentBag.length === 0) {
        generateBag();
    }
    return currentBag.pop();
}

function fillNextQueue() {
    while (nextPieces.length < NEXT_QUEUE_SIZE) {
        nextPieces.push(getNextPieceType());
    }
}

function getPieceData(type) {
    return TETROMINOS[type];
}

function getRotatedPiece(piece, rotation) {
    const shape = piece.shape;
    const size = shape.length;
    let newShape = Array.from({ length: size }, () => Array(size).fill(0));

    for (let r = 0; r < size; r++) {
        for (let c = 0; c < size; c++) {
            if (shape[r][c]) {
                switch (rotation % 4) {
                    case 0: // 0 degrees
                        newShape[r][c] = 1;
                        break;
                    case 1: // 90 degrees clockwise
                        newShape[c][size - 1 - r] = 1;
                        break;
                    case 2: // 180 degrees
                        newShape[size - 1 - r][size - 1 - c] = 1;
                        break;
                    case 3: // 270 degrees clockwise (90 counter-clockwise)
                        newShape[size - 1 - c][r] = 1;
                        break;
                }
            }
        }
    }
    return newShape;
}

// Collision Detection
function checkCollision(x, y, rotation) {
    const shape = getRotatedPiece(currentPiece, rotation);
    const size = shape.length;

    for (let r = 0; r < size; r++) {
        for (let c = 0; c < size; c++) {
            if (shape[r][c]) {
                const boardX = x + c;
                const boardY = y + r;

                // Check boundaries
                if (boardX < 0 || boardX >= COLS || boardY >= TOTAL_ROWS) {
                    return true; // Collision with walls or floor
                }

                // Check collision with settled blocks (only if within bounds)
                // Also allows checks in the buffer zone (boardY < 0 is okay here)
                if (boardY >= 0 && playfield[boardY][boardX]) {
                    return true; // Collision with another block
                }
            }
        }
    }
    return false; // No collision
}

// Spawning
function spawnPiece() {
    const type = nextPieces.shift();
    fillNextQueue(); // Refill the queue

    currentPiece = getPieceData(type);
    currentPiece.type = type; // Store type for reference (e.g., kicks, T-spins)
    currentRotation = 0;

    // Standard spawn position: center top of buffer
    // Adjust for piece width (especially I and O)
    currentX = Math.floor(COLS / 2) - Math.ceil(currentPiece.shape.length / 2);
    currentY = BUFFER_ROWS - 3; // Start high in the buffer (adjust as needed)

     // Adjust spawn Y for I piece specifically if needed (often spawns one row lower)
    if (currentPiece.type === 'I') {
        currentY = BUFFER_ROWS - 3;
    } else if (currentPiece.type === 'O') {
         currentX = Math.floor(COLS / 2) - 1; // Center O better
         currentY = BUFFER_ROWS - 2;
    } else {
        currentY = BUFFER_ROWS - 2;
    }


    // Initial collision check (Game Over condition)
    if (checkCollision(currentX, currentY, currentRotation)) {
        gameOver();
        return false; // Indicate spawn failed
    }

    canHold = true; // Allow hold after a piece locks and new one spawns
    hardDropUsed = false;
    lastMoveWasRotation = false;
    tSpinStatus = 'none';
    resetLockDelay(); // Spawn resets lock potential
    return true; // Spawn successful
}

// Movement
function moveLeft() {
    if (!isPaused && !isGameOver && !checkCollision(currentX - 1, currentY, currentRotation)) {
        currentX--;
        playSound(sounds.move);
        resetLockDelayIfTouching();
        lastMoveWasRotation = false;
        tSpinStatus = 'none'; // Moving invalidates T-Spin
        return true;
    }
    return false;
}

function moveRight() {
    if (!isPaused && !isGameOver && !checkCollision(currentX + 1, currentY, currentRotation)) {
        currentX++;
        playSound(sounds.move);
        resetLockDelayIfTouching();
        lastMoveWasRotation = false;
        tSpinStatus = 'none';
        return true;
    }
    return false;
}

function moveDown() {
    if (isPaused || isGameOver) return false;

    if (!checkCollision(currentX, currentY + 1, currentRotation)) {
        currentY++;
        // Reset lock delay only if it wasn't triggered by gravity naturally landing
        // The main gravity loop handles starting the lock delay.
        // Manual move down shouldn't necessarily *reset* it unless it moves off a surface.
        cancelLockDelay(); // Moving down cancels any active lock delay
        if (softDropActive) {
             addScore(1); // Soft drop points
        }
        lastMoveWasRotation = false; // Moving down usually invalidates T-spin unless it's the final lock-in move
        return true;
    } else {
        // Could not move down, start lock delay
        startLockDelay();
        return false;
    }
}

// Rotation (SRS)
function rotate(clockwise = true) {
    if (isPaused || isGameOver || currentPiece.type === 'O') return; // O doesn't rotate

    const currentRotIndex = currentRotation % 4;
    const nextRotIndex = clockwise ? (currentRotIndex + 1) % 4 : (currentRotIndex + 3) % 4; // +3 is equivalent to -1 mod 4

    const kickTable = (currentPiece.type === 'I') ? KICK_DATA_I :
                      (currentPiece.type === 'O') ? KICK_DATA_O : // Should not be used but included for completeness
                      KICK_DATA_JLSTZ;

    const rotationKey = `${rotationMap[currentRotIndex]}${rotationMap[nextRotIndex]}`;
    const kicks = kickTable[rotationKey] || [[0, 0]]; // Default to no kick if key invalid

    for (const [kickX, kickY] of kicks) {
        const newX = currentX + kickX;
        // SRS Y-axis is often inverted compared to typical screen coordinates
        // In our coordinate system (Y increases downwards), we subtract kickY
        const newY = currentY - kickY;

        if (!checkCollision(newX, newY, nextRotIndex)) {
            currentX = newX;
            currentY = newY;
            currentRotation = nextRotIndex;
            playSound(sounds.rotate);
            resetLockDelayIfTouching();
            lastMoveWasRotation = true; // Mark that rotation was the last action
             // Check for T-Spin after successful rotation
            if (currentPiece.type === 'T') {
                tSpinStatus = checkTSpinStatus(newX, newY, currentRotation, kicks, kickX, kickY);
            } else {
                tSpinStatus = 'none';
            }
            return; // Rotation successful
        }
    }
    // If no kick worked, rotation fails
    lastMoveWasRotation = false;
    tSpinStatus = 'none';
}

// Hard Drop
function hardDrop() {
    if (isPaused || isGameOver) return;

    let dropDistance = 0;
    let tempY = currentY;
    while (!checkCollision(currentX, tempY + 1, currentRotation)) {
        tempY++;
        dropDistance++;
    }

    if (dropDistance > 0) {
        currentY = tempY;
        addScore(dropDistance * 2); // Hard drop points
        playSound(sounds.hardDrop);
        hardDropUsed = true; // Flag that hard drop initiated the lock
        lockPiece(); // Lock immediately, skipping lock delay
    } else {
        // If already on the ground, just trigger lock sequence
        lockPiece();
    }
}

// Lock Delay Management
function isTouchingGround() {
    return checkCollision(currentX, currentY + 1, currentRotation);
}

function startLockDelay() {
    if (lockDelayTimeoutId) return; // Already timing

    if (isTouchingGround()) {
        lockDelayResets = 0; // Reset counter when initially touching down
        lockDelayTimeoutId = setTimeout(() => {
            // Double-check collision before locking, piece might have moved
            if (isTouchingGround()) {
                lockPiece();
            } else {
                 cancelLockDelay(); // Piece moved off surface during delay, cancel lock
            }
        }, LOCK_DELAY);
    }
}

function resetLockDelay() {
    if (lockDelayTimeoutId) {
        clearTimeout(lockDelayTimeoutId);
        lockDelayTimeoutId = null;
        lockDelayResets++;

        if (lockDelayResets < LOCK_DELAY_LIMIT_MOVES) {
             // Restart the timer only if limit not reached
             lockDelayTimeoutId = setTimeout(() => {
                if (isTouchingGround()) {
                    lockPiece();
                } else {
                    cancelLockDelay();
                }
            }, LOCK_DELAY);
        } else {
            // Force lock if move limit reached while touching ground
             if (isTouchingGround()) {
                lockPiece();
            }
        }
    } else if (isTouchingGround()) {
        // If not currently timing but touching ground (e.g., after a move), start the timer
        startLockDelay();
    }
}

function resetLockDelayIfTouching() {
    if (isTouchingGround()) {
        resetLockDelay();
    } else {
        cancelLockDelay(); // If move/rotate lifts piece off ground, cancel timer
    }
}


function cancelLockDelay() {
    if (lockDelayTimeoutId) {
        clearTimeout(lockDelayTimeoutId);
        lockDelayTimeoutId = null;
    }
}

// T-Spin Detection (Simplified 3-corner check for standard T-spins)
// More accurate checks might consider kick used (e.g., TST)
function checkTSpinStatus(x, y, rotation, kicksUsed, finalKickX, finalKickY) {
    if (currentPiece.type !== 'T' || !lastMoveWasRotation) {
        return 'none';
    }

    // T-Spin check requires the last move to be a rotation that lands the piece.
    // Check the 4 corners diagonally adjacent to the T's center block (after rotation)
    const shape = getRotatedPiece(currentPiece, rotation);
    // Find center relative to piece origin (usually [1,1] for T)
    let centerX = -1, centerY = -1;
    if (shape[1] && shape[1][1] === 1) { // Standard T center
        centerX = x + 1;
        centerY = y + 1;
    } else {
        // Need to find the center based on rotation if origin isn't [0,0]
        // For simplicity, assume standard T shape origin for now
         console.warn("Could not reliably find T center for T-Spin check.");
         return 'none';
    }


    const corners = [
        [centerX - 1, centerY - 1], // Top-left
        [centerX + 1, centerY - 1], // Top-right
        [centerX - 1, centerY + 1], // Bottom-left
        [centerX + 1, centerY + 1]  // Bottom-right
    ];

    let occupiedCorners = 0;
    for (const [cx, cy] of corners) {
        if (cx < 0 || cx >= COLS || cy >= TOTAL_ROWS || (cy >=0 && playfield[cy][cx])) {
            occupiedCorners++;
        }
    }

    // Basic T-Spin: 3 or more corners occupied.
    if (occupiedCorners >= 3) {
         // Check facing corners based on final rotation state to differentiate Mini vs Full
         // Corners A,B (front): determined by rotation state
         // Corners C,D (back): the other two
         let frontCornersOccupied = 0;
         const frontCornerIndices = [ [0, 1], [1, 3], [3, 2], [2, 0] ][rotation % 4]; // Indices into 'corners' array based on rotation [0,R,2,L]

         if(isOccupied(corners[frontCornerIndices[0]][0], corners[frontCornerIndices[0]][1])) frontCornersOccupied++;
         if(isOccupied(corners[frontCornerIndices[1]][0], corners[frontCornerIndices[1]][1])) frontCornersOccupied++;

        // Check if the T-Spin used specific kicks (like TST kick 4/5)
        // Kick indices 4/5 often indicate "fin" or complex spins
        const kickIndex = kicksUsed.findIndex(k => k[0] === finalKickX && k[1] === -finalKickY); // Find index of used kick

        if (frontCornersOccupied === 2 && occupiedCorners >= 3) {
             // TST Kick check (optional refinement)
             // if (currentPiece.type === 'T' && kickIndex >= 3) { // Check if high-index kick used
             //     console.log("T-Spin (potentially complex kick)");
             //     return 'tspin';
             // }
            // console.log("T-Spin Full");
            return 'tspin'; // Full T-Spin if front corners are blocked
        } else if (occupiedCorners >= 3) {
            // console.log("T-Spin Mini");
            return 'mini'; // Mini T-Spin otherwise (back corners blocked)
        }
    }

    return 'none';
}

function isOccupied(x, y) {
     return x < 0 || x >= COLS || y >= TOTAL_ROWS || (y >= 0 && playfield[y][x]);
}


// Locking Piece and Clearing Lines
function lockPiece() {
    cancelLockDelay(); // Ensure timer is stopped

    const shape = getRotatedPiece(currentPiece, currentRotation);
    const size = shape.length;
    let lockHeight = 0; // Find highest block row to check lock-out

    for (let r = 0; r < size; r++) {
        for (let c = 0; c < size; c++) {
            if (shape[r][c]) {
                const boardX = currentX + c;
                const boardY = currentY + r;

                // Check bounds (should be okay if checks passed, but safety first)
                if (boardX >= 0 && boardX < COLS && boardY >= 0 && boardY < TOTAL_ROWS) {
                    playfield[boardY][boardX] = currentPiece.color;
                    if (boardY < BUFFER_ROWS) { // Check if piece locked above visible area
                        lockHeight = Math.min(lockHeight, boardY);
                    }
                } else if (boardY < 0) {
                    // This case should ideally not happen if spawn/movement is correct
                    // But if it does, it's a potential pre-buffer lock-out? Treat as game over.
                    lockHeight = Math.min(lockHeight, boardY);
                }
                 // Track the highest point piece locked in
                 if (boardY > lockHeight) lockHeight = boardY;
            }
        }
    }

    // Check Lock Out Game Over condition (part of piece is above visible row 20)
    if (lockHeight < BUFFER_ROWS) {
         console.log("Lock out! Piece locked above visible area.");
         gameOver();
         return; // Stop processing if game over
    }


    playSound(sounds.lock);

    // Check for line clears
    const linesClearedCount = clearLines();

    // --- Scoring ---
    let scoreToAdd = 0;
    let currentClearIsDifficult = false;

    if (linesClearedCount > 0) {
        comboCount++; // Increment combo
        let baseScore = 0;

        // 1. T-Spin Scoring
        if (tSpinStatus !== 'none' && currentPiece.type === 'T') {
             playSound(sounds.tSpin);
             tSpinCount++;
             currentClearIsDifficult = true;
             if (tSpinStatus === 'tspin') {
                 switch (linesClearedCount) {
                     case 0: baseScore = 400; break; // T-Spin
                     case 1: baseScore = 800; break; // T-Spin Single
                     case 2: baseScore = 1200; break; // T-Spin Double
                     case 3: baseScore = 1600; break; // T-Spin Triple
                 }
             } else { // Mini T-Spin
                 switch (linesClearedCount) {
                     case 0: baseScore = 100; break; // Mini T-Spin (no lines)
                     case 1: baseScore = 200; break; // Mini T-Spin Single
                     // Mini T-Spin Double is usually not possible/recognized in standard rules
                 }
             }
             scoreToAdd = baseScore * level;
         }
        // 2. Line Clear Scoring (if not a T-Spin line clear)
        else {
            switch (linesClearedCount) {
                case 1: baseScore = 100; break; // Single
                case 2: baseScore = 300; break; // Double
                case 3: baseScore = 500; break; // Triple
                case 4: // Tetris
                    baseScore = 800;
                    currentClearIsDifficult = true;
                    tetrisCount++;
                    playSound(sounds.tetris);
                    break;
            }
            if (linesClearedCount < 4 && linesClearedCount > 0) {
                playSound(sounds.clear);
            }
            scoreToAdd = baseScore * level;
        }

        // 3. Back-to-Back Bonus
        if (currentClearIsDifficult) {
            if (backToBack > 0) { // Was the *previous* clear also difficult?
                scoreToAdd = Math.floor(scoreToAdd * 1.5); // Apply 50% B2B bonus
                b2bElement.textContent = `${backToBack}x`; // Show B2B chain count
            }
            backToBack++; // Increment B2B chain eligibility/count
        } else {
            backToBack = 0; // Reset B2B chain if clear wasn't difficult
            b2bElement.textContent = `0x`;
        }

        // 4. Combo Bonus
        if (comboCount > 0) {
            scoreToAdd += 50 * comboCount * level;
        }
        comboElement.textContent = `${comboCount}x`;

        addScore(scoreToAdd);
        updateLines(linesClearedCount);

    } else { // Piece locked without clearing lines
         comboCount = -1; // Reset combo
         comboElement.textContent = `0x`;
         // T-Spin with no lines still scores
         if (tSpinStatus === 'tspin' && currentPiece.type === 'T') {
             playSound(sounds.tSpin);
             tSpinCount++;
             scoreToAdd = 400 * level;
             currentClearIsDifficult = true; // T-spin 0 lines counts for B2B
              if (backToBack > 0) {
                 scoreToAdd = Math.floor(scoreToAdd * 1.5);
                 b2bElement.textContent = `${backToBack}x`;
              }
              backToBack++;
              addScore(scoreToAdd);
         } else if (tSpinStatus === 'mini' && currentPiece.type === 'T') {
             playSound(sounds.tSpin);
             tSpinCount++;
             scoreToAdd = 100 * level;
             // Mini T-Spin 0 lines usually doesn't count for B2B
             backToBack = 0;
             b2bElement.textContent = `0x`;
              addScore(scoreToAdd);
         } else {
            // If not a T-spin 0 line, B2B eligibility is maintained only if previous was difficult
            if (!lastClearWasDifficult) backToBack = 0; // Only reset B2B if the *previous* wasn't difficult either
            b2bElement.textContent = `${backToBack > 0 ? backToBack-1 : 0}x`; // Display stops counting if broken

         }
    }

    lastClearWasDifficult = currentClearIsDifficult; // Remember if this clear was difficult for next B2B check

     updateStatsUI(); // Update T-spin/Tetris counts display

    // Spawn next piece only if game not over
    if (!isGameOver) {
       spawnPiece();
    }
}


function clearLines() {
    let linesToClear = [];
    // Check from bottom row up to the buffer zone start
    for (let y = TOTAL_ROWS - 1; y >= 0; y--) {
        if (playfield[y].every(cell => cell !== null)) {
            linesToClear.push(y);
        }
    }

    if (linesToClear.length > 0) {
        // Remove cleared lines and shift down
        for (const lineIndex of linesToClear) {
            // Shift all rows above the cleared line down
            for (let y = lineIndex; y > 0; y--) {
                playfield[y] = playfield[y - 1];
            }
            // Insert new empty row at the top
            playfield[0] = Array(COLS).fill(null);
        }
    }

    return linesToClear.length;
}

// Scoring and Leveling
function addScore(points) {
    score += points;
    scoreElement.textContent = score;
}

function updateLines(count) {
    linesCleared += count;
    linesElement.textContent = linesCleared;
    checkLevelUp();
}

function checkLevelUp() {
     // Fixed Goal System: Level up every 10 lines
    const targetLinesForNextLevel = level * 10;
    if (linesCleared >= targetLinesForNextLevel) {
        level++;
        levelElement.textContent = level;
        goalLines = level * 10; // Next goal
        goalElement.textContent = goalLines;
        playSound(sounds.levelUp);
        updateGravity();

        // Increase BGM tempo slightly (example)
        if (sounds.bgm) {
             // Playback rate increase capped at 2.0 for sanity
             sounds.bgm.playbackRate = Math.min(2.0, 1.0 + (level - 1) * 0.05);
        }
    } else {
         goalElement.textContent = targetLinesForNextLevel; // Show current goal if not leveled up
    }
}


function getGravitySpeed() {
    // Formula based on Tetris guidelines (speeds up significantly)
    // Level 1: ~0.8s (48 frames at 60fps)
    // Level speeds up progressively. Example formula:
    const framesPerGridCell = Math.pow((0.8 - ((level - 1) * 0.007)), level - 1) * (48); // Approximation
    const speedInSeconds = (framesPerGridCell / 60); // Convert frames to seconds assuming 60 logic FPS target
    // Clamp speed, minimum is effectively 1 grid cell per frame (~16.67ms) at high levels
    return Math.max(16.67, speedInSeconds * 1000); // Return milliseconds
}


function updateGravity() {
    if (gravityIntervalId) {
        clearInterval(gravityIntervalId);
    }
    const speed = getGravitySpeed();
    gravityIntervalId = setInterval(() => {
        if (!isPaused && !isGameOver && !softDropActive) { // Gravity doesn't apply during soft drop
            moveDown();
        }
    }, speed);
}


function updateStatsUI() {
    tSpinsElement.textContent = tSpinCount;
    tetrisesElement.textContent = tetrisCount;
}


// Hold Function
function holdPiece() {
    if (isPaused || isGameOver || !canHold) return;

    playSound(sounds.hold);
    cancelLockDelay(); // Holding cancels lock delay

    if (heldPiece === null) {
        // Hold current piece, spawn next
        heldPiece = currentPiece.type;
        spawnPiece();
    } else {
        // Swap current and held piece
        const tempType = currentPiece.type;
        currentPiece = getPieceData(heldPiece);
        currentPiece.type = heldPiece; // Remember the type
        heldPiece = tempType;

        // Reset position and rotation for the piece coming from hold
        currentRotation = 0;
        currentX = Math.floor(COLS / 2) - Math.ceil(currentPiece.shape.length / 2);
         if (currentPiece.type === 'I') {
            currentY = BUFFER_ROWS - 3;
        } else if (currentPiece.type === 'O') {
            currentX = Math.floor(COLS / 2) - 1;
            currentY = BUFFER_ROWS - 2;
        } else {
             currentY = BUFFER_ROWS - 2;
        }


        // Check for collision immediately after swap
        if (checkCollision(currentX, currentY, currentRotation)) {
            // If swapped piece collides immediately, game might be over
            // Or maybe nudge it? For simplicity, treat as potential game over state if unrecoverable.
            // A proper implementation might try nudges, but sticking to basics here.
             gameOver(); // Simplified handling: immediate collision after hold = game over
             return;
        }
    }

    canHold = false; // Prevent holding again until next piece locks
    lastMoveWasRotation = false;
    tSpinStatus = 'none';
    drawHoldQueue(); // Update display
}

// Game Over
function gameOver() {
    if (isGameOver) return; // Prevent multiple triggers

    console.log("Game Over!");
    isGameOver = true;
    playSound(sounds.gameOver);
    sounds.bgm.pause();
    sounds.bgm.currentTime = 0; // Reset BGM

    clearInterval(gravityIntervalId);
    cancelAnimationFrame(gameLoopRequestId);
    cancelLockDelay();
    clearTimeout(dasLeftTimeout);
    clearTimeout(dasRightTimeout);
    clearInterval(dasLeftInterval);
    clearInterval(dasRightInterval);


    messageText.textContent = `GAME OVER! Score: ${score}`;
    messageOverlay.style.display = 'flex';
    restartButton.style.display = 'block';

    saveHighScore();
}

// Pause
function togglePause() {
    if (isGameOver) return;

    isPaused = !isPaused;
    if (isPaused) {
        cancelAnimationFrame(gameLoopRequestId); // Stop rendering
        clearInterval(gravityIntervalId); // Stop gravity
        cancelLockDelay(); // Stop lock delay timer
        clearTimeout(dasLeftTimeout);
        clearTimeout(dasRightTimeout);
        clearInterval(dasLeftInterval);
        clearInterval(dasRightInterval);
        sounds.bgm.pause();
        messageText.textContent = 'PAUSED';
        messageOverlay.style.display = 'flex';
        restartButton.style.display = 'none'; // Hide restart when paused
    } else {
        messageOverlay.style.display = 'none';
        updateGravity(); // Resume gravity
        gameLoopRequestId = requestAnimationFrame(gameLoop); // Resume rendering
        // Resume DAS if keys were held (tricky, might need keyup/down state check)
        // For simplicity, player needs to repress keys after unpausing
        sounds.bgm.play().catch(e => console.log("BGM resume failed", e));
    }
}

// --- Rendering ---
function clearCanvas(ctx, canvasElement) {
    ctx.clearRect(0, 0, canvasElement.width, canvasElement.height);
}

function drawBlock(ctx, x, y, color) {
    ctx.fillStyle = color;
    // Draw slightly smaller block with border effect
    ctx.fillRect(x * BLOCK_SIZE + 1, y * BLOCK_SIZE + 1, BLOCK_SIZE - 2, BLOCK_SIZE - 2);
    // Add a subtle border/highlight
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.2)';
    ctx.strokeRect(x * BLOCK_SIZE + 0.5, y * BLOCK_SIZE + 0.5, BLOCK_SIZE - 1, BLOCK_SIZE - 1);
    ctx.strokeStyle = 'rgba(0, 0, 0, 0.3)';
     ctx.strokeRect(x * BLOCK_SIZE + 1.5, y * BLOCK_SIZE + 1.5, BLOCK_SIZE - 3, BLOCK_SIZE - 3);
}

function drawPlayfield() {
    for (let y = 0; y < ROWS; y++) { // Only draw visible rows
        for (let x = 0; x < COLS; x++) {
            const boardY = y + BUFFER_ROWS; // Map visible row index to playfield array index
            if (playfield[boardY][x]) {
                drawBlock(context, x, y, playfield[boardY][x]);
            }
        }
    }
     // Draw grid lines (optional)
     context.strokeStyle = 'rgba(128, 128, 128, 0.1)';
     for (let x = 1; x < COLS; x++) {
         context.beginPath();
         context.moveTo(x * BLOCK_SIZE, 0);
         context.lineTo(x * BLOCK_SIZE, ROWS * BLOCK_SIZE);
         context.stroke();
     }
      for (let y = 1; y < ROWS; y++) {
         context.beginPath();
         context.moveTo(0, y * BLOCK_SIZE);
         context.lineTo(COLS * BLOCK_SIZE, y * BLOCK_SIZE);
         context.stroke();
     }
}

function drawPiece(ctx, pieceData, x, y, rotation, isGhost = false) {
    if (!pieceData) return;
    const shape = getRotatedPiece(pieceData, rotation);
    const color = pieceData.color;
    const size = shape.length;

    ctx.globalAlpha = isGhost ? 0.3 : 1.0; // Transparency for ghost

    for (let r = 0; r < size; r++) {
        for (let c = 0; c < size; c++) {
            if (shape[r][c]) {
                const drawX = x + c;
                const drawY = y + r - BUFFER_ROWS; // Adjust Y to be relative to visible area

                // Only draw blocks that are within the visible playfield bounds
                if (drawX >= 0 && drawX < COLS && drawY >= 0 && drawY < ROWS) {
                     if (isGhost) {
                         // Ghost piece style: outline or different fill
                         ctx.strokeStyle = color;
                         ctx.lineWidth = 2;
                         ctx.strokeRect(drawX * BLOCK_SIZE + 1, drawY * BLOCK_SIZE + 1, BLOCK_SIZE - 2, BLOCK_SIZE - 2);
                         ctx.lineWidth = 1; // Reset line width
                     } else {
                        drawBlock(ctx, drawX, drawY, color);
                     }
                }
            }
        }
    }
    ctx.globalAlpha = 1.0; // Reset alpha
}

function calculateGhostPosition() {
    let ghostY = currentY;
    while (!checkCollision(currentX, ghostY + 1, currentRotation)) {
        ghostY++;
    }
    return ghostY;
}


function drawNextQueue() {
    clearCanvas(nextContext, nextCanvas);
    const blockSize = 20; // Smaller blocks for preview
    const padding = 10;
    let startY = padding;

    for (let i = 0; i < Math.min(NEXT_QUEUE_SIZE, nextPieces.length); i++) {
        const type = nextPieces[i];
        const pieceData = getPieceData(type);
        const shape = pieceData.shape; // Use spawn orientation
        const color = pieceData.color;
        const size = shape.length;
        const pieceWidth = shape[0].filter(Boolean).length > 0 ? size : size - 1; // Crude width estimate
        const pieceHeight = shape.filter(row => row.some(Boolean)).length;

        // Center the piece horizontally
        const startX = Math.floor((nextCanvas.width - (pieceWidth * blockSize)) / 2);

        for (let r = 0; r < size; r++) {
            for (let c = 0; c < size; c++) {
                if (shape[r][c]) {
                    // Draw using mini block size
                     nextContext.fillStyle = color;
                     nextContext.fillRect(startX + c * blockSize + 1, startY + r * blockSize + 1, blockSize - 2, blockSize - 2);
                     nextContext.strokeStyle = 'rgba(255, 255, 255, 0.2)';
                     nextContext.strokeRect(startX + c * blockSize + 0.5, startY + r * blockSize + 0.5, blockSize - 1, blockSize - 1);
                }
            }
        }
        // Move drawing position down for the next piece
        startY += (pieceHeight * blockSize) + padding; // Adjust spacing based on piece height
    }
}

function drawHoldQueue() {
    clearCanvas(holdContext, holdCanvas);
    if (heldPiece) {
        const pieceData = getPieceData(heldPiece);
        const shape = pieceData.shape; // Spawn orientation
        const color = pieceData.color;
        const size = shape.length;
        const blockSize = 20; // Smaller blocks
        const pieceWidth = shape[0].filter(Boolean).length > 0 ? size : size -1;
        const pieceHeight = shape.filter(row => row.some(Boolean)).length;

        // Center piece
        const startX = Math.floor((holdCanvas.width - (pieceWidth * blockSize)) / 2);
        const startY = Math.floor((holdCanvas.height - (pieceHeight * blockSize)) / 2);

         if (!canHold) { // Dim the held piece if hold is not available
            holdContext.globalAlpha = 0.5;
        }

        for (let r = 0; r < size; r++) {
            for (let c = 0; c < size; c++) {
                if (shape[r][c]) {
                    holdContext.fillStyle = color;
                    holdContext.fillRect(startX + c * blockSize + 1, startY + r * blockSize + 1, blockSize - 2, blockSize - 2);
                    holdContext.strokeStyle = 'rgba(255, 255, 255, 0.2)';
                    holdContext.strokeRect(startX + c * blockSize + 0.5, startY + r * blockSize + 0.5, blockSize - 1, blockSize - 1);
                }
            }
        }
         holdContext.globalAlpha = 1.0; // Reset alpha
    }
}

// --- Game Loop ---
let lastTime = 0;
const targetLogicRate = 1000 / 60; // ~60 updates per second for logic consistency (not used for gravity)

function gameLoop(timestamp) {
    if (isGameOver || isPaused) return;

    // Note: Gravity is handled by setInterval for consistent fall speed based on level.
    // The game loop here focuses on rendering and potentially other fast updates if needed.

    // Clear main canvas
    clearCanvas(context, canvas);

    // Draw static elements
    drawPlayfield();

    // Draw dynamic elements
    const ghostY = calculateGhostPosition();
    drawPiece(context, currentPiece, currentX, ghostY, currentRotation, true); // Draw ghost first
    drawPiece(context, currentPiece, currentX, currentY, currentRotation, false); // Draw actual piece

    // Draw UI elements (updated elsewhere, but queues need drawing)
    drawNextQueue();
    drawHoldQueue(); // Draw hold piece state

    // Request next frame
    gameLoopRequestId = requestAnimationFrame(gameLoop);
}

// --- Input Handling ---
function handleKeyDown(e) {
    if (isGameOver) return; // Ignore input if game over

    // Handle pause first
    if (e.key === 'Escape' || e.key === 'p' || e.key === 'P') {
        e.preventDefault();
        togglePause();
        return; // Stop processing other keys if pausing/unpausing
    }

    if (isPaused) return; // Ignore game controls if paused

    keys[e.key] = true; // Mark key as down

    switch (e.key) {
        case 'ArrowLeft':
        case 'a':
        case 'A':
            e.preventDefault();
            if (!dasLeftTimeout && !dasLeftInterval) { // Prevent re-triggering while DAS active
                moveLeft(); // Initial move
                // Start DAS timeout
                dasLeftTimeout = setTimeout(() => {
                    dasLeftInterval = setInterval(() => {
                        if (keys['ArrowLeft'] || keys['a'] || keys['A']) { // Check if key is still held
                           moveLeft();
                        } else {
                            clearInterval(dasLeftInterval); // Stop interval if key released
                            dasLeftInterval = null;
                        }
                    }, DAS_INTERVAL);
                }, DAS_DELAY);
            }
            break;
        case 'ArrowRight':
        case 'd':
        case 'D':
            e.preventDefault();
             if (!dasRightTimeout && !dasRightInterval) {
                moveRight(); // Initial move
                dasRightTimeout = setTimeout(() => {
                    dasRightInterval = setInterval(() => {
                         if (keys['ArrowRight'] || keys['d'] || keys['D']) {
                           moveRight();
                        } else {
                            clearInterval(dasRightInterval);
                            dasRightInterval = null;
                        }
                    }, DAS_INTERVAL);
                }, DAS_DELAY);
            }
            break;
        case 'ArrowDown':
        case 's':
        case 'S':
            e.preventDefault();
            if (!softDropActive) {
                softDropActive = true;
                // Temporarily increase gravity speed (or just call moveDown more frequently)
                // Simpler approach: just call moveDown immediately
                 moveDown();
                 // Optional: set faster interval for soft drop feel, but moveDown on keypress is enough
            }
             // Award soft drop points on initial press and subsequent moves while held
             addScore(1);
            break;
        case 'ArrowUp':
        case 'w':
        case 'W':
            e.preventDefault();
            rotate(true); // Clockwise rotation
            break;
        // Optional: Counter-clockwise rotation (e.g., Ctrl or Z)
        case 'Control':
        case 'z':
        case 'Z':
             e.preventDefault();
             rotate(false); // Counter-clockwise
             break;
        case ' ': // Spacebar for Hard Drop
            e.preventDefault();
            hardDrop();
            break;
        case 'c':
        case 'C':
        case 'Shift': // Shift often used for Hold too
            e.preventDefault();
            holdPiece();
            break;
    }
}

function handleKeyUp(e) {
     keys[e.key] = false; // Mark key as up

    switch (e.key) {
        case 'ArrowLeft':
        case 'a':
        case 'A':
            clearTimeout(dasLeftTimeout);
            clearInterval(dasLeftInterval);
            dasLeftTimeout = null;
            dasLeftInterval = null;
            break;
        case 'ArrowRight':
        case 'd':
        case 'D':
            clearTimeout(dasRightTimeout);
            clearInterval(dasRightInterval);
            dasRightTimeout = null;
            dasRightInterval = null;
            break;
        case 'ArrowDown':
        case 's':
        case 'S':
            softDropActive = false;
            // Reset gravity speed if it was changed for soft drop
            break;
    }
}

// --- Persistence (High Score using localStorage) ---
function saveHighScore() {
    const currentHighScore = loadHighScore();
    if (score > currentHighScore) {
        try {
            localStorage.setItem('tetrisHighScore', score.toString());
            console.log("New high score saved:", score);
        } catch (e) {
            console.error("Failed to save high score:", e);
        }
    }
}

function loadHighScore() {
    try {
        const highScore = localStorage.getItem('tetrisHighScore');
        return highScore ? parseInt(highScore, 10) : 0;
    } catch (e) {
        console.error("Failed to load high score:", e);
        return 0;
    }
}

// --- Initialization ---
function initGame() {
    console.log("Initializing Tetris...");
    isGameOver = false;
    isPaused = false;
    score = 0;
    level = 1;
    linesCleared = 0;
    goalLines = 10; // Initial goal for level 1
    comboCount = -1;
    backToBack = 0;
    lastClearWasDifficult = false;
    tSpinCount = 0;
    tetrisCount = 0;
    heldPiece = null;
    canHold = true;
    currentBag = [];
    nextPieces = [];

    // Clear intervals/timeouts
    clearInterval(gravityIntervalId);
    cancelAnimationFrame(gameLoopRequestId);
    cancelLockDelay();
    clearTimeout(dasLeftTimeout); clearTimeout(dasRightTimeout);
    clearInterval(dasLeftInterval); clearInterval(dasLeftInterval);


    // Reset UI
    scoreElement.textContent = score;
    levelElement.textContent = level;
    linesElement.textContent = linesCleared;
    goalElement.textContent = goalLines;
    messageOverlay.style.display = 'none';
    restartButton.style.display = 'none';
     updateStatsUI(); // Reset stats display
     comboElement.textContent = '0x';
     b2bElement.textContent = '0x';


    // Setup game state
    playfield = createEmptyPlayfield();
    fillNextQueue(); // Initial fill for the queue
    fillNextQueue(); // Ensure enough pieces initially
    spawnPiece(); // Spawn the first piece

    // Start loops
    updateGravity();
    gameLoopRequestId = requestAnimationFrame(gameLoop);


    // Start background music
    sounds.bgm.currentTime = 0;
    sounds.bgm.playbackRate = 1.0; // Reset playback rate
    sounds.bgm.play().catch(e => console.log("BGM failed to play on start:", e));


    console.log("Game Ready!");
    console.log("High Score:", loadHighScore());
}

// --- Event Listeners ---
document.addEventListener('keydown', handleKeyDown);
document.addEventListener('keyup', handleKeyUp);
restartButton.addEventListener('click', initGame);

// --- Start Game ---
// Need to wait for audio to potentially load, or handle user interaction first
window.onload = () => {
     // Display something initially, maybe a "Click to Start"
     messageText.textContent = 'Press any key or click Play Again to Start';
     messageOverlay.style.display = 'flex';
     restartButton.style.display = 'block'; // Show button immediately now

     // Let's allow starting with a key press as well
     const startHandler = (e) => {
         if (!isGameOver && messageOverlay.style.display !== 'none') { // Check if initial screen is showing
             // Only start if it's the initial message overlay, not pause/game over
             if (messageText.textContent.includes("Start")) {
                 initGame();
                  // Remove this specific starter listener after first start
                 document.removeEventListener('keydown', startHandler);
                 window.removeEventListener('click', startHandler); // Also allow click to start
             }
         }
     };
     document.addEventListener('keydown', startHandler);
     window.addEventListener('click', startHandler); // Click anywhere to start initially
};

// Optional: Add focus to the window/body to ensure key events are captured
// window.focus(); // Might be blocked by browser security policies

EOF
echo "Created script.js"

echo ""
echo "Tetris game files created successfully!"
echo "Make sure to populate the 'sounds/' directory with the required audio files."
echo "Then, open index.html in your web browser to play."

exit 0
