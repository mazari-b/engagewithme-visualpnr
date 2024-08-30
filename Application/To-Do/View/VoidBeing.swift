//
//  VoidBeing.swift
//
//  Created by Mazari Bahaduri on 28/07/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit

class VoidBeing: UIView {
    
    private lazy var visualDisplay: UIImageView = {
        let IV = UIImageView()
        IV.tintColor = .black
        IV.contentMode = .scaleAspectFit
        
        return IV
    }()
    
    private lazy var mainTitle: UILabel = {
        let text = UILabel()
        text.font = UIFont.boldSystemFont(ofSize: 18.0)
        text.textColor = .black
        text.numberOfLines = 0
        text.textAlignment = .center
        
        return text
    }()
    
    private lazy var miniMainTitle: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        text.textColor = .darkGray
        text.textAlignment = .center
        
        text.numberOfLines = 2
        
        return text
    }()
    
    init(_ type : EmptyStateType) {
        super.init(frame: .zero)
        
        self.visualDisplay.image = type.image
        self.mainTitle.text = type.heading
        self.miniMainTitle.text = type.subheading
        self.miniMainTitle.numberOfLines = 0
        
        let SV = UIStackView(arrangedSubviews: [visualDisplay, mainTitle, miniMainTitle])
        SV.axis = .vertical
        SV.spacing = 10.0
        
        addSubview(SV)
        SV.translatesAutoresizingMaskIntoConstraints = false
        SV.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.30).isActive = true
        SV.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
        SV.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        SV.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public enum EmptyStateType{
        case emptySearch
        case emptyList
        case emptyHistory
        
        var heading : String{
            switch self {
            case .emptySearch:
                return "No tasks found"
            case .emptyList:
                return "No tasks added"
            case .emptyHistory:
                return "No task history found"
            }
        }
        
        
        var subheading : String{
            switch self {
            case .emptySearch:
                return """
                        Specified task was not found.
                        Create a new task!
                        """
            case .emptyList:
                return """
                        You can add a task very simply.
                        Click the '+' button on top!
                        """
            case .emptyHistory:
                return """
                        You can complete a task by swiping right.
                        Alternatively, star or delete by swiping left!
                        """
            }
        }
        
        var image : UIImage?{
            switch self {
            case .emptySearch:
                return UIImage(systemName: "magnifyingglass")
            case .emptyList:
                return UIImage(systemName: "note.text")
            case .emptyHistory:
                return UIImage(systemName: "minus.rectangle")
            }
        }
    }
    
}
