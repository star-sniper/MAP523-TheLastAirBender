//
//  GameScene.swift
//  FinalProject
//
//  Created by Harshit Arora on 2019-07-13.
//  Copyright © 2019 Harshit Arora. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var playNode : SKSpriteNode! = nil
    var top10: SKSpriteNode! = nil
    var exitNode: SKSpriteNode! = nil
    let Iscreen = SKScene(fileNamed: "InitialScreen")
    let Tscreen = SKScene(fileNamed: "Leaderboard")
    
    override func didMove(to view: SKView) {
       
        playNode = self.childNode(withName: "playBtn") as? SKSpriteNode
        playNode.name = "playNode"
        playNode.isUserInteractionEnabled = false
        
        top10 = self.childNode(withName: "topPlayer") as? SKSpriteNode
        top10.name = "top10"
        top10.isUserInteractionEnabled = false
        
        exitNode = self.childNode(withName: "exitBtn") as? SKSpriteNode
        exitNode.name = "exitNode"
        exitNode.isUserInteractionEnabled = false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "playNode"
            {
                let skView = self.view!
                let trans = SKTransition.moveIn(with: .right, duration: 2)
               // let nextScene = InitialScreen(size: Iscreen!.size)
                //InitialScreen iS = i
                Iscreen?.scaleMode = .aspectFill
                skView.presentScene(Iscreen!, transition: trans)
            }
            if( name == "top10")
            {
                let skView = self.view!
                let trans = SKTransition.moveIn(with: .right, duration: 2)
                // let nextScene = InitialScreen(size: Iscreen!.size)
                //InitialScreen iS = i
                Tscreen?.scaleMode = .aspectFill
                skView.presentScene(Tscreen!, transition: trans)
            }
            if(name == "exitNode")
            {
                 UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                      to: UIApplication.shared, for: nil)
                
            }
        }
    }
    
}
