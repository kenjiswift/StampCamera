//
//  StampImageView.swift
//  StampCamera2
//
//  Created by 松尾健司 on 2024/02/02.
//

import UIKit

class StampImageView: UIImageView {

    var scale:CGFloat = 1
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        ///ジェスチャーを可能にする
        isUserInteractionEnabled = true
        print("stampImageView init実行")
        
        let pan = UIPanGestureRecognizer(target: self,
                                         action: #selector(doPanAction))
        addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(target: self,
                                             action: #selector(doPinchAction))
        addGestureRecognizer(pinch)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func doPanAction(sender: UIPanGestureRecognizer){
        print("doPanAction実行")
        
        ///元の場所から移動した差分
        let translation = sender.translation(in: self.superview!)
        ///新しい移動先の座標
        let movedPoint = CGPointMake(self.center.x + translation.x,
                                     self.center.y + translation.y)
        ///移動する
        self.center = movedPoint
        
        ///差分を取得しているので、移動ごとに座標を初期化する
        sender.setTranslation(CGPointZero, in: self)
    }
    
    @objc func doPinchAction(sender: UIPinchGestureRecognizer){
        print("doPinchAction")
        
        if (sender.state == UIGestureRecognizer.State.began){
            self.scale = self.scale * sender.scale
            sender.scale = self.scale
        } else {
            self.scale = sender.scale
        }
        
        
        self.transform = CGAffineTransformMakeScale(sender.scale,
                                                    sender.scale)
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
   
}
