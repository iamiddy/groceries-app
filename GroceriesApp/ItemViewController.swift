//
//  ItemViewController.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/24/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit

class ItemViewController: GenericViewController, UITextFieldDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var itemName: UITextField!
    @IBOutlet var itemQuantity: UITextField!
    
    
    //MARK:- DELEGATE: UITextField
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField {
        case self.itemName:
            if self.itemName.text == "New Item" {
                self.itemName.text = ""
            }
            break;
        default:
            break;
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let item = self.segueObject as? Item {
            switch textField {
            case self.itemName:
                if self.itemName.text == "" {
                    self.itemName.text = "New Item"
                }
                item.name = self.itemName.text
                break;
                
            case self.itemQuantity:
                if let text = self.itemQuantity.text, floatValue = Float(text){
                    item.quantity = NSNumber(float: floatValue)
                }
                break;
                
            default: break;
            }
        }else{self.done()}
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
