//
//  sdmGame.swift
//  Triggers
//
//  Created by Peter Spencer on 22/10/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import SceneKit


class Game: NSObject
{
    // MARK: - Property(s)
    
    weak var triggerDelegate: TriggerContactDelegate?
    
    var scene: SCNScene?
    
    private(set) lazy var trigger: TriggerNode =
    { [unowned self] in
        
        let anObject: TriggerNode = TriggerNode.box(extents: SCNVector3(2, 4, 2))
        anObject.name = "trigger"
        anObject.position = SCNVector3(0, 2, 0)
        anObject.isContinuous = false
        
        return anObject
    }()
    
    private(set) lazy var box: SCNNode =
    { [unowned self] in
        
        let dim: CGFloat = 1.75
        let geometry: SCNBox = SCNBox(width: dim*0.5, height: dim, length: dim, chamferRadius: 0)
        geometry.firstMaterial?.diffuse.contents = UIColor.lightGray
        
        let anObject: SCNNode = SCNNode(geometry: geometry)
        anObject.name = "box"
        anObject.position = SCNVector3(0, 1, 0)
        
        return anObject
    }()
    
    private(set) lazy var ball: SCNNode =
    { [unowned self] in
        
        let anObject: SCNNode = SCNNode(geometry: SCNSphere(radius: 1.0))
        anObject.name = "ball"
        anObject.position = SCNVector3(5, 0, 0)
        anObject.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
        anObject.physicsBody = SCNPhysicsBody.kinematic()
        
        return anObject
    }()
    
    private(set) lazy var camera: SCNNode =
    { [unowned self] in
        
        let constraint = SCNLookAtConstraint(target: self.trigger)
        constraint.isGimbalLockEnabled = true
        
        let anObject = SCNNode()
        anObject.name = "camera"
        anObject.camera = SCNCamera()
        anObject.camera?.zNear = 0.1
        anObject.camera?.zFar = 1000.0
        anObject.position = SCNVector3(0, 2, 10)
        anObject.constraints = [constraint]
        
        return anObject
    }()
    
    
    // MARK: - Loading
    
    func load()
    {
        self.scene = SCNScene()
        self.scene?.physicsWorld.contactDelegate = self
        self.triggerDelegate = self.scene
        
        self.scene?.rootNode.addChildNode(self.trigger)
        self.scene?.rootNode.addChildNode(self.box)
        self.scene?.rootNode.addChildNode(self.ball)
        self.scene?.rootNode.addChildNode(self.camera)
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.byValue = -10.0
        animation.duration = 1.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        self.ball.addAnimation(animation, forKey: "autoreverse_posx")
    }
}

// MARK: - SCNPhysicsContactDelegate
extension Game: SCNPhysicsContactDelegate
{
    func physicsWorld(_ world: SCNPhysicsWorld,
                      didBegin contact: SCNPhysicsContact)
    {
        self.triggerDelegate?.trigger(status: .begin, for: contact)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld,
                      didUpdate contact: SCNPhysicsContact)
    {
        self.triggerDelegate?.trigger(status: .update, for: contact)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld,
                      didEnd contact: SCNPhysicsContact)
    {
        self.triggerDelegate?.trigger(status: .end, for: contact)
    }
}

