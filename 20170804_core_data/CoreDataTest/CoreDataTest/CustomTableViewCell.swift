//
//  CustomTableViewCell.swift
//  CoreDataTest
//
//  Created by Jason on 02/08/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var sexLab: UILabel!
    @IBOutlet weak var ageLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(people:People){
        nameLab.text = people.name
        sexLab.text = people.sex
        ageLab.text = people.age
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
