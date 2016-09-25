//
//  AnnotationViewController.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 25/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit

class AnnotationViewController: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var annotationText: UITextView!
    @IBOutlet weak var annotationPhoto: UIImageView!
    
    var model: Annotation?
    
    init(annotation: Annotation) {
        super.init(nibName: nil, bundle: nil)
        self.model = annotation
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        
        self.dateLabel.text = df.string(from: self.model?.creationDate as! Date)
        self.annotationText.text = self.model?.text
        self.annotationPhoto.image = self.model?.photo?.image
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.model?.text != self.annotationText.text {
            self.model?.text = self.annotationText.text
            self.model?.modificationDate = NSDate()
        }
    }

    @IBAction func shareAnnotation(_ sender: AnyObject) {
        let activityVC = UIActivityViewController(activityItems: getShareItems(), applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func removeAnnotation(_ sender: AnyObject) {
        self.model?.managedObjectContext?.delete(self.model!)
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func takePhoto(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) && UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let actionSheet = UIAlertController(title: "Select photo source", message: nil, preferredStyle: .actionSheet)
            let actionCamera = UIAlertAction(title: "New photo", style: .default) { (action: UIAlertAction) in
                self.launchPicker(sourceType: .camera)
            }
            let actionLibrary = UIAlertAction(title: "Photo from library", style: .default) { (action: UIAlertAction) in
                self.launchPicker(sourceType: .photoLibrary)
            }
            actionSheet.addAction(actionCamera)
            actionSheet.addAction(actionLibrary)
            
            present(actionSheet, animated: true, completion: nil)
            
        } else if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.launchPicker(sourceType: .camera)
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.launchPicker(sourceType: .photoLibrary)
        }
    }
    
    func getShareItems() -> [Any] {
        var items = [Any]()
        
        items.append((self.model?.text)!)
        items.append((self.model?.photo?.image)!)
        
        return items
    }
    
    func launchPicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension AnnotationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.model?.photo?.restoreDefaultImage()
        self.model?.modificationDate = NSDate()
        self.annotationPhoto.image = self.model?.photo?.image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            DispatchQueue.global(qos: .userInitiated).async {
                let screenBounds = UIScreen.main.bounds
                if let resizedImg = self.resizeImage(image: img, newWidth: screenBounds.size.width) {
                    
                    DispatchQueue.main.async {
                        self.model?.photo?.image = resizedImg
                        self.model?.modificationDate = NSDate()
                        self.annotationPhoto.image = resizedImg
                    }
                }
            }
        }
    
        self.dismiss(animated: true, completion: nil)
    }
}

