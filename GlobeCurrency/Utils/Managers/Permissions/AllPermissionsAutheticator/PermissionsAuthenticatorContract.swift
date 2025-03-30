//
//  PermissionsAuthenticatorContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Foundation

protocol PermissionsAuthenticatorContract {
    func requestAuthorizationStatus(completion: @escaping (AuthorizationStatus) -> Void)
}
