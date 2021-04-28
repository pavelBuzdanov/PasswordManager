//
//  UITableView+Extension.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 25.04.2021.
//

import UIKit

extension UITableView {

    var rowsCount: Int {
        let sections = self.numberOfSections
        var rows = 0

        for i in 0...sections - 1 {
            rows += self.numberOfRows(inSection: i)
        }

        return rows
    }
}
