//
//  PermissionFactoryContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Foundation
import SwiftUI

enum AuthorizationStatus {
    case authorized
    case denied
    case notDetermined
}

protocol PermissionTypeContract {
    func requestPermission(completionHandler: @escaping (_ authorizationStatus: AuthorizationStatus) -> Void)
    func checkAuthorizationStatus(completionHandler: @escaping (_ authorizationStatus: AuthorizationStatus) -> Void)
}

extension PermissionTypeContract {
    func settingsURL() -> String {
        return UIApplication.openSettingsURLString
    }
}
