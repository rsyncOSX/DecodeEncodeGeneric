import Testing
@testable import DecodeEncodeGeneric

@available(macOS 14.0, *)
@Test func example() async throws {
    var testconfigurations = [TestSynchronizeConfiguration]()
    let urlJSONuiconfig: String = "https://raw.githubusercontent.com/rsyncOSX/RsyncArguments/master/Testdata/rsyncuiconfig.json"
    let urlJSON: String = "https://raw.githubusercontent.com/rsyncOSX/RsyncArguments/master/Testdata/configurations.json"
    
    func getdata() async {
        let testdata = DecodeGeneric()
        // Load user configuration
        do {
            if let userconfig = try await
                testdata.decodestringdata(DecodeTestUserConfiguration.self, fromwhere: urlJSONuiconfig) {
                await TestUserConfiguration(userconfig)
                print("ReadTestdataFromGitHub: loading userconfiguration COMPLETED)")
            }
            
        } catch {
            print("ReadTestdataFromGitHub: loading userconfiguration FAILED)")
        }
        // Load data
        do {
            if let testdata = try await testdata.decodearraydata(DecodeTestdata.self, fromwhere: urlJSON) {
                testconfigurations.removeAll()
                for i in 0 ..< testdata.count {
                    var configuration = TestSynchronizeConfiguration(testdata[i])
                    configuration.profile = "test"
                    testconfigurations.append(configuration)
                }
                print("ReadTestdataFromGitHub: loading data COMPLETED)")
            }
        } catch {
            print("ReadTestdataFromGitHub: loading data FAILED)")
        }
    }
}
