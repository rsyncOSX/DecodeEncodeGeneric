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

    @MainActor private func convertToBoolean(_ value: Int) -> Bool {
        return value == 1
    }

    @MainActor private func convertBoolToInt(_ value: Bool) -> Int {
        return value ? 1 : -1
    }

    @MainActor private func setuserconfigdata() {
        TestSharedReference.shared.rsyncversion3 = convertToBoolean(rsyncversion3)
        TestSharedReference.shared.addsummarylogrecord = convertToBoolean(addsummarylogrecord)
        TestSharedReference.shared.logtofile = convertToBoolean(logtofile)
        TestSharedReference.shared.monitornetworkconnection = convertToBoolean(monitornetworkconnection)
        TestSharedReference.shared.localrsyncpath = localrsyncpath
        TestSharedReference.shared.pathforrestore = pathforrestore
        if Int(marknumberofdayssince) ?? 0 > 0 {
            TestSharedReference.shared.marknumberofdayssince = Int(marknumberofdayssince) ?? 0
        }
        TestSharedReference.shared.sshkeypathandidentityfile = sshkeypathandidentityfile
        TestSharedReference.shared.sshport = sshport
        TestSharedReference.shared.environment = environment
        TestSharedReference.shared.environmentvalue = environmentvalue
        TestSharedReference.shared.checkforerrorinrsyncoutput = convertToBoolean(checkforerrorinrsyncoutput)
        if let confirmexecute = confirmexecute {
            TestSharedReference.shared.confirmexecute = convertToBoolean(confirmexecute)
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
        setuserconfigdata()
    }

    // Default values user configuration
    @discardableResult
    @MainActor init() {
        rsyncversion3 = convertBoolToInt(TestSharedReference.shared.rsyncversion3)
        addsummarylogrecord = convertBoolToInt(TestSharedReference.shared.addsummarylogrecord)
        logtofile = convertBoolToInt(TestSharedReference.shared.logtofile)
        monitornetworkconnection = convertBoolToInt(TestSharedReference.shared.monitornetworkconnection)
        localrsyncpath = TestSharedReference.shared.localrsyncpath
        pathforrestore = TestSharedReference.shared.pathforrestore
        marknumberofdayssince = String(TestSharedReference.shared.marknumberofdayssince)
        sshkeypathandidentityfile = TestSharedReference.shared.sshkeypathandidentityfile
        sshport = TestSharedReference.shared.sshport
        environment = TestSharedReference.shared.environment
        environmentvalue = TestSharedReference.shared.environmentvalue
        checkforerrorinrsyncoutput = convertBoolToInt(TestSharedReference.shared.checkforerrorinrsyncoutput)
        confirmexecute = convertBoolToInt(TestSharedReference.shared.confirmexecute)
    }
}
