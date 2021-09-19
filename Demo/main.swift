//
//  main.swift
//  Demo
//
//  Created by Andrew Breckenridge on 9/19/21.
//

import Foundation
import ProxyPropertyWrapper_swift

class Public: ProxyContainer {
  private let hiddenInternalInstance = Internal()

  @Proxy(\.hiddenInternalInstance.publicallyAvailableProperty) var publishedProperty: Int
}

class Internal {
  var publicallyAvailableProperty: Int = 0 {
    didSet {
      print("internal private property set to \(publicallyAvailableProperty)")
    }
  }
}

let someInstance = Public()
someInstance.publishedProperty = 2
