import Foundation

let displayFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()

extension Int {

    var formattedForDisplay: String {
        displayFormatter.string(from: self as NSNumber) ?? ""
    }

}
