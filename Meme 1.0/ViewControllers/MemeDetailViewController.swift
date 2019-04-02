//
//  MemeDetailViewController.swift
//  Meme 1.0
//
//  Created by Evan Barbour on 3/23/19.
//  Copyright © 2019 Evan Barbour. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeView: UIImageView!
    
    var memeOnTap: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeView.image = memeOnTap.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
