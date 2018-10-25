//
//  sdmSceneKit-ext.swift
//  Triggers
//
//  Created by Peter Spencer on 22/10/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import SceneKit


// MARK: - SCNPhysicsContact
extension SCNPhysicsContact
{
    var nodes: [SCNNode]
    { return [self.nodeA, self.nodeB] }
}

