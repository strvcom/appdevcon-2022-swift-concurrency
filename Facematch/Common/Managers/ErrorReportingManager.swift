//
//  ErrorReportingManager.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 1/26/21.
//

import Sentry

protocol ErrorReportingManaging {
    func start()
    func setUser(loggedUser: LoggedUser)
}

class ErrorReportingManager: ErrorReportingManaging {
    func start() {
        guard let sentryDSN = Configuration.default.sentryDSN, !sentryDSN.isEmpty else {
            return
        }

        SentrySDK.start { options in
            options.dsn = sentryDSN
        }
    }
    
    func setUser(loggedUser: LoggedUser) {
        let user = Sentry.User()
        user.userId = loggedUser.id ?? ""
        user.data = [
            "firstName": loggedUser.firstName ?? "",
            "lastName": loggedUser.lastName ?? ""
        ]
        
        SentrySDK.setUser(user)
    }
}
