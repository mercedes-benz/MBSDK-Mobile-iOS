//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit
import ZIPFoundation

enum ArchivingError: Error {
    case unarchivingFailed
}

class TopViewUnarchiver {
    
    private let fileManager = FileManager()
    
    func unarchive(fileUrl: URL, completion: (Result<[APIVehicleTopViewImageComponentModel], ArchivingError>) -> Void) {
        let destUrl = destinationUrl(forZipFileUrl: fileUrl)
        
        do {
            defer {
                cleanup(dirs: [fileUrl, destUrl])
            }
            
            try unzip(fileUrl: fileUrl, to: destUrl)
            
            let files = try listOfUnzipedFiles(forUnzipDirectory: destUrl)
            
            let models = files?.compactMap { url -> APIVehicleTopViewImageComponentModel? in
                guard let data = try? Data(contentsOf: url) else {
                    return nil
                }
                return APIVehicleTopViewImageComponentModel(name: url.lastPathComponent, imageData: data)
            }
            
            if models != nil {
                completion(Result.success(models!))
            } else {
                completion(Result.failure(ArchivingError.unarchivingFailed))
            }

        } catch {
            completion(Result.failure(ArchivingError.unarchivingFailed))
        }
    }
    
    private func cleanup(dirs: [URL]) {
        dirs.forEach {
            try? fileManager.removeItem(at: $0)
        }
    }
    
    private func listOfUnzipedFiles(forUnzipDirectory dir: URL) throws -> [URL]? {
        // zip file contains a "root" element that we have to "skip". We are only interested in the contents of that root folder
        guard let unzipedArchiveUrl = (try fileManager.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)).first else {
            return nil
        }
        return try fileManager.contentsOfDirectory(at: unzipedArchiveUrl, includingPropertiesForKeys: nil)
    }
    
    private func unzip(fileUrl: URL, to: URL) throws {
        try fileManager.createDirectory(at: to,
                                        withIntermediateDirectories: true,
                                        attributes: nil)
        try fileManager.unzipItem(at: fileUrl, to: to)
    }
    
    private func destinationUrl(forZipFileUrl url: URL) -> URL {
        let basePath = url.deletingLastPathComponent()
        return basePath.appendingPathComponent("ziptmp")
    }
    
}
