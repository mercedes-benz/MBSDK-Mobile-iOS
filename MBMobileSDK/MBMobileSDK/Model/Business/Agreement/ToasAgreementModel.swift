//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of agreements document
public class ToasAgreementModel: Codable {
    
    public let documents: [ToasDocumentModel]?
    public let checkboxes: [ToasCheckboxModel]?
    
    public init(documents: [ToasDocumentModel], checkboxes: [ToasCheckboxModel]) {
        
        self.documents = documents
        self.checkboxes = checkboxes
    }
}
