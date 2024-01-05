//
//  ViewController.swift
//  StampCamera2
//
//  Created by 松尾健司 on 2024/01/01.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    //MARK: -ImageView
    @IBOutlet weak var imageView: UIImageView!
    let pickerView = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func takePictureTapped(_ sender: Any) {
        cameraOn()
        toolBarCustomize()
    }

    func cameraOn(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //            let pickerView = UIImagePickerController()
            pickerView.sourceType = .camera
            pickerView.delegate = self
            pickerView.showsCameraControls = false
            
            self.present(pickerView, animated: true)
        }
    }

    @objc func takePhoto(){
            self.pickerView.takePicture()
    }

    func toolBarCustomize(){
        let takePhotoButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.camera,
            target: self,
            action: #selector(self.takePhoto))
        
        let bottomBar = UIToolbar(frame: CGRect(x: 0, y: self.view.bounds.height - 100, width: self.view.bounds.width, height:50))
        bottomBar.barStyle = UIBarStyle.black
        bottomBar.isTranslucent = false
        bottomBar.items = [takePhotoButton]
        
        pickerView.cameraOverlayView = bottomBar
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage //カメラで撮影した画像を取得
        imageView.image = image
        picker.dismiss(animated: true)
    }

}
