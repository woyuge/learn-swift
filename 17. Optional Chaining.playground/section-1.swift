// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 可選鏈(Optional Chaining)是一個不需要一步步地解開可選型別，就能安全地參考一連串可選型別的處理過程
// ------------------------------------------------------------------------------------------------

// 考慮一個強制展開如 "someOptional!.someProperty" 這個可選型別的過程。我們已經了解除非這個可選型別不為 nil，
// 此次的展開才是安全地操作。但通常我們不曉得可選型別的內容裡頭是否有值，所以在使用之前必須先做確認。這個過程在許多
// 可選型別鏈接一起－例如屬性的屬性－的時候，整個判斷過程會顯得很笨重。讓我們創建一連串的可選型別來展示這個情況：
class Artist
{
	let name: String
	init(name: String) { self.name = name }
}

class Song
{
	let name: String
	var artist: Artist?
	init(name: String, artist: Artist?)
	{
		self.name = name
		self.artist = artist
	}
}

class MusicPreferences
{
	var favoriteSong: Song?
	init(favoriteSong: Song?) { self.favoriteSong = favoriteSong }
}

class Person
{
	let name: String
	var musicPreferences: MusicPreferences?
	init (name: String, musicPreferences: MusicPreferences?)
	{
		self.name = name
		self.musicPreferences = musicPreferences
	}
}

// 我們在這兒創建整個鏈
var someArtist: Artist? = Artist(name: "Somebody with talent")
var favSong: Song? = Song(name: "Something with a beat", artist: someArtist)
var musicPrefs: MusicPreferences? = MusicPreferences(favoriteSong: favSong)
var person: Person? = Person(name: "Bill", musicPreferences: musicPrefs)

// 我們可以使用強制解開來存取這個鏈。在這個可控的情況下做這種操作沒有關係，但此作法在真實情況下不一定可取，除非你能
// 確定鏈中的每一個值都不是 nil
person!.musicPreferences!.favoriteSong!.artist!

// 讓我們破壞掉這個鏈，先移除 person 的 musicPreferences 的參考：
if var p = person
{
	p.musicPreferences = nil
}

// 以破壞掉的鏈而言，如果我們像先前一樣試著去參考 arist，我們將會得到一個執行階段錯誤
//
// 下面這一行可編譯，但執行時會引發錯誤：
//
//		person!.musicPreferences!.favoriteSong!.artist!
//
// 這個情況就需要使用可選鏈來解決問題，使用問號 "?" 取代強制解開的符號 "!"。如果任何這個鏈中的可選型別的值為 nil
// ，程式對鏈的運算將會中斷，整個表達式的結果將會回傳 nil
//
// 讓我們看看這整個鏈，一次一步的往前追。這可以讓我們了解整個可選鏈究竟是如何變成有效的值：
person?.musicPreferences?.favoriteSong?.artist
person?.musicPreferences?.favoriteSong
person?.musicPreferences
person

// 可選鏈可以跟不是可選型別的變數、強制解開的可選型別以及其他內文(下標腳本，函式呼叫，回傳值)一起使用，我們不用特地費
// 心地創建一連串的類別與實體來展示下面的例子，但此例子確實展示了如何在不同狀況下，有效地使用可選鏈的語法。搭配正確的
// 內容之後，下面的這一行例子不但可以編譯，而且執行結果也符合預期
//
// person?.musicPreferences?[2].getFavoriteSong()?.artist?.name
//
// 解讀這一行的方法為：取得 person(可選型別) 的第三個 musicPreferences(可選型別) 的喜愛歌曲(可選型別) 的 artist
// (可選型別) 的名字
