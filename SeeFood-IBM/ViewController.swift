//
//  ViewController.swift
//  SeeFood-IBM
//
//  Created by Arjun Singh on 18/07/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var classificationResults: [String] = []
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Could not cast down to UIImage")
        }
        
        imageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
        
        let visualRecognition = VisualRecognition(apiKey: Secrets.API_KEY, version: Secrets.VERSION)
        
        guard let depreciatedImageData = UIImageJPEGRepresentation(image, 0.01) else {
            fatalError("Could not convert image to data")
        }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileURL = documentsURL.appendingPathComponent("tempImage.jpg")
        
        try? depreciatedImageData.write(to: fileURL, options: [])
        
        visualRecognition.classify(imagesFile: fileURL, threshold: 0.5, acceptLanguage: "en") { (classifiedImages) in
            let classes = classifiedImages.images.first!.classifiers.first!.classes
            
            self.classificationResults = []
            for index in 0..<classes.count {
                self.classificationResults.append(classes[index].className)
            }
            
            print(self.classificationResults)
            
            if self.classificationResults.contains("hotdog") {
                
                DispatchQueue.main.async {
                    self.navigationItem.title = "Hotdog!"
                }
                
            } else {
                
                DispatchQueue.main.async {
                    self.navigationItem.title = "Not Hotdog!"
                }
                
            }
        }
        
    }
    
}

