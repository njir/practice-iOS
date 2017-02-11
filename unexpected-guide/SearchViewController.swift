//
//  SearchViewController.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 11..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets and Properties
    let mainColor: UIColor = UIColor(red:0.29, green:0.09, blue:0.24, alpha:1.00)
    let backgroundColor: UIColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
    
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchBtn: UIButton!

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTxtFld.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.searchTxtFld.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTxtFld.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    // MARK: - IBAction
    
    @IBAction func pressSearchBtn(_ sender: Any) {
        let newText: String = searchTxtFld.text!
        
        guard !newText.isEmpty else {
            return
        }
        searchWord(text: newText)
    }
    
    // MARK: - Implement delegates function
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Construct the text that will be in the field if this change is accepted
        let newText = textField.text! as String
        guard !newText.isEmpty else {
            return false
        }
        
        searchWord(text: newText as String)
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        searchTxtFld.layer.borderColor = mainColor.cgColor
        searchTxtFld.layer.borderWidth = 1.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let defaultBorderColor: UIColor = UIColor(red:0.79, green:0.79, blue:0.79, alpha:1.00)
        searchTxtFld.layer.borderColor = defaultBorderColor.cgColor
        searchTxtFld.layer.borderWidth = 1.0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let limitLength = 30
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    // MARK: - Navigation
    
    func searchWord(text: String) {
        // For Navigation View Controller
        let artsTableVC = self.storyboard?.instantiateViewController(withIdentifier: "ArtsTableViewController") as! ArtsTableViewController
        artsTableVC.searchWord = text
        self.navigationController?.pushViewController(artsTableVC, animated: true)
    }

}
