package gtools

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"time"
)

// GetDate 获取当前时间
func GetDate() string {
	now := time.Now()
	date := fmt.Sprint(now.Format("2006-01-02 15:04:05"))
	return date
}

// InputStr 用户输入字符串
func InputStr(userInput string) string {
	fmt.Print(userInput)
	reader := bufio.NewReader(os.Stdin)
	text, err := reader.ReadString('\n')
	if err != nil {
		log.Fatalln("输入有误: ", err)
	}
	text = strings.TrimSpace(text)
	return text
}

// InputInt 用户输入正整数
func InputInt(userInput string) int {
	for i := 0; i < 5; i++ {
		fmt.Print(userInput)
		reader := bufio.NewReader(os.Stdin)
		text, err := reader.ReadString('\n')
		if err != nil {
			log.Fatalln("输入有误: ", err)
		}
		text = strings.TrimSpace(text)
		num, err := strconv.Atoi(text)
		if err != nil {
			PrintlnYellow("错误: 你输入的不是数字")
			continue // 如果输入的不是数字, 返回-1
		}
		if num < 0 {
			PrintlnRed("错误: 请输入正整数")
			continue
		}
		return num
	}
	return -1
}
