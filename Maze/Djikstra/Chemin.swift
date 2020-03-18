//
//  Chemin.swift
//  Maze
//
//  Created by ugo cottin on 09/03/2020.
//  Copyright © 2020 ugo cottin. All rights reserved.
//

import Foundation

class Chemin {
	public let poidsCumulé: Int
	public let noeud: Noeud
	public let précédentChemin: Chemin?
	
	public init(vers noeud: Noeud, via connexion: Connexion? = nil, cheminPrécédent chemin: Chemin? = nil) {
		if let cheminPrécédent = chemin, let connexion = connexion {
			self.poidsCumulé = connexion.poids + cheminPrécédent.poidsCumulé
		} else {
			self.poidsCumulé = 0
		}
		
		self.noeud = noeud
		self.précédentChemin = chemin
	}
	
	public func cheminLePlusCourt(depuis source: Noeud, vers destination: Noeud) -> Chemin? {
		var frontier = [Chemin]() {
			didSet {
				frontier.sort { (lhs, rhs) -> Bool in
					lhs.poidsCumulé < rhs.poidsCumulé
				}
			}
		}
		
		frontier.append(Chemin(vers: source))
		
		while !frontier.isEmpty {
			let cheminLePlusCourtInFrontier = frontier.removeFirst()
			guard !cheminLePlusCourtInFrontier.noeud.visité else {
				continue
			}
			
			if cheminLePlusCourtInFrontier.noeud === destination {
				return cheminLePlusCourtInFrontier
			}
			
			cheminLePlusCourtInFrontier.noeud.visité = true
			
			for connexion in cheminLePlusCourtInFrontier.noeud.connexions where !connexion.vers.visité {
				frontier.append(Chemin(vers: connexion.vers, via: connexion, cheminPrécédent: cheminLePlusCourtInFrontier))
			}
		}
		
		return nil
	}
}
