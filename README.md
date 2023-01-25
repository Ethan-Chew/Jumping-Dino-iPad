# Jumping Dinosaur on iPad
'Clone' of the Google Chrome Dinosaur Game where you have to actually jump in real life  
![Image](https://assets.ethanchew.com/jumpingdino)

## How it works
- Uses Vision to detect your face  
- Set a position where you will be standing (not jumping yet)  
- Every time you jump, the offset from the calibrated position is calculated. If it is above a certain threshold, it will be considered as a jump  
- Every jump is sent to SpriteKit where you will be able to see your dinosaur jump

## How to play
1. Run the app by pressing `Command + R`  
2. Ensure that the player walks back far enough that their face is fully visible in the Camera view  
3. Press the 'Calibrate' button, a blue line should appear above the player's head. Jump above that line for it to register as a jump
4. Have fun! Press the 'Reset Game' button to restart the game.
| Note: There will be some delay from the time you jump and the time the dinosaur jumps in the game. Do take note of that!

## Technologies Used
1. SwiftUI  
2. UIKit  
3. Vision  
4. AVFoundation  
5. SpriteKit
