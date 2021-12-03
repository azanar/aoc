import Swift

var aim = 0
var horz = 0
var dpth = 0

for line in AnyIterator({ readLine() }) {
    let sp = line.split(separator: " ")
    let ins = sp[0]
    let mag = Int(sp[1])!
    switch ins {
        case "down":
            aim += mag
        case "up":
            aim -= mag
        case "forward":
            horz += mag
            dpth += aim * mag
        default:
            print("ugh")
    }
}
print(dpth * horz)
