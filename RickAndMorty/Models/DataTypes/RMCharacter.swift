//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 13.03.2023.
//

import Foundation

struct RMCharacter: Codable { /* 46 paste all info from json and rewrite */
    let id: Int 
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMOrigin
    let location: RMSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}


