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
    
    @IBOutlet weak var searchTxtFld: UITextField!

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTxtFld.delegate = self
        self.view.backgroundColor = backgroundColor
        setDefaultTextfieldUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.searchTxtFld.text = ""
    }
    
    func setDefaultTextfieldUI() {
        self.searchTxtFld.layer.borderColor = textfieldColor.cgColor
        self.searchTxtFld.backgroundColor = textfieldColor
        self.searchTxtFld.layer.cornerRadius = 5.0
        self.searchTxtFld.layer.borderWidth = 2.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setDefaultTextfieldUI()
        searchTxtFld.resignFirstResponder()
        self.view.endEditing(true)
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
        self.searchTxtFld.layer.borderColor = mainColor.cgColor
        self.searchTxtFld.layer.borderWidth = 1.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
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
