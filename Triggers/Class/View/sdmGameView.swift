//
//  sdmGameView.swift
//  Triggers
//
//  Created by Peter Spencer on 20/10/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import SceneKit


class GameView: SCNView
{
    // MARK: - Initialisation
    
    override init(frame: CGRect,
                  options: [String : Any]? = nil)
    {
        super.init(frame: frame, options: options)
        
        self.backgroundColor = UIColor.white
        self.allowsCameraControl = true
        self.autoenablesDefaultLighting = true
        self.debugOptions.insert(.showPhysicsShapes)
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
}

