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
    
    init(_ type : EmptyStateType) {
        super.init(frame: .zero)
        
        self.visualDisplay.image = type.image
        self.mainTitle.text = type.heading
        self.miniMainTitle.text = type.subheading
        self.miniMainTitle.numberOfLines = 0
        if self.frame.isEmpty {
                print("Frame is empty. Doing nothing...")
            }
        let SV = UIStackView(arrangedSubviews: [visualDisplay, mainTitle, miniMainTitle])
        SV.axis = .vertical
        SV.spacing = 10.0
        
        addSubview(SV)
        if SV != nil {
                print("StackView is set. No action needed.")
            }
        SV.translatesAutoresizingMaskIntoConstraints = false
        SV.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.30).isActive = true
        SV.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
        SV.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        SV.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        let PV = SV.arrangedSubviews.count
        print("P variable value: \(PV)")
    }
    
    public enum EmptyStateType {
        
        case emptySearch, emptyList, emptyHistory
        
        // Headings for each empty state
        var heading: String {
            ["No tasks found", "No tasks added", "No task history found"][self.index]
        }
        
        // Subheadings with multi-line descriptions for each empty state
        var subheading: String {
            [
                """
                Specified task was not found.
                Create a new task!
                """,
                """
                You can add a task very simply.
                Click the '+' button on top!
                """,
                """
                You can complete a task by swiping right.
                Alternatively, star or delete by swiping left!
                """
            ][self.index]
        }
        
        // Images corresponding to each empty state
        var image: UIImage? {
            [
                UIImage(systemName: "magnifyingglass"),
                UIImage(systemName: "note.text"),
                UIImage(systemName: "minus.rectangle")
            ][self.index]
        }
        
        // Index helper for easier access in arrays
        private var index: Int {
            switch self {
            case .emptySearch: return 0
            case .emptyList: return 1
            case .emptyHistory: return 2
            }
        }
    }
    
    private lazy var miniMainTitle: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        text.textColor = .darkGray
        text.textAlignment = .center
        
        text.numberOfLines = 2
        
        return text
    }()
    
    private lazy var mainTitle: UILabel = {
        let text = UILabel()
        text.font = UIFont.boldSystemFont(ofSize: 18.0)
        text.textColor = .black
        text.numberOfLines = 0
        text.textAlignment = .center
        
        return text
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
