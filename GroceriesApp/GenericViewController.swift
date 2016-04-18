//
//  GenericViewController.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/18/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit

class GenericViewController: UIViewController {

    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func hideKeyboardWhenBackgroundIsTapped(){
        let tgr = UITapGestureRecognizer(target: self, action: #selector(GenericViewController.hideKeyboard))
        self.view.addGestureRecognizer(tgr)
    }
   
}
