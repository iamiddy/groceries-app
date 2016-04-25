//
//  GenericViewController.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/18/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit
import CoreData

class GenericViewController: UIViewController {
    var segueObject:NSManagedObject?
    var selectedObject:NSManagedObject? {
        if let object = self.segueObject{
            return object
        }
        self.done()
        return nil
    }

    
    func done(){
    //The selectedObject variable is set up in such a way that if the managed object disappears,
    //for example, it is deleted on another device, then the view is dismissed and the table view displayed instead.
        self.navigationController?.popViewControllerAnimated(true)
    }
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func hideKeyboardWhenBackgroundIsTapped(){
        let tgr = UITapGestureRecognizer(target: self, action: #selector(GenericViewController.hideKeyboard))
        self.view.addGestureRecognizer(tgr)
    }
   
}
