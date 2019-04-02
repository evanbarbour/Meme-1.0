//
//  MemeTableViewController.swift
//  Meme 1.0
//
//  Created by Evan Barbour on 3/23/19.
//  Copyright © 2019 Evan Barbour. All rights reserved.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class SentMemesTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }
    
    // Shared data model for memes, source for the table
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // How many rows? Depends on how many memes
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // Populates each new saved meme into a new cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[(indexPath).row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.topText ?? "")...\(meme.bottomText ?? "")"
        
        return cell
    }
    
    // Shows you the meme when you tap on it
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailViewController.memeOnTap = memes[indexPath.row]
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}
