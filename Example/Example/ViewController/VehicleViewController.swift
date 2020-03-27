//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import UIKit
import MBCarKit
import MBIngressKit


// MARK: - VehicleSelectionDelegate

protocol VehicleSelectionDelegate: class {
    func didSelectVehicle(vehicle: VehicleModel)
}


// MARK: - VehicleViewController

class VehicleViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.dataSource.configure(tableView: self.tableView)
        }
    }
    
    // MARK: - Lazy
    
    private lazy var dataSource: VehicleDataSource = {
        return VehicleDataSource(didSelectHandler: { [weak self] (vehicleModel) in
            self?.delegate?.didSelectVehicle(vehicle: vehicleModel)
        }, updateUIHandler: { [weak self] in
            self?.tableView.reloadData()
        })
    }()
    
    // MARK: - Properties
    
    private weak var delegate: VehicleSelectionDelegate?

    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.title = "Fetch Vehicle"

        CarKit.vehicleService.fetchVehicles { (result) in

            switch result {
            case let .success(vehicles):
                LOG.D("Found vehicles: \(vehicles.count)")
                
                self.dataSource.setDataSource(vehicles)
				
            case let .failure(error):
                LOG.E(error)
            }
        }
    }
    
    
    // MARK: - Instatiation
    
    public static func instantiate(delegate: VehicleSelectionDelegate) -> UIViewController {
        
        let vc = StoryboardScene.Main.vehicleViewController.instantiate()
        vc.delegate = delegate
        return vc
    }
}
