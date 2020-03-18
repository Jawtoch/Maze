//
//  Connexion.swift
//  Maze
//
//  Created by ugo cottin on 09/03/2020.
//  Copyright © 2020 ugo cottin. All rights reserved.
//

import Foundation

class Connexion {
	public let vers: Noeud
	public let poids: Int
	
	public init(vers noeud: Noeud, poids: Int) {
		assert(poids >= 0, "le poids doit être positif")
		self.vers = noeud
		self.poids = poids
	}
}
