//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of agreements document
public class LdssoAgreementModel: Codable {
    
    public let documentID: String
    public let locale: String
    public let version: String
    public let position: Int
    public let displayName: String
    public let implicitConsent: Bool
    public let href: String
    public var acceptanceState: AgreementAcceptanceState
    
    enum CodingKeys: String, CodingKey {
        case documentID = "id"
        case locale
        case version
        case position
        case displayName
        case implicitConsent
        case href
        case acceptanceState
    }
    
    public init(documentID: String,
                locale: String,
                version: String,
                position: Int,
                displayName: String,
                implicitConsent: Bool,
                href: String,
                acceptanceState: AgreementAcceptanceState) {
        
        self.documentID = documentID
        self.locale = locale
        self.version = version
        self.position = position
        self.displayName = displayName
        self.implicitConsent = implicitConsent
        self.href = href
        self.acceptanceState = acceptanceState
    }
}


// MARK: - Hashable

extension LdssoAgreementModel: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.documentID)
    }
}


// MARK: - Equatable

extension LdssoAgreementModel: Equatable {
    public static func == (lhs: LdssoAgreementModel, rhs: LdssoAgreementModel) -> Bool {
        return lhs.documentID == rhs.documentID
    }
}
