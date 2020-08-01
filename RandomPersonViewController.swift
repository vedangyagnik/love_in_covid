//
//  RandomPersonViewController.swift
//  LoveInCovid
//
//  Created by Parrot on 2020-06-02.
//  Copyright © 2020 Parrot. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class RandomPersonViewController: UIViewController, AVAudioPlayerDelegate {
    
    // ----------
    // MARK: Outlets
    // ----------
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var resultsLabel: UILabel!
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    var timer:Timer = Timer()
    var selectedGender:String?
    var personsData:[[String:Any]]?
    var personCounter = 0
    var leftSwipe = 0
    var seconds = 10
    
    // ----------
    // MARK: IOS Lifecycle functions
    // ----------
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.url(forResource: "swipe1", withExtension: "mp3")
        do{
            self.audioPlayer = try AVAudioPlayer(contentsOf: path!)
            self.audioPlayer.delegate = self
        }
        catch{
            print("Error Opening Audio File")
        }
        showPerson()
    }
    
    // ----------
    // MARK: Actions
    // ----------
    @IBAction func chatDebugButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "chatSegue", sender: self)
    }
    
    // ----------
    // MARK: Helper Functions
    // ----------
    func showPerson() {
        var url = "https://randomuser.me/api/"
        if(selectedGender! == "Male"){
            url = "https://randomuser.me/api/?gender=male&results=5"
        } else if(selectedGender == "Female"){
            url = "https://randomuser.me/api/?gender=female&results=5"
        } else if(selectedGender == "Either"){
            url = "https://randomuser.me/api/?results=5"
        }
        Alamofire.request(url).responseJSON {
            (response)
            in
            do{
                if let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any] {
                    self.personsData = json["results"] as? [[String : Any]]
                    self.setPersonData(c:self.personCounter)
                }
                
            } catch {
                print("error")
            }
        }
    }

    @IBAction func leftSwipeAction(_ sender: UISwipeGestureRecognizer) {
        //Not Interested
        if(leftSwipe == 3){
            leftSwipe = 0
            self.photoImageView.isUserInteractionEnabled = false
            let alertBox = UIAlertController(title: "Maximum Swipe Reached!", message: "Wait 10 second to continue.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
             self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                 self.seconds -= 1
                 self.resultsLabel.text = self.timeString(time: TimeInterval(self.seconds))
                 if self.seconds < 1 {
                    self.photoImageView.isUserInteractionEnabled = true
                    timer.invalidate()
                    self.resultsLabel.text = "continue"
                 }
             }
        } else {
            self.audioPlayer.play()
            setPersonData(c: personCounter)
            leftSwipe += 1
        }
    }
    
    @IBAction func rightSwipeAction(_ sender: UISwipeGestureRecognizer) {
        //Interested
        self.audioPlayer.play()
        //Equal chance of every possibility
        let probability = Int.random(in: 1...30)
        if(probability < 10){
            //Like
            performSegue(withIdentifier: "chatSegue", sender: self)
        } else if(probability < 20){
            //Dislike
            let alertBox = UIAlertController(title: "Dislike", message: "This person doesn't like you.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            setPersonData(c: personCounter)
        } else if(probability < 30){
            //Not sure
            performSegue(withIdentifier: "sendPhoto", sender: self)
        }
    }
    
    func setPersonData(c:Int){
        if(personCounter > 4){
            personCounter = 0
            showPerson()
        } else {
            let name = self.personsData![c]["name"] as! [String:String]
            self.nameLabel.text = name["last"]! + " " + name["first"]!
            let dob = self.personsData![c]["dob"] as! [String:Any]
            self.ageLabel.text = String(dob["age"] as! Int)
            let picture = self.personsData![c]["picture"] as! [String:String]
            let imageUrl = URL(string: picture["large"]!)
            let data = try? Data(contentsOf: imageUrl!)
            self.photoImageView.image = UIImage(data: data!)
            self.personCounter += 1
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let seconds = Int(time) % 60

        return String(format:"%02i", seconds)
    }
}
