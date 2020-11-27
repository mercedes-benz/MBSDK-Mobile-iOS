//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBMobileSDK

class WeeklyProfileModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddTimeProfile() {
		
		var weeklyProfileModel = WeeklyProfileModel(
			singleEntriesActivatable: true,
			maxSlots: 0,
			maxTimeProfiles: 0,
			currentSlots: 0,
			currentTimeProfiles: 0,
			allTimeProfiles: []
		)
		weeklyProfileModel = weeklyProfileModel.addTimeProfile(timeProfile: TimeProfile(hour: 1337,
																						minute: 0,
																						active: true,
																						days: Set()))
		
		XCTAssertEqual(1337, weeklyProfileModel.timeProfiles[0].hour)
    }

    func testRemoveTimeProfile() {
		
		let weeklyProfileModel = WeeklyProfileModel(
			singleEntriesActivatable: true,
			maxSlots: 0,
			maxTimeProfiles: 0,
			currentSlots: 0,
			currentTimeProfiles: 0,
			allTimeProfiles: [TimeProfile(identifier: 4, hour: 0, minute: 0, active: true, days: Set())]
		)
		
		XCTAssertEqual(1, weeklyProfileModel.timeProfiles.count)
		let removed = weeklyProfileModel.removeTimeProfile(index: 0)
		XCTAssertEqual(0, removed?.timeProfiles.count)
    }
	
	
    func testAddRemoveMixTimeProfile() {
		
		var weeklyProfileModel = WeeklyProfileModel(
			singleEntriesActivatable: true,
			maxSlots: 0,
			maxTimeProfiles: 0,
			currentSlots: 0,
			currentTimeProfiles: 0,
			allTimeProfiles: [TimeProfile(identifier: 1, hour: 1, minute: 1, active: true, days: Set())]
		)
		
		weeklyProfileModel = weeklyProfileModel.addTimeProfile(timeProfile: TimeProfile(identifier: 2,
																						hour: 2,
																						minute: 2,
																						active: true,
																						days: Set()))
		weeklyProfileModel = weeklyProfileModel.addTimeProfile(timeProfile: TimeProfile(identifier: 3,
																						hour: 3,
																						minute: 3,
																						active: true,
																						days: Set()))
		
		XCTAssertEqual(3, weeklyProfileModel.timeProfiles.count)
		if let removed = weeklyProfileModel.removeTimeProfile(index: 1) {
			weeklyProfileModel = removed
		}
		
		XCTAssertEqual(2, weeklyProfileModel.timeProfiles.count)
		
		if let updated = weeklyProfileModel.updateTimeProfile(index: 1, timeProfile: TimeProfile(identifier: 3, hour: 4, minute: 4, active: true, days: Set())) {
			weeklyProfileModel = updated
		}
		XCTAssertEqual(4, weeklyProfileModel.timeProfiles[1].hour)
    }
	
    func testNilForInvalidIndexTimeProfile() {
		
		var weeklyProfileModel = WeeklyProfileModel(
			singleEntriesActivatable: true,
			maxSlots: 0,
			maxTimeProfiles: 0,
			currentSlots: 0,
			currentTimeProfiles: 0,
			allTimeProfiles: [
				TimeProfile(identifier: 1,
							hour: 1,
							minute: 1,
							active: true,
							days: Set())
			]
		)
		
		weeklyProfileModel = weeklyProfileModel.addTimeProfile(timeProfile: TimeProfile(identifier: 2,
																						hour: 2,
																						minute: 2,
																						active: true,
																						days: Set()))

		XCTAssertNil(weeklyProfileModel.removeTimeProfile(index: 341))
    }
}
