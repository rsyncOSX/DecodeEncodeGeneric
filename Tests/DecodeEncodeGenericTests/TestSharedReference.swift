//
//  TestSharedReference.swift
//  RsyncArguments
//
//  Created by Thomas Evensen on 05/08/2024.
//

import Foundation

@MainActor
final class TestSharedReference {
    @MainActor static let shared = TestSharedReference()
    private init() {
        synctasks = Set<String>()
        synctasks = [synchronize, snapshot, syncremote]
    }

    var settingsischanged: Bool = false
    var rsyncversion3: Bool = true
    var localrsyncpath: String?
    var norsync: Bool = false
    var pathforrestore: String?
    var addsummarylogrecord: Bool = true
    var logtofile: Bool = false
    var marknumberofdayssince: Int = 5
    var environment: String?
    var environmentvalue: String?
    var sshport: Int?
    var sshkeypathandidentityfile: String?
    var checkforerrorinrsyncoutput: Bool = false
    var monitornetworkconnection: Bool = false
    var confirmexecute: Bool = false
    var URLnewVersion: String?
    let rsync: String = "rsync"
    let usrbin: String = "/usr/bin"
    let usrlocalbin: String = "/usr/local/bin"
    let usrlocalbinarm: String = "/opt/homebrew/bin"
    var macosarm: Bool = true
    // RsyncUI config files and path
    let configpath: String = "/.rsyncosx/"
    let logname: String = "rsyncui.txt"
    // Userconfiguration json file
    let userconfigjson: String = "rsyncuiconfig.json"
    // String tasks
    let synchronize: String = "synchronize"
    let snapshot: String = "snapshot"
    let syncremote: String = "syncremote"
    var synctasks: Set<String>
    // rsync short version
    var rsyncversionshort: String?
    // filsize logfile warning
    let logfilesize: Int = 100_000
    // Mac serialnumer
    var macserialnumber: String?
    // True if menuapp is running
    // var menuappisrunning: Bool = false
    // Reference to the active process
    var process: Process?
    // JSON names
    let filenamelogrecordsjson = "logrecords.json"
    let fileconfigurationsjson = "configurations.json"
    // Object for propogate errors to views
    // var errorobject: AlertError?
    // Used when starting up RsyncUI
    // Default profile
    let defaultprofile = "Testprofile"
}
