//
//  Camera.swift
//  StampCamera2
//
//  Created by 松尾健司 on 2024/01/12.
//

import Foundation
import UIKit

class Camera:UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    let pickerView = UIImagePickerController()
    let customToolBarHeight = 100.0
    
    var cameraAreaSize: CGSize{
        get {
            return CGSizeMake(self.view.frame.width,
                              self.view.frame.height - customToolBarHeight
            )
        }
    }
    
    var cameraFinderFrame: CGRect{
        get {
            return CGRectMake(
                0,
                (cameraAreaSize.height * 0.5) - (self.view.frame.width * 0.5),
                self.view.frame.width,
                self.view.frame.width)
        }
    }
    
    var maskViewFrame: CGRect{
        get{
            return CGRectMake(
                    0,
                    cameraFinderFrame.origin.y + cameraFinderFrame.height,
                    cameraFinderFrame.width,
                    cameraAreaSize.height - (cameraFinderFrame.origin.y + cameraFinderFrame.height)
                )
        }
    }
    
    func cameraOn(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            pickerView.sourceType = .camera
            pickerView.delegate = self
            pickerView.showsCameraControls = false
            
            let view = ViewController()
            view.present(pickerView, animated: true)
        }
    }
    
    func toolBarCustomize(){
        let takePhotoButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.camera,
            target: self,
            action: #selector(self.takePhoto))
        
        let bottomBar = UIToolbar(frame: CGRect(x: 0, y: self.view.bounds.height - customToolBarHeight, width: self.view.bounds.width, height:customToolBarHeight))
        bottomBar.barStyle = UIBarStyle.black
        bottomBar.isTranslucent = false
        bottomBar.items = [takePhotoButton]
        
        pickerView.cameraOverlayView = bottomBar
    }
    
    @objc func takePhoto(){
//        let camera = Camera()
        self.pickerView.takePicture()
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage //カメラで撮影した画像を取得
//        imageView.image = image
        /// 画像の向きを調整した写真
        let editImage = adjustImageRotation(baseImage: image)
        
        //写真アプリに撮影した写真を保存
        UIImageWriteToSavedPhotosAlbum(
            editImage,
            self,
            #selector(didSaveToPhotosApp(image:didFinishSavingWithError:contextInfo:)),
            nil
        )
        print ("写真を撮りました。")
        // 画像サイズを保持する
//        imageOriginalSize = editImage.size
        
        picker.dismiss(animated: true)
    }
    
    func fiderCustomize(){
        print("fiderCustomize実行")
        //アフィン変換でファインダーの位置を水平移動させる。
        pickerView.cameraViewTransform = CGAffineTransformMakeTranslation(0, cameraFinderFrame.origin.y)
        let maskView = UIView(frame: maskViewFrame)
        maskView.backgroundColor = .black
        self.view.addSubview(maskView)
    }
    
//    /**
//    画像の向きを調整
//    */
    func adjustImageRotation(baseImage: UIImage) -> UIImage{
        print("adjustImageRotation実行")
        var editImage = baseImage
        
        if baseImage.imageOrientation != UIImage.Orientation.right{
            //UIimage をCGImageへ変換
            let cgImage = baseImage.cgImage
            //CGImageからUIImageへ再変換して、左に回転させる。
            editImage = UIImage(cgImage: cgImage!, scale: baseImage.scale, orientation: .right)
        }
        
        return editImage
    }

    @objc func didSaveToPhotosApp(image: UIImage,didFinishSavingWithError error:NSError?, contextInfo: UnsafeRawPointer){
        if let error = error {
            print("失敗\(error)")
        } else {
            print("撮った写真を写真アプリに保存しました。")
        }
        
    }
}
