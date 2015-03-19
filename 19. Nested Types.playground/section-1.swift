// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 巢狀結構型別(nested types)是宣告在其他類別、結構以及列舉中的類別及結構
// ------------------------------------------------------------------------------------------------

// 讓我們看看如何使用巢狀結構型別來定義一個 BlackjackCard 結構
//
// 每一張撲克牌都有一個花色(黑桃、紅心、鑽石、梅花)以及它們的階級(王牌、國王、皇后等等...)，這是使用巢狀結構型別的
// 自然時機，因為花色與階級的列舉只適用在 BlackjackCard 這個 21 點的撲克牌遊戲中，也因此它們都被限制在自己的型別
// 裡頭
//
// 此外，因為王牌可以表示 1 或者是 11，我們可以在階級列舉中創建一個巢狀的結構，讓我們代表一個階級所擁有的多個值
//
// 讓我們看看實作這個結構的可能方式：
struct BlackjackCard
{
    // 巢狀結構中的花色列舉
	enum Suit: Character
	{
		case Spades = "♠", Hearts = "♡", Diamonds = "♢", Clubs = "♣"
	}
	
    // 巢狀結構中的階級列舉
	enum Rank: Int
	{
		case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
		case Jack, Queen, King, Ace
		
        // 一個階級可能擁有兩種值(例如王牌)，所以我們將使用以下這個結構來包含這兩種值。雖然我們同樣可以使用元組來
        // 達成這個效果，但我們正在展示巢狀結構型別
		//
        // 注意，因為所有的階級都有一個值，但只有某些階級有第二個值，我們將定義第一個值為 Int，第二個值為 Int?
		struct Values
		{
			let first: Int
			let second: Int?
		}

        // 我們在這裡使用計算屬性來回傳一個階級擁有的值。注意，只有王牌這個階級才會回傳多個值。然而，我們也使用這個
        // 計算屬性來回傳騎士/國王/皇后該具備的值，也就是 10
		var values: Values
		{
			switch self
			{
				case .Ace:
					return Values(first: 1, second: 11)
				case .Jack, .Queen, .King:
					return Values(first: 10, second: nil)
				default:
					return Values(first: self.rawValue, second: nil)
			}
		}
	}
	
    // BlackjackCard 類別中的屬性以及方法
	let rank: Rank
	let suit: Suit
	
	var description: String
	{
		var output = "A \(suit.rawValue) with a value of \(rank.values.first)"
		if let second = rank.values.second
		{
			output += " or \(second)"
		}
		return output
	}
}

// 讓我們初始化一個代表黑桃王牌的 BlackjackCard 實體。注意，BlackjackCard 並沒有定義任何建構器，所以我們可以使
// 用默認的針對個別成員的建構器
//
// 注意，因為建構器知道每個被初始化成員的型別(包含那兩個列舉)，我們可以使用簡寫(.Something)來代表初始化這些個別成
// 員的值
let theAceOfSpades = BlackjackCard(rank: .Ace, suit: .Spades)
theAceOfSpades.description

// 使用型別名稱來存取這個巢狀結構型別
let heartsSymbol = String( BlackjackCard.Suit.Hearts.rawValue )
