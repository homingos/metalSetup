//
//  JoystickView.swift
//  metalRND
//
//  Created by Vishwas Prakash on 03/12/24.
//

import UIKit

class JoystickView: UIView {
    
    private var thumbView: UIView!
    private var centerPoint: CGPoint!
    private var joystickRadius: CGFloat!
    private var thumbRadius: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupJoystick()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupJoystick()
    }
    
    private func setupJoystick() {
        // Adjust the joystick size (make it smaller)
        joystickRadius = self.bounds.width / 2  // Adjust as needed (e.g., 50 points for 100x100 area)
        thumbRadius = joystickRadius / 4       // Thumbstick size (quarter of joystick size)
        
        // Set the center point of the joystick
        centerPoint = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        // Create thumb view (smaller circular element that moves)
        thumbView = UIView(frame: CGRect(x: 0, y: 0, width: thumbRadius * 2, height: thumbRadius * 2))
        thumbView.layer.cornerRadius = thumbRadius
        thumbView.backgroundColor = .blue
        thumbView.center = centerPoint
        self.addSubview(thumbView)
        
        // Set the background color of the joystick and border
        self.layer.cornerRadius = joystickRadius
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        let distance = distanceFromCenter(to: touchLocation)
        
        // Ensure the thumb moves only within the joystick radius
        if distance <= joystickRadius - thumbRadius {
            thumbView.center = touchLocation
        } else {
            let angle = angleFromCenter(to: touchLocation)
            let newX = centerPoint.x + (joystickRadius - thumbRadius) * cos(angle)
            let newY = centerPoint.y + (joystickRadius - thumbRadius) * sin(angle)
            thumbView.center = CGPoint(x: newX, y: newY)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset the thumb to the center when the touch ends
        thumbView.center = centerPoint
    }
    
    // Helper function to calculate the distance from the center
    private func distanceFromCenter(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - centerPoint.x, 2) + pow(point.y - centerPoint.y, 2))
    }
    
    // Helper function to calculate the angle from the center
    private func angleFromCenter(to point: CGPoint) -> CGFloat {
        return atan2(point.y - centerPoint.y, point.x - centerPoint.x)
    }
}
