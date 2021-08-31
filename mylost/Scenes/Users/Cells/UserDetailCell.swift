//
//  UserDetailCell.swift
//  UserDetailCell
//
//  Created by Nato Egnatashvili on 14.08.21.
//

import UIKit

class UserDetailCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with model: ViewModel) {
        self.name.text = model.name
        self.lastname.text = model.lastname
        self.date.text = model.date
        guard let handler = model.buttonHandler else { return }
        self.button.addAction(.init(handler: handler),
                              for: .touchUpInside)
        
    }
}

extension UserDetailCell {
    struct ViewModel {
        let name: String?
        let lastname: String?
        let date: String?
        let buttonHandler: UIActionHandler?
        
        init (name: String?,
              lastname: String?,
              date: String?,
              buttonHandler: UIActionHandler?) {
            self.name = name
            self.lastname = lastname
            self.date = date
            self.buttonHandler = buttonHandler
        }
    }
}
