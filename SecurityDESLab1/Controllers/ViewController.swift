//
//  ViewController.swift
//  SecurityDESLab1
//
//  Created by Artur on 10/4/18.
//  Copyright © 2018 Artur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    let desEncryptor = DESEncryptor(message: "")
    
    // MARK: - Outlets
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet var resultLabels: [UILabel]!
    
    @IBOutlet weak var encryptedMessageLabel: UILabel!
    @IBOutlet weak var decryptedMessageLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let block = Block(bytes: [0b11111111])
        
        for bit in block {
            print(bit, terminator: "")
        }
        print()
        
        for bitIndex in 0..<block.bitsCount {
            print(block[bitIndex]!, terminator: "")
        }
        print()
        
        hideKeyboardWhenTappedAround()
        
        resultLabels.forEach { $0.isHidden = true }
    }
    
    // MARK: - Actions
    
    @IBAction func enryptWasTapped(_ sender: UIButton) {
        encryptAndDecryptMessage()
    }
    
    // MARK: - Methods
    
    func encryptAndDecryptMessage() {
        desEncryptor.message = messageTextField.text ?? ""
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
