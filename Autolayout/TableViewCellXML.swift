//  TableViewCellXML.swift
//  Autolayout
//  Created by Felipe Ramírez on 31/1/22.

import UIKit

class TableViewCellXML: UITableViewCell {
    @IBOutlet weak var lbl_nombre: UILabel!
    @IBOutlet weak var lbl_apellido: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
