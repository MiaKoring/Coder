import Foundation
class UserDefaultHandler{
    public static func setup(){
        if UserDefaults.standard.double(forKey: "fontSize") == 0.0{
            UserDefaults.standard.set(14.0, forKey: "fontSize")
        }
    }
    
    public static func getFontSize()->Double{
        return UserDefaults.standard.double(forKey: "fontSize")
    }
    
    private static func setFontSize(_ value: Double)->Double{
        UserDefaults.standard.set(value, forKey: "fontSize")
        return value
    }
    
    public static func changeFontSize(_ direction: FontSizeDirection)-> Double{
        let current = getFontSize()
        switch direction{
        case .bigger:
            return setFontSize(current < 30 ? current+1 : current)
        case .smaller:
            return setFontSize(current > 8 ? current-1 : current)
        }
    }
    
}

enum FontSizeDirection{
    case bigger
    case smaller
}
