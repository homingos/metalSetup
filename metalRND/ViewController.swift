//
//  ViewController.swift
//  metalRND
//
//  Created by Vishwas Prakash on 03/12/24.
//

import UIKit

class ViewController: UIViewController {
    private var metalView: MetalView!
    private var joystickView: JoystickView!


    override func viewDidLoad() {
        super.viewDidLoad()

        setupMetalView()
        setupJoystickView()

    }
    
    private func setupMetalView() {
        // Create an instance of MetalView
        let metalView = MetalView(frame: self.view.bounds, device: MTLCreateSystemDefaultDevice())
        metalView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        metalView.translatesAutoresizingMaskIntoConstraints = true
        
        // Add MetalView as a subview
        self.view.addSubview(metalView)
    }
    private func setupJoystickView() {
        joystickView = JoystickView(frame: CGRect(x: self.view.bounds.midX - 50, y: self.view.bounds.midY + 250, width: 100, height: 100))
        joystickView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        joystickView.backgroundColor = .cyan
        
        self.view.addSubview(joystickView)
    }
}
