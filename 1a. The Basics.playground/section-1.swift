// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * Swift 是蘋果電腦為了 iOS 以及 OSX 設計的新程式語言。如果你懂 C 語言或 Objective-C 語言，那麼這些遊樂場應當
//   是個幫助你轉換到 Swift 語言的可靠入門手冊。
//
// * 預期讀者擁有一些類 C 語言程式的開發經驗。如果不具備，那我感到遺憾，你並不是目標聽眾。
// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// 常數與變數 - 這些都是 Swift 程式語言中的 "儲存值"

// 使用 'let' 關鍵字來定義一個常數
let maximumNumberOfLoginAttempts = 10

// 使用 'var' 關鍵字來定義一個變數
//
// 提示: 當你要儲存的數值會改變的時候才使用變數。否則，寧可使用常數。
//
var currentLoginAttempt = 0

// 常數不可改變，下面這一行無法編譯：
// maximumNumberOfLoginAttempts = 9

// 變數可以改變：
currentLoginAttempt += 1

// 你也不能重複宣告一個已經宣告過的變數或常數，下面這兩行都不能編譯：
// let maximumNumberOfLoginAttempts = 10
// var currentLoginAttempt = "一些不是 Int 的字串"

// 你可以透過逗號的分隔在同一行內一次宣告多個變數
let a = 10, b = 20, c = 30
var x = 0.0, y = 0.0, z = 0.0

// 使用型別註解(type annotation)來指定型別
//
// Swift 內建的型別為： Int, Double, Float, Bool, String, Array, Dictionary
// 還有一些是前面這些型別的變化型(例如 Uint16)，不過這裡列出來的都是基本型別。請注意所有型別的首字母都是大寫。
//
// 因為型別能自動推斷(inference)(42 代表 Int 而 "某些文字" 代表 String)，所以在 Swift 中通常很少使用型別註解。
//
// 這裡展示了如何使用型別註解來指定型別。如果沒有指定變數的型別為 Double，那麼型別將被自動推斷為 Int。
var SomeDouble: Double = 4

// 常數與變數的命名不能包含數學符號、箭頭、保留的(或不合法的)萬國碼或方框繪製字元，也不能使用數字當變數的開頭。
// 除此之外沒有任何其它規定。隨心所欲命名變數名稱的時代開始了！(確實如此！)
//
//
// 這裡的常數命名雖然奇特但完全合法：
let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"

// 你可以使用 println 函式印出值：
let fiveHundred = 500
println("The current value of fiveHundred is: \(fiveHundred)")

// 因為我們正在使用遊樂場，所以只需要直接將字串打出來程式就會將它顯示在右方的面板上，例如下面這樣：
"The current value of fiveHundred is: \(fiveHundred)"

// ------------------------------------------------------------------------------------------------
// 關於變數名稱的注意事項
//
// 對於絕大多數的程式語言來說，你不能將關鍵字當作命名(變數、常數或類別)時的名稱。例如，你無法將一個常數命名為 "let"
//
// 下面這行程式碼無法編譯：
//
// let let = 0
//
// 然而，有的時候這麼做可以帶來一些方便，而 Swift 可以藉由在變數名稱的前後各加一個反引號(`)來達成這個需求：
let `let` = 42.0

// 現在我們可以像使用一般變數一樣地使用 `let`：
x = `let`

// 這個方法可以使用在任何關鍵字上：
let `class` = "class"
let `do` = "do"
let `for` = "for"

// 另外，重要的事是了解這個方法也能用在不是關鍵字的變數名稱上：
let `myConstant` = 123.456

// 而且留意 `myConstant` 以及 myConstant 所指的是同一個常數：
myConstant

// ------------------------------------------------------------------------------------------------
// 註解
//
// 或許你已經搞清楚了，但還是說明一下，任何在 "//" 後方的東西都是註解。以下還有更多使用註解的方法：

/* 這是一個跨越了
   多行的多行註解 */

// 多行註解方便之處在於它們支援巢狀結構，讓你放心地註解掉一段已經有跨越了多行註解的程式碼

/* 
    // 某個變數
	var someVar = 10

	/* 一個函式
     * 
     * 這是一個註解函式的常見方式，但這個方式會讓這段程式碼難以一次全部註解掉
     */
    func doSomething()
    {
		return
    }
*/

// ------------------------------------------------------------------------------------------------
// 分號
//
// 可自行決定要不要在一行的結尾加上分號，但 Swift 偏好的風格是不在結尾處加上分號。
var foo1 = 0
var foo2 = 0; // 可加可不加的分號

// 然而，如果你想把兩行程式碼放在同一行內，就必須使用分號來區隔它們。
foo1 = 1; foo2 = 2

// ------------------------------------------------------------------------------------------------
// 整數
//
// 整數有多種型別，有號、無號搭配上 8、16、32、以及 64 位元的大小。
// 這裏有兩個例子：
let meaningOfLife: UInt8 = 42 // 無號的 8 位元整數
let randomNumber: Int32 = -34 // 有號的 32 位元整數

// 默認的整數型是 Int 以及 Uint。這些型別的大小會依據程式執行平台上一個字(word)的大小做調整。
// 在一個 32 位元的平台上，Int 的大小會等同於 Int32/UInt32，
// 在 64 位元的平台上，它的大小會等同於 Int64/UInt64。
//
// 提示：偏好使用 Int 來取代它的類似型別可提升程式碼的可移植性
let tirePressurePSI = 52

// 試著在 int 型別的後方加上 ".min" 或 ".max" 來獲取它大小值的極限
UInt8.min
UInt8.max
Int32.min
Int32.max

// ------------------------------------------------------------------------------------------------
// 浮點數
//
// Double 是個 64 位元的浮點數，Float 是個 32 位元的浮點數
let pi: Double = 3.14159
let pie: Float = 100 // ... 因為派 100% 好吃！

// ------------------------------------------------------------------------------------------------
// 型別安全以及型別推斷
//
// Swift 是個強型別的語言，正因為如此，每一個儲存值都必須有個型別，而且僅能使用在這個型別被允許的操作上。
//
// 整數文字的型別會被自動推斷為 Int
let someInt = 1234

// 浮點數文字的型別總是被自動推斷為 Double
let someDouble = 1234.56

// 如果你想要的型別是 Float，你必須使用型別註解來顯式地聲明 Float
let someFloat: Float = 1234.56

// 字串文字的型別會被自動推斷為 String
let someString = "This will be a String"

// 這裡是一個布爾型別
let someBool = true

// 以下這三行無法編譯因為我們顯式地提供了不符合文字類別的型別註解
// let someBool: Bool = 19
// let someInteger: Int = "45"
// let someOtherInt: Int = 45.6

// ------------------------------------------------------------------------------------------------
// 數值文字
//
// 你可以使用一些有趣的方式來指定數值
let decimalInteger = 17
let binaryInteger = 0b10001 // 使用 2 進位來表示 17
let octalInteger = 0o21 // ...依然是 17 (8 進位啊, 親愛的！)
let hexInteger = 0x11 // ...17 的 16 進位

// 浮點數也能使用多種方式來指定數值，這裡有一些直接的例子：(沒有將值賦予給變數)
1.25e2 // 科學計數法
1.25e-2
0xFp2 // 將它拆解為 "0xF"、"p"、"2"。解讀為 15 (0xF) 乘上 1 往左位移 2 次 (p), 結果為 60
0xFp-2
0xC.3p0

// 也可以補齊數值文字
000123.456 // 補零
0__123.456 // 下劃線會被無視

// 數值型別的轉換

// 不匹配型別註解的數字是無法編譯的
// let cannotBeNegative: UInt8 = -1
// let tooBig: Int8 = Int8.max + 1

// 因為數值型別的默認型別是 Int，因此你需要使用型別註解來指定為不同的型別
let simpleInt = 2_000 // Int
let twoThousand: UInt16 = 2_000 // 指定為 UInt16
let one: UInt8 = 1 // 指定為 UInt8

// 這會基於兩個運算元的型別自動推斷為 UInt16
let twoThousandAndOne = twoThousand + UInt16(one)

// 在整數與浮點數之間轉換必須顯式地聲明
let three = 3 // 自動推斷為 Int
let pointOneFourOneFiveNine = 0.14159 // 自動推斷為 Double
let doublePi = Double(three) + pointOneFourOneFiveNine // 顯式轉換 Int 型別到 Double 型別

// 這個規定在反向轉換的時候也是成立的 - 從浮點數轉換到整數必須顯式地聲明
//
// 從浮點數轉換到整數會直接截斷小數點後的部份，因此 doublePi 會變成 3，而 -doublePi 變成 -3
let integerPi = Int(doublePi)
let negativePi = Int(-doublePi)

// 數值文字在未使用型別註解指定型別的時候，作用的方式不太一樣。
// 它們的型別將在執行運算時才被自動推斷出來：
let someValue = 3 + 0.14159
