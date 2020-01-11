//
//  AlertService.swift
//  Dysgu
//
//  Created by Tomas Moore on 08/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//
import UIKit

class AlertService {
    
    func alert(message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        return alert
    }
}
