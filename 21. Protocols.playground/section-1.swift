// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 協定(protocol)為類別、結構或列舉定義一個功能所需要的一組方法及屬性
//
// * 協定可被類別、結構或列舉中的實作所"遵循"，這被稱為"滿足"一個協定
//
// * 正如你應該已經知道的，協定常被使用在代理(delegation)上
//
// * 協定的語法看起來像這樣：
//
//		protocol 協定的名稱
//		{
//          // 這裡是此協定的定義
//		}
//
// * 遵循協定的類別、結構或列舉看起來像這樣：
//
//		struct 結構的名稱: 第一個協定名稱, 另一個協定名稱
//		{
//			// 這裡是此結構的定義
//		}
//
//		class 類別的名稱: 繼承的父類別名稱, 第一個協定名稱, 另一個協定名稱
//		{
//			// 這裡是此類別的定義
//		}
// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// 屬性要求
//
// * 一個協定可以要求遵循它的型別實體提供一個屬性或者是型別屬性
//
// * 協定也可以指定一個屬性必須是唯讀或者是讀寫。如果協定只需要唯讀屬性，那麼遵循此協定的類別可以使用儲存屬性或者
//   是計算屬性。另外，如果需要的話，遵循此協定的類別也被允許增加 setter 方法
//
// * 屬性要求總是使用 'var' 關鍵字來宣告為變數型別
//
// 讓我們一起來看看這個簡單的協定。正如你將見到的，我們只需要定義一個屬性是 'get' 或 'set'，而不需要提供它實際
// 的功能
protocol someProtocolForProperties
{
    // 一個讀/寫屬性
	var mustBeSettable: Int { get set }
	
    // 一個唯讀屬性
	var doesNotNeedToBeSettable: Int { get }
	
    // 使用 'static' 關鍵字來定義一個型別屬性
	static var someTypeProperty: Int { get set }
}

// 讓我們創建一個待會可以真的來遵循的實際協定：
protocol FullyNamed
{
	var fullName: String { get }
}

// 一個遵循 FullyNamed 協定的結構。我們不用特別費心地為了 'fullName' 屬性創建 getter 或 setter 函式，因為
// 默認 Swift 就會滿足這個需求
struct Person: FullyNamed
{
	var fullName: String
}

let john = Person(fullName: "John Smith")

// 讓我們試試另一個更複雜的類別
class Starship: FullyNamed
{
	var prefix: String?
	var name: String
	init(name: String, prefix: String? = nil)
	{
		self.name = name
		self.prefix = prefix
	}
	
	var fullName: String
	{
		return (prefix != .None ? prefix! + " " : "") + name
	}
}

// 在以上的類別中，我們使用 'name' 以及一個可選型別 'prefix' 來代表一個完整的名字，然後提供一個計算屬性來遵循
// 這個 'fullName' 屬性的需求
//
// 這裡是實際使用的狀況：
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
ncc1701.fullName

// ------------------------------------------------------------------------------------------------
// 方法要求
//
// 跟屬性要求類似，協定只有指定方法的型別，而沒有指定方法的實作
//
// 可以使用可變參數，但不能使用有默認值的參數
//
// 方法要求可以被變異 - 只要在函式定義名稱前使用 'mutating' 關鍵字即可。注意，當遵循這個協定的時候，只有類別不
// 需要使用 'mutating' 關鍵字，結構以及列舉都要加上這個關鍵字
//
// 正如屬性要求，型別方法前必須增加 'static' 關鍵字
//
// 這裡是一個簡單的協定，它定義了一個不需要任何傳入參數的 'random' 方法，它會回傳一個 Double 型別
protocol RandomNumberGenerator
{
	func random() -> Double
}

// 讓我們遵循這個協定：
class LinearCongruentialGenerator: RandomNumberGenerator
{
	var lastRandom = 42.0
	var m = 139956.0
	var a = 3877.0
	var c = 29573.0
	func random() -> Double
	{
		lastRandom = ((lastRandom * a + c) % m)
		return lastRandom / m
	}
}
let generator = LinearCongruentialGenerator()
generator.random()
generator.random()
generator.random()

// ------------------------------------------------------------------------------------------------
// 將協定當作型別
//
// 協定也可以被當作型別來處理，這代表它們可以被使用在許多允許使用型別的地方，包含了：
//
// * 當作參數被傳遞進一個函式、方法或建構器
// * 當做一個常數、變數或屬性的型別
// * 當作一個陣列、字典或其他容器中元素的型別
//
// 這兒是一個將協定當作型別使用的例子。我們將創建一個 Dice 類別用來儲存一個型別為 RandomNumberGenerator 的常
// 數屬性，此屬性可被用來自定義擲骰的結果：
class Dice
{
	let sides: Int
	let generator: RandomNumberGenerator
	init(sides: Int, generator: RandomNumberGenerator)
	{
		self.sides = sides
		self.generator = generator
	}
	
	func roll() -> Int
	{
		return Int(generator.random() * Double(sides)) + 1
	}
}

// 只是為了娛樂一下，讓我們擲擲骰子吧：
let d6 = Dice(sides: 6, generator: generator)
d6.roll()
d6.roll()
d6.roll()
d6.roll()
d6.roll()
d6.roll()

// ------------------------------------------------------------------------------------------------
// 透過擴展來遵循協定
//
// 既存的類別、結構以及列舉可以透過擴展來遵循特定的協定
//
// 讓我們從一個打算拿來實驗的簡單協定開始：
protocol TextRepresentable
{
	func asText() -> String
}

// 我們可以透過擴展 Dice 類別來遵循協定
extension Dice: TextRepresentable
{
	func asText() -> String
	{
		return "A \(sides)-sided dice"
	}
}

// 既存的物件實體(例如 'd6')，將會自動地遵循這個新的協定， 即使這個實體在做擴展前就已經宣告完成了
d6.asText()

// ------------------------------------------------------------------------------------------------
// 使用擴展來宣告欲遵循的協定
//
// 有一些型別已經遵循了協定，但尚未在它們的定義中宣告。型別將不會自動遵循它們必須滿足的協定要求－要遵循的協定必須
// 總是被顯式地宣告出來
//
// 這個情況可以使用空的擴展來解決
//
// 為了展示這個例子，讓我們創建一個滿足了 TextRepresentable 協定的結構，但在宣告結構時，不在結構名稱的後方指定
// 使用此協定：
struct Hamster
{
	var name: String
	func asText() -> String
	{
		return "A hamster named \(name)"
	}
}

// 讓我們確認一下這段程式碼：
let tedTheHamster = Hamster(name: "Ted")
tedTheHamster.asText()

// 我們可以使用空的擴展，增加欲遵循的 TextRepresentable 協定到 Hamster 結構
//
// 這個做法會生效的原因在於我們早已滿足了所有協定的需求。所以我們不需要在擴展的定義中，包含任何多餘的功能
extension Hamster: TextRepresentable
{
	
}

// ------------------------------------------------------------------------------------------------
// 協定型別的集合
//
// Hamsters 以及 Dice 類別並沒有什麼共同點，但在我們先前的範例程式碼中，它們都滿足了 TextRepresentable 協定
// 。因為如此，我們可以創建一個包含一堆滿足了 TextRepresentable 協定的陣列來存放它們：
let textRepresentableThigns: [TextRepresentable] = [d6, tedTheHamster]

// 我們現在可以遍歷陣列中每一個元素並取得它們的文字表述：
for thing in textRepresentableThigns
{
	thing.asText()
}

// ------------------------------------------------------------------------------------------------
// 協定繼承
//
// 協定也可以繼承其他的協定來增加進一步的要求。這個語法近似於類別繼承的語法
//
// 讓我們創建一個繼承自 TextRepresentable 協定的 PrettyTextRepresentable 協定
protocol PrettyTextRepresentable: TextRepresentable
{
	func asPrettyText() -> String
}

// 讓我們把 Dice 類別變得更佳正點
//
// 注意，Dice 類別總是知道它滿足了 TextRepresentable 協定，這表示我們可以在 asPrettyText() 方法中呼叫
// asText() 方法
extension Dice: PrettyTextRepresentable
{
	func asPrettyText() -> String
	{
		return "The pretty version of " + asText()
	}
}

// 我們現在可以測試一下這段程式碼：
d6.asPrettyText()

// ------------------------------------------------------------------------------------------------
// 合成協定
//
// 協定可以被結合在一起使用。舉例來說，一個"人"可以是"上年紀的人"，也可以是"有名字的人"
//
// 合成協定是一種讓實體滿足一組協定的語法宣告方式，它使用這個格式 "protocol<某協定, 另一個協定>"。在角括號之
// 間無論增加多少協定都沒有關係
//
// 讓我們從創建 2 個用來實驗的新協定開始：
protocol Named
{
	var name: String { get }
}
protocol Aged
{
	var age: Int { get }
}

// 這兒，我們宣告一個同時滿足了 Named 以及 Aged 協定的 Individual 結構：
struct Individual: Named, Aged
{
	var name: String
	var age: Int
}

// 在這兒我們可以看到合成協定在 wishHappyBirthday() 函式中發揮了它的作用：
func wishHappyBirthday(celebrator: protocol<Named, Aged>) -> String
{
	return "Happy Birthday \(celebrator.name) - you're \(celebrator.age)!"
}

// 呼叫了這個函式會對 Bill 說生日快樂
wishHappyBirthday(Individual(name: "Bill", age: 31))

// ------------------------------------------------------------------------------------------------
// 協定的一致性(檢查物件是否滿足某協定)
//
// 如同在型別轉換章節中看過的方法，我們也能夠使用 'is' 以及 'as' 兩個關鍵字來測試物件是否滿足某協定
//
// 為了讓這個功能可以使用在協定上，協定必須要被標記為 "@objc" 屬性。此遊樂場下面的程式碼中可以看到這些特別的
// @objc 屬性
//
// 讓我們創建一個有著正確 @objc 前綴的新協定來試試這個功能：
@objc protocol HasArea
{
	var area: Double { get }
}

//class Circle: HasArea
class Circle
{
	let pi = 3.14159
	var radius: Double
	@objc var area: Double { return pi * radius * radius }
	init(radius: Double) { self.radius = radius }
}
class Country: HasArea
{
	@objc var area: Double
	init(area: Double) { self.area = area }
}
class Animal
{
	var legs: Int
	init(legs: Int) { self.legs = legs }
}

// 我們可以使用 AnyObject 陣列來儲存所有的實體物件
let objects: [AnyObject] =
[
	Circle(radius: 3.0),
	Country(area: 4356947.0),
	Animal(legs: 4)
]

// 然後我們可以檢查每一個物件是否滿足了 HasArea 協定：
objects[0] is HasArea
objects[1] is HasArea
objects[2] is HasArea

// ------------------------------------------------------------------------------------------------
// 可選協定要求
//
// 有時候，在協定中宣告一個或多個可選型別可以帶來一些便利性。可以在協定的需求前面加上 'optional' 關鍵字來指定
// 使用這個功能
//
// 所謂的"可選協定"指協定中的要求是可選的，它們的運作方式與先前見過的可選型別相當類似。然而"可選協定"並非儲存一
// 個裡頭可能是 nil 的值，它們使用可選鏈以及可選綁定來決定一個可選的要求是否已經滿足了，如果是，則使用這個要求
//
// 至於協定的一致性，一個使用了可選要求的協定也必須在前方加上 "@objc" 屬性
//
// 關於 "@objc" 屬性的特殊注意事項：
//
// * 為了檢查一個類別實體是否滿足了指定給它的協定，這個協定必須宣告為 @objc 屬性
//
// * 在協定中使用可選要求時也必須使用。為了在協定中使用 'optional' 關鍵字，這個協定必須宣告為 @objc 屬性
//
// * 除此之外，任何一個類別、結構或列舉只要擁有一個滿足了前方有 @objc 屬性協定的實體，那麼這個類別、結構或列舉的
//   前方就必須加上 @objc 屬性
//
// 這裡是一個簡單的，使用了可選要求的協定例子：
@objc protocol CounterDataSource
{
	optional func incrementForCount(count: Int) -> Int
	optional var fixedIncrement: Int { get }
}

// 在下面的例子中，我們將見到如何檢查一個實體是否滿足協定中的特定要求，這跟檢查(或存取)可選型別很像。我們將使用
// 可選鏈來檢查這個可選要求：
@objc class Counter
{
    var count = 0
	var dataSource: CounterDataSource = ThreeSource()
	func increment()
	{
        // dataSource 是否滿足了 incrementForCount 方法要求？
		if let amount = dataSource.incrementForCount?(count)
		{
			count += amount
		}
        // 如果不是，它是否滿足了 fixedIncrement 屬性要求？
		else if let amount = dataSource.fixedIncrement
		{
			count += amount
		}
	}
}

// 建立一個滿足了 CounterDataSource 部份協定的類別 ThreeSource
class ThreeSource: CounterDataSource {
    let fixedIncrement = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()

for _ in 1...3 {
    counter.increment()
}
counter.count
