//
//  FileManager+Documents.swift
//  iOSeries
//
//  Created by Pierre on 14/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import Foundation

extension FileManager {
    public static func documentURL() -> URL? {
        return self.documentURL(childPath: nil)
    }
    
    public static func documentURL(childPath: String?) -> URL? {
        if let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            if let path = childPath {
                return documentURL.appendingPathComponent(path)
            }
            return documentURL
        }
        return nil
    }
}
