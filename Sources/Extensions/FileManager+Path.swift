//
//  FileManager+Path.swift
//  colir
//
//  Created by Vitalii P on 07.10.2023.
//

import Foundation

extension FileManager {
    
    //Path to the "Pictures" directory in home dir
    var userPicturesDirectory: URL {
        homeDirectoryForCurrentUser.appendingPathComponent("Pictures")
    }
}
