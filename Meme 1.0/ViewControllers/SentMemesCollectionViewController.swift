//
//  MemesCollectionViewController.swift
//  Meme 1.0
//
//  Created by Evan Barbour on 3/30/19.
//  Copyright © 2019 Evan Barbour. All rights reserved.
//

import UIKit
import Foundation

class SentMemesCollectionViewController: UICollectionViewController {
    
    // Set flow layout for the Collection View
    @IBOutlet weak var sentMemesFlowLayout: UICollectionViewFlowLayout!
    
    // Shared data model to populate the Collection View
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // Reload the data everytime the view refreshes
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    // Set spacing in the view, with help from https://github.com/chandakvishal/MemeMe-2.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let itemWidth = (view.frame.size.width - (5 * space)) / 3.0
        let itemHeight = (view.frame.size.height - (5 * space)) / 3.0
        
        sentMemesFlowLayout.minimumInteritemSpacing = space
        sentMemesFlowLayout.minimumLineSpacing = space
        sentMemesFlowLayout.itemSize = CGSize(width:itemWidth,height:itemHeight)
    }
    
    // How many cells? Depends on how many memes have been shared or saved
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    // Populates each saved meme into a new cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemesCollection", for: indexPath) as! MemesCollectionViewCell
        let meme = self.memes[(indexPath).row]
        
        cell.memeCollectionImageView?.image = meme.memedImage
        
        return cell
    }
    
    // When you tap on a meme in the view, you should see the details
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        let memeDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailViewController.memeOnTap = memes[indexPath.row]
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}



