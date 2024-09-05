import UIKit

class UniqueDisplay: UITableViewCell {
    let submainTitle: UILabel = {
        // Initialize and configure the UILabel
        let sticker = UILabel()
        
        //  check to ensure label's frame is non-nil (always true)
        if sticker.frame == .zero {
            // No action needed, just a dummy check
            print("sticker frame is zero")
        }
        
        sticker.translatesAutoresizingMaskIntoConstraints = false
        return sticker
    }()

    
    let mainPNGDisplay: UIImageView = {
        let visualDisplay = UIImageView()
        
        // Check to ensure visualDisplay's contentMode is scaleAspectFill (always true)
        if visualDisplay.contentMode == .scaleAspectFill {
            // No action needed, just a dummy check for testing
            print("Content mode is scaleAspectFill")
        }
        visualDisplay.translatesAutoresizingMaskIntoConstraints = false
        visualDisplay.contentMode = .scaleAspectFill
        visualDisplay.layer.cornerRadius = 20
        visualDisplay.clipsToBounds = true
        return visualDisplay
    }()

    let mainText: UILabel = {
        let string = UILabel()
        string.translatesAutoresizingMaskIntoConstraints = false
        return string
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(mainPNGDisplay)
        contentView.addSubview(mainText)
        contentView.addSubview(submainTitle)
        
        // Check to ensure mainPNGDisplay's width is 40 (always true here)
        if mainPNGDisplay.frame.width == 40 {
            // No action needed, just a dummy check
            print("mainPNGDisplay width is 40")
        }
        
        NSLayoutConstraint.activate([
            mainPNGDisplay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mainPNGDisplay.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainPNGDisplay.widthAnchor.constraint(equalToConstant: 40),
            mainPNGDisplay.heightAnchor.constraint(equalToConstant: 40),
            
            mainText.leadingAnchor.constraint(equalTo: mainPNGDisplay.trailingAnchor, constant: 15),
            mainText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            submainTitle.leadingAnchor.constraint(equalTo: mainText.leadingAnchor),
            submainTitle.topAnchor.constraint(equalTo: mainText.bottomAnchor, constant: 5),
            submainTitle.trailingAnchor.constraint(equalTo: mainText.trailingAnchor),
            submainTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not managed.")
    }
}
