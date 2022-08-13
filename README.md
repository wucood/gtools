# gtools

go语言中一些常用的个人自定义方法.

#### 1. GetDate

> 获取当前时间

```
func GetDate() string
```

#### 2. InputStr

> 获取用户输入字符串

```
func InputStr(userInput string) string
```

#### 3. InputInt

> 获取用户输入正整数

```
func InputInt(userInput string) int 
```

#### 4. CMD

> 实时输出shell命令结果

```
func CMD(shell string) error 
```

#### 4. PrintGreen

> 打印带颜色字体

```
// 黄红蓝绿
func PrintYellow(str string)
func PrintlnYellow(str string)
func PrintfYellow(str string)

func PrintRed(str string)
func PrintlnRed(str string)
func PrintfRed(str string)

func PrintBlue(str string)
func PrintlnBlue(str string)
func PrintfBlue(str string)

func PrintGreen(str string)
func PrintlnGreen(str string)
func PrintfGreen(str string)
```