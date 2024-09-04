import UIKit

class UniqueDisplay: UITableViewCell {
    let mainPNGDisplay: UIImageView = {
        let visualDisplay = UIImageView()
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
    
    let submainTitle: UILabel = {
        let string = UILabel()
        string.translatesAutoresizingMaskIntoConstraints = false
        return string
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(mainPNGDisplay)
        contentView.addSubview(mainText)
        contentView.addSubview(submainTitle)
        
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
