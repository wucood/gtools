package gtools

import "fmt"

// Shell中输出彩色字体
var (
	//greenBg      = string([]byte{27, 91, 57, 55, 59, 52, 50, 109})
	//whiteBg      = string([]byte{27, 91, 57, 48, 59, 52, 55, 109})
	//yellowBg     = string([]byte{27, 91, 57, 48, 59, 52, 51, 109})
	//redBg        = string([]byte{27, 91, 57, 55, 59, 52, 49, 109})
	//blueBg       = string([]byte{27, 91, 57, 55, 59, 52, 52, 109})
	//magentaBg    = string([]byte{27, 91, 57, 55, 59, 52, 53, 109})
	//cyanBg       = string([]byte{27, 91, 57, 55, 59, 52, 54, 109})
	green = string([]byte{27, 91, 51, 50, 109})
	//white        = string([]byte{27, 91, 51, 55, 109})
	yellow = string([]byte{27, 91, 51, 51, 109})
	red    = string([]byte{27, 91, 51, 49, 109})
	blue   = string([]byte{27, 91, 51, 52, 109})
	//magenta      = string([]byte{27, 91, 51, 53, 109})
	//cyan         = string([]byte{27, 91, 51, 54, 109})
	reset = string([]byte{27, 91, 48, 109})
	//disableColor = false
)

func PrintGreen(str string) {
	fmt.Print(green, str, reset)
}

func PrintlnGreen(str string) {
	fmt.Println(green, str, reset)
}

func PrintfGreen(str string) {
	fmt.Printf(green, str, reset)
}

func PrintYellow(str interface{}) {
	fmt.Print(yellow, str, reset)
}

func PrintlnYellow(str string) {
	fmt.Println(yellow, str, reset)
}

func PrintfYellow(str string) {
	fmt.Printf(yellow, str, reset)
}

func PrintRed(str string) {
	fmt.Print(red, str, reset)
}

func PrintlnRed(str string) {
	fmt.Println(red, str, reset)
}

func PrintfRed(str string) {
	fmt.Printf(red, str, reset)
}

func PrintBlue(str string) {
	fmt.Println(blue, str, reset)
}

func PrintlnBlue(str string) {
	fmt.Println(blue, str, reset)
}

func PrintfBlue(str string) {
	fmt.Printf(blue, str, reset)
}
