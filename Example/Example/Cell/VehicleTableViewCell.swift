//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import UIKit
import MBCarKit

class VehicleTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var labelModel: UILabel!
    @IBOutlet private weak var labelFIN: UILabel!
    @IBOutlet private weak var labelFuelType: UILabel!
    @IBOutlet private weak var labelRoofType: UILabel!
    
    
    // MARK: - View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
    }
    
    
    // MARK: - Instatiation
    
    static func reuseIdentifier() -> String {
        return String(describing: VehicleTableViewCell.self)
    }
    
    
    // MARK: - Configure
    
    public func configure(with model: VehicleModel?) {
        
        self.labelModel.text = "Model: \(model?.model ?? "Unkown")"
        self.labelFIN.text = "VIN: \(model?.fin ?? "Unkown")"
        self.labelFuelType.text = "Fuel Type: \(model?.fuelType?.rawValue ?? "Unavailable")"
        self.labelRoofType.text = "Roof Type: \(model?.roofType?.rawValue ?? "Unavailable")"
    }
}
