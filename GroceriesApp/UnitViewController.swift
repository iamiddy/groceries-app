//
//  UnitViewController.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/27/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit

class UnitViewController: GenericViewController , UITextFieldDelegate{
    
    @IBOutlet var name: UITextField!
    
    
// MARK: - DELEGATE: UITextField
    func textFieldDidBeginEditing(textField: UITextField) {
        switch (textField) {
        case self.name:
            if self.name.text == "New Unit" {
                self.name.text = ""
            }
            break;
        default:break;
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let unit = self.selectedObject as? Unit {
        switch (textField) {
        case self.name:
            if self.name.text == "" {
                self.name.text = "New Unit"
            }
            unit.name = self.name.text
            break;
        default:break;
        }
    } else {self.done()} }
    
    // MARK: - VIEW
    func refreshInterface () {
        if let unit = self.selectedObject as? Unit {
            self.name.text = unit.name
        } else {self.done()}
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenBackgroundIsTapped()
        self.name.delegate = self
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self,action: #selector(GenericViewController.done))
        self.navigationItem.rightBarButtonItem = doneButton
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshInterface()
        self.name.becomeFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) { super.viewDidDisappear(animated)
        CDHelper.saveSharedContext()
        NSNotificationCenter.defaultCenter().postNotificationName("SomethingChanged",object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
