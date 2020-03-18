//
//  Grid.swift
//  Maze
//
//  Created by ugo cottin on 09/03/2020.
//  Copyright © 2020 ugo cottin. All rights reserved.
//

import Foundation

class Grid<T> {
	var matrix:[T]
	var rows:Int
	var columns:Int
	
	init(rows:Int, columns:Int, defaultValue:T) {
		self.rows = rows
		self.columns = columns
		matrix = Array(repeating:defaultValue,count:(rows*columns))
	}
	
	func indexIsValidForRow(row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	
	subscript(col:Int, row:Int) -> T {
		get{
			assert(indexIsValidForRow(row: row, column: col), "Index out of range")
			return matrix[Int(columns * row + col)]
		}
		set{
			assert(indexIsValidForRow(row: row, column: col), "Index out of range")
			matrix[(columns * row) + col] = newValue
		}
	}
}
