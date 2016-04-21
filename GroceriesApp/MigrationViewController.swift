//
//  MigrationViewController.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/19/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit

class MigrationViewController: UIViewController {

    @IBOutlet var label: UILabel!
    @IBOutlet var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MigrationViewController.progressChanged(_:)), name: "migrationProgress", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
// MARK: - MIGRATION
    func progressChanged (note:AnyObject?) {
        if let _note = note as? NSNotification {
            if let progress = _note.object as? NSNumber {
                let progressFloat:Float = round(progress.floatValue * 100)
                let text = "Migration Progress: \(progressFloat)%"
                print(text)
               
                dispatch_async(dispatch_get_main_queue(), {
                    self.label.text = text
                    self.progressView.progress = progress.floatValue
                })
            } else {print("\(#function) FAILED to get progress")}
        } else {print("\(#function) FAILED to get note")}
    }

    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "migrationProgress", object: nil)
    }

    /*
    // MARK: - Navigation


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
