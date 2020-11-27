//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a user agreement document
public class SoeAgreementModel: Codable {
    public let href, documentID: String
    public let checkBoxText: String
    public var version: String?
    public let position: Int
    public let displayName: String
    public var acceptanceState: AgreementAcceptanceState
    public let checkBoxTextKey: String
    public let isGeneralUserAgreement: Bool
    public let titleText: String
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
        case acceptanceState, isGeneralUserAgreement
        case href
        case documentID = "documentId"
        case version, position, displayName, checkBoxTextKey, checkBoxText, titleText
    }
    
    public init(href: String,
                documentID: String,
                version: String?,
                position: Int,
                displayName: String,
                acceptanceState: AgreementAcceptanceState,
                checkBoxTextKey: String,
                isGeneralUserAgreement: Bool,
                checkBoxText: String,
                titleText: String) {
        
        self.href = href
        self.documentID = documentID
        self.version = version
        self.position = position
        self.displayName = displayName
        self.acceptanceState = acceptanceState
        self.checkBoxTextKey = checkBoxTextKey
        self.isGeneralUserAgreement = isGeneralUserAgreement
        self.checkBoxText = checkBoxText
        self.titleText = titleText
    }
}


// MARK: - Hashable

extension SoeAgreementModel: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.documentID)
    }
}


// MARK: - Equatable

extension SoeAgreementModel: Equatable {
    public static func == (lhs: SoeAgreementModel, rhs: SoeAgreementModel) -> Bool {
        return lhs.documentID == rhs.documentID
    }
}
