//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import UIKit
import MBMobileSDK


class VehicleDataSource: NSObject {

    // MARK: - Typealias

    internal typealias DidSelectHandler = (_ item: VehicleModel) -> Void
    internal typealias UpdateUIHandler = () -> Void

    // MARK: - Properties

    private var dataSource = [VehicleModel]() {
        didSet {
            self.updateUIHandler?()
        }
    }
    private var didSelectHandler: DidSelectHandler?
    private var updateUIHandler: UpdateUIHandler?


    // MARK: - Init

    init(didSelectHandler: DidSelectHandler?, updateUIHandler: UpdateUIHandler?) {

        self.didSelectHandler = didSelectHandler
        self.updateUIHandler = updateUIHandler
    }

    func configure(tableView: UITableView) {

        tableView.dataSource            = self
        tableView.delegate              = self
        tableView.rowHeight             = UITableView.automaticDimension
        tableView.sectionHeaderHeight   = UITableView.automaticDimension
        tableView.tableFooterView       = UIView()
        
        tableView.register(UINib(nibName: VehicleTableViewCell.reuseIdentifier(), bundle: nil), forCellReuseIdentifier: VehicleTableViewCell.reuseIdentifier())
    }

    func setDataSource(_ dataSource: [VehicleModel]) {
        self.dataSource = dataSource
    }
}


// MARK: - UITableViewDataSource

extension VehicleDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleTableViewCell.reuseIdentifier(), for: indexPath) as? VehicleTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: self.dataSource.item(at: indexPath.row))
        return cell
    }
}


// MARK: - UITableViewDelegate

extension VehicleDataSource: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = self.dataSource.item(at: indexPath.row) else {
            return
        }
        
        self.didSelectHandler?(item)
    }
}
