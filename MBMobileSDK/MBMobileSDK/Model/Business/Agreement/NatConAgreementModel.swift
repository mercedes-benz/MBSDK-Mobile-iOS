//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of NatCon agreements
public class NatConAgreementModel: Codable {
    
    /// A text for the "accpet all" checkbox.
    /// If it is empty, the checkbox should be be displayed.
    public let acceptAllText: String?
    public let title: String
    public let description: String
    public let version: String?
    public let documents: [NatConAgreementDocumentModel]
    
    enum CodingKeys: String, CodingKey {
        case acceptAllText
        case title
        case description
        case version
        case documents
    }
    
    public init(acceptAllText: String?,
                title: String,
                description: String,
                version: String?,
                documents: [NatConAgreementDocumentModel]) {
        self.acceptAllText = acceptAllText
        self.title = title
        self.description = description
        self.version = version
        self.documents = documents
    }
    
}

/// Representation of NatCon agreements document
public class NatConAgreementDocumentModel: Codable {
    
    public let isMandatory: Bool
    public let position: Int
    public let termsId: String
    public let text: String
    public let href: String
    public let language: String
    public var acceptanceState: AgreementAcceptanceState?
    public var isSelected: Bool = false
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
        case isMandatory
        case position
        case termsId
        case text
        case href
        case language
        case acceptanceState
    }
    
    public init(isMandatory: Bool,
                position: Int,
                termsId: String,
                text: String,
                href: String,
                language: String,
                acceptanceState: AgreementAcceptanceState?) {
        self.isMandatory = isMandatory
        self.position = position
        self.termsId = termsId
        self.text = text
        self.href = href
        self.language = language
        self.acceptanceState = acceptanceState
    }
    
    /// It makes a document text with mandatory mark (*),
    /// if the NatCon agreement is mandatory to agree.
    public func textWithMandatory() -> String {
        guard self.isMandatory else {
            return self.text
        }
        return self.text + " *"
    }
    
}
