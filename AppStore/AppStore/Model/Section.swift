import Foundation
struct Section: Decodable,Identifiable {
    let id: Int
    let type: String
    let title: String
    let subtitle: String
    let items: [App]
}
