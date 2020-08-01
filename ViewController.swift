//
//  ViewController.swift
//  LoveInCovid
//
//  Created by Parrot on 2020-06-02.
//  Copyright © 2020 Parrot. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chatMessages:[String] = []
    var msgs:[[String:String]]?
    var userMsgCount = 0
    
    // ----------
    // MARK: Outlets
    // ----------
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var chatbox: UITextField!
    
    // ----------
    // MARK: IOS Lifecycle Functions
    // ----------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        if let path = Bundle.main.path(forResource: "responses", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                msgs = try (JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [[String:String]])!
                chatMessages.append(msgs![0]["response"]!)
              } catch {
                   // handle error
              }
        }
        
    }
    
    // ----------
    // MARK: Actions
    // ----------
    @IBAction func sendMessage(_ sender: Any) {
        if(userMsgCount == 0){
            chatMessages.append(chatbox.text!)
            chatMessages.append(msgs![1]["response"]!)
        } else{
            chatMessages.append(chatbox.text!)
            let chance = Int.random(in: 1...2)
            if(chance == 1){
                chatMessages.append(msgs![2]["response"]!)
            } else{
                chatMessages.append(msgs![2]["alternate"]!)
            }
        }
        tableview.reloadData()
        userMsgCount += 1
    }
    
    // ----------
    // MARK: Table View Functions
    // ----------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        if(indexPath.row % 2 != 0){
            cell.textLabel?.text = self.chatMessages[indexPath.row]
            cell.detailTextLabel?.text = ""}
        else{
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = self.chatMessages[indexPath.row]
        }
        return cell
    }

}

