//
//  TestUserConfiguration.swift
//  RsyncArguments
//
//  Created by Thomas Evensen on 05/08/2024.
//

import Foundation

struct TestUserConfiguration: Codable {
    var rsyncversion3: Int = -1
    // Detailed logging
    var addsummarylogrecord: Int = 1
    // Logging to logfile
    var logtofile: Int = 1
    // Montor network connection
    var monitornetworkconnection: Int = -1
    // local path for rsync
    var localrsyncpath: String?
    // temporary path for restore
    var pathforrestore: String?
    // days for mark days since last synchronize
    var marknumberofdayssince: String = "5"
    // Global ssh keypath and port
    var sshkeypathandidentityfile: String?
    var sshport: Int?
    // Environment variable
    var environment: String?
    var environmentvalue: String?
    // Check for error in output from rsync
    var checkforerrorinrsyncoutput: Int = -1
    // Automatic execution
    var confirmexecute: Int?

    @MainActor private func setuserconfigdata() {
        if rsyncversion3 == 1 {
            TestSharedReference.shared.rsyncversion3 = true
        } else {
            TestSharedReference.shared.rsyncversion3 = false
        }
        if addsummarylogrecord == 1 {
            TestSharedReference.shared.addsummarylogrecord = true
        } else {
            TestSharedReference.shared.addsummarylogrecord = false
        }
        if logtofile == 1 {
            TestSharedReference.shared.logtofile = true
        } else {
            TestSharedReference.shared.logtofile = false
        }
        if monitornetworkconnection == 1 {
            TestSharedReference.shared.monitornetworkconnection = true
        } else {
            TestSharedReference.shared.monitornetworkconnection = false
        }
        if localrsyncpath != nil {
            TestSharedReference.shared.localrsyncpath = localrsyncpath
        } else {
            TestSharedReference.shared.localrsyncpath = nil
        }
        if pathforrestore != nil {
            TestSharedReference.shared.pathforrestore = pathforrestore
        } else {
            TestSharedReference.shared.pathforrestore = nil
        }
        if Int(marknumberofdayssince) ?? 0 > 0 {
            TestSharedReference.shared.marknumberofdayssince = Int(marknumberofdayssince) ?? 0
        }
        if sshkeypathandidentityfile != nil {
            TestSharedReference.shared.sshkeypathandidentityfile = sshkeypathandidentityfile
        }
        if sshport != nil {
            TestSharedReference.shared.sshport = sshport
        }
        if environment != nil {
            TestSharedReference.shared.environment = environment
        }
        if environmentvalue != nil {
            TestSharedReference.shared.environmentvalue = environmentvalue
        }
        if checkforerrorinrsyncoutput == 1 {
            TestSharedReference.shared.checkforerrorinrsyncoutput = true
        } else {
            TestSharedReference.shared.checkforerrorinrsyncoutput = false
        }
        if confirmexecute == 1 {
            TestSharedReference.shared.confirmexecute = true
        } else {
            TestSharedReference.shared.confirmexecute = false
        }
    }

    // Used when reading JSON data from store
    @discardableResult
    @MainActor init(_ data: DecodeTestUserConfiguration) {
        rsyncversion3 = data.rsyncversion3 ?? -1
        addsummarylogrecord = data.addsummarylogrecord ?? 1
        logtofile = data.logtofile ?? 0
        monitornetworkconnection = data.monitornetworkconnection ?? -1
        localrsyncpath = data.localrsyncpath
        pathforrestore = data.pathforrestore
        marknumberofdayssince = data.marknumberofdayssince ?? "5"
        sshkeypathandidentityfile = data.sshkeypathandidentityfile
        sshport = data.sshport
        environment = data.environment
        environmentvalue = data.environmentvalue
        checkforerrorinrsyncoutput = data.checkforerrorinrsyncoutput ?? -1
        confirmexecute = data.confirmexecute ?? -1
        // Set user configdata read from permanent store
        setuserconfigdata()
    }

    // Default values user configuration
    @discardableResult
    @MainActor init() {
        if TestSharedReference.shared.rsyncversion3 {
            rsyncversion3 = 1
        } else {
            rsyncversion3 = -1
        }
        if TestSharedReference.shared.addsummarylogrecord {
            addsummarylogrecord = 1
        } else {
            addsummarylogrecord = -1
        }
        if TestSharedReference.shared.logtofile {
            logtofile = 1
        } else {
            logtofile = -1
        }
        if TestSharedReference.shared.monitornetworkconnection {
            monitornetworkconnection = 1
        } else {
            monitornetworkconnection = -1
        }
        if TestSharedReference.shared.localrsyncpath != nil {
            localrsyncpath = TestSharedReference.shared.localrsyncpath
        } else {
            localrsyncpath = nil
        }
        if TestSharedReference.shared.pathforrestore != nil {
            pathforrestore = TestSharedReference.shared.pathforrestore
        } else {
            pathforrestore = nil
        }
        marknumberofdayssince = String(TestSharedReference.shared.marknumberofdayssince)
        if TestSharedReference.shared.sshkeypathandidentityfile != nil {
            sshkeypathandidentityfile = TestSharedReference.shared.sshkeypathandidentityfile
        }
        if TestSharedReference.shared.sshport != nil {
            sshport = TestSharedReference.shared.sshport
        }
        if TestSharedReference.shared.environment != nil {
            environment = TestSharedReference.shared.environment
        }
        if TestSharedReference.shared.environmentvalue != nil {
            environmentvalue = TestSharedReference.shared.environmentvalue
        }
        if TestSharedReference.shared.checkforerrorinrsyncoutput == true {
            checkforerrorinrsyncoutput = 1
        } else {
            checkforerrorinrsyncoutput = -1
        }
        if TestSharedReference.shared.confirmexecute == true {
            confirmexecute = 1
        } else {
            confirmexecute = -1
        }
    }
}

// swiftlint:enable cyclomatic_complexity function_body_length
