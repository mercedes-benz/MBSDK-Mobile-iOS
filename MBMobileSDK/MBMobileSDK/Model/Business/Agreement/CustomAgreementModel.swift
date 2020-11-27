//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a user agreement document
public class CustomAgreementModel: Codable {
    
    public var acceptanceState: AgreementAcceptanceState
    public let displayLocation: String
    public let displayName: String
    public let position: Int
    public let documentID: String
    public let href: String
    public let version: Int
    public var accepted: Bool {
        get {
            return acceptanceState == .accepted
        }
        set {
            if newValue {
                self.acceptanceState = .accepted
            } else {
                self.acceptanceState = .rejected
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case acceptanceState
        case position
        case href
        case documentID = "id"
        case displayLocation, displayName, version
    }
    
    public init(acceptanceState: AgreementAcceptanceState,
                displayLocation: String,
                displayName: String,
                position: Int,
                documentID: String,
                href: String,
                version: Int) {
        
        self.acceptanceState = acceptanceState
        self.displayLocation = displayLocation
        self.displayName = displayName
        self.position = position
        self.documentID = documentID
        self.href = href
        self.version = version
    }
}


// MARK: - Hashable

extension CustomAgreementModel: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.documentID)
    }
}


// MARK: - Equatable

extension CustomAgreementModel: Equatable {
    public static func == (lhs: CustomAgreementModel, rhs: CustomAgreementModel) -> Bool {
        return lhs.documentID == rhs.documentID
    }
}
