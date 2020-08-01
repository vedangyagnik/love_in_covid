//
//  ImageSendViewController.swift
//  LoveInCovid
//
//  Created by Vedang Yagnik on 2020-06-02.
//  Copyright © 2020 Parrot. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class ImageSendViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var imagePicker:UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func imageTapAction(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default){ _ in
            self.imagePicker = UIImagePickerController()
            if(UIImagePickerController.isSourceTypeAvailable(.camera) == false) {
                print("Camera not available!")
                
                return
            }
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        }
        let chooseFromLibAction = UIAlertAction(title: "Choose From Library", style: .default){ _ in
            self.imagePicker = UIImagePickerController()
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false) {
                print("Gallery not found!")
                
                return
            }
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(chooseFromLibAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            let photoTakenFromCamera = info[.originalImage] as? UIImage
            self.imageView.image = photoTakenFromCamera
        }
    @IBAction func sendPhotoAction(_ sender: UIButton) {
        let alertBox = UIAlertController(title: "Photo Sent!", message: "Your photo has been sent.", preferredStyle: .alert)
        alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertBox, animated: true, completion: nil)
    }
}
