// ------------------------------------------------------------------------------------------------
// 本篇須知：
//
// * 只有在除錯模式而且不是釋出版本的時候，斷言才會啟動
//
// * 斷言會中止你的 app 並停在錯誤的那一行，並讓除錯器跳到那一行
// ------------------------------------------------------------------------------------------------

// 從這個設定為 3 的值開始...
let age = 3

// 你可以為斷言加上一個訊息
assert(age >= 0, "A person's age cannot be negative")

// 你可以不加訊息直接使用斷言
assert(age >= 0)

