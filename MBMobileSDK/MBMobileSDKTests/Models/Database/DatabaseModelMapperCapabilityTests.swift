//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import XCTest

@testable import MBMobileSDK

class DatabaseModelMapperCapabilityTests: XCTestCase {

	let finOrVin = "MOCKVIN871Z000099"
	let mapper = SendToCarCapabilitiesDbModelMapper()
	
    func testMapSendToCarCapabilitiesModel() {
		
		let capabilities: [SendToCarCapability] = [
			.singlePoiBluetooth,
			.staticRouteBackend
		]
		let preconditions: [SendToCarPrecondition] = [
			.registerUser,
			.enableMBApps
		]
        let capabilitiesModel = SendToCarCapabilitiesModel(capabilities: capabilities,
														   finOrVin: self.finOrVin,
														   preconditions: preconditions)

		let mappedModel = self.mapper.map(capabilitiesModel)
		let dbModelCapabilities = mappedModel.capabilities.components(separatedBy: ",")
		let dbModelPreconditions = mappedModel.preconditions.components(separatedBy: ",")
		XCTAssertEqual(dbModelCapabilities.count, 2)
		XCTAssertEqual(dbModelPreconditions.count, 2)
        XCTAssertTrue(dbModelCapabilities.contains( where: { $0 == SendToCarCapability.singlePoiBluetooth.rawValue }))
        XCTAssertTrue(dbModelCapabilities.contains( where: { $0 == SendToCarCapability.staticRouteBackend.rawValue }))
		XCTAssertTrue(dbModelPreconditions.contains( where: { $0 == SendToCarPrecondition.registerUser.rawValue }))
		XCTAssertTrue(dbModelPreconditions.contains( where: { $0 == SendToCarPrecondition.enableMBApps.rawValue }))

	}

    func testMapDbSendToCarCapabilitiesModel() {
		
		let capabilities: [SendToCarCapability] = [
			.singlePoiBluetooth,
			.staticRouteBackend
		]
		let preconditions: [SendToCarPrecondition] = [
			.registerUser,
			.enableMBApps
		]
        let dbCapabilitiesModel = DBSendToCarCapabilitiesModel()
		dbCapabilitiesModel.capabilities = capabilities.map { $0.rawValue }
			.joined(separator: ",")
		dbCapabilitiesModel.preconditions = preconditions.map { $0.rawValue }
			.joined(separator: ",")

		let mappedModel = self.mapper.map(dbCapabilitiesModel)

        XCTAssertEqual(mappedModel.capabilities.count, 2)
        XCTAssertTrue(mappedModel.capabilities.contains(.singlePoiBluetooth))
        XCTAssertTrue(mappedModel.capabilities.contains(.staticRouteBackend))
		
		XCTAssertEqual(mappedModel.preconditions.count, 2)
		XCTAssertTrue(mappedModel.preconditions.contains(.registerUser))
		XCTAssertTrue(mappedModel.preconditions.contains(.enableMBApps))
    }
}
