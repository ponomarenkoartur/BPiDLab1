//
//  ViewController.swift
//  SecurityDESLab1
//
//  Created by Artur on 10/4/18.
//  Copyright © 2018 Artur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var keyTextField: UITextField!
    
    @IBOutlet var resultLabels: [UILabel]!
    
    @IBOutlet weak var encryptedMessageLabel: UILabel!
    @IBOutlet weak var decryptedMessageLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        resultLabels.forEach { $0.isHidden = true }
    }
    
    // MARK: - Actions
    
    @IBAction func enryptWasTapped(_ sender: UIButton) {
        encryptAndDecryptMessage()
    }
    
    // MARK: - Methods
    
    func encryptAndDecryptMessage() {
        let desEncryptor = DESEncryptor(message: messageTextField.text!, keyPhrase: keyTextField.text!)
        
        encryptedMessageLabel.text = desEncryptor.encryptMessage()
        decryptedMessageLabel.text = desEncryptor.decryptMessage()
        showResultLabels()
    }
    
    func showResultLabels() {
        resultLabels.forEach { $0.isHidden = false }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        encryptAndDecryptMessage()
        dismissKeyboard()
        return true
    }
}
