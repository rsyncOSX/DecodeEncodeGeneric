import Foundation
import Testing

@testable import DecodeEncodeGeneric

@Suite final class TestDecodeEncode {
    var testconfigurations = [TestSynchronizeConfiguration]()
    var testuserconfiguration: TestUserConfiguration?

    let urlJSONuiconfig: String = "https://raw.githubusercontent.com/rsyncOSX/RsyncArguments/master/Testdata/rsyncuiconfig.json"
    let urlJSON: String = "https://raw.githubusercontent.com/rsyncOSX/RsyncArguments/master/Testdata/configurations.json"

    @Test func getdata() async {
        let testdata = await DecodeGeneric()
        // Load user configuration
        do {
            if let userconfig = try await
                testdata.decodestringdata(DecodeTestUserConfiguration.self, fromwhere: urlJSONuiconfig)
            {
                testuserconfiguration = await TestUserConfiguration(userconfig)
                print("getdata: loading userconfiguration COMPLETED\n)")
                await encodeuserconfiguration()
            }

        } catch {
            print("TestDecode: loading userconfiguration FAILED\n)")
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
                print("getdata: loading configuration COMPLETED\n)")
                await encodconfigurations()
            }
        } catch {
            print("TestDecode: loading configuration FAILED\n)")
        }
    }

    func encodeuserconfiguration() async {
        let testdata = await EncodeGeneric()
        // Load user configuration
        do {
            if let encodeddata = try await testdata.encodedata(data: testuserconfiguration) {
                print("encodeuserconfiguration: got encodeddata\n")
                
                if let printedString = String(data: encodeddata, encoding: .utf8) {
                    print(printedString)
                }
                
            }

        } catch {
            print("encodeuserconfiguration: encoding userconfiguration FAILED\n")
        }
    }

    func encodconfigurations() async {
        let testdata = await EncodeGeneric()
        // Load user configuration
        do {
            if let encodeddata = try await testdata.encodedata(data: testconfigurations) {
                print("encodconfigurations: got encodeddata\n")
                if let printedString = String(data: encodeddata, encoding: .utf8) {
                    print(printedString)
                }
            }

        } catch {
            print("encodconfigurations: encoding userconfiguration FAILED\n")
        }
    }
}

extension URLSession {
    func getURLdata(for url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url)
    }
}
