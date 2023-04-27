//
//  main.swift
//  MyCreditManager
//
//  Created by 김수경 on 2023/04/27.
//

import Foundation

//프로그램의 메뉴: 학생추가, 학생삭제, 성적추가(변경), 성적삭제, 평점보기, 종료


var student: [String: [String:String]] = [:]
var grade: [String: Double] =  ["A+": 4.5, "A": 4.0, "B+": 3.5, "B": 3.0, "C+": 2.5, "C": 2.0, "D+": 1.5, "D": 1.0, "F": 0.0]



func process_command(){
    menu()
    while( true ){
//        print(student)
        guard let input = readLine() else {return}
        
        
        //아무것도 입력을 하지 않거나, 문자를 입력받거나, 1~5 범위를 벗어난 숫자를 입력받은 경우의 입력처리
        if input.count != 1 {
            wrongInput(0)
        }
        else if !Character(input).isNumber {
            //프로그램 종료
            if Character(input) == "X"{
                print("프로그램을 종료합니다...")
                break
            }else{
                wrongInput(0)
            }
        }
        else if Int(input)! > 5 || Int(input)! < 0 {
            wrongInput(0)
        }else{
            //1~5 사이의 입력 처러ㅣ
            switch Int(input)! {
            case 1:
                addStudent()
            case 2:
                deleteStudent()
            case 3:
                addScore()
            case 4:
                deleteScore()
            case 5:
                showGrade()
            default:
                break
            }
        }
    }
}

process_command()


func menu(){
    print("원하는 기능을 입력해주세요. \n 1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
}

func wrongInput(_ num: Int){
    switch num{
    case 0:
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    case 1:
        print("입력이 잘못되었습니다. 다시 확인해주세요.")

    default: break
    }
    menu()
}


func addStudent(){
    print("추가할 학생의 이름을 입력해주세요")
    let name = readLine()!
    
    //공백을 입력한 경우 처리
    if name.count == 0 {
        wrongInput(1)
        return
    }
    //이미 존재하는 학생은 다시 추가하지 않음
    if student[name] != nil {
        print("\(name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
        menu()
    }else{
        student[name] = [:]
        print("\(name) 학생을 추가했습니다.")
        menu()
    }
    return
}


func deleteStudent(){
    print("삭제할 학생의 이름을 입력해주세요")
    let name = readLine()!
    
    //공백을 입력한 경우 처리
    if name.count == 0 {
        wrongInput(1)
        return
    }
    //없는 학생은 삭제하지 않음
    if student[name] == nil {
        print("\(name) 학생을 찾지 못했습니다.")
        menu()
    }else{
        student[name] = nil
        print("\(name) 학생을 삭제하였습니다.")
        menu()
    }
    return
}

func addScore(){
    print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift A+\n만약에 학생의 성적 중 해당 과목이 존재한다면 기존 점수가 갱신됩니다.")

    let input = readLine()!.split(separator: " ").map{String($0)}
    
    //3개 이하의 입력 처리
    if input.count < 3 { wrongInput(1); return }
    
    //존재하는 학생에게만 추가해야함
    if student[input[0]] != nil{
        student[input[0]]?.merge([input[1]:input[2]]) { (_, new) in new}
        print("\(input[0]) 학생의 \(input[1]) 과목이 \(input[2])로 추가(변경)되었습니다.")
        menu()
        return
    }else{
        //* 추가
        print("\(input[0]) 학생을 찾지 못했습니다.")
        menu()
        return
    }
}

func deleteScore(){
    print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift")
    
    let input = readLine()!.split(separator: " ").map{String($0)}
    
    //2개 이하의 입력 처리
    if input.count < 2 { wrongInput(1); return }
    
    //존재하는 학생에게만 추가해야함
    if student[input[0]] != nil{
        //student[input[0]]?.merge([input[1]:input[2]]) { (_, new) in new}
        if student[input[0]]?.index(forKey: input[1]) != nil {
            student[input[0]]!.remove(at: (student[input[0]]?.index(forKey: input[1]))!)
            print("\(input[0]) 학생의 \(input[1]) 과목의 성적이 삭제되었습니다.")
            menu()
            return
        }else{
            //* 추가
            print("\(input[0]) 학생의 \(input[1]) 과목의 성적이 존재하지 않습니다.")
            wrongInput(1)
            return
        }
    }else{
        print("\(input[0]) 학생을 찾지 못했습니다.")
        menu()
        return
    }
}

func showGrade(){
    print("평점을 알고싶은 학생의 이름을 입력해주세요")
    
    let name = readLine()!
    
    //공백을 입력한 경우 처리
    if name.count == 0 {
        wrongInput(1)
        return
    }
    
    //존재하지 않는 학생
    if student[name] == nil{
        print("\(name) 학생을 찾지 못했습니다.")
        menu()
        return
    }else{
        print(name)
        var total_score = 0.0
        for (key, value) in student[name]! {
            print("\(key): \(value)")
            total_score += grade[String(value)]!
        }
        print("평점: \(String(format: "%.2f", total_score / Double(student[name]!.count)))")
        menu()
        return
    }
}
