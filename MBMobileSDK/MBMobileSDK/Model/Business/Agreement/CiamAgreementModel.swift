//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of agreements document
public class CiamAgreementModel: Codable {
    
    public var acceptanceState: AgreementAcceptanceState
    public let href, documentID: String
    public var version: String?
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
        case href
        case documentID = "documentId"
        case version
    }
    
    public init(acceptanceState: AgreementAcceptanceState,
                href: String,
                documentID: String,
                version: String?) {
        
        self.acceptanceState = acceptanceState
        self.href = href
        self.documentID = documentID
        self.version = version
    }
}


// MARK: - Hashable

extension CiamAgreementModel: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.documentID)
    }
}


// MARK: - Equatable

extension CiamAgreementModel: Equatable {
    
    public static func == (lhs: CiamAgreementModel, rhs: CiamAgreementModel) -> Bool {
        return lhs.documentID == rhs.documentID
    }
}
