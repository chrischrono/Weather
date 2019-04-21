//
//  StringExtension.swift
//  Weather
//
//  Created by Christian on 17/03/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation

extension String
{
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
}

