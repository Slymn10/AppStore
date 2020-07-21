import Foundation

class GetDate: ObservableObject {
    @Published var today = Date().getToday()
}
extension Date{
     func getToday() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM EEEE"
        return formatter.string(from: self)
    }
}

