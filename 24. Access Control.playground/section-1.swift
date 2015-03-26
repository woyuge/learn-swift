// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 存取控制(access control)可以限制開發者在程式碼或模組中存取屬性或方法等成員的權限，這個功能可以讓開發者決
//   定模組中的哪些部份對於外部程式碼來說是可見的
//
// * 在 Swift 中，可以替類別、結構、列舉設定存取控制，也可以替屬性、函式、方法、建構器、基本類型、下標腳本等設
//   定存取控制，協定中的全域變數、常數以及函式也可以使用存取控制
//
// * 如果不是在開發模組(framework)，而是單純地開發獨立的應用程式，開發者完全可以不顯式的去指定程式碼的存取控制
//   層級，因為 Swift 並沒有硬性規定開發者要在程式碼中明確地指定存取層級
// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// 存取層級
//
// Swift 提供了三種不同的存取層級，分別使用 public、internal 以及 private 這三個關鍵字做區分，這三者所規定
// 的處理範圍如下：
//
// public: 公開存取的層級，可以讓跟它被定義的在同模組中的任何程式碼檔案使用，而且也可以讓其他引入了這個模組的程
// 式碼檔案使用。當指定一個模組的介面為公開的時候，通常會將它設為'公開存取'
//
// internal: 內部存取的層級，可以讓跟它被定義的同模組中的任何程式碼檔案使用，但不能被模組外的任何程式碼檔案使用
// 。當定義一個應用程式或是模組內部結構的時候，通常會將它設為'內部存取'
//
// private: 私有存取的層級，將一個實體限制在它被定義的模組程式碼檔案中。使用'私有存取'來隱藏一個特定功能的實作
// 細節
//
// 接下來我們會看一些使用存取控制的語法例子，這些例子在類別、變數或函式的前方，分別加上 public、internal 以及
// private 這三種不同的關鍵字來修飾它們的存取層級：
public class SomePublicClass {}
internal class SomeInternalClass {}
private class SomePrivateClass {}

public var somePublicVariable = 0
internal let someInternalConstant = 0
private func somePrivateFunction() {}

// 如果沒有明確地定義程式碼中實體的存取層級為何，那麼這個實體的存取控制就會被自動設定為 internal 層級，以下兩個
// 表達式都擁有 internal 存取層級：
class AnotherInternalClass {}              // 隱式地指定存取層級為 internal
var AnotherInternalConstant = 0            // 隱式地指定存取層級為 internal

// ------------------------------------------------------------------------------------------------
// 自定義的型別
//
// 你也可以為自定義的型別指定明確的存取層級，只要你確保這個自定義型別的作用範圍匹配你指定給它的存取層級即可。類別
// 的存取層級會影響到類別中成員默認的存取層級，一個指定為 private 的類別，其成員將會擁有 private 的存取控制層
// 級；一個指定為 public 或 internal 的類別，其成員將會擁有 internal 的存取控制層級
//
// 下面的例子是關於類別的存取層級如何影響它的成員：
public class AnotherPublicClass {          // 顯式指定為 public 類別
    public var somePublicProperty = 0      // 顯式指定為 public 類別成員
    var someInternalProperty = 0           // 隱式推斷為 internal 類別成員
    private func somePrivateMethod() {}    // 顯式指定為 private 類別成員
}

class YetAnotherInternalClass {            // 隱式推斷為 internal 類別
    var someInternalProperty = 0           // 隱式推斷為 internal 類別成員
    private func somePrivateMethod() {}    // 顯式指定為 private 類別成員
}

private class AnotherPrivateClass {        // 顯式指定為 private 類別
    var somePrivateProperty = 0            // 隱式推斷為 private 類別成員
    func somePrivateMethod() {}            // 隱式推斷為 private 類別成員
}

// 元組的存取層級不需要顯式地定義，它的存取層級在被使用的時候會被自動推斷出來
// 
// 元組的存取層級遵循它內部成員存取層級中較為嚴格的一方。例如，一個擁有 internal 以及 private 兩種不同存取層
// 級元素的元組，它的存取層級會被自動推斷為 private
//
// 讓我們定義一個擁有不同存取層級元素的元組：
private var privateMsg = "Not Found!"
internal var internalCode = 404
let responseTuple = (internalCode, privateMsg)

// 函式的存取層級是由此函式的傳入參數存取層級以及回傳值的存取層級所推斷出來。如果依據傳入參數以及回傳值所得出的函
// 式存取層級有出入，那麼就要明確地指定此函式的存取層級
//
// 下面這個例子定義了一個尚未指定存取層級的全域函式 someFunction，因為沒有指定任何存取層級，所以看似為 internal
// ，但事實並非如此。下面的程式碼在修改前是無法編譯的，因為 Swift 認為這個函式的存取層級不正確：
//func someFunction() -> (SomeInternalClass, SomePrivateClass) {
//    return (SomeInternalClass(), SomePrivateClass())
//}
//
// 此函式的回傳值型別是元組，前面提過，一個元組的存取層級由內部元素中較嚴格的層級自動推斷而得，因為此元組中兩個元
// 素的存取層級分別為 internal 以及 private(由元素的名稱得知)，所以這個回傳元組的存取層級就會是較為嚴格的
// private。因此，這個函式的存取層級也就會是 private，在原本的函式前方加上 private 關鍵字來顯式地指定存取層級
// 後，即可通過編譯：
private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
    return (SomeInternalClass(), SomePrivateClass())
}

// 列舉中成員的存取層級從列舉定義繼承而來。而列舉中的原始值/相關值的存取層級至少要比列舉定義的存取層級要高，例如
// 你不能在一個 internal 的列舉中，定義一個 private 層級的原始值。下面這個例子中，所有列舉成員都擁有跟列舉一
// 樣的存取層級 public：
public enum CompassPoint {
    case North
    case South
    case East
    case West
}

// 以巢狀結構型別而言，定義在 private 型別中的巢狀結構型別，會自動擁有 private 層級，定義在 public/internal
// 型別中的巢狀結構型別，會自動擁有 internal 層級。如果想讓一個在 public 型別中的巢狀結構型別擁有 public 層級
// ，那麼必須顯式地加上 public 關鍵字，例如下面這個例子：
public struct PublicStruct {
    public struct AnotherPublicStruct {
        public struct YetAnotherPublicStruct {}
    }
}

// ------------------------------------------------------------------------------------------------
// 子類別
//
// 子類別的存取層級不可以高於所繼承的父類別。例如，一個繼承了 internal 層級類別的子類別，其層級就不可以是 public
// 。在不違背這個規則的前提下，開發者可以任意覆寫內部成員為不同的層級
//
// 如果無法直接存取某個類別成員，可以繼承該類別以獲得存取其中成員的權限。例如以下這個例子中，類別 A 的存取層級是
// public，它擁有一個存取層級為 private 的方法 someMethod。類別 B 繼承了類別 A 後，將 someMethod 這個方法
// 的存取層級覆寫為 internal：
public class A {
    private func someMethod() {}
}

internal class B: A {
    override internal func someMethod() {}
}

// 只要滿足子類別的存取層級不高於父類別的存取層級這個規定，你甚至可以在子類別中，存取父類別中的 private 成員：
internal class AnotherB: A {
    override internal func someMethod() {
        super.someMethod()
    }
}

// ------------------------------------------------------------------------------------------------
// 常數、變數、屬性以及下標腳本
//
// 常數、變數、屬性不可以擁有比它們的型別更高的存取層級。例如，Swift 的編譯器不允許你將一個 public 層級的屬性指
// 定為 private 層級的型別，下標腳本也不能擁有比它的索引型別或返回型別更高的存取層級，例如下面這段程式碼是無法編
// 譯的：
//public class SomeClass {
//    public var publicInstance = SomePrivateClass()
//}

// 如果一個常數、變數、屬性或下標腳本的存取層級為 private，那麼宣告它們的時候必須顯式地指定為 private：
private var privateInstance = SomePrivateClass()

// 常數、變數、屬性以及下標腳本的 getter 與 setter 方法的存取層級，繼承自它們所屬成員的存取層級。Setter 的存取
// 層級可以低於相應的 getter，以控制變數、屬性或下標腳本的讀寫權限。你可以在 var 或 subscript 關鍵字之前，使用
// private(set) 和 internal(set) 這個語法來指定較低的存取層級
//
// 下面這個例子定義了一個名為 TrackedString 的結構，它可以用來計算 value 屬性被修改的次數。這個結構被隱式地推斷
// 為 internal 層級，因此它內部的成員也是 internal 層級。但這裡使用 private(set) 關鍵字來顯式地指定這個用來記
// 錄被修改次數的屬性，其存取只能由同結構的內部成員做修改。因為此屬性默認的 getter 未被修改，所以 getter 的層級會
// 被隱式地推斷為 internal，因此對於內部成員而言，這個屬性是讀/寫，但對非此結構的外部程式碼來說，這個屬性是唯讀：
struct TrackedString {
    private(set) var numberOfEdits = 0
    var value: String = "" {
        didSet {
            numberOfEdits++
        }
    }
}

// 將這個結構實體化，並且修改實體中 value 的值，就會看到 numberOfEdits 屬性的值不斷增加：
var stringToEdit = TrackedString()
stringToEdit.value = "This string will be tracked."
stringToEdit.value += " This edit will increment numberOfEdits."
stringToEdit.value += " So will this one."
"The number of edits is \(stringToEdit.numberOfEdits)"

// ------------------------------------------------------------------------------------------------
// 建構器
//
// 我們也可以替自定義的建構器指定存取層級，但是不可以高於它所屬類別的存取層級，如果此建構器是必須被使用的(例如唯一的
// 建構器)，那麼此建構器的層級必須跟所屬類別的存取層級相同
//
// 如同函式或方法的參數，建構器的參數也不能低於此建構器的存取層級
//
// Swift 替類別與結構都提供了一個默認的建構器，默認建構器的存取層級與所屬型別的存取層級相同，但前面提過，一個 public
// 層級的類別，其內部成員的默認層級為 internal，因此如果你想要一個 public 層級的建構器，必須自行宣告一個不需要傳入
// 參數的 puclic 層級建構器，例如下面這段程式碼中的做法：
public class PublicClass {
    public init() {}
}

// 如果結構中任一儲存屬性的存取層級為 private，那麼此結構默認的針對個別成員的建構器，其層級就是 private。否則，建
// 構器的存取層級會是 internal。如果開發者希望在其他模組中，使用這個結構的針對個別成員的建構器，那麼必須自行在此結
// 構中提供一個層級為 public 的針對個別成員的建構器，例如以下這個例子：
public struct SomePublicStruct {
    private var privateMember = 0
    internal var internalMember = 0
    public var publicMember = 0
    public init(priv: Int, inte: Int, publ: Int) {
        self.privateMember = priv
        self.internalMember = inte
        self.publicMember = publ
    }
}

// ------------------------------------------------------------------------------------------------
// 協定
//
// 如果你想顯式地指定一個協定的存取層級，必須在定義此協定的時候指定。這個規定可以確保你創建了一個只能在確知的存取層
// 級中被遵循的協定
//
// 在協定定義中的每個存取層級，都會自動地被設定為跟所屬協定的層級相同。你不能將協定中的要求設定為跟協定本身不同的存
// 取層級。這個規定確保了協定中的所有要求都能被打算遵循此協定的程式碼所存取
//
// 協定繼承
// 如果從既有的協定中繼承了一個新的協定，這個新協定最高的存取層級就跟它所繼承協定的存取層級相同。例如，你無法宣告一
// 個存取層級為 public 的協定，而去繼承一個存取層級為 internal 的協定
//
// 協定的一致性
// 一個型別可以滿足一個比自身存取層級更低的協定要求。例如，你可以定義一個能被其他模組所使用的 public 層級型別，但
// 它也滿足了一個只能在被定義的模組中使用的 internal 層級協定
//
// 一個型別的存取層級，會被它所滿足協定中的最低存取層級所限制。如果一個型別是 public 層級，但它滿足的協定層級是 
// internal，那麼此型別滿足的協定層級也是 internal
//
// 當你讓一個型別滿足某個協定的要求時，你必須確保這個型別針對每個協定要求的實作部份，其層級至少要跟所遵循協定的存取
// 層級相同。例如一個滿足了 internal 層級協定的 public 層級型別，在此型別中滿足協定要求的的實作部份，至少要宣告
// 為 internel 層級
//
// 下面的例子中有一個顯式宣告為 private 層級的協定，一個隱式推斷為 internal 層級的協定，以及另一個同時滿足這兩
// 個協定，隱式推斷為 internal 層級的類別。在此結構中用來遵循協定要求的實作層級，也要跟所遵循的協定相同：
private protocol PrivateProtocol {
    var varInPrivateProtocol: Int { get }
}

protocol InternalProtocol {
    var varInInternalProtocol: Int { get }
}

class AlsoInternalClass: PrivateProtocol, InternalProtocol {
    private var varInPrivateProtocol: Int
    internal var varInInternalProtocol: Int
    init( priv: Int, inte: Int) {
        self.varInPrivateProtocol = priv
        self.varInInternalProtocol = inte
    }
}

// ------------------------------------------------------------------------------------------------
// 擴展
//
// 對類別、結構以及列舉做的擴展，會跟所擴展的對象擁有相同的存取層級，例如你擴展了一個 public 層級的型別，那麼任何
// 對此型別的擴展都會擁有默認的 internal 層級
//
// 除此之外，你可以顯式地宣告一個擴展的存取層級(例如 private extension)，以此讓所有在此擴展中的成員都擁有相同的
// 默認存取層級。這個默認的存取層級可被個別成員所指定的存取層級覆寫
//
// 透過擴展來遵循協定
// 如果你正使用一個擴展來遵循某個協定，那麼你不可以顯式地指定存取層級給這個擴展。取而代之的是，這個協定本身的存取層
// 級將變成默認的存取層級，指定給擴展中每個滿足協定要求的實作

// ------------------------------------------------------------------------------------------------
// 泛型
//
// 泛型型別或泛型函式的存取層級由泛型型別或泛型函式本身與泛型的型別約束參數三者中最低的那個層級來決定

// ------------------------------------------------------------------------------------------------
// 型別別名
//
// 任何自定義的型別別名都會被視為不同的型別來做存取控制。一個型別的型別別名不能擁有高於此型別的存取層級。例如，一個
// 存取層級為 private 的型別，可以宣告為存取層級為 private、internal 或者是 public 的型別別名，但是一個擁有存
// 取層級為 public 的型別，不能宣告為存取層級為 internal 或者是 private 的型別別名
//
// 例如以下這個例子，先宣告一個 Double 的型別別名出來，因為沒有指定，所以被隱式地推斷為 internal 層級
typealias InternalDouble = Double

// 可以型別別名為相等或更低的存取層級
internal typealias AnotherInternalDouble = InternalDouble
private typealias PrivateDouble = InternalDouble

// 不可以宣告為更高的存取層級，此行無法編譯
//public typealias PublicDouble = InternalDouble



