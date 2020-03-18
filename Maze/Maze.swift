//
//  Maze.swift
//  Maze
//
//  Created by ugo cottin on 09/03/2020.
//  Copyright © 2020 ugo cottin. All rights reserved.
//

import Foundation
import UIKit

class Maze {
	
	var up: Grid<Bool>
	var down: Grid<Bool>
	var left: Grid<Bool>
	var right: Grid<Bool>
	
	var visitedCells: Grid<Bool>
	var colorCells: Grid<UIColor>
	
	private let gridSize: Int
	private let screenSize: Int
	
	var view: UIView {
		return drawView(gridSize: self.gridSize, screenSize: self.screenSize)
	}
	
	init(gridSize: Int, screenSize: Int) {
		self.gridSize = gridSize
		self.screenSize = screenSize
		
		self.visitedCells = Grid(rows: gridSize + 2, columns: gridSize + 2, defaultValue: false)
		self.up = Grid(rows: gridSize + 2, columns: gridSize + 2, defaultValue: true)
		self.down = Grid(rows: gridSize + 2, columns: gridSize + 2, defaultValue: true)
		self.left = Grid(rows: gridSize + 2, columns: gridSize + 2, defaultValue: true)
		self.right = Grid(rows: gridSize + 2, columns: gridSize + 2, defaultValue: true)
		
		self.colorCells = Grid(rows: gridSize + 2, columns: gridSize + 2, defaultValue: .white)

		for x in 0 ..< self.gridSize + 2 {
			visitedCells[x, 0] = true
			visitedCells[x, gridSize + 1] = true
		}
		
		for y in 0 ..< self.gridSize + 2 {
			visitedCells[0, y] = true
			visitedCells[gridSize + 1, y] = true
		}
		
		dropWalls(x: 1, y: 1, gridSize: gridSize)

	}
	
	private func dropWalls(x: Int, y: Int, gridSize: Int) {
		
		visitedCells[x, y] = true
		
		while unvisidedNeighbor(x: x, y: y) {
			
			while true {
				let r = UInt32(arc4random() % 4)
				
				if r == 0 && !visitedCells[x, y + 1] {
					up[x, y] = false
					down[x, y + 1] = false
					dropWalls(x: x, y: y + 1, gridSize: gridSize)
					break
				} else if r == 1 && !visitedCells[x + 1, y] {
					right[x, y] = false
					left[x + 1, y] = false
					dropWalls(x: x + 1, y: y, gridSize: gridSize)
					break
				} else if r == 2 && !visitedCells[x, y - 1] {
					down[x, y] = false
					up[x, y - 1] = false
					dropWalls(x: x, y: y - 1, gridSize: gridSize)
					break
				} else if r == 3 && !visitedCells[x - 1, y] {
					left[x, y] = false
					right[x - 1, y] = false
					dropWalls(x: x - 1, y: y, gridSize: gridSize)
					break
				}
			}
		}
		
		up[1, 1] = false
		down[1, 1] = false
		
		up[gridSize, gridSize] = false
		down[gridSize, gridSize] = false
	}
	
	private func unvisidedNeighbor(x: Int, y: Int) -> Bool {
		return !visitedCells[x, y + 1] || !visitedCells[x, y - 1] || !visitedCells[x + 1, y] || !visitedCells[x - 1, y]
	}
	
	func drawLine(from origin: CGPoint, to destination: CGPoint, with resizeFactor: CGFloat) {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: origin.x * resizeFactor, y:origin.y * resizeFactor))
		path.addLine(to: CGPoint(x:destination.x * resizeFactor, y:destination.y * resizeFactor))
		UIColor.black.setStroke()
		path.stroke()
	}
	
	func drawRect(from origin: CGPoint, to destination: CGPoint, with resizeFactor: CGFloat, color: UIColor) {
		let size = CGSize(width: (destination.x - origin.x) * resizeFactor, height: (destination.y - origin.y) * resizeFactor)
		let rect = CGRect(origin: CGPoint(x: origin.x * resizeFactor, y: origin.y * resizeFactor), size: size)
		
		color.set()
		UIRectFrame(rect)
		UIRectFill(rect)
	}
	
	func drawView(gridSize: Int, screenSize: Int) -> UIView {
		let viewSize = CGSize(width: screenSize, height: screenSize)
		let result: UIView = UIView(frame: CGRect(origin: CGPoint.zero, size: viewSize))
		result.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
		UIGraphicsBeginImageContextWithOptions(viewSize, false, 0)
		
		let resizeFactor = viewSize.width / CGFloat(gridSize + 2)
		
		for x in 1 ..< gridSize + 1 {
			for y in 1 ..< gridSize + 1 {
				
				drawRect(from: CGPoint(x: x, y: y), to: CGPoint(x: x + 1, y: y + 1), with: resizeFactor, color: self.colorCells[x, y])
				
				if (down[x, y]) {
					drawLine(from: CGPoint(x: x, y: y), to: CGPoint(x: x + 1, y: y), with: resizeFactor)
				}
				
				if (up[x,y]) {
					drawLine(from: CGPoint(x: x, y: y + 1), to: CGPoint(x: x + 1, y: y + 1), with: resizeFactor)
				}
				
				if (left[x,y]) {
					drawLine(from: CGPoint(x: x, y: y), to: CGPoint(x: x, y: y + 1), with: resizeFactor)
				}
				if (right[x,y]) {
					drawLine(from: CGPoint(x: x + 1, y: y), to: CGPoint(x: x + 1, y: y + 1), with: resizeFactor)
				}
				
			}
		}
		
		result.layer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
		UIGraphicsEndImageContext()
		return result
	}
	
	public func draw(x: Int, y: Int, color: UIColor) {
		self.colorCells[x, y] = color
	}
	
	public var graphe: [MazeNode] {
		
		self._noeuds.removeAll()
		
		for x in 1 ..< gridSize + 1 {
			for y in 1 ..< gridSize + 1 {
				let noeud = MazeNode(x: x, y: y)
				self._noeuds.append(noeud)
			}
		}
		
		
		
		for x in 1 ..< gridSize + 1 {
			for y in 1 ..< gridSize + 1 {
				//let node = noeud(x: x, y: y)
				
			}
		}
		
		return self._noeuds
	}
	
	private var _noeuds = [MazeNode]()
	
	private func voisins(de noeud: MazeNode) {
		let coords = noeud.coords
		var v = [MazeNode]()
		
		if !up[coords.x, coords.y] {
			//v.append(noeud(x: coords.x + 1, y: coords.y))
		}
		
	}
	
}

class MazeNode: Noeud {
	let coords: (x: Int, y: Int)
	
	init(x: Int, y: Int) {
		self.coords = (x, y)
		super.init()
	}
}
