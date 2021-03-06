//
//  File.swift
//  Glovo
//
//  Created by Eugène Peschard on 11/03/2019.
//  Copyright © 2019 pesch.app. All rights reserved.
//

import Foundation

public struct Request<ResponseType> {
    let endpoint: Endpoint
    let environment: Environment
    let signature: Signature?
}
