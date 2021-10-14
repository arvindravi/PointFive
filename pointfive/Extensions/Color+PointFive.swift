//
//  Color+PointFive.swift
//  pointfive
//
//  Created by Arvind Ravi on 14/10/2021.
//

import SwiftUI

extension Color {
	init(brandColor: String) {
		switch brandColor.lowercased() {
		case "red": self = .red
		case "orange": self = .orange
		case "blue": self = .blue
		default: self = .clear
		}
	}
}
