//  GameScene.swift
//  FinalProject
//
//  Created by Harshit Arora on 2019-07-13.
//  Copyright © 2019 Harshit Arora. All rights reserved.
//

import Foundation 
import SpriteKit
import GameplayKit
import CoreData

class GameScreen : SKScene, SKPhysicsContactDelegate
{
    var backGroundImg = SKSpriteNode(imageNamed: "Arena")
    var enemyNode : SKSpriteNode! = nil
    var playerNode : SKSpriteNode! = nil
    
    var attackLevel1Cat: UInt32 = 0x1 << 1   // = 2
    var enemyCat: UInt32 = 0x1 << 2  // 4
    var cirCat: UInt32 = 0x1 << 3 // 8
    var playerCat: UInt32 = 0x1 << 4 //16
    var attackLevel2Cat: UInt32 = 0x1 << 5 //32
    var attackLevel3Cat: UInt32 = 0x1 << 6 //64
   // var enemyCat: UInt32 = 0x1 << 3
    
    var enemyCount: Int = 4
    let tapRec = UITapGestureRecognizer()
    let swipeRight = UISwipeGestureRecognizer()
    let swipeDown = UISwipeGestureRecognizer()
    let rotate = UIRotationGestureRecognizer()
    var selectedPlayer : String? = nil
    var enemyArray = ["air","water","earth","fire"]
    var enemy: String? = nil
    
    var enemyTimer = Timer()
    var gameTimer = Timer()
    
    var pHBox : SKShapeNode = SKShapeNode(rectOf: CGSize(width: -400, height: 60))
    var eHBox : SKShapeNode = SKShapeNode(rectOf: CGSize(width: 400, height: 60))
    var pHLab : SKLabelNode! = SKLabelNode(fontNamed: "Bradley Hand Bold")
    var eHLab : SKLabelNode! = SKLabelNode(fontNamed: "Bradley Hand Bold")
    
    var timerLabel: SKLabelNode! = SKLabelNode(fontNamed: "Bradley Hand Bold")
    
    var pHCount: Int = 100
    var eHCount: Int = 100
    var counter = 0.0
    
    let gameOver : SKLabelNode! = SKLabelNode(fontNamed: "Bradley Hand Bold")
    
    var gameOverCalled : Bool = false
    
    var attack2Launched: Bool = true
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //ROTATING THE SCREEN
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        //ADDING A BACKGROUND
        backGroundImg.size = CGSize(width: 1334, height: 750)
        backGroundImg.zPosition = 1
        addChild(backGroundImg)
        
        selectedPlayer = InitialScreen.playerSelected
        //SPAWNING PLAYER AND OPPONENT
        spawnPlayer()
        
        var randomIndex = Int(arc4random_uniform(UInt32(enemyArray.count)))
        enemy = enemyArray[randomIndex]
        repeat
        {
            
            randomIndex = Int(arc4random_uniform(UInt32(enemyArray.count)))
            enemy = enemyArray[randomIndex]
            
        }while(enemy == "air");
        
        enemyArray.remove(at: randomIndex)
        enemyCount = enemyCount - 1
        spawnOppnent()
        
        //ADDING TAP GESTURE
        tapRec.addTarget(self, action:#selector(playerTappedView(_:) ))
        tapRec.numberOfTouchesRequired = 1
        tapRec.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapRec)
 
        //ADDING SWIPE DOWN GESTURE
        swipeDown.addTarget(self, action: #selector(swipedDown) )
        swipeDown.direction = .down
        self.view!.addGestureRecognizer(swipeDown)
        
        //ADDING SWIPE RIGHT GESTURE
        swipeRight.addTarget(self, action: #selector(swipedRight) )
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)
        
        rotate.addTarget(self, action: #selector(rotatedView))
        self.view!.addGestureRecognizer(rotate)
        
        //DOESN'T LET PLAYERS GO OUT OF SCREEN
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        enemyAttacking()
        gameOver.name = "gameover"
        gameOver.isUserInteractionEnabled = false
        
        timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        timerLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        timerLabel.fontSize = 58
        timerLabel.fontColor = UIColor.black
        timerLabel.position = CGPoint(x: 0, y: 245)
        timerLabel.zPosition = 4
        self.addChild(timerLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func UpdateTimer()
    {
        counter = counter + 1
        let minutes = Int(counter) / 60 % 60
        let seconds = Int(counter) % 60
        
        timerLabel.text = String(format:"%02i:%02i", minutes, seconds)
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if ((contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 8) ||
            (contact.bodyA.categoryBitMask == 64 && contact.bodyB.categoryBitMask == 8) ||
          (contact.bodyA.categoryBitMask == 32 && contact.bodyB.categoryBitMask == 8))
        {
            contact.bodyA.node?.removeFromParent()
            print("ATTACK1/2/3 AND CIRCLE")
        }
        
        
        //PLAYER'S ATTACK1 HITTING ENEMY
        if (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 4)
        {
            contact.bodyA.node?.removeFromParent()
            eHCount = eHCount - 5
            print("PLAYER'S attack1 and enemy")
        }
        
        //ENEMY'S ATTACK1 HITTING PLAYER
        if (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 16)
        {
            contact.bodyA.node?.removeFromParent()
            pHCount = pHCount - 5
            print("ENEMY'S attack1 and PLAYER")
        }
        
        //PLAYER'S ATTACK1/ATTACK2 AND ENEMY'S ATTACK1/ATTACK2
        if ((contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 2) ||
            (contact.bodyA.categoryBitMask == 32 && contact.bodyB.categoryBitMask == 32) ||
             (contact.bodyA.categoryBitMask == 64 && contact.bodyB.categoryBitMask == 64))
        {
           // contact.bodyA.node?.removeFromParent()
            //ßcontact.bodyB.node?.removeFromParent()
            print("PLAYER'S ATTACK AND ENEMY'S ATTACK")
        }
        
        //PLAYER'S ATTACK2 HITTING ENEMY
        if (contact.bodyA.categoryBitMask == 32 && contact.bodyB.categoryBitMask == 4)
        {
            //contact.bodyA.node?.removeFromParent()
            eHCount = eHCount - 10
            print("PLAYER'S attack2 and enemy")
        }
      
        //ENEMY'S ATTACK2 HITTING PLAYER
        if (contact.bodyA.categoryBitMask == 32 && contact.bodyB.categoryBitMask == 16)
        {
           // contact.bodyA.node?.removeFromParent()
            pHCount = pHCount - 10
            print("ENEMY'S attack2 and PLAYER")
        }
        
        //PLAYER'S ATTACK3 HITTING ENEMY
        if (contact.bodyA.categoryBitMask == 64 && contact.bodyB.categoryBitMask == 4)
        {
            //contact.bodyA.node?.removeFromParent()
            eHCount = eHCount - 15
           // contact.bodyA.node?.removeFromParent()
            print("PLAYER'S attack3 and enemy")
        }
    
        //ENEMY'S ATTACK3 HITTING PLAYER
        if (contact.bodyA.categoryBitMask == 64 && contact.bodyB.categoryBitMask == 16)
        {
            // contact.bodyA.node?.removeFromParent()
            pHCount = pHCount - 15
           // contact.bodyA.node?.removeFromParent()
            print("ENEMY'S attack3 and PLAYER")
        }
        
        //CIRCLE HITTING ATTACK1/2/3
        if ((contact.bodyA.categoryBitMask == 8 && contact.bodyB.categoryBitMask == 2) ||
            (contact.bodyA.categoryBitMask == 8 && contact.bodyB.categoryBitMask == 64))
        {
            contact.bodyB.node?.removeFromParent()
            print("CIRCLE AND ATTACK")
        }
        
        //ATTACK1 OR ATTACK2 OR ATTACK3 HITTING CIRCLE
        if ((contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 8) ||
            (contact.bodyA.categoryBitMask == 64 && contact.bodyB.categoryBitMask == 8))
        {
            contact.bodyA.node?.removeFromParent()
            print("ATTACK AND CIRCLE")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "gameover"
            {
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                
                let skscene = SKScene(fileNamed: "Leaderboard")
                let trans = SKTransition.moveIn(with: .right, duration: 2)
                let skView = self.view!
                skscene?.scaleMode = .aspectFill
                skView.presentScene(skscene!,transition: trans)
            }
        }
    }
    
    func createHealthBars(playerBar: Bool, enemyBar: Bool)
    {
        if(enemyBar == true)
        {
            eHBox = SKShapeNode(rectOf: CGSize(width: 400, height: 60))
            eHBox.position = CGPoint(x: 380, y: 260)
            eHBox.strokeColor = SKColor.black
            eHBox.fillColor = .yellow
            eHBox.zPosition = 4
            self.addChild(eHBox)
            
           // eHLab = SKLabelNode(fontNamed: "Bradley Hand Bold")
            eHLab.text = "100"
            eHLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            eHLab.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            eHLab.fontSize = 58
            eHLab.fontColor = UIColor.black
            eHLab.position = CGPoint(x: 380, y: 245)
            eHLab.zPosition = 4
            self.addChild(eHLab)
        }
        
        if(playerBar == true)
        {
            pHBox = SKShapeNode(rectOf: CGSize(width: 400, height: 60))
            pHBox.position = CGPoint(x: -380, y: 260)
            pHBox.strokeColor = SKColor.black
            pHBox.fillColor = .yellow
            pHBox.zPosition = 4
            self.addChild(pHBox)
            
          //  pHLab = SKLabelNode(fontNamed: "Bradley Hand Bold")
            pHLab.text = "100"
            pHLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            pHLab.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            pHLab.fontSize = 58
            pHLab.fontColor = UIColor.black
            pHLab.position = CGPoint(x: -380, y: 245)
            pHLab.zPosition = 4
            self.addChild(pHLab)
            
        }
    }
    
    func updateHealthBars(actor: String, rectWidth: CGFloat)
    {
        pHBox.removeFromParent()
        eHBox.removeFromParent()
        eHLab.removeFromParent()
        pHLab.removeFromParent()
        
        
        pHLab.text = String(pHCount)
        pHLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        pHLab.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        pHLab.fontSize = 58
        pHLab.fontColor = UIColor.black
        pHLab.position = CGPoint(x: -380, y: 245)
        pHLab.zPosition = 4
        self.addChild(pHLab)
        
        pHBox = SKShapeNode(rectOf: CGSize(width: (pHCount * 4), height: 60))
        pHBox.position = CGPoint(x: -380, y: 260)
        pHBox.strokeColor = SKColor.black
        pHBox.fillColor = .yellow
        pHBox.zPosition = 4
        self.addChild(pHBox)
        
        eHLab.text = String(eHCount)
        eHLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        eHLab.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        eHLab.fontSize = 58
        eHLab.fontColor = UIColor.black
        eHLab.position = CGPoint(x: 380, y: 245)
        eHLab.zPosition = 4
        self.addChild(eHLab)
      
        eHBox = SKShapeNode(rectOf: CGSize(width: (eHCount * 4), height: 60))
        eHBox.position = CGPoint(x: 380, y: 260)
        eHBox.strokeColor = SKColor.black
        eHBox.fillColor = .yellow
        eHBox.zPosition = 4
        self.addChild(eHBox)
    }
    
    func spawnPlayer()
    {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        if(selectedPlayer == "air")
        {
            playerNode = SKSpriteNode(imageNamed: "AangLeft")
        }
        else if(selectedPlayer == "water")
        {
            playerNode = SKSpriteNode(imageNamed: "KataraLeft")
        }
        else if(selectedPlayer == "fire")
        {
            playerNode = SKSpriteNode(imageNamed: "ZukoLeft")
        }
        else
        {
            playerNode = SKSpriteNode(imageNamed: "TophLeft")
            
        }
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        playerNode.physicsBody?.isDynamic = false
        playerNode.physicsBody?.categoryBitMask = playerCat
        playerNode.physicsBody?.contactTestBitMask = attackLevel1Cat | attackLevel2Cat | attackLevel3Cat
        playerNode.physicsBody?.collisionBitMask = attackLevel1Cat | attackLevel2Cat | attackLevel3Cat
        playerNode.physicsBody?.affectedByGravity = false
        playerNode.size = CGSize(width: 283, height: 363)
        playerNode.position = CGPoint(x: -483, y: -91)
        playerNode.zPosition = 2
         addChild(playerNode)
    }
    
    func spawnOppnent()
    {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        if(enemy == "air")
        {
            enemyNode = SKSpriteNode(imageNamed: "AangRight")
        }
        else if(enemy == "water")
        {
            enemyNode = SKSpriteNode(imageNamed: "KataraRight")
        }
        else if(enemy == "fire")
        {
            enemyNode = SKSpriteNode(imageNamed: "ZukoRight")
        }
        else
        {
            enemyNode = SKSpriteNode(imageNamed: "TophRight")
        }
        enemyNode.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        enemyNode.physicsBody?.isDynamic = false
        enemyNode.physicsBody?.categoryBitMask = enemyCat
        enemyNode.physicsBody?.contactTestBitMask = attackLevel1Cat | attackLevel2Cat | attackLevel3Cat
        enemyNode.physicsBody?.collisionBitMask = attackLevel1Cat | attackLevel2Cat | attackLevel3Cat
        enemyNode.physicsBody?.affectedByGravity = false
        enemyNode.size = CGSize(width: 283, height: 363)
        enemyNode.position = CGPoint(x: 483, y: -91)
        enemyNode.zPosition = 2
        addChild(enemyNode)
        enemyNode.name = "enemyN"
        enemyNode.isUserInteractionEnabled = true
    }
    
    //TAP GESTURE FUNCTION
    @objc func playerTappedView(_ sender:UITapGestureRecognizer) {
        
        //eHCount = 0
        
        if(selectedPlayer == "air")
        {
        attackLevel1(attackName: "AirAttack1", forceDir: CGVector(dx: 30, dy: 0), spPostn: CGPoint(x: -230, y: -44), bitMask: enemyCat)
        }
        else if(selectedPlayer == "fire")
        {
          attackLevel1(attackName: "FireAttack1", forceDir: CGVector(dx: 30, dy: 0), spPostn: CGPoint(x: -230, y: -44), bitMask: enemyCat)
        }
        else if(selectedPlayer == "water")
        {
           attackLevel1(attackName: "WaterAttack1", forceDir: CGVector(dx: 30, dy: 0), spPostn: CGPoint(x: -230, y: -44), bitMask: enemyCat)
        }
        else
        {
         attackLevel1(attackName: "EarthAttack1", forceDir: CGVector(dx: 30, dy: 0), spPostn: CGPoint(x: -230, y: -44), bitMask: enemyCat)
        }
    }
    
    //MOST BASIC ATTACK: CALLED ON TAP
    func attackLevel1(attackName: String, forceDir: CGVector, spPostn: CGPoint, bitMask: UInt32)
    {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let moveBall = SKAction.move(by: forceDir, duration: 0.03)//(forceDir, duration: 2)
        let airBall = SKSpriteNode(imageNamed: attackName)
        airBall.size = CGSize(width: 82, height: 91)
        airBall.physicsBody = SKPhysicsBody(rectangleOf: airBall.size)
        airBall.position = spPostn//CGPoint(x: -298, y: -44)
        airBall.zPosition = 2
        airBall.physicsBody?.isDynamic = true
        airBall.physicsBody?.categoryBitMask = attackLevel1Cat
        airBall.physicsBody?.contactTestBitMask = attackLevel1Cat | cirCat | bitMask
        airBall.physicsBody?.collisionBitMask = attackLevel1Cat | bitMask | cirCat
        airBall.physicsBody?.allowsRotation = false
        airBall.physicsBody?.affectedByGravity = false
        addChild(airBall)
        airBall.run(SKAction.repeatForever(moveBall))
    }
    
    //SWIPE RIGHT GESTURE FUNCTION
    @objc func swipedRight(_ gestureRecognizer : UISwipeGestureRecognizer)
    {
        if(selectedPlayer == "air")
        {
            attackLevel2(attackName: "AirAttack2",spPostn: CGPoint(x: 483, y: -91), bitMask: enemyCat, attackSize: CGSize(width: 343, height: 750))
        }
        else if(selectedPlayer == "fire")
        {
            attackLevel2(attackName: "FireAttack2",spPostn: CGPoint(x: 33, y: -134), bitMask: enemyCat, attackSize: CGSize(width: 800, height: 277))
            
        }
        else if(selectedPlayer == "water")
        {
            attackLevel2(attackName: "WaterAttack2",spPostn: CGPoint(x: 33, y: -134), bitMask: enemyCat, attackSize: CGSize(width: 800, height: 273))
        }
        else
        {
            attackLevel2(attackName: "EarthAttack2",spPostn: CGPoint(x: 165, y: -134), bitMask: enemyCat, attackSize: CGSize(width: 960, height: 360))
        }
    }
    
    
    //ADVANCED LEVEL ATTACK : CALLED ON SWIPE
    func attackLevel2(attackName: String, spPostn: CGPoint, bitMask: UInt32, attackSize: CGSize)
    {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let attack2 = SKSpriteNode(imageNamed: attackName)
        attack2.size = attackSize
        attack2.physicsBody = SKPhysicsBody(rectangleOf: attack2.size)
        attack2.position = spPostn//CGPoint(x: -298, y: -44)
        attack2.zPosition = 2
        attack2.zRotation = 0
        attack2.physicsBody?.isDynamic = true
        attack2.physicsBody?.categoryBitMask = attackLevel2Cat
        attack2.physicsBody?.contactTestBitMask =  cirCat | bitMask
        attack2.physicsBody?.collisionBitMask = bitMask | cirCat
        attack2.physicsBody?.allowsRotation = false
        attack2.physicsBody?.affectedByGravity = false
        addChild(attack2)
        let fade: SKAction = SKAction.fadeOut(withDuration: 2)
        fade.timingMode = .easeIn
        attack2.run(SKAction.sequence([fade,SKAction.removeFromParent()]))
    }
    
    //ROTATION GESTURE FUNCTION
    @objc  func rotatedView(_ gestureRecognizer: UIRotationGestureRecognizer) {
        if gestureRecognizer.state == .began
        {
          //  print("begin")
        }
        else if gestureRecognizer.state == .changed
        {
        
        }
        else if gestureRecognizer.state == .ended
        {
            if(selectedPlayer == "air")
            {
                  attackLevel3(attackName: "AirAttack3", spPostn: CGPoint(x: 500, y: 5), bitMask: enemyCat, attackSize: CGSize(width: 300 , height: 500))
            }
            else if(selectedPlayer == "fire")
            {
               attackLevel3(attackName: "FireAttack3", spPostn: CGPoint(x: 135, y: -89), bitMask: enemyCat, attackSize: CGSize(width: 800 , height: 366))
            }
            else if(selectedPlayer == "water")
            {
                attackLevel3(attackName: "WaterAttack3", spPostn: CGPoint(x: 500, y: 0), bitMask: enemyCat, attackSize: CGSize(width: 400 , height: 400))
            }
            else
            {
                attackLevel3(attackName: "EarthAttack3", spPostn: CGPoint(x: 500, y: -80), bitMask: enemyCat, attackSize: CGSize(width: 400 , height: 400))
            }
        }
    }
    
    //ATTACK TYPE 3
    func attackLevel3(attackName: String, spPostn: CGPoint, bitMask: UInt32, attackSize: CGSize)
    {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let attack3 = SKSpriteNode(imageNamed: attackName)
        attack3.size = attackSize
        attack3.zPosition = 2
        attack3.position = spPostn
        attack3.physicsBody = SKPhysicsBody(rectangleOf: attack3.size)
        attack3.physicsBody?.isDynamic = true
        attack3.physicsBody?.categoryBitMask = attackLevel3Cat
        attack3.physicsBody?.contactTestBitMask = cirCat | bitMask
        attack3.physicsBody?.collisionBitMask = cirCat | bitMask
        attack3.physicsBody?.allowsRotation = false
        attack3.physicsBody?.affectedByGravity = false
        addChild(attack3)
        attack3.run(SKAction.sequence([.rotate(byAngle: 25, duration: 2),SKAction.removeFromParent()]))
        
    }
    
    @objc func swipedDown(_ gestureRecognizer : UISwipeGestureRecognizer) {
        blockAttack(blockWho: CGPoint(x: -483, y: -91))
    }
    
    func blockAttack(blockWho: CGPoint)
    {
        let Circle = SKShapeNode(circleOfRadius: 250 )
        // Create circle
        Circle.physicsBody = SKPhysicsBody(circleOfRadius: 250)
        Circle.position =  blockWho// // Center (given scene anchor point is 0.5 for x&y)
        Circle.strokeColor = SKColor.black
        Circle.glowWidth = 1.0
        Circle.physicsBody?.categoryBitMask = cirCat
        Circle.physicsBody?.contactTestBitMask =  attackLevel1Cat | attackLevel2Cat | attackLevel3Cat
        Circle.physicsBody?.collisionBitMask = attackLevel1Cat | attackLevel2Cat | attackLevel3Cat
        Circle.physicsBody?.mass = 10000
        Circle.zPosition = 4
        self.addChild(Circle)
        let fade: SKAction = SKAction.fadeOut(withDuration: 2)
        fade.timingMode = .easeIn
        Circle.run(SKAction.sequence([fade,SKAction.removeFromParent()]))
    }
    
    @objc func enemyAttackLevel1()
    {
        if(enemy == "air")
        {
            attackLevel1(attackName: "AirAttack1", forceDir: CGVector(dx: -30, dy: 0), spPostn: CGPoint(x: 230, y: -44), bitMask: playerCat)
        }
        else if(enemy == "fire")
        {
            attackLevel1(attackName: "FireAttack1", forceDir: CGVector(dx: -30, dy: 0), spPostn: CGPoint(x: 230, y: -44), bitMask: playerCat)
        }
        else if(enemy == "water")
        {
            attackLevel1(attackName: "WaterAttack1", forceDir: CGVector(dx: -30, dy: 0), spPostn: CGPoint(x: 230, y: -44), bitMask: playerCat)
        }
        else
        {
          attackLevel1(attackName: "EarthAttack1", forceDir: CGVector(dx: -30, dy: 0), spPostn: CGPoint(x: 230, y: -44), bitMask: playerCat)
        }
    }
    
    @objc func enemyAttackLevel2()
    {
        attack2Launched = true
        if(enemy == "air")
        {
            attackLevel2(attackName: "AirAttack2",spPostn: CGPoint(x: -483, y: -91), bitMask: playerCat, attackSize: CGSize(width: 343, height: 750))
        }
        else if(enemy == "fire")
        {
            attackLevel2(attackName: "FireAttack2E",spPostn: CGPoint(x: -110, y: -134), bitMask: playerCat, attackSize: CGSize(width: 900, height: 277))
        }
        else if(enemy == "water")
        {
            attackLevel2(attackName: "WaterAttack2E",spPostn: CGPoint(x: -110, y: -134), bitMask: playerCat, attackSize: CGSize(width: 750, height: 277))
        }
        else
        {
            attackLevel2(attackName: "EarthAttack2E",spPostn: CGPoint(x: -165, y: -134), bitMask: playerCat, attackSize: CGSize(width: 960, height: 360))
        }
        
    }
    
    @objc func enemyAttackLevel3()
    {
        if(enemy == "air")
        {
            attackLevel3(attackName: "AirAttack3", spPostn: CGPoint(x: -500, y: 5), bitMask: playerCat, attackSize: CGSize(width: 300 , height: 500))
        }
        else if(enemy == "fire")
        {
            attackLevel3(attackName: "FireAttack3", spPostn: CGPoint(x: -135, y: -89), bitMask: playerCat, attackSize: CGSize(width: 800 , height: 366))
        }
        else if(enemy == "water")
        {
            attackLevel3(attackName: "WaterAttack3", spPostn: CGPoint(x: -500, y: 0), bitMask: playerCat, attackSize: CGSize(width: 400 , height: 400))
        }
        else
        {
            attackLevel3(attackName: "EarthAttack3", spPostn: CGPoint(x: -500, y: -80), bitMask: playerCat, attackSize: CGSize(width: 400 , height: 400))
        }
    }
    
    override func didFinishUpdate()
    {
        if(gameOverCalled == false)
        {
            updateHealthBars(actor: "", rectWidth: 0)
           
            if( eHCount <= 0 && enemyArray.count > 0)
            {
                enemyNode.removeFromParent()
                enemyNode = nil;
                
                var randomIndex = Int(arc4random_uniform(UInt32(enemyArray.count)))
                enemy = enemyArray[randomIndex]
                repeat
                {
                    randomIndex = Int(arc4random_uniform(UInt32(enemyArray.count)))
                    enemy = enemyArray[randomIndex]
                }while(enemy == "air" && enemyCount == 1);
                
                
                enemyArray.remove(at: randomIndex)
                enemyCount = enemyCount - 1
                spawnOppnent()
                eHCount = 100
                pHCount = 100
                enemyAttacking()
            }
            if((enemyCount == 0  && eHCount <= 0 && enemyArray.count == 0) || pHCount <= 0)
            {
                gameOverUI()
            }
        }
    }
    
    func gameOverUI()
    {
        if(gameOverCalled == false)
        {
            gameOver.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            gameOver.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            gameOver.fontSize = 100
            gameOver.fontColor = UIColor.black
            gameOver.position = CGPoint(x: 48, y: -34)
            gameOver.zPosition = 4
            print(enemyArray.count)
            
            if(enemyCount != 0 && eHCount > 0 && pHCount <= 0)
            {
                gameOver.text = "GAME OVER: YOU LOST"
            }
            else
            {
                gameOver.text = "GAME OVER: YOU WON"
                addPlayerToDb()
            }
            self.addChild(gameOver)
            gameOverCalled = true
            playerNode.removeFromParent()
            enemyNode.removeFromParent()
            self.enemyTimer.invalidate()
            self.gameTimer.invalidate()
        }
    }
    
    //ENEMY ATTACKING DIFFERENT ATTACKS AT DIFFERNT TIMES
    func enemyAttacking()
    {
        if(gameOverCalled == false)
        {
            if(enemy == "air")
            {
                    self.enemyTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Float.random(in: 1 ... 3)), repeats: true, block: { timer in
                    let attackLevel: Int = Int.random(in: 1 ... 12)
                    let tempEnemy = ["air","water","earth","fire"]
                    let selectTemp = tempEnemy.randomElement()
                    
                    self.enemy = selectTemp
                    
                    if(attackLevel <= 3)
                    {
                        var i = 0
                        while i <= attackLevel {
                           self.enemyAttackLevel1()
                            i = i + 1
                        }
                    }
                    else if( attackLevel <= 6)
                    {
                        self.enemyAttackLevel2()
                    }
                    else if(attackLevel <= 8)
                    {
                        self.enemyAttackLevel3()
                    }
                    else if(attackLevel > 10)
                    {
                        self.blockAttack(blockWho: CGPoint(x: 483, y: -91))
                    }
                    })
            }
            else
            {
                self.enemyTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Float.random(in: 2 ... 4)), repeats: true, block: { timer in
                    let attackLevel: Int = Int.random(in: 1 ... 10)
                    if(attackLevel <= 3)
                    {
                        var i = 0
                        while i <= 2 {
                            self.enemyAttackLevel1()
                            i = i + 1
                        }
                    }
                    else if( attackLevel <= 5)
                    {
                        self.enemyAttackLevel2()
                    }
                    else if(attackLevel <= 6)
                    {
                        self.enemyAttackLevel3()
                    }
                    if(attackLevel >= 9)
                    {
                        self.blockAttack(blockWho: CGPoint(x: 483, y: -91))
                    }
                 })
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    func addPlayerToDb()
    {
       // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let newStudent = NSEntityDescription.insertNewObject(forEntityName: "Players", into: context)
        
        newStudent.setValue(InitialScreen.playerName, forKey: "playerName")
        newStudent.setValue(InitialScreen.playerSelected, forKey: "playerCharacter")
        newStudent.setValue(timerLabel!.text, forKey: "timeTaken")
        
        do{
            try context.save()
            print("saved")
        }
        catch {
            print("I/O unsuccesful")
        }
    }
}
