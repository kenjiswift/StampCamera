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
    let customToolBarHeight = 100.0
    
    /**
    タブバー、ツールバーを除いた画面サイズ
    */
    var cameraAreaSize: CGSize{
        get {
            return CGSizeMake(self.pickerView.view.frame.width,
                              self.pickerView.view.frame.height - customToolBarHeight
            )
        }
    }
    /**
    写真撮影時のファインダのframe
    
    - ファインダーの始点Yを計算する
    - 画面領域の中央Yから、ファインダの中央Yを引く
    - ツールバーを除いた画面領域のサイズを取得する
    - UIImagePickerControllerのデフォルトツールバーのframeを利用している
    - ツールバーの始点Yを画面の高さとする
    - 画面の幅と同じ
    */
    var cameraFinderFrame: CGRect{
        get {
            return CGRectMake(
                0,
                (cameraAreaSize.height * 0.5) - (self.view.frame.width * 0.5),
                self.pickerView.view.frame.width,
                self.pickerView.view.frame.width)
        }
    }
    
    /**
    画面下部を隠すマスクビューのフレーム
    
    - photoFinderFrameに準じて計算している
    */
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

    var imageOriginalSize : CGSize = CGSizeMake(0,0)
    
    /**
    写真の画質
    
    - small
    - medium
    - large
    - original
    */
    enum pictureQuarityType{
        case small
        case medium
        case largy
        case original
        
        func width() -> CGFloat {
            switch self{
            case .small:
                return 640
            case .medium:
                return 1024
            case .largy:
                return 1536
            case .original:
                return 0
            }
        }
    }
    
    /// 画質設定
    var picQuarity :pictureQuarityType = pictureQuarityType.small
    //フレーム画像
    let frameImageView = FrameImageView()
    
   
    
    //縮小比率を求める
    var picQuarityRetioForEditedImage: CGFloat{
        get {
            if picQuarity == pictureQuarityType.original{
                //オリジナルはそのまま
                return 1
            } else {
                //オリジナル以外
                return picQuarity.width() / imageOriginalSize.width
            }
        }
    }
    
    var picQuarityRetio: CGFloat{
        get {
            if picQuarity == pictureQuarityType.original {
                return imageOriginalSize.width / cameraFinderFrame.width
            } else {
                return picQuarity.width() / cameraFinderFrame.width
            }
        }
    }
    
    var editedPicRect: CGRect{
        get {
            return CGRectMake(0,
                              0,
                              cameraFinderFrame.width * picQuarityRetio,
                              cameraFinderFrame.height * picQuarityRetio
            )
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        let camera = Camera()
        print("カメラエリアサイズ： \(cameraAreaSize)")
        print("カメラファインダーフレーム： \(cameraFinderFrame)")
        print("マスクビューフレーム: \(maskViewFrame)")

    }

    @IBAction func takePictureTapped(_ sender: Any) {
        
        cameraOn()
//        toolBarCustomize()
        fiderCustomize()
        
        self.frameImageView.frame = self.cameraFinderFrame
        self.pickerView.cameraOverlayView = frameImageView
        toolBarCustomize()
    }

    func cameraOn(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            pickerView.sourceType = .camera
            pickerView.delegate = self
            pickerView.showsCameraControls = false
            
            
            self.present(pickerView, animated: true)
        }
    }

    @objc func takePhoto(){
        pickerView.takePicture()
    }

    func toolBarCustomize(){
        //撮影ボタン
        let takePhotoButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.camera,
            target: self,
            action: #selector(takePhoto))
        
        ///フレーム変更ボタン
        let changeFramButton = UIBarButtonItem(title: "フレーム変更",
                                               style: UIBarButtonItem.Style.plain,
                                               target: self,
                                               action: #selector(changeFrame)
        )
        
        ///スタンプ追加ボタン
        let opneStampSleclectViewButton = UIBarButtonItem(title: "スタンプ追加",
                                                          style: UIBarButtonItem.Style.plain,
                                                          target: self,
                                                          action: #selector(openStampSelectView)
        )
        ///スペースを開けるもの
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil,
                                          action: nil
        )
        
        let bottomBar = UIToolbar(frame: CGRect(x: 0,
                                                y: self.view.bounds.height - customToolBarHeight,
                                                width: self.view.bounds.width,
                                                height:customToolBarHeight))
        bottomBar.barStyle = UIBarStyle.black
        bottomBar.isTranslucent = false
        bottomBar.items = [changeFramButton,
                           spaceButton,
                           takePhotoButton,
                           spaceButton,
                           opneStampSleclectViewButton]
        
        self.pickerView.view.addSubview(bottomBar)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage //カメラで撮影した画像を取得
        /// 画像の向きを調整した写真
        var editImage = adjustImageRotation(baseImage: image)
        
        // 画像サイズを保持する
        imageOriginalSize = editImage.size
        
        //画像サイズを変更する
        editImage = changeSizeImage(baseImage: editImage)
        
        //画像を正方形にする
        editImage = makeSqureImage(baseImage: editImage)
        
        //フレームを写真に合成する
        editImage = makeImageWithFrameImage(baseImage: editImage)
        
        //写真アプリに撮影した写真を保存
        UIImageWriteToSavedPhotosAlbum(
            editImage,
            self,
            #selector(didSaveToPhotosApp(image:didFinishSavingWithError:contextInfo:)),
            nil
        )
        print ("写真を撮りました。")

        imageView.image = editImage
        picker.dismiss(animated: true)
    }

    func fiderCustomize(){
        print("fiderCustomize実行")
        //アフィン変換でファインダーの位置を水平移動させる。
        pickerView.cameraViewTransform = CGAffineTransformMakeTranslation(0, cameraFinderFrame.origin.y)
        let maskView = UIView(frame: maskViewFrame)
        maskView.backgroundColor = .black
        self.pickerView.view.addSubview(maskView)
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
        
        
        imageOriginalSize = editImage.size

        return editImage
    }

    @objc func didSaveToPhotosApp(image: UIImage,didFinishSavingWithError error:NSError?, contextInfo: UnsafeRawPointer){
        if let error = error {
            print("失敗\(error)")
        } else {
            print("撮った写真を写真アプリに保存しました。")
        }

    }
    
    //画像サイズ変更処理
    func changeSizeImage(baseImage: UIImage) -> UIImage!{
        print("changeSizeImage実行")
        
        ///変更後のサイズを計算
        let ediedSize = CGSizeMake(
            baseImage.size.width * self.picQuarityRetioForEditedImage,
            baseImage.size.height * self.picQuarityRetioForEditedImage
        )
        
        //描画領域を保持
        UIGraphicsBeginImageContext(ediedSize)
        
        //描画領域に画像を描く
        baseImage.draw(in: CGRectMake(0, 0, ediedSize.width, ediedSize.height))
        
        //描画領域を書き出す
        let editedSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //描画領域を破棄
        UIGraphicsEndImageContext()
        
        return editedSizeImage
    }
    
    
    //正方形にトリミングする
    func makeSqureImage(baseImage: UIImage) -> UIImage{
        print("makeSqureImage実行")
        
        var editImage = baseImage
        //正方形に切り取り枠を設定
        let squreRect = CGRectMake(0, 0, baseImage.size.width, baseImage.size.width)
        
        //編集処理実行(cropping = ほぼトリミングのこと。画像加工ならcroppingの方が正しいようだ。）
        let cgImage = baseImage.cgImage?.cropping(to: squreRect)
        
        editImage = UIImage(cgImage: cgImage!,
                            scale: baseImage.scale,
                            orientation: baseImage.imageOrientation)
        return editImage
    }
         
    //フレーム変更ボタン処理
    @objc func changeFrame(){
        print("changeFrame実行")      
        frameImageView.changeFrame()
    }
            
    //フレーム画像を写真に合成する処理
    func makeImageWithFrameImage(baseImage: UIImage) -> UIImage!{
        print("makeImageWithFrameImage実行")
        
        var editImage = baseImage
        
        //描画領域を保持
        UIGraphicsBeginImageContext(baseImage.size)
        
        //写真画像を割り当てる
        editImage.draw(in: editedPicRect)
        self.frameImageView.image?.draw(in: editedPicRect,
                                        blendMode: .normal,
                                        alpha: 1
        )
        
        //描画領域を書き出す
        editImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        //描画領域を破棄
        UIGraphicsEndImageContext()
        
        return editImage
    }
            
    ///スタンプセレクトをオープン
    @objc func openStampSelectView(){
        print("openStampSelectView実行")
        
        ///スタンプ選択画面
        let stampCollectionViewController = StampClollectionViewController(nibName: "StampClollectionViewController", bundle: nil)
        
        self.pickerView.present(stampCollectionViewController, animated: true,completion: nil)
    }
            
}
