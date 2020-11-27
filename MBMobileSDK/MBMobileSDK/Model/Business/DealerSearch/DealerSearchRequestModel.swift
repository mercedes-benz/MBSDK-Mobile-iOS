//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a dealer search request
public struct DealerSearchRequestModel {

	// MARK: Enum
	
	/// Search type for 2 cases (location based and zip/city based)
    public enum SearchType {
        case byLocation(center: CoordinateModel, radius: Double)
        case byZipOrCity(value: String, countryIsoCode: String)
    }

	// MARK: Properties
    private let searchType: SearchType
    let activity: String?
    let brandCode: String?
    let productGroup: String?

	
	// MARK: - Init
	
    public init(searchType: SearchType, activity: String? = nil, brandCode: String? = nil, productGroup: String? = nil) {
        
        self.activity = activity
        self.brandCode = brandCode
        self.productGroup = productGroup
        self.searchType = searchType
    }
	
	
	// MARK: - Helper
	
	var zipCode: String? {
		switch self.searchType {
		case .byLocation:					return nil
		case .byZipOrCity(let value, _):	return value
		}
	}
    
	var countryIsoCode: String? {
		switch self.searchType {
		case .byLocation:							return nil
		case .byZipOrCity(_, let countryIsoCode):	return countryIsoCode
		}
	}
    
	var location: CoordinateModel? {
		switch self.searchType {
		case .byLocation(let coordinateModel, _):	return coordinateModel
		case .byZipOrCity:						    return nil
		}
	}
    
    var radius: Double? {
        switch self.searchType {
        case .byLocation(_, let radius):    return radius
        case .byZipOrCity:                  return nil
        }
    }
}
