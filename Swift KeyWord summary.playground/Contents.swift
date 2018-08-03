//: Playground - noun: a place where people can play

import UIKit

var str = "Swift 关键字总结, 这只是博客中所有代码的提取, 详细内容请看下面链接:"
// http://blog.csdn.net/wangyanchang21/article/details/78887137#t10
// http://blog.csdn.net/wangyanchang21/article/details/78928925


/*************************************Swift 之关键字总结上篇*********************************************/


// MARK: inout  定义输入输出形式参数

func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var abc = 99
var efg = 88
swapTwoInts(&abc, &efg)

print(abc, efg)



// MARK: typealias  定义类型别名

typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min

typealias Point = (Int, Int)
let origin: Point = (0, 0)


protocol P {}
protocol Q {}
protocol R {}
typealias PQ = P & Q
typealias PQR = PQ & Q & R



// MARK: associatedtype  关联类型

protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
}

struct IntStack: Container {
    // original IntStack implementation
    var items = [Int]()
    
    // conformance to the Container protocol
    typealias ItemType = Int
    mutating func append(_ item: Int) {
        // append...
    }
    var count: Int {
        return items.count
    }
}



// MARK: subscript 下标语法

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")
// prints "six times three is 18"



// MARK: operator、prefix（前置运算符）、postfix（后置运算符）、infix（中置运算符）  自定义运算符,新的运算符要在全局作用域内，使用 operator 关键字进行声明，同时还要指定 prefix 、infix 或者 postfix 限定符。自定义运算符仅能包含这些字符：/ = - + * % < >！& | ^。~

prefix operator +++
class SomeNumber {
    var minNum = 0
    var maxNum = 0

    static prefix func +++(number: SomeNumber) -> SomeNumber {
        number.minNum = number.minNum * number.minNum
        number.maxNum = number.maxNum * number.maxNum
        return number
    }
}

var aaa = SomeNumber()
aaa.minNum = 3
aaa.maxNum = 6
+++aaa
print(aaa.minNum, aaa.maxNum)

// 前置：返回2的n次方
prefix operator  ^

prefix func ^ (vector: Double) -> Double {
    return pow(2, vector)
}
print(^5)  // 32.0

// 后置：返回2次方
//postfix operator  ^
//
//postfix func ^ (vector: Int) -> Int {
//    return vector * vector
//}
//print(5^)  // 25

//中间：计算N的M次方，左结合，优先级为255
//infix operator ^^ {associativity left precedence 255}
//
//func ^^(left: Double, right: Double) -> Double {
//    return pow(left, right)
//}
//
//print(2 ^^ 10 - 2 ^^ 3)  // 1024 － 8 ＝ 1016



// MARK: precedenceGroup、precedence(depricate from Swift 4.0)、associativity、left、right、none

//precedencegroup 优先级组名称 {
//    higherThan: 较低优先级组的名称
//    lowerThan: 较高优先级组的名称
//    associativity: 结合性
//    assignment: 赋值性
//}

infix operator +-: AdditionPrecedence
extension SomeNumber {
    static func +- (left: SomeNumber, right: SomeNumber) -> Int {
        return  left.minNum * left.maxNum + right.minNum * right.maxNum
    }
}
print(aaa +- aaa)


// MARK: defer 语句用于在退出当前作用域之前执行代码

func f() {
    defer { print("First") }
    defer { print("Second") }
    defer { print("Third") }
}
f()
// 打印 “Third”
// 打印 “Second”
// 打印 “First”



// MARK: fallthrough

switch 1 {
case 1:
    print("111")
    fallthrough
case 2:
    print("222")
case 3:
    print("333")
default:
    print("default")
}
// result is
// 111
// 222



// MARK: dynamicType (depricate from Swift 4.0)

//class SomeBaseClass {
//    class func printClassName() {
//        print("SomeBaseClass")
//    }
//}
//class SomeSubClass: SomeBaseClass {
//    override class func printClassName() {
//        print("SomeSubClass")
//    }
//}
//let someInstance: SomeBaseClass = SomeSubClass()
//// The compile-time type of someInstance is SomeBaseClass,
//// and the runtime type of someInstance is SomeSubClass
//someInstance.dynamicType.printClassName()
//// Prints "SomeSubClass"



// MARK: do 、 try 、 catch 、throw 、 throws、rethrows

enum SomeError: Error {
    case SomeError1
    case SomeError2
    case SomeError3(code: Int)
}

func makeSomeError(value: Int) throws {
    switch value {
    case 1:
        throw SomeError.SomeError1
    case 2:
        throw SomeError.SomeError2
    case 3:
        throw SomeError.SomeError3(code: 888)
    case 4:
        // 默认的这里随便找了一个错误, 来说明catch的范围
        throw MachError(.exceptionProtected)
    default:
        print("excute normal code")
    }
}

do {
    try makeSomeError(value: 3)
    // SomeError2
//    try makeSomeError(value: 3)
//    // SomeError3 code is 888
//    try makeSomeError(value: 4)
//    // nothing print, because can't catch
//    try makeSomeError(value: 5)
//    // excute normal code
} catch SomeError.SomeError1 {
    print("SomeError1")
} catch SomeError.SomeError2 {
    print("SomeError2")
} catch SomeError.SomeError3(let anyCode) {
    print("SomeError3 code is \(anyCode)")
}



// MARK: convenience

class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}
var food = Food.init()
print(food.name)
// result is [Unnamed]



// MARK: required

class SomeClass1 {
    required init() {
        // 构造器的实现代码
    }
}

//class SomeSubclass: SomeClass1 {
//    required init() {
//        // 构造器的实现代码
//    }
//}
class SomeSubclass: SomeClass1 {

}


protocol SomeProtocol {
    init()
}
class SomeSuperClass {
    init() {
        // 这里是构造器的实现部分
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    // 因为遵循协议，需要加上 required
    // 因为继承自父类，需要加上 override
    required override init() {
        // 这里是构造器的实现部分
    }
}



// MARK: mutating、nonmutating

struct Pointt {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Pointt(x: x + deltaX, y: y + deltaY)
    }
}

enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}
var ovenLight = TriStateSwitch.low
ovenLight.next()
// ovenLight is now equal to .high
ovenLight.next()
// ovenLight is now equal to .off


protocol Togglable {
    mutating func toggle()
}

struct Test: Togglable {
    var time: Int = 0
    
    mutating func toggle() {
        self.time = 33333
    }
}

var test = Test()
test.time = 2
test.toggle()



// MARK: dynamic

class DynamicSwiftClass {
    var zero = 0
    @objc dynamic var fist = 1
    @objc func dynamicFunc() {
        
    }
    //    open this code will be error
    //    @objc dynamic var adddd = (0 , 0)
    //    @objc dynamic func someMethod(value: Int) -> (Int, Int) {
    //        return (1, 1)
    //    }
}



// MARK: optional

class OptionalClass {
    var implicitlyUnwrappedString: String!
    var optionalInteger: String?
}

var optionals = OptionalClass()
//optionals.implicitlyUnwrappedString.count
//optionals.optionalInteger?.count



@objc protocol CounterDataSource {
    @objc optional var fixedIncrement: Int { get }
    @objc optional func incrementForCount() -> Int
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.incrementForCount?() {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            dataSource?.incrementForCount?()
            count += amount
        }
    }
}

class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}
// 3
// 6
// 9
// 12



// MARK: indirect

enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

//indirect enum ArithmeticExpression {
//    case number(Int)
//    case addition(ArithmeticExpression, ArithmeticExpression)
//    case multiplication(ArithmeticExpression, ArithmeticExpression)
//}

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}
print(evaluate(product))




/*************************************Swift 之关键字总结下篇*********************************************/


// MARK: #available

//if #available(platform name version, ..., *) {
//    statements to execute if the APIs are available
//} else {
//    fallback statements to execute if the APIs are unavailable
//}

if #available(iOS 10, macOS 10.12, *) {
    // Use iOS 10 APIs on iOS, and use macOS 10.12 APIs on macOS
} else {
    // Fall back to earlier iOS and macOS APIs
}



// MARK: #file、#column 、#line、#function

class SomeClass {
    func logLiteral(fileName: String = #file, methodName: String = #function, lineNumber: Int = #line, column: Int = #column) {
        print("ddd")
        print("\(fileName as NSString)->\(methodName)->\(lineNumber)->\(column)");
    }
    
    func excuteLog() {
        logLiteral()
    }
}
SomeClass().excuteLog()



// MARK: #if、#end、#sourceLocation

#if os(iOS)
print("come in one")
#endif
#if arch(x86_64)
print("come in two")
#endif
#if swift(>=4.0)
print("come in three")
#endif

// result is
// come in one
// come in two
// come in three



// MARK: @available

// 首发版本
//protocol MyProtocol {
//    // 这里是协议定义
//}
//// 后续版本重命名了 MyProtocol
//protocol MyRenamedProtocol {
//    // 这里是协议定义
//}
//@available(*, unavailable, renamed:"MyRenamedProtocol")
//typealias MyProtocol = MyRenamedProtocol

//@available(platform name version number, *)
//@available(swift version number)
//@available(macOS 10.12, *)
//@available(iOS 10.0, macOS 10.12, *)
//@available(swift 3.0.2)
//@available(*, deprecated: 10.0)
//@available(iOS, introduced: 2.0, deprecated: 8.0, message: "Header views are animated along with the rest of the view hierarchy")



// MARK: @discardableResult

class WaringClass {
    @discardableResult
    func someWarningMethod() -> Bool {
        return true
    }
}
var waring = WaringClass()
waring.someWarningMethod()



// MARK: @objc

//@objc
class ExampleClass: NSObject {
    @objc var enabled: Bool {
        @objc(isEnabled) get {
            // Return the appropriate value
            return true
        }
    }
}



// MARK: @NSCopying

class Dog : NSObject, NSCopying {
    var name = "no name"
    var age = 0
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Dog()
        print("copyed")
        copy.name = name
        copy.age = age
        return copy
    }
}

class Master : NSObject {
    @NSCopying var pet : Dog
    init(pet : Dog) {
        self.pet = pet
        super.init()
    }
}

// create dogA
var dogA = Dog()
dogA.name = "dididi"
dogA.age = 1

// create dogB
var dogB = Dog()
dogB.name = "dadada"
dogB.age = 3

// create master of dogA
var master = Master(pet: dogA)

print(master.pet === dogA)
print(master.pet.name, master.pet.age)
// true
// dididi 1

// dogB replace dogA
master.pet = dogB
// copyed

print(master.pet === dogB)
print(master.pet.name, master.pet.age)
// false
// dadada 3



// MARK: @testable

//@testable import someModule




// MARK: @autoclosure

func printIfTrue(block: ()-> Bool){
    if block(){
        print("The result is true")
    }
}

// 1.完整闭包
printIfTrue(block:  { () -> Bool in
    return 2 > 1
})
// 2.闭包中括号内的省略
printIfTrue(block: { return 2 > 1 })
// 3.尾随闭包的省略
printIfTrue(){ return 2 > 1 }
// 4.省略return
printIfTrue(){ 2 > 1 }
// 5.无入参时, 省略()
printIfTrue{2 > 1}


func printIfTrueOrNot(block: @autoclosure ()-> Bool){
    if block(){
        print("The result is true")
    }
}

// 使用自动闭包, 相当于把 2 > 1 这个表达式的bool结果, 自动转换为 () -> Bool
printIfTrueOrNot(block: 2 > 1)
// 不使用自动闭包的用法, 如此调用会报错
//printIfTrue(2 > 1)



// MARK: @escaping

var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    print("#1-刚刚进逃逸闭包函数, 准备开始添加---\(completionHandlers.count)")
    completionHandlers.append(completionHandler)
    print("#1-执行到我这里, 虽然已经将闭包添加进数组, 但是闭包还没有执行---\(completionHandlers.count)")
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    print("#2-刚刚进入非非非逃逸闭包函数")
    closure()
    print("#2-代码执行结束了")
}

class SomeClassd {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure {
            print("#1-这里才是真正执行传入闭包的时刻---\(completionHandlers.count)")
            self.x = 100
        }
        someFunctionWithNonescapingClosure {
            print("#2-这里我进行了操作")
            self.x = 200
        }
    }
}

let instance = SomeClassd()
instance.doSomething()
print(instance.x)
// Prints "200"

completionHandlers.first?()
print(instance.x)



// MARK: @convention
// 以下代码需要在可以运行对应代码的环境才能正常编译

//CGFloat myCFunction(CGFloat (callback)(CGFloat x, CGFloat y)) {
//    return callback(1.1, 2.2);
//}
//let swiftCallback : @convention(c) (CGFloat, CGFloat) -> CGFloat = {
//    (x, y) -> CGFloat in
//    return x + y
//}

//let result = myCFunction( swiftCallback )
//print(result) // 3.3
//let result = myCFunction( {
//    (x, y) -> CGFloat in
//    return x + y
//} )
//print(result) // 3.3


//[UIView animateWithDuration:2 animations:^{
//    NSLog(@"start");
//    } completion:^(BOOL finished){
//    NSLog(@"completion");
//    }];
//
//
//UIView.animate(withDuration: 2, animations: {
//    NSLog("start")
//}, completion: {
//    (completion) in
//    NSLog("completion")
//})
//
//let animationsBlock : @convention(block) () -> () = {
//    NSLog("start")
//}
//let completionBlock : @convention(block) (Bool) -> () = {
//    (completion) in
//    NSLog("start")
//}
//UIView.animate(withDuration: 2, animations: animationsBlock, completion: completionBlock)




/*************************************访问控制*********************************************/

