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
        let startDate = Date(milliseconds: route.startDate)
        let endDate = route.endDate != nil ? Date(milliseconds: route.endDate!) : nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current      // Idioma y región del dispositivo
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = .current      // Idioma y región del dispositivo
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        var endString = "Navigating..."
        titleLabel.textColor = .systemGreen
        if (endDate != nil) {
            endString = timeFormatter.string(from: endDate!)
            titleLabel.textColor = .label
        }
        
        titleLabel.text = "\(dateFormatter.string(from: startDate)): \(timeFormatter.string(from: startDate)) - \(endString)"
    }

}
