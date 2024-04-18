import Foundation
final class UserDefaultHandler{
    public static func setup(){
        if UserDefaults.standard.double(forKey: "fontSize") == 0.0{
            UserDefaults.standard.set(14.0, forKey: "fontSize")
        }
        if UserDefaults.standard.string(forKey: "language") == nil{
            UserDefaults.standard.set("system", forKey: "language")
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
    
    public static func setLanguage(_ lang: Language) -> Language{
        UserDefaults.standard.set(lang.rawValue, forKey: "language")
        return lang
    }
    
    public static func getLanguage() -> Language{
        let result = UserDefaults.standard.string(forKey: "language")
        if result == nil{
            setup()
            return .system
        }
        return Language(rawValue: result!) ?? .system
    }
    
}
