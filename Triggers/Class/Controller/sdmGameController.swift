//
//  sdmGameController.swift
//  Triggers
//
//  Created by Peter Spencer on 22/10/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit
import SceneKit


class GameController: UIViewController
{
    // MARK: - Property(s)
    
    var game: Game?
    
    private var observation: NSKeyValueObservation?
    
    
    // MARK: - Cleaning Up
    
    deinit
    { self.observation?.invalidate() }
    
    
    // MARK: - Managing the View
    
    override func loadView()
    {
        let rootView = GameView(frame: UIScreen.main.bounds, options: [:])
        self.view = rootView
    }
    
    
    // MARK: - Responding to View Events
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        guard let gameView = self.view as? GameView else
        { return }
        
        self.game = Game()
        self.game?.load()
        self.observation = self.game?.trigger.attach(self.handler)
        
        gameView.scene = self.game?.scene
        gameView.pointOfView = self.game?.camera
    }
}

// MARK: - Action(s)
extension GameController
{
    func handler(_ trigger: TriggerNode,
                 _ change: NSKeyValueObservedChange<TriggerEvent>)
    {
        if let status = change.newValue?.status
        {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.3
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            self.game?.box.position.y = (status == .begin ? 3.0 : 1.0)
            SCNTransaction.commit()
        }
    }
}

