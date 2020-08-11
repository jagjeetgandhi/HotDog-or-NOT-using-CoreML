//
//  ViewController.swift
//  HotDog or Not
//
//  Created by jagjeet on 23/07/20.
//  Copyright © 2020 jagjeet. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }
    @IBOutlet weak var imageCapture:UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            imageCapture.image = pickedImage
            guard let ciimage = CIImage(image: pickedImage) else { fatalError("Image is not converted")}
            detectImage(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    func detectImage(image:CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model)
            else{ fatalError("error in creating Model") }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("classification failed")
            }
           print(result)
            if let firstResult = result.first {
              if firstResult.identifier.contains("hot dog") {
                  self.navigationItem.title = "HOT DOG 🌭 "
               }else {
                   self.navigationItem.title = "NOT a HOT DOG"
              }
           }
          
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do{
        try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    @IBAction func cameratapped(_ sender:UIBarButtonItem){
        
        present(imagePicker, animated: true, completion: nil)
        
    }


}

