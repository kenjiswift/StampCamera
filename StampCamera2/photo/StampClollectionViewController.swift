//
//  StampClollectionViewController.swift
//  StampCamera2
//
//  Created by 松尾健司 on 2024/01/25.
//

import UIKit

private let reuseIdentifier = "Cell"

class StampClollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let stampRefs = [
        "stamp_pictures/stamp01.png",
        "stamp_pictures/stamp02.png",
        "stamp_pictures/stamp03.png",
        "stamp_pictures/stamp04.png",
        "stamp_pictures/stamp05.png",
        "stamp_pictures/stamp06.png",
        "stamp_pictures/stamp07.png",
        "stamp_pictures/stamp08.png",
        "stamp_pictures/stamp09.png",
        "stamp_pictures/stamp10.png"
    ]
    

    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        ///マージンの幅。単位はピクセル
        let outlineMargin: CGFloat = 8
        
        ///一行当たりの表示させたいセルの数
        let cellRowCount: CGFloat = 3
        
        ///セルのサイズ
        let cellSize = CGSizeMake(
            (self.view.frame.width - (outlineMargin * 2)) / cellRowCount,
            (self.view.frame.width - (outlineMargin * 2)) / cellRowCount
        )
        
        ///flowLayout に設定
        flowLayout.itemSize = cellSize
        flowLayout.minimumInteritemSpacing  = outlineMargin
        flowLayout.minimumLineSpacing = outlineMargin

        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    ///セクション数を設定する
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    ///表示するセルの数を設定する
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }
    
    ///セルの中身の設定
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        let fileName = stampRefs[indexPath.row]
        
        let stampView = StampImageView(image: UIImage(named: fileName))
        cell.backgroundView = stampView
        
       return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}
