//
//  ViewController.swift
//  Maze
//
//  Created by ugo cottin on 09/03/2020.
//  Copyright © 2020 ugo cottin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	private let maze = Maze(gridSize: 5, screenSize: 2560)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.view = maze.view
		
		//maze.draw(x: 20, y: 20, color: .brown)
		self.view = maze.view
	}

}

