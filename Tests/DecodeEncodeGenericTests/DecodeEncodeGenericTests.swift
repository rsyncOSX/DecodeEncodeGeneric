import Foundation
import Testing

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
            let userconfig: DecodeTestUserConfiguration = try
                await testdata.decode(DecodeTestUserConfiguration.self, fromURL: urlJSONuiconfig)
            testuserconfiguration = await TestUserConfiguration(userconfig)
            print("getdata: loading userconfiguration COMPLETED\n")
            await encodeuserconfiguration()

        } catch {
            print("TestDecode: loading userconfiguration FAILED\n")
        }
        // Load data
        do {
            let testdata: [DecodeTestdata] = try await testdata.decode([DecodeTestdata].self, fromURL: urlJSON)
            testconfigurations.removeAll()
            for i in 0 ..< testdata.count {
                var configuration = TestSynchronizeConfiguration(testdata[i])
                configuration.profile = "test"
                testconfigurations.append(configuration)
            }
            print("getdata: loading configuration COMPLETED\n")
            await encodconfigurations()

        } catch {
            print("TestDecode: loading configuration FAILED\n")
        }
    }

    func encodeuserconfiguration() async {
        let testdata = EncodeGeneric()
        // Load user configuration
        do {
            let encodeddata = try testdata.encode(testuserconfiguration)
            print("encodeuserconfiguration: got encodeddata\n")

            if let printedString = String(data: encodeddata, encoding: .utf8) {
                print(printedString)
            }
        } catch {
            print("encodeuserconfiguration: encoding userconfiguration FAILED\n")
        }
    }

    func encodconfigurations() async {
        let testdata = EncodeGeneric()
        // Load user configuration
        do {
            let encodeddata = try testdata.encode(testconfigurations)
            print("encodconfigurations: got encodeddata\n")
            if let printedString = String(data: encodeddata, encoding: .utf8) {
                print(printedString)
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
