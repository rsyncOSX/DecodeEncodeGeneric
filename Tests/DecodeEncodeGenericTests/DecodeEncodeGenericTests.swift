import Testing
import Foundation

@testable import DecodeEncodeGeneric

@Suite final class TestDecodeEncode {
    var testconfigurations = [TestSynchronizeConfiguration]()
    var testuserconfiguration: TestUserConfiguration?
    
    let urlJSONuiconfig: String = "https://raw.githubusercontent.com/rsyncOSX/RsyncArguments/master/Testdata/rsyncuiconfig.json"
    let urlJSON: String = "https://raw.githubusercontent.com/rsyncOSX/RsyncArguments/master/Testdata/configurations.json"
    
    
    @Test func getdata() async {
        let testdata = DecodeGeneric()
        // Load user configuration
        do {
            if let userconfig = try await
                testdata.decodestringdata(DecodeTestUserConfiguration.self, fromwhere: urlJSONuiconfig) {
                testuserconfiguration = await TestUserConfiguration(userconfig)
                print("getdata: loading userconfiguration COMPLETED)")
                await encodedata(data: testconfigurations)
            }
            
        } catch {
            print("TestDecode: loading userconfiguration FAILED)")
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
                print("TestDecode: loading data COMPLETED)")
            }
        } catch {
            print("TestDecode: loading data FAILED)")
        }
    }
    
    func encodedata<T: Codable>(data: T) async {
        let testdata = EncodeGeneric()
        // Load user configuration
        do {
            if let encodeddata = try await testdata.encodedata(data: testuserconfiguration) {
                print("encodedata: got encodeddata")
                let printedString = String(data: encodeddata, encoding: .utf8)!
                print(printedString)
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
