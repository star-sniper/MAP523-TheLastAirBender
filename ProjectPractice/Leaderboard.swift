//
//  Leaderboard.swift
//  ProjectPractice
//
//  Created by Harshit Arora on 2019-08-12.
//  Copyright © 2019 Harshit Arora. All rights reserved.
//

import Foundation
import UIKit
import SQLite3
import SpriteKit
import CoreData


class Tables: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    
    var items: [String] = [""]//"["Player1", "Player2", "Player3"]"
    
    func storeItemsInArray()
    {
        items.append("Name\tCharacter\tTime Taken")
        var arrayItem: String = ""
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        request.returnsObjectsAsFaults = false
        
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let results = try context.fetch(request)
            
            print(results.count)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]
                {
                    
                    if let studentname = result.value(forKey: "playerName") as? String {
                        arrayItem = arrayItem + studentname + "\t"
                    }
                    
                    if let studentChar = result.value(forKey: "playerCharacter") as? String {
                        arrayItem = arrayItem + studentChar + "\t"
                    }
                    if let time = result.value(forKey: "timeTaken") as? String {
                        
                        arrayItem = arrayItem + time
                    }
                    items.append(arrayItem)
                    arrayItem = ""
                }
                
                
            }
            
        }
        catch {
            
        }
    }
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        storeItemsInArray()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Leaderboard Players"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
}
class Leaderboard: SKScene {
    
    var backGroundImg = SKSpriteNode(imageNamed: "LeaderboardBG")
    var gameTableView = Tables()
    private var label : SKLabelNode?
    override func didMove(to view: SKView) {
        
        backGroundImg.size = CGSize(width: 770, height: 1368)
        backGroundImg.zPosition = 1
        addChild(backGroundImg)
        
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        // Table setup
        gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        gameTableView.frame = CGRect(x: 20,y: 50,width: 350, height: 800)
        self.scene?.view?.addSubview(gameTableView)
        gameTableView.reloadData()
    }
}
