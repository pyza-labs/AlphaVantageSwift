import Foundation

public final class AVProvider {

    enum KeyNames: String {
        case apiKey
    }

    public static func setup(with apiKey: String) {
        UserDefaults.standard.set(apiKey, forKey: KeyNames.apiKey.rawValue)
    }

    static func currentApiKey() throws -> String {
        guard let currentAPIKey = UserDefaults.standard.string(forKey: KeyNames.apiKey.rawValue) else { throw AVError.missingApiKey }
        return currentAPIKey
    }
}
