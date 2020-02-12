//
//  MessageChatCell.swift
//  Dysgu
//
//  Created by Tomas Moore on 11/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class MessageChatCell: UITableViewCell {

    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var isIncoming: Bool! {
        didSet {
            bubbleBackgroundView.backgroundColor = isIncoming ? .white : .systemOrange
            messageLabel.textColor = isIncoming ? .black : .white
            
            if isIncoming {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        bubbleBackgroundView.backgroundColor = .systemOrange
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)
        
        addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
        
        //Layout Constraints
        let constraints = [
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
        
        bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
        bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
        bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
        ]
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
        
        
        //messageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
