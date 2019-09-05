//
//  InitialScreen.swift
//  ProjectPractice
//
//  Created by Harshit Arora on 2019-07-12.
//  Copyright © 2019 Harshit Arora. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class InitialScreen : SKScene, UITextFieldDelegate
{
    var mainLabel: SKLabelNode! = nil
    var enterNameLabel: SKLabelNode! = nil
    var nameTextField: UITextField!
    var airlabel: SKLabelNode! = nil
    var airImgNode: SKSpriteNode? = nil
    var earthLabel: SKLabelNode! = nil
    var earthImgNode: SKSpriteNode! = nil
    var firelabel: SKLabelNode! = nil
    var fireImgNode: SKSpriteNode! = nil
    var waterlabel: SKLabelNode! = nil
    var waterImgNode: SKSpriteNode! = nil
    
    let gscreen = SKScene(fileNamed: "GameScreen")
    var backGroundImg = SKSpriteNode(imageNamed: "AvatarBG2")
     
    static var playerSelected: String! = nil
    static var playerName: String! = nil
    
    override func didMove(to view: SKView) {
        backGroundImg.size = CGSize(width: 760, height: 1380)
        addChild(backGroundImg)
        view.ignoresSiblingOrder = true
        initializeLabels()
        
        //NAME TEXT FIELD
        let textFieldFrame = CGRect(x: 200, y: 100, width: 200, height: 30)
        nameTextField = UITextField(frame: textFieldFrame)
       // let skView = self.view!
        
        nameTextField.delegate = self
        view.addSubview(nameTextField!)
        nameTextField!.borderStyle = UITextField.BorderStyle.roundedRect
        nameTextField!.textColor = .black
        
        self.view!.addSubview(nameTextField)
        
       
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        addNameLabel(clr: .black)

        let touch: UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        print(touchedNode.name as Any)
        if let name = touchedNode.name
        {
            if(!nameTextField!.text!.isEmpty)
            {
                if name == "aLabel"
                {
                    nameTextField!.isHidden = true
                    InitialScreen.playerSelected = "air"
                    
                    let trans = SKTransition.moveIn(with: .right, duration: 2)
                    let skView = self.view!
                    gscreen?.scaleMode = .aspectFill
                    skView.presentScene(gscreen!,transition: trans)
                }
                else if name == "eLabel"
                {
                    nameTextField!.isHidden = true
                    InitialScreen.playerSelected = "earth"
                    
                    let trans = SKTransition.moveIn(with: .right, duration: 2)
                    let skView = self.view!
                    gscreen?.scaleMode = .aspectFill
                    skView.presentScene(gscreen!,transition: trans)
                }
                else if name == "fLabel"
                {
                    nameTextField!.isHidden = true
                    InitialScreen.playerSelected = "fire"
                    
                    let trans = SKTransition.moveIn(with: .right, duration: 2)
                    let skView = self.view!
                    gscreen?.scaleMode = .aspectFill
                    skView.presentScene(gscreen!,transition: trans)
                }
                else if name == "wLabel"
                {
                    nameTextField!.isHidden = true
                    InitialScreen.playerSelected = "water"
                  
                    let trans = SKTransition.moveIn(with: .right, duration: 2)
                    let skView = self.view!
                    gscreen?.scaleMode = .aspectFill
                    skView.presentScene(gscreen!,transition: trans)
                }
            }
            else
            {
                 addNameLabel(clr: .red)
            }
        }
    }
    
    func addNameLabel(clr: UIColor)
    {
        if(enterNameLabel != nil)
        {
            enterNameLabel.removeFromParent()
        }/*do
        {
            try
        }
        catch
        {
        
        }*/
        enterNameLabel = SKLabelNode(fontNamed: "Bradley Hand Bold")
        enterNameLabel.text = "ENTER YOUR NAME"
        enterNameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        enterNameLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        enterNameLabel.fontSize = 30
        enterNameLabel.fontColor = clr
        enterNameLabel.position = CGPoint(x: -300, y: 483)
        enterNameLabel.zPosition = CGFloat(bitPattern: 1)
        addChild(enterNameLabel)
    }
    
    
    func initializeLabels()
    {
        //LABEL CHOOSE A PLAYER BY CLICK KINGDOM
        mainLabel = SKLabelNode(fontNamed: "Bradley Hand Bold")
        mainLabel.text = "CHOOSE YOUR KINGDOM"
        mainLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        mainLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        mainLabel.fontSize = 48
        mainLabel.fontColor = UIColor.black
        mainLabel.position = CGPoint(x: 0, y: 545)
        mainLabel.zPosition = CGFloat(bitPattern: 1)
        addChild(mainLabel)
        
        //ENTER YOUR NAME LABEL
        addNameLabel(clr: .black)
        
        //air kingdom
        airImgNode = SKSpriteNode(imageNamed: "AirClan")
        airImgNode?.size = CGSize(width: 150, height: 150)
        airImgNode?.position = CGPoint(x: -245, y: -430)
        addChild(airImgNode!)
        
        airlabel = SKLabelNode(fontNamed: "Bradley Hand Bold")
        airlabel.name = "aLabel"
        airlabel.text = "AIR"
        airlabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        airlabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        airlabel.fontSize = 42
        airlabel.fontColor = UIColor.black
        airlabel.fontName = "Bradley Hand Bold"
        airlabel.position = CGPoint(x: -245, y: -550)
         airlabel.zPosition = CGFloat(bitPattern: 1)
        addChild(airlabel)
        
        //EARTH KINGDOM
        earthImgNode = SKSpriteNode(imageNamed: "EarthClan")
        earthImgNode?.size = CGSize(width: 150, height: 150)
        earthImgNode?.position = CGPoint(x: -85, y: -430)
        // airImgNode.isUserInteractionEnabled = false
        addChild(earthImgNode!)
        
        earthLabel = SKLabelNode(fontNamed: "Bradley Hand Bold")
        earthLabel.name = "eLabel"
        earthLabel.text = "EARTH"
        earthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        earthLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        earthLabel.fontSize = 42
        earthLabel.fontColor = UIColor.black
        earthLabel.fontName = "Bradley Hand Bold"
        earthLabel.position = CGPoint(x: -83, y: -550)
        earthLabel.zPosition = CGFloat(bitPattern: 1)
        addChild(earthLabel)
        
        //FIRE KINGDOM
        fireImgNode = SKSpriteNode(imageNamed: "FireClan")
        fireImgNode?.size = CGSize(width: 150, height: 150)
        fireImgNode?.position = CGPoint(x: 85, y: -430)
        // airImgNode.isUserInteractionEnabled = false
        addChild(fireImgNode!)
        
        firelabel = SKLabelNode(fontNamed: "Bradley Hand Bold")
        firelabel.name = "fLabel"
        firelabel.text = "FIRE"
        firelabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        firelabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        firelabel.fontSize = 42
        firelabel.fontColor = UIColor.black
        firelabel.fontName = "Bradley Hand Bold"
        firelabel.position = CGPoint(x: 86, y: -550)
        firelabel.zPosition = CGFloat(bitPattern: 1)
        addChild(firelabel)
        
        //WATER KINGDOM
        waterImgNode = SKSpriteNode(imageNamed: "WaterClan")
        waterImgNode?.size = CGSize(width: 150, height: 150)
        waterImgNode?.position = CGPoint(x: 245, y: -430)
        // airImgNode.isUserInteractionEnabled = false
        addChild(waterImgNode!)
        
        waterlabel = SKLabelNode(fontNamed: "Bradley Hand Bold")
        waterlabel.name = "wLabel"
        waterlabel.text = "WATER"
        waterlabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        waterlabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        waterlabel.fontSize = 42
        waterlabel.fontColor = UIColor.black
        waterlabel.fontName = "Bradley Hand Bold"
        waterlabel.position = CGPoint(x: 245, y: -550)
        waterlabel.zPosition = CGFloat(bitPattern: 1)
        addChild(waterlabel)
    }
    
    override func didFinishUpdate() {
        InitialScreen.playerName = String(nameTextField!.text!)
      //  enterNameLabel.color = .black
    }
    
}
