// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 型別轉換(type casting)允許我們檢查一個實體的型別後，在這個實體的階層中把它當作另一個不同的型別來操作
//
// * 型別轉換也允許我們確定一個型別是否符合某一個協定
//
// * 其餘的部份看範例程式碼來解釋
// ------------------------------------------------------------------------------------------------

// 讓我們創建一些型別來做處理：
class MediaItem
{
	var name: String
	init(name: String) { self.name = name }
}

class Movie: MediaItem
{
	var director: String
	init(name: String, director: String)
	{
		self.director = director
		super.init(name: name)
	}
}

class Song: MediaItem
{
	var artist: String
	init(name: String, artist: String)
	{
		self.artist = artist
		super.init(name: name)
	}
}

// 我們將創建一個擁有 Movie 以及 Song 的 library，注意，Swift 將自動推斷 library 的型別為 MediaItem[]
let library =
[
	Movie(name: "Casablanca", director: "Michael Curtiz"),
	Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
	Movie(name: "Citizen Kane", director: "Orson Welles"),
	Song(name: "The One And Only", artist: "Chesney Hawkes"),
	Song(name: "Never Gunna Give You Up", artist: "Rick Astley")
]

// ------------------------------------------------------------------------------------------------
// 檢查型別
//
// 我們可以使用被稱為型別檢查運算子的 'is' 運算子來輕易地檢查一個物件的型別
library[0] is Movie // true
library[0] is Song  // false

// 讓我們看看實際運用的結果。讓我們遍歷這個 library 陣列並且計數其中包含的 movies 以及 songs：
var movieCount = 0
var songCount = 0
for item in library
{
	if item is Movie { ++movieCount }
	else if item is Song { ++songCount }
}

// 我們最終包含的 movies 以及 songs 的數目為：
movieCount
songCount

// ------------------------------------------------------------------------------------------------
// 向下轉型
//
// 跟其他語言一樣，向下轉型指在一個物件的階層中，將它的型別轉換為它子類別的型別。這個動作可以使用型別轉換運算子 "as"
// 來達成
//
// 因為不是所有的物件都能被向下轉型，所以轉換的結果可能是 nil。正因如此，我們在轉型過程中需要兩個可選型別。我們可以使
// 用 "as?" 運算子向下轉換到一個可選型別，或者是使用 "as" 運算子向下轉型到一個強制解開的可選型別。以強制解開的可選型
// 別而言，除非你確定向下轉型一定成功，否則別直接這麼做
//
// 讓我們看看使用可選綁定以及 "as?" 運算子實際運作的狀況。記得，我們的 library 型別是 MediaItem[]，所以如果我們將
// 一個陣列中的一個元素轉型為 Movie 或是 Song，就表示對實體做向下轉型
for item in library
{
	if let movie = item as? Movie
	{
		"Movie: '\(movie.name)' was directed by \(movie.director)"
	}
	else if let song = item as? Song
	{
		"Song: '\(song.name)' was performed by \(song.artist)"
	}
}

// ------------------------------------------------------------------------------------------------
// 對 Any 以及 AnyObject 做向下轉型
//
//
// * AnyObject 允許我們使用任意的類別型別來儲存一個實體
//
// * Any 允許我們儲存除了函式型別的任意型別
//
// 我們應當儘可能地在必要的時候才使用 Any 以及 AnyObject(例如當 API 函式回傳了一個包含了 AnyObject 元素的陣列)
// 否則，為了在 Swift 中達到型別安全，應該顯式地指定物件的型別
//
// 讓我們看看 AnyObject 實際運作的狀況。我們將定義一個型別為 AnyObject[] 的陣列，然後把一些 Movie 實體放進這個
// 陣列中：
let someObjects: [AnyObject] =
[
	Movie(name: "2001: A Space Odyssey", director: "Stanley Kubrick"),
	Movie(name: "Moon", director: "Duncan Jones"),
	Movie(name: "Alien", director: "Ridley Scott"),
]

// 這裡，我們曉得 someObjects[] 只儲存了 Movie 實體，所以我們使用 "as" 型別轉換運算子來對它強制轉型。然而，如果之
// 後某個人在這個陣列中加入了不是 Movie 型別的實體(他們確實做得到)，程序將崩潰。這就是為什麼我們應該在只在有必要的時
// 候才去使用 AnyObject 以及 Any 的原因
//
// 讓我們看看該如何使用這個 someObjects[]：
for object: AnyObject in someObjects
{
	let movie = object as! Movie
	"Movie: '\(movie.name)' was directed by \(movie.director)"
}

// 另外，我們可以將整個陣列向下轉型，而不是一個個元素分別處理：
var someMovies = someObjects as! [Movie]
for movie in someMovies
{
	"Movie: '\(movie.name)' was directed by \(movie.director)"
}

// 最後，我們可以避免使用多餘的區域變數，並且在循環結構中直接使用向下轉型：
for movie in someObjects as! [Movie]
{
	"Movie: '\(movie.name)' was directed by \(movie.director)"
}

// Any 允許我們儲存除了函式型別外的任意型別，這包含了整數、浮點數、字串或是物件
//
// 讓我們看看實際運作情況如何。我們將創建一個任意型別的陣列 Any[]，並且隨意放各種不同的東西在裡頭：
var things = [Any]()

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("Hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))

// 我們現在可以使用混用了 "is" 運算子以及 "as" 運算子的 switch 表達式來取得這個陣列中元素的資訊
//
// 我們將使用 switch 表達式來檢查每一個型別(甚至包含了這型別中更詳細的資訊)。注意，當我們這麼做的時候，我們使用強制轉
// 換的 "as" 運算子，這在 case 區塊中是安全地操作，因為當 switch 中的特定 case 區塊被匹配成功時，就已經保證了這個
// 傳入型別的合法性
for thing in things
{
	switch thing
	{
		case 0 as Int:
			"zero as an Int"
		case 0 as Double:
			"zero as a Double"
		case let someInt as Int:
			"an integer value of \(someInt)"
		case let someDouble as Double where someDouble > 0:
			"a positive Double value of \(someDouble)"
		case is Double:
			"some other double that I don't want to print"
		case let someString as String:
			"a string value of \(someString)"
		case let (x, y) as (Double, Double):
			"a Tuple used to store an X/Y floating point coordinate: \(x), \(y)"
		case let movie as Movie:
			"A movie called '\(movie.name)'"
		default:
			"Something else"
	}
}
