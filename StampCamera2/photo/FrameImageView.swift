//
//  FrameImageView.swift
//  StampCamera2
//
//  Created by 松尾健司 on 2024/01/18.
//

import Foundation
import UIKit

class FrameImageView: UIImageView{
    
    let frameImageResources: [String] = [
    "frame_pictures/frame01.png",
    "frame_pictures/frame02.png",
    "frame_pictures/frame03.png",
    "frame_pictures/frame04.png",
    "frame_pictures/frame05.png",
    "frame_pictures/frame06.png",
    "frame_pictures/frame07.png",
    "frame_pictures/frame08.png",
    "frame_pictures/frame09.png",
    "frame_pictures/frame10.png",
    ""]
    
    private var frameImageIndex = 0
    
    func changeFrame(){
        print("changeFrame実行しました。")
        if frameImageIndex > frameImageResources.count - 1 {
            frameImageIndex = 0
        }
        self.image = UIImage(named: frameImageResources[frameImageIndex])
        frameImageIndex += 1
    }
}
