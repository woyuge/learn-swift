// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 泛型(generic)可以根據你定義的限制，寫出可用於任何型別上的靈活的、可重複使用的函式以及型別
//
// * Swift 的陣列以及字典都是泛型
//
// * 泛型可以使用在函式、結構、類別以及列舉上
// ------------------------------------------------------------------------------------------------

// 泛型能解決的問題
//
// 考慮以下這個能交換兩個整數的函式
func swapTwoInts(inout a: Int, inout b: Int)
{
	let tmp = a
	a = b
	b = tmp
}

// 如果我們想要交換字串呢？或者是任意其他型別？我們需要寫出很多不同的交換函式才行。相較這個做法，讓我們使用泛型。考慮
// 以下這個泛型函式：
func swapTwoValues<T>(inout a: T, inout b: T)
{
	let tmp = a
	a = b
	b = tmp
}

// 這個 'swapTwoValues()' 就是泛型函式，這代表在某種意義上，它所使用的部份的或是所有的型別都是泛型(也就是說，具體
// 而言指的是這個函式的傳入參數)
//
// 仔細看看函式的第一行就能發現，我們使用了 <T>，傳入參數 'a' 與 'b' 的型別也是 T。在這個情況下，T 只是表達一個佔
// 位符型別，而且透過這個函式，我們可以瞭解 'a' 與 'b' 的型別是相同的
//
// 如果我們使用兩個傳入的整數型別來呼叫這個函式，它將把這個函式視為接受兩個整數，但如果我們傳入兩個字串，它也可以作用
// 在字串上
//
// 如果我們好好看看這個函式的實作部份，我們將會發現它被設計為能使用任何型別的傳入參數：裡頭的 'tmp' 變數型別是透過傳
// 入參數 'a' 來自動推斷，而 'a' 與 'b' 這兩個參數必須是可賦值的(assignable)。如果以上任一個條件不滿足，那就會在
// 嘗試呼叫不符合這些條件的型別時，發生編譯錯誤
//
// 雖然我們正在使用 T 當作我們的佔位符型別，我們可以使用我們想要的任意名稱，即便 T 在單一型別的列表中，是一個常見的
// 佔位符。如果我們創建了一個新字典類別的實作，我們可能會想使用兩個參數，並且有效地命名它們，例如
// <KeyType, ValueType>
//
// 一個佔位符型別也可以用來定義回傳值的型別
//
// 讓我們呼叫這個函式幾次，來看看它實際執行的結果：
var aInt = 3
var bInt = 4
swapTwoValues(&aInt, &bInt)
aInt
bInt

var aDouble = 3.3
var bDouble = 4.4
swapTwoValues(&aDouble, &bDouble)
aDouble
bDouble

var aString = "three"
var bString = "four"
swapTwoValues(&aString, &bString)
aString
bString

// ------------------------------------------------------------------------------------------------
// 泛型型別
//
// 目前為止我們看到了如何在函式上使用泛型，讓我們看看要如何使用在結構上。我們可以定義一個標準的 'stack' 實作，它
// 運作的方式就像是陣列，可以增加(push)一個元素到陣列後方，或者是從陣列後方取出(pop)一個元素
//
// 如同你所見到的，當宣告一個結構的時候，佔位符型別可以代表在結構中的任意型別。在下方的程式碼中，佔位符型別被使用在
// 屬性的型別、方法中的輸入參數型別以及方法的回傳值型別
struct Stack<T>
{
	var items = [T]()
	mutating func push(item: T)
	{
		items.append(item)
	}
	mutating func pop() -> T
	{
		return items.removeLast()
	}
}

// 讓我們使用看看我們的新堆疊：
var stackOfStrings = Stack<String>()

stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")

stackOfStrings.pop()
stackOfStrings.pop()
stackOfStrings.pop()
stackOfStrings.pop()

// ------------------------------------------------------------------------------------------------
// 型別約束
//
// 目前為止，我們的型別參數都是泛型－它們可以代表任何給予的型別。有時候我們會想要在這些型別上加上一些約束。例如，Swift
// 的字典型別使用了泛型，並且為鍵值的型別加上了必須要可雜湊(hashable)的約束(也就是說，它必須滿足定義在 Swift 的標準
// 函式庫中的雜湊協定)
//
// 使用下列的語法來定義約束：
func doSomethingWithKeyValue<KeyType: Hashable, ValueType>(someKey: KeyType, someValue: ValueType)
{
    // 我們的 KeyType 必須要可雜湊，所以我們可以使用在協定中定義好的 hashValue 屬性：
	someKey.hashValue
	
    // 'someValue' 對我們來說是個未知型別的變數，我們將它擺在這裡，以便當它一被任何人使用的時候，我們就能看到它的值
	someValue
}

// 讓我們看看型別約束的實際運作情況。我們將創建一個函式，它可以依據給予的值找出在給予的陣列中相應的索引，因為不一定陣列
// 中有這個值，所以這個索引值會做為可選型別回傳
//
// 留意我們對型別 T 所做的"可比較是否相等"(Equatable)約束，這是讓函式可以編譯的關鍵，少了它，我們將會在使用條件判斷
// 語句來比較陣列中元素值的地方，得到一個編譯錯誤。藉著引入 Equatable 的約束，我們告訴這個泛型函式，它必須保證接收的
// 值都要滿足這個特定的條件
func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int?
{
	for (index, value) in enumerate(array)
	{
		if value == valueToFind
		{
			return index
		}
	}
	return nil
}

// 讓我們試試幾種不同的輸入
let doubleIndex = findIndex([3.14159, 0.1, 0.25], 9.3)
let stringIndex = findIndex(["Mike", "Malcolm", "Andrea"], "Andrea")

// ------------------------------------------------------------------------------------------------
// 關聯型別
//
// 協定使用不同的方法來定義泛型型別，這稱呼為關聯型別，它結合了型別自動推斷以及型別別名
//
// 讓我們直接跳到程式碼：
protocol Container
{
	typealias ItemType
	mutating func append(item: ItemType)
	var count: Int { get }
	subscript(i: Int) -> ItemType { get }
}

// 在上面的例子中，我們宣告了一個叫做 ItemType 的型別別名，但因為我們宣告的是協定，我們只需要宣告這個協定的要求
// 即可，使用這個協定的類別、結構或列舉必須提供實際的型別
//
// 使用泛型後，ItemType 的型別可以被自動推斷，它為 append() 方法以及下標腳本的實作提供了正確的型別
//
// 讓我們看看這個實際運作的情況，這個堆疊已經被轉化為一個容器了：

struct StackContainer<T> : Container
{
    // 在這兒我們使用原本實作堆疊的程式碼，完全沒有修改
	
	var items = [T]()
	mutating func push(item: T)
	{
		items.append(item)
	}
	mutating func pop() -> T
	{
		return items.removeLast()
	}
	
    // 以下這段實作是為了滿足協定的要求
	
	mutating func append(item: T)
	{
		self.push(item)
	}
	var count: Int
	{
		return items.count
	}
	subscript(i: Int) -> T
	{
		return items[i]
	}
}

// 這個新的 StackContainer 已經準備好可以使用了。你或許會注意到它並不包含在 Container 協定中所指定的 typealias
// 。這是因為所有應該使用 ItemType 的地方，都已經被 T 所代替。這允許 Swift 得以自動地做向後型別推斷來得知 ItemType
// 的型別就是 T，順道滿足了這個協定的要求
//
// 讓我們檢查一下結果：
var stringStack = StackContainer<String>()
stringStack.push("Albert")
stringStack.push("Andrew")
stringStack.push("Betty")
stringStack.push("Jacob")
stringStack.pop()
stringStack.count

var doubleStack = StackContainer<Double>()
doubleStack.push(3.14159)
doubleStack.push(42.0)
doubleStack.push(1_000_000)
doubleStack.pop()
doubleStack.count

// 我們也可以將既存的型別做擴展，來滿足新的泛型協定。原來 Swift 內建的陣列類別就已經滿足了我們這個 Container 協
// 定的要求
//
// 因為協定使用型別推斷的方法來實作泛型，所以我們不需要修改字串類別，就可以將字串型別擴展為滿足協定：
extension Array: Container {}

// ------------------------------------------------------------------------------------------------
// Where 語句
//
// 我們可以透過 where 語句來進一步擴展我們對型別的約束。where 語句提供了一個對所關聯型別，以及(或)一個或多個型別
// 和關聯型別之間的對等關係

// 讓我們看看 where 語句實際運作的狀況。我們將定義一個函式，它使用兩個不同的 container，每個 container 裡頭都
// 要存放相同型別的元素
func allItemsMatch
	<C1: Container, C2: Container where C1.ItemType == C2.ItemType, C1.ItemType: Equatable>
	(someContainer: C1, anotherContainer: C2) -> Bool
{
    // 檢查是否兩個 container 包含了相同數目的元素
	if someContainer.count != anotherContainer.count
	{
		return false
	}
	
    // 檢查每一對元素，看看它們是否相等
	for i in 0..<someContainer.count
	{
		if someContainer[i] != anotherContainer[i]
		{
			return false
		}
	}
	
    // 所有的元素都相同，回傳 true
	return true
}

// 這個函式在參數列表的可使用型別上，設定了以下的限制：
//
// * C1 必須滿足 Container 協定 (C1: Container)
// * C2 也必須滿足 Container 協定 (C2: Container)
// * C1 的 ItemType 必須跟 C2 的 ItemType 相同 (C1.ItemType == C2.ItemType)
// * C1 的 ItemType 必須滿足 Equatable 協定 (C1.ItemType: Equatable)
//
// 注意，我們只需要指定 C1.ItemType 滿足 Equatable 協定，因為程式碼只使用了 != (Equatable 協定的一部份)
// 運算子來比較 someContainer，也就是 C1 的型別
//
// 讓我們傳入兩個同型別的參數來檢查一下這段程式碼，它應當一定得回傳 true：
allItemsMatch(doubleStack, doubleStack)

// 我們可以比較 stringStack 與一個字串陣列，因為我們在先前已經擴展了 Swift 的陣列型別來滿足我們的 Container
// 協定
allItemsMatch(stringStack, ["Alpha", "Beta", "Theta"])

// 最後，如果我們試著傳入參數 stringStack 以及 doubleStack 來呼叫 allItemsMatch 函式，我們應該會得到一個編
// 譯錯誤，以為它們所儲存的元素型別並不相同，這不滿足在函式的 where 語句中定義好的，ItemType 必須一樣的規定
//
// 下面這一行程式碼無法編譯：
//
// allItemsMatch(stringStack, doubleStack)
