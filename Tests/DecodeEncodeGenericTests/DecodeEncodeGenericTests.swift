import Testing
import Foundation

@testable import DecodeEncodeGeneric

@Suite final class TestDecode {
    var testconfigurations = [TestSynchronizeConfiguration]()
    let urlJSONuiconfig: String = "https://raw.githubusercontent.com/rsyncOSX/RsyncArguments/master/Testdata/rsyncuiconfig.json"
    let urlJSON: String = "https://raw.githubusercontent.com/rsyncOSX/RsyncArguments/master/Testdata/configurations.json"
    
    
    @Test func getdata() async {
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

@Suite final class TestEncode {
    let urlJSONuiconfig: String = "https://raw.githubusercontent.com/rsyncOSX/RsyncArguments/master/Testdata/rsyncuiconfig.json"
    // let urlJSON: String = "https://raw.githubusercontent.com/rsyncOSX/RsyncArguments/master/Testdata/configurations.json"
    let urlSession = URLSession.shared
    
    @Test func testdata() async {
        let testdata = EncodeGeneric()
        // Load user configuration
        do {
            if let url = URL(string: urlJSONuiconfig) {
                let (data, _) = try await urlSession.getURLdata(for: url)
                print("got data")
                if let encodedata = try await testdata.encodedata(DecodeTestUserConfiguration.self, data: data) {
                    print("got encodedata")
                    print(encodedata)
                }
            }
            
        } catch {
            print("ReadTestdataFromGitHub: loading userconfiguration FAILED)")
        }
    }
}

extension URLSession {
    func getURLdata(for url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url)
    }
}
