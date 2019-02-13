//
//  Localizable.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import Foundation
import UIKit



enum AppStrings {
    
    static let welcome = localized("welcome")
    
    //Common
    static let common_alert_error_title = localized("Common.Alert.Error.Title")
    static let common_ok = localized("Common.Ok")
    static let common_no_favorites = localized("Common.NoFavorites")
    static let common_app_name = localized("Common.App.Title")
    static let common_favorites_title = localized("Common.App.Favorites.Title")
    static let common_alert_warning_title = localized("Common.Alert.Warning.Title")
    //Api Errors
    static let apiError_noInternetConnection = localized("ApiError.NoInternetConnection")
    static let apiError_refresher = localized("ApiError.Refresher")
    
    
    //TabBar
    static let tabBar_home_title = localized("TabBar.Home.Title")
    static let tabBar_favorites_title = localized("TabBar.Favorites.Title")
    
    public static func getLocalizedString(value: Any) -> String {
        if let value = value as? String {
            return localized(value)
        }
        return String(describing: value)
    }
    
    private static func localized(_ value: String) -> String {
        return NSLocalizedString(value, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
}



