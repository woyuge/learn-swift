// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 自動參考計數(Automatic Reference Counting)允許 Swift 追蹤並管理你 app 的記憶體使用狀況。它自動地將
//   已不需要的實體記憶體釋放出來
//
// * 參考計數只會用在參考型別的類別上，因為結構與列舉都是值型別
//
// * 每當一個類別實體被賦值(給一個屬性、常數或變數)的時候，就會製造一個 "強參考" 計數，強參考可以確保只要當它還
//   需要使用，就不會被釋放
// ------------------------------------------------------------------------------------------------

// 我們不能真的看到自動參考計數在遊樂場中是怎麼運作的，但我們依然能繼續往下看看會發生什麼事
//
// 我們將從創造這個類別開始著手
class Person
{
	let name: String
	init (name: String)
	{
		self.name = name
	}
}

// 我們想要先創建一個 person 實體，然後再釋放它的參考，這表示我們需要將這個變數宣告為可選 Person 型別：
var person: Person? = Person(name: "Bill")

// 現在我們擁有一個指向單一 Persen 實體的強參考
//
// 如果我們將 'person' 賦值給其他變數或常數，將會增加 1 個參考計數，現在 Person 實體的參考計數總數是 2：
var copyOfPerson = person

// 在參考計數總數為 2 的狀況下，我們可以將原本的參考設為 nil。這個動作將讓參考計數的數目降到 1
person = nil

// copyOfPerson 變數依然存在，而且儲存了一個代表 Person 實體的強參考：
copyOfPerson

// 如果我們移除這個參考，那麼參考計數的數目將被降低到剩下 0 個，使得這個物件從參考計數中被移除：
copyOfPerson = nil

// ------------------------------------------------------------------------------------------------
// 在類別實體間的強參考循環
//
// 如果兩個類別之間互相參考，那麼它們將創建一個 "強參考循環"
//
// 這兒的例子，是兩個互相持有對方參考的類別，但參考沒有做初始化(它們對彼此的參考是可選型別，所以默認為 nil)：
class Tenant
{
	let name: String
	var apartment: Apartment?

	init(name: String) { self.name = name }
}
class Apartment
{
	let number: Int
	var tenant: Tenant?

	init (number: Int) { self.number = number }
}

// 我們可以創建一個內部屬性還沒有互相參考的 tenant 以及一個 apartment，在下面兩行程式碼中，每個實體都會有數目
// 為 1 的參考計數：
var bill: Tenant? = Tenant(name: "Bill")
var number73: Apartment? = Apartment(number: 73)

// 讓我們將它們聯結起來
//
//
// 這個動作將會創建一個強參考循環，因為每個實體都會擁有對彼此的參考。最後的結果就是每個實體現在持有的參考計數數目
// 都是 2。例如，Tenant 實體所擁有的 2 個強參考，分別是參考了 Tenant 實體的 'bill' 以及參考了 'number73'
// 變數的屬性 'tenant'
//
// 變數後方的 "!" 符號表示強制解開這些可選型別(在先前的章節中提過)：
bill!.apartment = number73
number73!.tenant = bill

// 如果我們試著釋放這些使用的資源，記憶體將不會被自動參考計數完整地釋放。讓我們繼續往下看看到底在每一個步驟中發生
// 了什麼事
//
// 首先，我們將 'bill' 變數賦值為 nil，這個動作會將此實體的強參考計數數目減為 1 個。因為實體內部的屬性依然持有
// 一份強參考計數，因此那一份記憶體將永無釋放的機會。(而且 Person 解構器的實體也不會被呼叫)
bill = nil

// 下一步我們在 'number73' 變數上做一樣的操作，將它的強參考計數數目減為 1 個。同樣地，這並不會釋放所有使用的記
// 憶體或呼叫解構器
number73 = nil

// 至此，我們在記憶體中擁有兩個依然存在的實體，但因為我們未持有任何指向它們的參考，所以無法釋放它們所使用的資源

// ------------------------------------------------------------------------------------------------
// 解除在類別實體間的強參考循環
//
// Swift 提供了兩個方法來解除類別實體間的強參考循環：弱參考以及無主參考

// ------------------------------------------------------------------------------------------------
// 弱參考也能參考實體，但它們不是強參考，也不會牢牢地持有對實體的參考(因此，目標實體的參考計數數目不會增加)
//
// 當一個變數在它的生命週期中，值偶爾會是 nil 的時候，使用弱參考。因為 Apartment 有時候沒有 tenant，使用弱參
// 考就是一個正確的方式
//
// 弱參考必須是可選型別(因為它們的值有時候是 nil)。當一個物件持有指向另一個物件的弱參考時，如果被持有的物件被釋放
// 了，Swift 將會把所有指向這個物件的弱參考值都設為 nil
// 
// 使用 'weak' 關鍵字來宣告弱參考
//
// 讓我們修改一下 Apartment 類別。注意，我們只需要破壞掉參考循環即可。讓 Tenant 繼續持有 apartment 的強參考
// 是完全沒問題的。我們也將創建一個新的 Tenant 類別(只是給它一個新名字 "NamedTenant")，但唯有如此，我們才能將
// apartment 型別修改為參考新的 FixedApartment 類別
class NamedTenant
{
	let name: String
	var apartment: FixedApartment?
	
	init(name: String) { self.name = name }
}
class FixedApartment
{
	let number: Int
	weak var tenant: NamedTenant?
	
	init (number: Int) { self.number = number }
}

// 這裡是我們的新 tenant 實體 'jerry'，以及它擁有的新 apartment 實體 'number74'：
//
// 這兩行會替個別的實體創建單一的強參考到個別的類別：
var jerry: NamedTenant? = NamedTenant(name: "Jerry")
var number74: FixedApartment? = FixedApartment(number: 74)

// 跟先前一樣，讓我們把這兩個實體聯結起來。注意，這次我們不會替 'number74' 的屬性 'tenant' 創建一個新的強參考
// ，所以它的參考計數數目依然是 1。然而，'jerry' 依然擁有數目為 2 的參考計數數目(因為它的 'apartment' 屬性會
// 持有一個指向 'number74' 的強參考)
jerry!.apartment = number74
number74!.tenant = jerry

// 至此，我們擁有一個指向 NamedTenant 類別的強參考，擁有兩個指向 FixedApartment 類別的強參考
//
// 讓我們將 'jerry' 設為 nil，這將把參考計數的數目設為 0 導致這個實體被釋放。當這件事發生時，它也會被解構
jerry = nil

// 隨著 'jerry' 的解構，被 FixedApartment 持有的強參考數目也會被減少到剩下 1 個，只剩參考這個類別本身的變數
// 'number74'
//
// 如果我們釋放掉 'number74'，那麼我們將把最後剩餘的強參考數目也移除：
number74 = nil

// ------------------------------------------------------------------------------------------------
// 無主參考
//
// 無主參考就像是弱參考一樣，它們不會牢牢地持有對實體的參考。然而，它跟弱參考之間最主要的差別，在於如果某物件的參
// 考被解構了，它裡頭的無主參考將不會像弱參考一樣被設為 nil。因此，確保這個擁有無主參考的實體存在性是很重要的。如
// 果存取一個被釋放了的實體中的無主參考，會發生執行階段錯誤。事實上，Swift 擔保了你的 app 在這情況下一定會崩潰
//
// 使用關鍵字 'unowned' 來創建無主參考，它們絕不能是可選型別
//
// 我們使用 Customer 以及 CreditCard 兩個類別當例子。這是個挺好的例子，因為 Customer 不一定會有 CreditCard
// 。但當 CreditCard 被創建出來的時候，它一定屬於某個 Customer
class Customer
{
	let name: String
	var card: CreditCard?
	init (name: String)
	{
		self.name = name
	}
}

class CreditCard
{
	let number: Int
	unowned let customer: Customer
	
    // 因為 'customer' 屬性不是可選型別，它必須在建構器中被初始化
	init (number: Int, customer: Customer)
	{
		self.number = number
		self.customer = customer
	}
}

// ------------------------------------------------------------------------------------------------
// 無主參考以及隱式地解開可選型別
//
// 我們已涵蓋了兩種在一般參考循環中會遇到的情況，但這兒有第三種情況。考慮一個 Country 以及它擁有的 capitalCity
// 屬性。跟 Customer 不一定擁有 CreditCard，或者是 Apartment 不一定被哪個 Tenant 所持有不同，Country 一定
// 會有 capitalCity，而一個 capitalCity 也必定有包含它的 Country
//
// 這個情況要在其中一個類別中使用無主參考，而在另一個類別中隱式地解開可選型別。這個做法允許兩個屬性都能被直接存取(
// 不需要解開可選型別)。當初始化完成後，就避開了參考循環
//
// 讓我們看看這是如何完成的：
class Country
{
	let name: String
	var capitalCity: City!
	
	init(name: String, capitalName: String)
	{
		self.name = name
		self.capitalCity = City(name: capitalName, country: self)
	}
}

class City
{
	let name: String
	unowned let country: Country

	init(name: String, country: Country)
	{
		self.name = name
		self.country = country
	}
}

// 我們可以定義一個帶著 capitalCity 的 Country 類別實體
var america = Country(name: "USA", capitalName: "Washington DC")

// 這裡會解釋它是怎麼運作的，以及為什麼這麼做
//
// 在 Customer:CreditCard 之間的關係與在 Country:City 之間的關係類似。主要的差異在於 Country 類別在初始化
// 它的 capitalCity 時，不需要透過可選綁定或強制解開去參考 City 類別，因為 Country 類別使用了一個定義為隱式解
// 開可選型別的 capitalCity 屬性(在變數的型別後方加上驚嘆號 !)
//
// City 類別在 country 屬性上使用了無主參考，就跟 CreditCard 類別在 customer 屬性上使用了無主參考道理相同
//
// Country 類別仍然在 capitalCity 屬性上使用了一個可選型別(透過隱式解開)，就跟 Customer 類別在 card 屬性上
// 使用了一個可選型別道理相同。如果我們好好看看 Country 類別的建構器就會發現，它使用了一個 'self' 關鍵字來將自
// 己傳遞進 City 類別的初始化建構器。一般而言，一個建構器不能使用 'self' 來存取它自己，除非它已初始化完成。在此
// 例子中可以這麼做的原因在於當 Country 類別中的 'name' 屬性被初始化了，整個實體就被當作初始化完畢了，因為
// 'capitalCity' 是一個可選型別
//
// 我們再進一步地將可選型別的 'capitalCity' 屬性宣告為隱式解開，所以避免了每次在使用 'capitalCity' 之前，都
// 必須先將它解開的規定

// ------------------------------------------------------------------------------------------------
// 閉包引起的強參考循環
//
// 因為類別是參考型別，所以我們已看過類別會因為互相參考而引起一個參考循環。然而，類別不是唯一一個會引起參考循環的
// 型別。這些互相參考的問題也會在閉包中發生，因為閉包也是參考型別
//
// 當一個閉包捕獲了一個類別實體(僅僅只是在這個閉包裡頭使用了這個類別實體)，而此類別也保存了這個閉包的參考，就會發
// 生參考循環。注意，閉包所捕獲的參考會被自動視為強參考
//
// 讓我們看看如何表達這個問題。我們將創建一個代表 HTML 元素的類別，此類別中擁有一個型別為閉包的屬性(asHTML)
//
// 速記：asHTML 屬性被定義為 lazy，所以它可以在自己的閉包中使用 'self' 關鍵字來存取同類別的屬性。試著將 'lazy'
// 關鍵字移除，你會發現無法在第一階段的初始化中存取 'self'。我們將 'asHTML' 宣告為 lazy 後，此屬性的初始化過
// 程可以往後延遲到被存取的時候，藉此來解決 Swift 認為類別尚未全被初始化完成的問題
class HTMLElement
{
	let name: String
	let text: String?
	
	lazy var asHTML: () -> String =
	{
		if let text = self.text
		{
			return "<\(self.name)>\(text)</\(self.name)>"
		}
		else
		{
			return "<\(self.name) />"
		}
	}
	
	init(name: String, text: String? = nil)
	{
		self.name = name
		self.text = text
	}
}

// 讓我們來使用這個 HTMLElement 類別。我們將之宣告為可選型別，以便在之後可將它的值設為 nil
var paragraph: HTMLElement? = HTMLElement(name: "p", text: "Hello, world")
paragraph!.asHTML()

// 至此，我們已創建了一個在 HTMLElement 實體與 asHTML 閉包之間的強參考循環，因為閉包參考了擁有(參考到)此閉包的
// 實體
//
// 我們可以將 paragraph 設置為 nil，但 HTMLElement 實體將不會被解構：
paragraph = nil

// 這裡的解決方法，使用了在閉包型別定義中的 '閉包捕獲列表'。實質上允許我們修改閉包默認使用強參考來捕獲實體的行為
//
// 這兒展示了我們如何定義一個捕獲列表：
//
//	lazy var 閉包名稱: (Int, String) -> String =
//	{
//		[unowned self] (index: Int, stringToProcess: String) -> String in
//
//		// ... 表達式 ...
//	}
//
// 有些閉包可使用簡化的語法，其中一部份閉包的參數可以透過自動推斷而得，另一部份的閉包則是沒有任何參數。在這兩種情
// 況下宣告一個捕獲列表的方式也差不多。在閉包捕獲列表後緊接著的就是 'in' 關鍵字
//
//	lazy var 閉包名稱: () -> String =
//	{
//		[unowned self] in
//
//		// ... 表達式 ...
//	}
//
// 讓我們看看如何使用這個捕獲列表來解決 HTMLElement 的問題。我們將創建一個新的類別 FixedHTMLElement，它除了
// 一行新增的捕獲列表 "[unowned self] in" 外，跟前一個類別完全相同
class FixedHTMLElement
{
	let name: String
	let text: String?
	
	lazy var asHTML: () -> String =
	{
		[unowned self] in
		if let text = self.text
		{
			return "<\(self.name)>\(text)</\(self.name)>"
		}
		else
		{
			return "<\(self.name) />"
		}
	}
	
	init(name: String, text: String? = nil)
	{
		self.name = name
		self.text = text
	}
}

// 遊樂場無法讓我們檢查/證明這個有沒有效，所以請隨意地將這些程式碼放到一個新專案中，編譯後測試實際效果如何
