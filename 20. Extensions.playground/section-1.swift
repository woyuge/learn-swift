// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 類似於 Objective-C 中的分類(categories)，擴展(extension)允許你為已有的型別(類別、結構、列舉)，增加新的
//   功能
//
// * 你不需要修改原本的程式碼就可以擴展一個型別
//
// * 擴展也可以使用在內建的型別上，包含 String、Int、Double 等等
//
// * 擴展可以讓你：
//
//   o 增加計算屬性(包含靜態屬性)
//   o 定義實體方法以及型別方法
//   o 提供新的便利建構器
//   o 定義下標腳本
//   o 定義且使用新的巢狀結構型別
//   o 讓既存的型別符合某個協定
//
// * 擴展並不支援替一個型別增加儲存屬性或屬性監視器
//
// * 擴展會套用在所擴展型別的每一個實體上，即使這個實體是在擴展前就宣告完成的
// ------------------------------------------------------------------------------------------------

// 讓我們看看擴展是如何宣告的。注意，不像 Objective-C 的分類，擴展是沒有名稱的：
extension Int
{
	// ... 表達式
}

// ------------------------------------------------------------------------------------------------
// 計算屬性
//
// 計算屬性是擴展最能發揮它強大功能的地方。下面，我們為 Double 型別增加各種(Km, mm, feet, 等等)不同的原生的轉
// 換支援
extension Double
{
	var kmToMeters: Double { return self * 1_000.0 }
	var cmToMeters: Double { return self / 100.0 }
	var mmToMeters: Double { return self / 1_000.0 }
	var inchToMeters: Double { return self / 39.3701 }
	var ftToMeters: Double { return self / 3.28084 }
}

// 我們可以呼叫 Double 型別的新計算屬性來將 inch 轉換為 meter
let oneInchInMeters = 1.inchToMeters

// 同樣的，我們可以將 3 feet 轉換到 meter
let threeFeetInMeters = 3.ftToMeters

// ------------------------------------------------------------------------------------------------
// 建構器
//
// 可以用擴展來替類別增加新的便利建構器，但不能用來增加新的指定建構器
//
// 讓我們看看實際應用的情況：
struct Size
{
	var width = 0.0
	var height = 0.0
}
struct Point
{
	var x = 0.0
	var y = 0.0
}
struct Rect
{
	var origin = Point()
	var size = Size()
}

// 因為我們沒有主動提供任何建構器，所以可以使用 Swift 默認的針對個別成員的建構器來替 Rect 結構初始化
var memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))

// 讓我們擴展 Rect 結構，為它新增一個新的便利建構器。注意，我們依然必須確保整個實體的屬性都被初始化完成
extension Rect
{
	init (center: Point, size: Size)
	{
		let originX = center.x - (size.width / 2)
		let originY = center.y - (size.height / 2)
		self.init(origin: Point(x: originX, y: originY), size: size)
	}
}

// 讓我們試試看這個新的便利建構器：
let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))

// 請記住，如果一個類別擁有任何自定義的建構器，Swift 將不會提供默認的針對個別成員的建構器。然而，因為我們是透
// 過擴展來增加一個建構器，因此依然可以使用 Swift 為我們提供的針對個別成員的建構器
var anotherRect = Rect(origin: Point(x: 1.0, y: 1.0), size: Size(width: 3.0, height: 2.0))

// ------------------------------------------------------------------------------------------------
// 方法
//
// 正如你所期望的，我們也可以新增方法到既有的型別。這裡是一個絕妙的小擴展，它可以多次地重複一個任務(閉包)，而重
// 複的次數就等於此 Int 型別中的儲存值
//
// 注意，可藉由 'self' 關鍵字來存取 Int 型別中的儲存值
extension Int
{
	func repititions(task: () -> ())
	{
		for i in 0..<self
		{
			task()
		}
	}
}

// 讓我們使用簡化語法來呼叫此 Int 型別中的尾隨閉包：
3.repititions { println("hello") }

// 實體方法可以變異為修改實體本身
//
// 注意，使用了 'mutating' 關鍵字
extension Int
{
	mutating func square()
	{
		self = self * self
	}
}

var someInt = 3
someInt.square() // someInt 現在的值是 9

// ------------------------------------------------------------------------------------------------
// 下標腳本
//
// 讓我們替 Int 型別增加一個下標腳本：
extension Int
{
	subscript(digitIndex: Int) -> Int
	{
		var decimalBase = 1
		for _ in 0 ..< digitIndex
		{
			decimalBase *= 10
		}
		return self / decimalBase % 10
	}
}

// 並且我們可以直接呼叫這個 Int 型別的下標腳本，包括直接使用數字型態的 Int
123456789[0]
123456789[1]
123456789[2]
123456789[3]
123456789[4]
123456789[5]
123456789[6]

// ------------------------------------------------------------------------------------------------
// 巢狀結構型別
//
// 我們也可以替既有的型別增加一個巢狀結構型別的擴展
extension Character
{
	enum Kind
	{
		case Vowel, Consonant, Other
	}
	var kind: Kind
	{
		switch String(self)
		{
			case "a", "e", "i", "o", "u":
				return .Vowel
			case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
			     "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
				return .Consonant
			default:
				return .Other
		}
	}
}

// 讓我們測試一下這個裡頭有巢狀結構型別的擴展：
Character("a").kind == .Vowel
Character("h").kind == .Consonant
Character("+").kind == .Other
