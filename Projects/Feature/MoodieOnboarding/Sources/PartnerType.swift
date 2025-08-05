import Foundation

enum PartnerType: String, CaseIterable {
    case boyfriend
    case girlfriend
    
    var name: String {
        switch self {
        case .boyfriend:
            return "남자친구"
        case .girlfriend:
            return "여자친구"
        }
    }
    
    var imageName: String {
        switch self {
        case .boyfriend:
            return "남자친구 이미지"
        case .girlfriend:
            return "여자친구 이미지"
        }
    }
}

extension PartnerType {
    struct CheckItem: Identifiable, Hashable, Sendable {
        let id: String
        let type: PartnerType
        var isChecked: Bool
        
        public init(
            id: String = UUID().uuidString,
            type: PartnerType,
            isChecked: Bool = false
        ) {
            self.id = id
            self.type = type
            self.isChecked = isChecked
        }
    }
}
