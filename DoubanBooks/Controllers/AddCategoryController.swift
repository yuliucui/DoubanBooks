//
//  AddCategoryController.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/19.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import UIKit

let imgDir = "/Documents/"
class AddCategoryController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var imgCover: UIImageView!
    @IBOutlet var txtName: UITextField!
    var selectedImage: UIImage?
    let factory = CategoryFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(pickFromPhotoLibrary))
        imgCover.addGestureRecognizer(recognizer)
        imgCover.isUserInteractionEnabled = true

    }
    
    @IBAction func pickFromPhotoLibrary(_ sender: Any) {
        let imgController = UIImagePickerController()
        imgController.sourceType = .photoLibrary
        imgController.delegate = self
        present(imgController,animated: true,completion: nil)
    }
    
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true , completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imge = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImage = imge
        imgCover.image = imge
        dismiss(animated: true, completion: nil)
    }
    func saveImage(image: UIImage,fileName: String) {
        if let imageData = image.jpegData(compressionQuality: 1) as NSData?{
            let path = NSHomeDirectory().appending("/imgDir").appending(fileName)
            imageData.write(toFile: path, atomically: true)
        }
    }
    
    @IBAction func saveCategory() {
        let name = txtName.text
        let category = VMCategory()
        category.name = name
        category.image = category.id.uuidString + ".jpg"
        let (success,info) = factory.addCategory(category: category)
        if !success {
            UIAlertController.showALertAndDismiss(info!, in: self)
            return
        }
        saveImage(image: selectedImage!, fileName: category.image!)
            
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
