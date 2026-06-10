//
//  RouteViewCell.swift
//  TrackingApp
//
//  Created by Tardes on 10/6/26.
//

import UIKit

class RouteViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with route: Route) {
        titleLabel.text = route.id
    }

}
