//
//  sdmTriggerNode.swift
//  Triggers
//
//  Created by Peter Spencer on 22/10/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import SceneKit


protocol TriggerContactDelegate: class
{
    func trigger(status: TriggerStatus, for contact: SCNPhysicsContact)
}

typealias TriggerHandler = (TriggerNode, NSKeyValueObservedChange<TriggerEvent>) -> Void

enum TriggerBitMask: Int
{
    case `default` = 1001
}

enum TriggerStatus: Int
{
    case unkown
    case begin, update, end
    
    func clamp(_ contact: SCNPhysicsContact) -> TriggerStatus
    {
        if self == .update { return self }
        if contact.penetrationDistance >= 0.1 { return .unkown }
        return self
    }
}

final class TriggerEvent: NSObject /* https://bugs.swift.org/browse/SR-7533 */
{
    let status: TriggerStatus
    let other: SCNNode?
    
    init(_ status: TriggerStatus, node: SCNNode? = nil)
    {
        self.status = status
        self.other = node ?? nil
    }
    
    init(_ status: TriggerStatus, contact: SCNPhysicsContact)
    {
        self.status = status.clamp(contact)
        self.other = contact.nodes.filter ({ $0.categoryBitMask != TriggerBitMask.default.rawValue }).first as? TriggerNode
    }
}

@objcMembers
class TriggerNode: SCNNode
{
    // MARK: - Property(s)
    
    dynamic var event: TriggerEvent = TriggerEvent(.unkown)
    
    var isEnabled: Bool = true
    
    var isContinuous: Bool = false
    
    override var categoryBitMask: Int
    {
        get { return TriggerBitMask.default.rawValue }
        set {}
    }
    
    
    // MARK: - Attaching Observer(s)
    
    func attach(_ handler: @escaping TriggerHandler) -> NSKeyValueObservation /* TODO:Should this be a protocol ..? */
    {
        return self.observe(\TriggerNode.event,
                            options: [.new],
                            changeHandler: handler)
    }
    
    
    // MARK: - Shape(s)
    
    static func box(extents: SCNVector3) -> TriggerNode
    {
        let trigger = TriggerNode()
        
        let box = SCNBox(width: CGFloat(extents.x),
                         height: CGFloat(extents.y),
                         length: CGFloat(extents.z),
                         chamferRadius: 0)
        let node = SCNNode(geometry: box)
        let options = [SCNPhysicsShape.Option.type:SCNPhysicsShape.ShapeType.boundingBox]
        
        trigger.physicsBody = SCNPhysicsBody(type: .static,
                                          shape: SCNPhysicsShape(node: node, options: options))
        trigger.physicsBody?.contactTestBitMask = TriggerBitMask.default.rawValue
        
        return trigger
    }
    
    static func capsule(radius: CGFloat,
                        height: CGFloat) -> TriggerNode
    {
        let trigger = TriggerNode()
        
        let geometry = SCNCapsule(capRadius: radius, height: height)
        geometry.heightSegmentCount = 1
        geometry.capSegmentCount = 3
        geometry.radialSegmentCount = 6
        
        trigger.physicsBody = SCNPhysicsBody(type: .static,
                                             shape: SCNPhysicsShape(geometry: geometry, options: [:]))
        trigger.physicsBody?.contactTestBitMask = TriggerBitMask.default.rawValue
        
        return trigger
    }
    
    static func sphere(radius: CGFloat) -> TriggerNode
    {
        let trigger = TriggerNode()
        
        let geometry = SCNSphere(radius: radius)
        geometry.segmentCount = 8
        
        trigger.physicsBody = SCNPhysicsBody(type: .static,
                                             shape: SCNPhysicsShape(geometry: geometry, options: [:]))
        trigger.physicsBody?.contactTestBitMask = TriggerBitMask.default.rawValue
        
        return trigger
    }
    
    
    // MARK: - Filtering
    
    static func filter(from contact: SCNPhysicsContact,
                       for status: TriggerStatus) -> TriggerNode?
    {
        let clamped = status.clamp(contact)
        
        guard clamped != .unkown,
            let trigger = contact.nodes.filter ({ $0.categoryBitMask == TriggerBitMask.default.rawValue }).first as? TriggerNode else
        { return nil }
        
        if !trigger.isContinuous && clamped == .update { return nil }
        if !trigger.isEnabled { return nil }
        
        return trigger
    }
}

// MARK: - TriggerContactDelegate
extension SCNScene: TriggerContactDelegate
{
    func trigger(status: TriggerStatus,
                 for contact: SCNPhysicsContact)
    {
        TriggerNode.filter(from: contact, for: status)?.event = TriggerEvent(status, contact: contact)
    }
}

